function Base.merge(r::AbstractUnitRange, s::AbstractUnitRange)
    isdisjoint(r,s) && throw(ErrorException("merge expects its arguments to overlap but received $r, $s"))
    return min(first(r), first(s)):max(last(r), last(s))
end

function addrange!(c::Vector{UnitRange{Int}}, r::AbstractUnitRange)
    if length(c) == 0
        push!(c, r)
        return c
    end
    i = searchsortedfirst(c, r)
    if i > length(c)
        if !isdisjoint(c[end], r)
            c[end] = merge(c[end], r)
        else
            insert!(c, i, r)
        end
        return c
    end
    i > 1 && !isdisjoint(c[i-1], r) && (i -= 1)
    !isdisjoint(c[i], r) && (c[i] = merge(c[i], r))
    while i < length(c) && !isdisjoint(c[i], c[i+1])
        c[i] = merge(c[i], popat!(c, i+1))
    end
    return c
end

struct DisjointRanges
    ranges :: Vector{UnitRange{Int}}
    function DisjointRanges(c::Vector{UnitRange{Int}})
        length(c) ≤ 1 && return new(c)
        sort!(c)
        all(map(isdisjoint, c[1:end-1], c[2:end])) || throw(ErrorException("ranges aren't disjoint"))
        return new(c)
    end
end
DisjointRanges() = DisjointRanges(UnitRange{Int}[])
DisjointRanges(r::AbstractUnitRange) = DisjointRanges([r])
function DisjointRanges(c::Any)
    Base.isiterable(typeof(c)) || throw(ErrorException("expected an iterable collection, received $c of type $(typeof(c))"))
    return DisjointRanges(collect(c))
end
addrange!(d::DisjointRanges, r::AbstractUnitRange) = addrange!(d.ranges, r)
Base.push!(d::DisjointRanges, r::AbstractUnitRange) = addrange!(d,r)
Base.pop!(d::DisjointRanges) = pop!(d.ranges)
Base.popfirst!(d::DisjointRanges) = popfirst!(d.ranges)
Base.deleteat!(d::DisjointRanges, i::Int) = deleteat!(d.ranges, i)
Base.iterate(d::DisjointRanges) = iterate(Iterators.flatten(d.ranges))
Base.iterate(d::DisjointRanges, state) = iterate(Iterators.flatten(d.ranges), state)
Base.in(a::Int, d::DisjointRanges) = a ∈ searchsortedfirst(d, a:a)
Base.isequal(r::AbstractUnitRange, d::DisjointRanges) = [r] == d.ranges
Base.collect(d::DisjointRanges) = vcat(collect.(d.ranges))