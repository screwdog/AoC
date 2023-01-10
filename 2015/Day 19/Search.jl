function expandnode(transforms::Vector{Transform}, molecule, generations, node)
    newnodes = Node[]
    for transform ∈ transforms
        offsets = findall((==)(element(node)), to(transform))
        for offset ∈ offsets
            append!(newnodes,
                expandnode(transform, molecule, generations, newelement(node, from(transform)), offset)
            )
        end
    end
    return newnodes
end

function expandnode(transform::Transform, molecule, generations, node, offset)
    newnodes = Node[]
    leftnodes = expandleft(transform, molecule, generations, node, offset)
    for leftnode ∈ leftnodes
        append!(newnodes, expandright(transform, molecule, generations, leftnode, offset))
    end
    return newnodes
end

ExpandFns = @NamedTuple begin   # Arguments
    newoffset::Function         # (offset)
    newlocation::Function       # (node)
    isend::Function             # (offset, transform)
    hasroom::Function           # (offset, transform, molecule, node)
    join::Function              # (newnode, node)
    bound::Function             # (generations, location)
end

function _expand(transform, molecule, generations, node, offset, fns)
    curroffset = fns.newoffset(offset)
    currlocation = fns.newlocation(node)

    fns.isend(offset, transform)                    && return [node]
    fns.hasroom(offset, transform, molecule, node)  || return Node[]

    newnodes = Node[]
    if to(transform)[curroffset] == molecule[currlocation]
        leafnode = Node(currlocation)
        append!(newnodes,
            _expand(transform, molecule, generations, fns.join(leafnode, node), curroffset, fns)
        )
    end
    expandnodes = fns.bound(generations, currlocation)
    for expandnode ∈ expandnodes
        if element(expandnode) == to(transform)[curroffset]
            append!(newnodes,
                _expand(transform, molecule, generations, fns.join(expandnode, node), curroffset, fns)
            )
        end
    end
    return newnodes
end
const E_LEFT = ExpandFns((
    o               -> o - 1,
    n               -> first(n) - 1,
    (o, t)          -> o == 1,
    (o, t, m, n)    -> o ≤ first(n),
    leftjoin,
    endat
))
const E_RIGHT = ExpandFns((
    o               -> o + 1,
    n               -> last(n) + 1,
    (o, t)          -> o == length(t),
    (o, t, m, n)    -> length(t) - o ≤ length(m) - last(n),
    rightjoin,
    startat
))
expandleft(transform, molecule, generations, node, offset) = _expand(transform, molecule, generations, node, offset, E_LEFT)
expandright(transform, molecule, generations, node, offset) = _expand(transform, molecule, generations, node, offset, E_RIGHT)