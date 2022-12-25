_merge(r::AbstractUnitRange, s::AbstractUnitRange) = min(first(r), first(s)):max(last(r), last(s))

function _addrange!(c::Vector{UnitRange{Int}}, r::AbstractUnitRange)
    _addToEmpty(c, r) = (push!(c,r); c)
    _addToEnd(c, r) = (isdisjoint(c[end], r) ? push!(c, r) : (c[end] = _merge(c[end], r)); c)
    
    isempty(r) && return c
    isempty(c) && return _addToEmpty(c, r)
    i = searchsortedfirst(c, r)
    i > length(c) && return _addToEnd(c, r)

    i > 1 && !isdisjoint(c[i-1], r) && (i -= 1)
    insert!(c, i, r)
    while i < length(c) && !isdisjoint(c[i], c[i+1])
        c[i] = _merge(c[i], popat!(c, i+1))
    end
    return c
end

function _allDisjoint!(c::Vector{UnitRange{Int}})
    length(c) ≤ 1 && return true
    sort!(c)
    return all(map(isdisjoint, c[1:end-1], c[2:end]))
end

function _makeDisjoint!(c::Vector{UnitRange{Int}})
    sort!(c)
    i = 1
    while i < length(c)
        if isdisjoint(c[i], c[i+1])
            i += 1
        else
            c[i] = _merge(c[i], popat!(c, i+1))
        end
    end
    return c
end

struct DisjointRanges
    ranges :: Vector{UnitRange{Int}}
    function DisjointRanges(c::Vector{UnitRange{Int}})
        r = copy(c)
        _allDisjoint!(r) || _makeDisjoint!(r)
        return new(r)
    end
end
DisjointRanges() = DisjointRanges(UnitRange{Int}[])
DisjointRanges(r::AbstractUnitRange) = DisjointRanges([r])
DisjointRanges(c::Any) = DisjointRanges(collect(c))

_addrange!(d::DisjointRanges, r::AbstractUnitRange) = (_addrange!(d.ranges, r); d)
Base.push!(d::DisjointRanges, r::AbstractUnitRange) = (_addrange!(d,r); d)
Base.pop!(d::DisjointRanges) = pop!(d.ranges)
Base.popfirst!(d::DisjointRanges) = popfirst!(d.ranges)
Base.deleteat!(d::DisjointRanges, i::Int) = deleteat!(d.ranges, i)
Base.iterate(d::DisjointRanges) = iterate(d.ranges)
Base.iterate(d::DisjointRanges, state) = iterate(d.ranges, state)
Base.getindex(d::DisjointRanges, i::Int) = d.ranges[i]
Base.in(a::Int, d::DisjointRanges) = any(a .∈ d.ranges)
Base.isequal(r::AbstractUnitRange, d::DisjointRanges) = [r] == d.ranges
Base.collect(d::DisjointRanges) = vcat(collect.(d.ranges))
Base.isempty(d::DisjointRanges) = isempty(d.ranges)
Base.issubset(r::AbstractUnitRange, d::DisjointRanges) = any(Ref(r) .⊆ d.ranges)
Base.issubset(d1::DisjointRanges, d2::DisjointRanges) = all(d1 .⊆ Ref(d2))
Base.issubset(d::DisjointRanges, r::AbstractUnitRange) = all(d .⊆ Ref(r))
Base.union!(d::DisjointRanges, r::AbstractUnitRange) = _addrange!(d,r)
Base.union!(d1::DisjointRanges, d2::DisjointRanges) = d1.ranges = _makeDisjoint!(vcat(d1.ranges, d2.ranges))
Base.union(d::DisjointRanges, r::AbstractUnitRange) = union!(deepcopy(d), r)
Base.union(d1::DisjointRanges, d2::DisjointRanges) = union!(deepcopy(d1), d2)
Base.union(r::AbstractUnitRange, d::DisjointRanges) = union(d,r)
function Base.intersect!(d::DisjointRanges, r::AbstractUnitRange)
    
end
Base.intersect!(d1::DisjointRanges, d2::DisjointRanges) = intersect!.(Ref(d1), d2)
Base.intersect(d::DisjointRanges, r::AbstractUnitRange) = intersect!(deepcopy(d.ranges), r)
Base.intersect(d1::DisjointRanges, d2::DisjointRanges) = intersect!.(Ref(deepcopy(d1)), d2)
Base.intersect(r::AbstractUnitRange, d::DisjointRanges) = intersect(d,r)

function _setdiff(r1::AbstractUnitRange, r2::AbstractUnitRange)
    isdisjoint(r1, r2) && return r1
    r = r1 ∩ r2
    s = first(r1):first(r)-1
    e = last(r)+1:last(r1)
    return DisjointRanges([s,e])
end
function Base.setdiff!(d::DisjointRanges, r::AbstractUnitRange)
    @show d, r
    d.ranges = _makeDisjoint!(_setdiff.(d, Ref(r)))
end
Base.setdiff!(d1::DisjointRanges, d2::DisjointRanges) = setdiff!.(Ref(d1), d2)
Base.setdiff(d::DisjointRanges, r::AbstractUnitRange) = setdiff!(deepcopy(d), r)
Base.setdiff(d1::DisjointRanges, d2::DisjointRanges) = setdiff!.(Ref(deepcopy(d1)), d2)
Base.setdiff(r::AbstractUnitRange, d::DisjointRanges) = setdiff(DisjointRanges(r), d)
