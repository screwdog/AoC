"""
`throwitem!(monkey, monkeys, item)`

Throws `item` *from* `monkey`, determining which monkey it should be thrown to
based on `monkey`'s test criteria. That is, whether `item` is divisible by the
monkey's `test` value.
"""
function throwitem!(monkey, monkeys, item)
    incthrown!(monkey)
    monkeyto = throwto(monkey, testpasses(monkey, item))
    additem!(monkeys[monkeyto], item)
end

"""
`monkeyturn!(monkey, monkeys, part2)`

Perform `monkey`'s turn by examining each item it is holding and then throwing
each according to whether they pass or fail the test. Change the worry value of
each item in accordance to the rules of part 1 (`part2` false) or part 2
(`part2` true).

For part 2, each item's worry value is recorded modulo the lcm of the monkey's
test values. In this way, the divisibility is not affected but the worry values
don't grow excessively.
"""
function monkeyturn!(monkey, monkeys, part2)
    part2 && (divisor = lcm(test.(values(monkeys))...))
    while !isempty(items(monkey))
        item = getitem!(monkey)
        worry = op(monkey)(item)
        part2 || (worry ÷= 3)
        part2 && (worry = mod(worry, divisor))
        throwitem!(monkey, monkeys, worry)
    end
    return nothing
end

"""
`monkeyround!(monkeys, part2)`

Perform a round of the game, where each monkey takes a turn, in numerical order
by monkey.
"""
function monkeyround!(monkeys, part2)
    monkeynums = monkeys |> keys |> collect |> sort
    for i ∈ monkeynums
        monkeyturn!(monkeys[i], monkeys, part2)
    end
end

function monkeyrounds!(monkeys, rounds, part2)
    for _ ∈ 1:rounds
        monkeyround!(monkeys, part2)
    end
end
