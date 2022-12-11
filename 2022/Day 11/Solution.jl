include("Monkey.jl")
include("Game.jl")

function summariseRounds(monkeys)
    monkeynums = monkeys |> keys |> collect |> sort
    for num ∈ monkeynums
        println("Monkey $num inspected items $(monkeys[num].inspectionCount) times.")
    end
end

function day11(part2, test=false)
    part2 && test && (SUMMARY_ROUNDS = [1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10_000])

    inputfile = test ? "test.txt" : "input.txt"
    monkeys = readAllMonkeys(inputfile)
    if !part2
        monkeyrounds!(monkeys, 20, part2)
        test && summariseRounds(monkeys)
    else
        if test
            round = 0
            for nextStop ∈ SUMMARY_ROUNDS
                δ = nextStop - round
                monkeyrounds!(monkeys, δ, part2)
                println("\n== After round $nextStop ==")
                summariseRounds(monkeys)
                round += δ
            end
        else
            monkeyrounds!(monkeys, 10_000, part2)
        end
    end

    values(monkeys) |>
        ms -> map(m -> m.inspectionCount, ms) |>
        sort |>
        cs -> cs[end-1] * cs[end]
end
day11.(false:true)