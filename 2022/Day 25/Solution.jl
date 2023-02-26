module Day25
using Underscores

const SNAFU_CHARS = "=-012"
snafu_char(i) = SNAFU_CHARS[i + 3]
snafu_val(c) = findfirst((==)(c), SNAFU_CHARS) - 3

parsesnafu(str) = @_ snafu_val.(collect(str)) |> foldl((a,b) -> 5a + b, __)

function snafu(n)
    n == 0 && return 
    snafu_chars = Char[]
    while n > 0
        # next 2 lines are the same for normal base conversion
        d = mod(n, -2:2)
        n = (n - d) ÷ 5
        pushfirst!(snafu_chars, snafu_char(d))
    end
    return join(snafu_chars)
end

"""
`day25() -> String`

Solves Advent of Code 2022 day 25, reading the input from "input.txt". That is,
sums the numbers in the input file, interpreting them as balanced quinary, and
returns the sum in the same format.
"""
function day25()
    @_ "input.txt"      |>
        readlines       |>
        parsesnafu.(__) |>
        sum             |>
        snafu
end
end;
Day25.day25()
