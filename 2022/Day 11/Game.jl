function monkeyturn!(monkey, monkeys, part2)
    part2 && (divisor = lcm(map(m -> m.test, values(monkeys))...))
    for item ∈ monkey.items
        monkey.inspectionCount += 1
        newWorry = monkey.operation(item)
        part2 || (newWorry ÷= 3)
        part2 && (newWorry = mod(newWorry, divisor))
        testpasses = mod(newWorry, monkey.test) == 0
        newmonkey = monkey.throwto[testpasses ? 1 : 2]
        push!(monkeys[newmonkey].items, newWorry)
    end
    deleteat!(monkey.items, axes(monkey.items,1))
    return nothing
end

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