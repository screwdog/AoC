function subarrays(A, len)
    ithview(i) = view(A, i:i+len-1)
    return ithview.(1:size(A,1)-len+1)
end

function nodeat(generations, location, f)
    nodes = Node[]
    for generation ∈ generations
        append!(nodes, filter(n -> f(n) == location, generation))
    end
    return nodes
end
startat(generations, location) = nodeat(generations, location, first)
endat(generations, location) = nodeat(generations, location, last)

function firstgeneration(transforms, molecule)
    generation = Node[]
    for transform ∈ transforms
        views = subarrays(molecule, length(transform))
        locations = findall((==)(to(transform)), views)
        ranges = range.(locations; length=length(transform))
        append!(generation, Node.(ranges, from(transform), 1))
    end
    return generation
end

allnodes(generations) = Iterators.flatten(generations)
isnewnode(n::Node, generations) = all(x -> (!issame(x, n) || n < x), allnodes(generations))

function filtergeneration!(generation, generations)
    unique!(generation)
    filter!(n -> isnewnode(n, generations), generation)
    return generation
end

function nextgeneration(transforms, molecule, generations)
    newgeneration = Node[]
    for node ∈ last(generations)
        nodes = expandnode(transforms, molecule, generations, node)
        append!(newgeneration, nodes)
    end
    return filtergeneration!(newgeneration, generations)
end

function allgenerations(transforms, molecule)
    generations = Vector{Node}[]
    generation = firstgeneration(transforms, molecule)
    while !isempty(generation)
        push!(generations, generation)
        generation = nextgeneration(transforms, molecule, generations)
    end
    return generations
end