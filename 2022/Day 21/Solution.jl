module Day21
using Underscores
include("Monkeys.jl")
include("Data.jl")
include("Calculations.jl")

"""
`part1() -> Int`

Solve Advent of Code 2022 day 21, part 1, reading data from "input.txt". That
is, calculates the value of monkey "root" given the values and equations given.
"""
function part1()
    monkeys = readdata()
    calcvalues!(monkeys)
    return value(monkeys, "root")
end

"""
`part2() -> Int`

Solve Advent of Code 2022 day 21, part 2, reading data from "input.txt". That
is, calculates the value that "humn" must shout in order for the monkey "root"
to receive equal values.
"""
function part2()
    monkeys = readdata()
    removeval!(monkeys, "humn")
    # calculate every monkey's value that we can
    calcvalues!(monkeys)

    # all values have been calculated, except for "root", and a sequence from
    # there leading to "humn". One of "root"s left or right childs will have a
    # value, the other won't. Copy the value from one to the other.
    l, r = left(monkeys, "root"), right(monkeys, "root")
    if hasval(monkeys, l)
        addval!(monkeys, r => value(monkeys, l))
    else
        addval!(monkeys, l => value(monkeys, r))
    end
    removeeqn!(monkeys, "root")

    # calculate value in reverse
    calcvalues!(monkeys, rev=true)
    return value(monkeys, "humn")
end
end;
Day21.part1(), Day21.part2()