# To calculate in both directions we need to take an equation like:
#   mnky: ape1 (op) ape2
# and be able to calculate any one from the other two. Since - and / are not
# commutative they have different left and right inverses
struct Operation
    fn::Function
    linv::Function
    rinv::Function
end
fn(o::Operation) = o.fn
linv(o::Operation) = o.linv
rinv(o::Operation) = o.rinv

const Ops = Dict{String, Operation}(
    "+" => Operation(+, -, -),
    "-" => Operation(-, +, (p, l) -> l - p),
    "*" => Operation(*, ÷, ÷),
    "/" => Operation(÷, *, (p, l) -> l ÷ p)
)

# Store monkey names as strings
mutable struct Equation
    op::Operation
    left::AbstractString
    right::AbstractString
end
op(e::Equation) = e.op
left(e::Equation) = e.left
right(e::Equation) = e.right

# Monkey names as keys to both dictionaries
struct Monkeys
    vals::Dict{String, Int}
    eqns::Dict{String, Equation}
end

# Convenience functions. With multiple dispatch functions are to be preferred
# to accessing fields directly. This way we can easily change the underlying
# implementation with simple function redefinitions.
Monkeys() = Monkeys(Dict{String, Int}(), Dict{String, Equation}())
op(m::Monkeys, monkey) = op(m.eqns[monkey])
left(m::Monkeys, monkey) = left(m.eqns[monkey])
right(m::Monkeys, monkey) = right(m.eqns[monkey])
value(m::Monkeys, monkey) = m.vals[monkey]
unsolved(m::Monkeys) = keys(m.eqns)

Base.broadcastable(m::Monkeys) = Ref(m)

addval!(m::Monkeys, p::Pair) = push!(m.vals, p)
addeqn!(m::Monkeys, p::Pair) = push!(m.eqns, p)
removeval!(m::Monkeys, monkey) = delete!(m.vals, monkey)
removeeqn!(m::Monkeys, monkey) = delete!(m.eqns, monkey)

hasval(m::Monkeys, monkey) = haskey(m.vals, monkey)
haseqn(m::Monkeys, monkey) = haskey(m.eqns, monkey)
