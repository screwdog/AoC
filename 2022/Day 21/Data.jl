# functions to process the input file and convert to appropriate types. Makes
# very strong assumptions about the validity of the data.

# We assume that a monkey either has a literal value or has an infix binary
# operation between two other monkeys (ie no "mnky: dude + 10" or similar)
const VALUE_MONKEY = r"(\w+): (\d+)"
const OP_MONKEY = r"(\w+): (\w+) (.) (\w+)"

# Assumes if the line ends in a digit then it must be a "mkny: 1234" type line
isvaluemonkey(line) = isdigit(last(line))

function valuemonkey(line)
    m = match(VALUE_MONKEY, line)
    return m[1] => parse(Int, m[2])
end

function eqnmonkey(line)
    m = match(OP_MONKEY, line)
    op = Ops[m[3]]
    return m[1] => Equation(op, m[2], m[4])
end

function addmonkey!(m::Monkeys, line)
    # Assume either a value monkey or equation monkey. No error checking
    if isvaluemonkey(line)
        addval!(m, valuemonkey(line))
    else
        addeqn!(m, eqnmonkey(line))
    end
end

function readdata()
    monkeys = Monkeys()
    addmonkey!.(monkeys, eachline("input.txt"))
    return monkeys
end
