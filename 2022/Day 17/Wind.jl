mutable struct Wind
    directions::AbstractString
    current::Int
    function Wind(dirs::AbstractString, curr::Int)
        isempty(dirs) && throw(ErrorException("Wind requires directions::String to be non-empty but received $dirs"))
        0 ≤ curr ≤ length(dirs)-1 || throw(ErrorException("Wind requires 0 ≤ current ≤ length(directions)-1 but received directions $dirs and current $curr"))
        new(dirs, curr)
    end
end
Wind(dirs::AbstractString) = Wind(dirs,0)
function Base.iterate(w::Wind, state)
    w.current = mod(w.current, length(w.directions)) + 1
    (w.directions[w.current], w.current)
end
Base.iterate(w::Wind) = iterate(w, 0)
next(w::Wind) = w |> iterate |> first
Base.IteratorSize(::Wind) = Base.IsInfinite()
Base.eltype(::Wind) = Char
Base.isdone(::Wind, state) = false
Base.isdone(::Wind) = false