struct Transform
    from::Int
    to::Vector{Int}
end
Transform(v::Vector{Vector{Int}}) = Transform(only(first(v)), last(v))
from(t::Transform) = t.from
to(t::Transform) = t.to
Base.length(t::Transform) = length(t.to)
apply!(t::Transform, molecule, at) = splice!(molecule, at:at+length(t)-1, from(t))

struct Node
    range::UnitRange{Int}
    element::Int
    numtransforms::Int
end
Node(location) = Node(location:location, NULL_ELEMENT, 0)
Base.range(n::Node) = n.range
element(n::Node) = n.element
numtransforms(n::Node) = n.numtransforms
newelement(n::Node, element) = Node(range(n), element, numtransforms(n) + 1)
numtransforms(itr) = sum(numtransforms, itr)
Base.length(n::Node) = length(range(n))
Base.first(n::Node) = first(n.range)
Base.last(n::Node) = last(n.range)
leftjoin(x::Node, y::Node) = Node(first(x):last(y), element(y), numtransforms((x, y)))
rightjoin(x::Node, y::Node) = Node(first(y):last(x), element(y), numtransforms((x, y)))
isbefore(location, n::Node) = location < first(n)
isafter(location, n::Node) = location > last(n)
issame(x::Node, y::Node) = range(x) == range(y) && element(x) == element(y)
Base.:<(x::Node, y::Node) = numtransforms(x) < numtransforms(y)
