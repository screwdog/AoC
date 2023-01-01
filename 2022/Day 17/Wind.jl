const LEFT_CHAR = '<'

mutable struct StatefulCycle
    vec::Vector
    len::Int
    curr::Int
    StatefulCycle(v) = new(v, length(v), length(v))
end
state(sc::StatefulCycle) = sc.curr
cyclelength(sc::StatefulCycle) = sc.len
reset!(sc::StatefulCycle) = sc.curr = sc.len
function Base.iterate(sc::StatefulCycle, state=nothing)
    sc.curr = mod1(sc.curr + 1, sc.len)
    return (sc.vec[sc.curr], sc.curr)
end
Base.IteratorSize(::StatefulCycle) = Base.IsInfinite()
Base.IteratorEltype(::StatefulCycle) = Base.HasEltype()
Base.eltype(sc::StatefulCycle) = el(sc.vec)
Base.isdone(sc::StatefulCycle, state=nothing) = false

wind(v::Vector{Bool}) = StatefulCycle(v)
wind(str::AbstractString) = @_ str  |> 
    collect                         |>
    map((==)(LEFT_CHAR), __)        |>
    wind