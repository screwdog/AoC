using Underscores, Base.Iterators
"""
`day10()`

Calculates the answer to both parts 1 and 2 of Advent of Code 2022, day 10,
reading input from "input.txt". That is, interprets the pseudo-assembly code
and calculates the correct value for the register X at each clock cycle. This
is then used to calculate the signal strength (for part 1) and the display
(for part 2).
"""
function day10()
    # Trick here is to recognise that if we split the input at white space we
    # find that "noop" is a single token, and takes one cycle to process, while
    # "addx n" is two tokens and takes two cycles. If we convert "noop"/"addx"
    # to the value "0", then we are left with a sequence of numbers that are
    # the changes to register X at each cycle.
    valX = @_ read("input.txt", String)         |>
        split                                   |>
        replace.(__, r"[a-z]+" => s"0")         |>
        parse.(Int, __)                         |>
    # Appending 1 represents the initial value of the register, and then we can
    # discard the final cycle since its effect occurs at the end of the cycle
    # and so can't effect anything.
        [1, __[1:end-1]...]                     |>
    # Since each number represents the change in X, the cumulative sum of these
    # values gives the actual value of X at each cycle
        cumsum

    @_ valX                                     |>
        (20:40:220) .* __[20:40:220]            |>
        sum                                     |>
        println

    @_ valX                                     |>
    # each value of X corresponds to a range of pixels
        map(_-1:_+1, __)                        |>
    # cycles need to be 0-based to correspond to the X values
        .∈(mod.(0:length(__)-1, 40), __)        |>
        map(_ ? '█' : ' ', __)                  |>
        partition(__, 40)                       |>
        join.(__)                               |>
        println.(__)
end
day10();