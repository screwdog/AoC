using Underscores, Base.Iterators
@_ read("input.txt", String)        |>
    split                           |>
    tryparse.(Int, __)              |>
    pushfirst!(__, 1)               |>
    map(_ === nothing ? 0 : _, __)  |>
    cumsum                          |>
    (20:40:220) .* __[20:40:220]    |>
    sum

@_ read("input.txt", String)                |>
    split                                   |>
    tryparse.(Int, __)                      |>
    pushfirst!(__, 1)                       |>
    deleteat!(__, length(__))               |>
    map(_ === nothing ? 0 : _, __)          |>
    cumsum                                  |>
    map(_-1:_+1, __)                        |>
    .∈(take(cycle(0:39), length(__)), __)   |>
    reshape(__, (40, 6))'                   |>
    map(_ ? '■' : ' ', __)                  |>
    [join(__[i,:]) for i ∈ 1:size(__,1)]

    