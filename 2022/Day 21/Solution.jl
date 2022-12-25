using Underscores
NAME = 1
VALUE = 2
DEP_LEFT = 3
OPERATION = 4
DEP_RIGHT = 5
DISTANCE = 6

include("Dijkstra.jl")

NOOP = -1
PLUS = 1
MINUS = 2
MULTIPLY = 3
DIVIDE = 4
EQUAL = 5

OP_CHARS = Dict([
    "+" => PLUS,
    "-" => MINUS,
    "*" => MULTIPLY,
    "/" => DIVIDE,
])

err(x,y) = throw(ErrorException("invalid operation on monkeys (x,y) = ($x, $y)"))

OPERATIONS = Dict([
    NOOP => err,
    PLUS => +,
    MINUS => -,
    MULTIPLY => *,
    DIVIDE => ÷
])

"""
    INV_OPS[op] = (parent, left || right)

Inverse operations for reverse dependency traversal. If the parent node
has the equation `parent` = `left` op `right`, then these are the
operations necessary to calculate `left` or `right`. That is,

    parent = left op right
    left = INV_OPS[op][1](parent, right)
    right = INV_OPS[op][2](parent, left)
"""
INV_OPS = Dict([
    NOOP => (err, err),
    PLUS => (-, -),
    MINUS => (+, (p,l) -> l-p),
    MULTIPLY => (÷, ÷),
    DIVIDE => (*, Int ∘ \)
])

str2Int(str) = reinterpret(Int, hash(str))

function getMonkeyData(filename)
    numMonkeys = countlines(filename)
    data = fill(-1, 6, numMonkeys)

    open(filename) do file
        for currMonkey ∈ 1:numMonkeys
            monkeyData = @_ readline(file)              |>
                split(__, [':', ' '], keepempty=false)

            data[NAME, currMonkey] = str2Int(monkeyData[1])
            if length(monkeyData) == 2
                data[VALUE, currMonkey] = parse(Int, monkeyData[2])
            else
                data[[DEP_LEFT,DEP_RIGHT], currMonkey] .= str2Int.(monkeyData[[2,4]])
                data[OPERATION, currMonkey] = OP_CHARS[monkeyData[3]]
            end
        end
    end
    return data
end

function fixData!(monkeys, root, human)
    humanNum = monkeyNum(monkeys, human)
    monkeys[[VALUE, OPERATION], humanNum] .= -1
    monkeys[[DEP_LEFT, DEP_RIGHT], humanNum] .= root
end

function getValues(monkeys)
    vals = Dict{Int,Int}([])
    for monkey ∈ eachcol(monkeys)
        monkey[VALUE] ≠ -1 && (vals[monkey[NAME]] = monkey[VALUE])
    end
    return vals
end

function prepData!(monkeys)
    for monkey ∈ eachcol(monkeys)
        monkey[DISTANCE] == MAX_DIST() && (monkey[DISTANCE] = -MAX_DIST())
    end
    return sortslices(monkeys, dims=2, lt=(a,b) -> a[DISTANCE] < b[DISTANCE], rev=true)
end

function calcVals!(vals, monkeys; forward=true, exclude=[])
    uncalculated = findall(m -> m[DISTANCE] ≥ 0, eachcol(monkeys))
    calcRange = first(uncalculated):last(uncalculated)
    for currNum ∈ (forward ? calcRange : reverse(calcRange))
        monkeys[NAME, currNum] ∈ exclude && continue
        if forward
            monkeys[VALUE, currNum] = 
                OPERATIONS[monkeys[OPERATION, currNum]](
                    vals[monkeys[DEP_LEFT, currNum]],
                    vals[monkeys[DEP_RIGHT, currNum]]
                )
            vals[monkeys[NAME, currNum]] = monkeys[VALUE, currNum]
        else
            if monkeys[DEP_LEFT, currNum] ∉ keys(vals)
                leftNum = monkeyNum(monkeys, monkeys[DEP_LEFT, currNum])
                monkeys[VALUE, leftNum] =
                    INV_OPS[monkeys[OPERATION, currNum]][1](
                        monkeys[VALUE, currNum],
                        vals[monkeys[DEP_RIGHT, currNum]])
                vals[monkeys[DEP_LEFT, currNum]] = monkeys[VALUE, leftNum]
            elseif monkeys[DEP_RIGHT, currNum] ∉ keys(vals)
                rightNum = monkeyNum(monkeys, monkeys[DEP_RIGHT, currNum])
                monkeys[VALUE, rightNum] =
                    INV_OPS[monkeys[OPERATION, currNum]][2](
                        monkeys[VALUE, currNum],
                        vals[monkeys[DEP_LEFT, currNum]])
                vals[monkeys[DEP_RIGHT, currNum]] = monkeys[VALUE, rightNum]
            end
        end
    end
    return vals
end

function calcRoot!(vals, monkeys, root)
    rootNum = monkeyNum(monkeys, root)
    leftNum = monkeyNum(monkeys, monkeys[DEP_LEFT, rootNum])
    rightNum = monkeyNum(monkeys, monkeys[DEP_RIGHT, rootNum])
    if monkeys[DEP_LEFT, rootNum] ∉ keys(vals)
        monkeys[VALUE, leftNum] = monkeys[VALUE, rightNum]
        vals[monkeys[DEP_LEFT, rootNum]] = monkeys[VALUE, leftNum]
    elseif monkeys[DEP_RIGHT, rootNum] ∉ keys(vals)
        monkeys[VALUE, rightNum] = monkeys[VALUE, leftNum]
        vals[monkeys[DEP_RIGHT, rootNum]] = monkeys[VALUE, rightNum]
    end
end

function day21(part2=false, test=false)
    MONKEY_OF_INTEREST = str2Int(part2 ? "humn" : "root")
    ROOT = str2Int("root")

    monkeys = getMonkeyData(test ? "test.txt" : "input.txt")
    part2 && fixData!(monkeys, ROOT, MONKEY_OF_INTEREST)
    allPaths!(monkeys, ROOT)
    vals = getValues(monkeys)
    monkeys = prepData!(monkeys)
    deps = part2 ? dependents(monkeys, MONKEY_OF_INTEREST) : []
    calcVals!(vals, monkeys, forward=true, exclude=deps)
    if part2
        calcRoot!(vals, monkeys, ROOT)
        calcVals!(vals, monkeys, forward=false)
    end
    return vals[MONKEY_OF_INTEREST]
end
day21(true, true)