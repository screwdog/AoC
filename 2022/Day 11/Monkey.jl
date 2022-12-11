mutable struct Monkey
    number::Int
    items::Vector{Int}
    operation::Function
    test::Int
    throwto::Tuple{Int, Int}
    inspectionCount::Int
end
Monkey(number, items, op, test, throwto) = Monkey(number, items, op, test, throwto, 0)

function parseNumber(str)
    m = match(r"Monkey (\d+)", str)
    return parse(Int, first(m))
end

function parseItems(str)
    ms = eachmatch(r"(\d+)", str)
    nums = parse.(Int, first.(ms))
    return nums
end

function parseOp(str)
    ops = Dict([
        "+" => +,
        "*" => *,
        "-" => -,
        "/" => ÷
    ])
    m = match(r"Operation: new = old (.+) (-?\d+|\w+)", str)
    op = ops[m[1]]
    num = tryparse(Int, m[2])
    if num === nothing
        # assume last(m) == "old"
        return (old -> op(old, old))
    else
        return (old -> op(old, num))
    end
end

function parseTest(str)
    # assume the only tests are divisibility ones
    m = match(r"Test: divisible by (\d+)", str)
    return parse(Int, first(m))
end

parseTrueTo(line) = parse(Int, match(r"(\d+)", line).match)
parseFalseTo(line) = parseTrueTo(line)

function parseMonkey(lines)
    parsers = [parseNumber, parseItems, parseOp, parseTest, parseTrueTo, parseFalseTo]
    data = [parsers[i](lines[i]) for i ∈ axes(parsers,1)]
    data[5] = (data[5], pop!(data))
    return Monkey(data...)
end

function readAllMonkeys(file)
    lines = readlines(file)
    filter!((≠)(""), lines)
    parts = Iterators.partition(lines, 6)
    monkeys = Dict{Any, Monkey}()
    for ls ∈ parts
        m = parseMonkey(ls)
        monkeys[m.number] = m
    end
    return monkeys
end