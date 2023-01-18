module Day11
using Underscores
include("Monkey.jl")
include("Game.jl")

"""
`monkeybusiness(monkeys)`

Returns the current amount of "monkey business". This is the product of the
number of items thrown by the two most active monkeys.
"""
monkeybusiness(monkeys) = @_ monkeys    |>
    values                              |>
    numthrown.(__)                      |>
    partialsort!(__, 1:2, rev=true)     |>
    prod

"""
`day11(part2::Bool)`

Calculates the answer to Advent of Code 2022, day 11, reading input from
"input.txt". That is, calculates the amount of "monkey business" after a
certain number of Keep Away are played by the monkeys given in the input. For
part 1 (`part2` false), the amount of worry is divided by three after each
inspection and 20 rounds are performed. For part 2 (`part2` true) the worry is
not decreased after inspection and 10,000 rounds are performed.
"""
function day11(part2)
    rounds = !part2 ? 20 : 10_000
    monkeys = readdata()
    monkeyrounds!(monkeys, rounds, part2)
    return monkeybusiness(monkeys)
end
end;
@time Day11.day11.(false:true)
