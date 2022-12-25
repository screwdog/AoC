QUEUE_LENGTH() = 100

mutable struct SimpleIndexQueue
    data::Matrix{Int}
    pointer::Int
end
SimpleIndexQueue() = SimpleIndexQueue(Matrix{Int}(undef, 2, QUEUE_LENGTH()), 0)

function Base.push!(q::SimpleIndexQueue, x::Int, y::Int)
    q.pointer < QUEUE_LENGTH() || throw(ErrorException("can't push!, queue is full. Try increasing QUEUE_LENGTH() = $(QUEUE_LENGTH())"))
    q.pointer += 1
    q.data[1,q.pointer], q.data[2,q.pointer] = x, y
    return nothing
end
function Base.pop!(q::SimpleIndexQueue)
    q.pointer ≥ 1 || throw(ErrorException("can't pop!, queue is empty"))
    x, y = q.data[1,q.pointer], q.data[2,q.pointer]
    q.pointer -= 1
    return x, y
end
Base.isempty(q::SimpleIndexQueue) = q.pointer == 0

function issubarray(needle, haystack)
    getView(vec, i, len) = view(vec, i:i+len-1)
    ithview(i) = getView(haystack, i, length(needle))
    return any(i -> ithview(i) == needle, 1:length(haystack)-length(needle)+1)
end