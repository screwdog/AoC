const LEFT_CHAR = '<'

wind(v::Vector{Bool}) = v |> Iterators.Cycle |> Iterators.Stateful
wind(str::AbstractString) = @_ str  |> 
    collect                         |>
    map((==)(LEFT_CHAR), __)        |>
    wind