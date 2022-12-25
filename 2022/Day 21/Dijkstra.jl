MAX_DIST() = 10_000

monkeyNum(monkeys, name) = findfirst(monkey -> monkey[NAME] == name, eachcol(monkeys))

function allPaths!(monkeys, from)
    monkeys[DISTANCE, :] .= MAX_DIST() #function call only happens once
    visited = fill(false, size(monkeys,2))
    fromNum = monkeyNum(monkeys, from)
    queue = [fromNum]
    monkeys[DISTANCE, fromNum] = 0

    while !isempty(queue)
        num = popfirst!(queue)

        visited[num] && continue
        visited[num] = true

        for depName ∈ (monkeys[DEP_LEFT, num], monkeys[DEP_RIGHT, num])
            depNum = monkeyNum(monkeys, depName)
            monkeys[OPERATION, depNum] == NOOP && continue
            monkeys[DISTANCE, depNum] = min(monkeys[DISTANCE, depNum], monkeys[DISTANCE, num] + 1)
            !visited[depNum] && push!(queue, depNum)
        end
    end
    return monkeys
end

function dependents(monkeys, root)
    deps = [root]
    unscanned = [root]
    while !isempty(unscanned)
        monkey = popfirst!(unscanned)
        newDeps = Int[]
        for m ∈ eachcol(monkeys)
            m[NAME] ∈ deps && continue
            monkey ∈ (m[DEP_LEFT], m[DEP_RIGHT]) && push!(newDeps, m[NAME])
        end
        append!(unscanned, newDeps)
        append!(deps, newDeps)
    end
    return deps
end