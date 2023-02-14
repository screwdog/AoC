# can we calculate the value of this monkey?
issolvable(m::Monkeys, monkey) = 
    hasval(m, left(m, monkey)) && hasval(m, right(m, monkey))

# can we calculate the value of a monkey, working backwards from this monkey?
# That is, do we have a value for this monkey and one of its children so we can
# calculate the other. This is needed for the 2nd half of part 2.
function issolvableinv(m::Monkeys, monkey)
    return hasval(m, monkey) && (
        hasval(m, left(m, monkey)) ⊻
        hasval(m, right(m, monkey))
    )
end

# can we calculate a value from this monkey? (either forwards or backwards)
function issolvable(m::Monkeys, monkey, rev)
    !rev && return issolvable(m, monkey)
    return issolvableinv(m, monkey)
end
issolvable(m::Monkeys, rev::Bool) = monkey -> issolvable(m, monkey, rev)

# calculate the value of a new monkey, based on this monkey. Forwards that means
# calculating the value of this monkey based on its two children. In reverse we
# use the value of this monkey and a child to calculate the value of the other
# child
function setvalue!(m::Monkeys, monkey, rev)
    # "parent" monkey, left operand monkey, right operand monkey:
    #   parent = left (op) right
    p, l, r = monkey, left(m, monkey), right(m, monkey)

    if !rev
        addval!(m, p => fn(op(m, p))(value(m, l), value(m, r)))
    else
        if hasval(m, l)
            addval!(m, r => rinv(op(m, p))(value(m, p), value(m, l)))
        else
            addval!(m, l => linv(op(m, p))(value(m, p), value(m, r)))
        end
    end
end

# repeatedly search for monkeys whose value we can determine and then do so,
# stopping when no progress can be made.
function calcvalues!(monkeys; rev=false)
    while true
        solvable = filter(issolvable(monkeys, rev), unsolved(monkeys))
        isempty(solvable) && return monkeys
        for monkey ∈ solvable
            setvalue!(monkeys, monkey, rev)
            removeeqn!(monkeys, monkey)
        end
    end
end