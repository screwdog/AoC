using Underscores

function day8()
    @_ readlines("input.txt")                               |>
        map([escape_string(_), _, unescape_string(_)], __)  |>
        map(length.(_), __)                                 |>
        map(_[1:2] - _[2:3], __)                            |>
        map(_ .+ 2, __)                                     |>
        reduce(+, __)                                       |>
        reverse(__)
end

day8()