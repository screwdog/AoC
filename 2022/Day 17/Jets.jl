const LEFT_CHAR = '<'

"""
`StatefulCycle{T}`

Represents an iterator that returns items from a finite collection in order
and then repeats this process endlessly. Used to represent the sequence of
blocks falling and the sequence of air jets.
"""
mutable struct StatefulCycle{T}
    vec::Vector{T}
    len::Int
    curr::Int
    StatefulCycle(v) = new{eltype(v)}(v, length(v), length(v))
end
state(sc::StatefulCycle) = sc.curr
cyclelength(sc::StatefulCycle) = sc.len
reset!(sc::StatefulCycle) = sc.curr = sc.len
# Conforming fully to the Iterator interface is unnecessary but helpful during
# development and debugging
function Base.iterate(sc::StatefulCycle, state=nothing)
    sc.curr = mod1(sc.curr + 1, sc.len)
    return (sc.vec[sc.curr], sc.curr)
end
Base.IteratorSize(::StatefulCycle) = Base.IsInfinite()
Base.IteratorEltype(::StatefulCycle) = Base.HasEltype()
Base.eltype(::StatefulCycle{T}) where T = T
Base.isdone(sc::StatefulCycle, state=nothing) = false

jets(v::Vector{Bool}) = StatefulCycle(v)
# create an iterator from a string of '<' and '>" as found in "input.txt".
jets(str::AbstractString) = @_ str  |> 
    collect                         |>
    map((==)(LEFT_CHAR), __)        |>
    jets