"""
`Monkey`

A single monkey, including the worry value of the items it is currently
carrying and the number of items it has thrown so far.
"""
mutable struct Monkey
    number::Int
    items::Vector{Int}
    operation::Function
    test::Int
    # number of the monkey to throw to is stored in reverse order:
    # (ifcheckfails, ifcheckpasses). This makes indexing easier.
    throwto::Tuple{Int, Int}
    numthrown::Int
end
Monkey(number, items, op, test, throwto) = Monkey(number, items, op, test, throwto, 0)
Monkey(itr) = Monkey(itr...)

number(m::Monkey) = m.number
items(m::Monkey) = m.items
op(m::Monkey) = m.operation
test(m::Monkey) = m.test
testpasses(m::Monkey, item) = mod(item, test(m)) == 0
# Bool ± Int treats true == 1, false == 0
throwto(m::Monkey, testpass) = m.throwto[testpass + 1]
numthrown(m::Monkey) = m.numthrown

getitem!(m::Monkey) = popfirst!(m.items)
additem!(m::Monkey, item) = push!(m.items, item)
incthrown!(m::Monkey) = m.numthrown += 1

parsenum(line) = parse(Int, only(match(r"(\d+)", line)))
parsenums(line) = parse.(Int, only.(eachmatch(r"(\d+)", line)))
function parseop(line)
    fns = Dict(["+" => +, "*" => *])
    m = match(r"(?'fn'[+*]{1}) (?'n'\d+)", line)
    m === nothing && return old -> old^2
    return old -> fns[m["fn"]](old, parse(Int, m["n"]))
end
# line "5" is actually lines 5 and 6 joined and we store them in reverse order
# ie (ifcheckfails, ifcheckpasses) for easier indexing
const parsefns = [parsenum, parsenums, parseop, parsenum, Tuple ∘ reverse ∘ parsenums]

"""
`parsemonkey(lines)`

Returns a `Monkey` representing the input `lines`. Makes some strong assumptions
about the format of the input:
    * line 1 contains a single number which is the number of this monkey
    * line 2 contains a list of item numbers currently being held
    * line 3 contains a function, which is "old + n", "old * n", or "old * old", where n is a number.
    * line 4 contains a single number which the monkey checks divisibility against
    * line 5 contains a single number which is the monkey number to throw the item to if the check passes
    * line 6 is like line 5 but if the check fails
Other text can appear in these lines but mustn't contain any numbers.
"""
function parsemonkey(lines)
    # we store the data from lines 5 and 6 in one field and so it's easier to
    # process them as a single line
    fixedlines = vcat(lines[1:4], join(lines[5:6]))
    # we want to apply a vector of functions to their corresponding arguments.
    # map.(parsefns, fixedlines) also works, but is arguably less clear since
    # we tend to use map to apply to entire collections rather than single
    # arguments.
    return Monkey(fixedlines .|> parsefns)
end

function readdata()
    input = readlines("input.txt")
    monkeylines = Iterators.partition(input, 7)
    monkeys = Dict{Int, Monkey}()
    for lines ∈ monkeylines
        monkey = parsemonkey(lines)
        monkeys[number(monkey)] = monkey
    end
    return monkeys
end
