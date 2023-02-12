# to avoid building unnecessary robots, each blueprint stores the maximum number
# of each robot to build
maxrobot(robots, i) = maximum(r -> requires(r, i), robots)
function maxrobots(robots)
    maxneeds = [maxrobot(robots, i) for i ∈ 1:3]
    push!(maxneeds, MAX_TIME)
    return Resources(maxneeds)
end

# convenient to iterate over the robot templates in a blueprint so make it a
# sub-type of AbstractVector.
struct Blueprint <: AbstractVector{Robot}
    # store the number to calculate quality in case input is out of order
    num::Int
    robots::Vector{Robot}
    maxrobots::Robots
    Blueprint(n::Int, r::Vector{Robot}) = new(n, r, maxrobots(r))
end
Blueprint(strs) = Blueprint(number(first(strs)), robot.(strs[begin+1:end]))
number(b::Blueprint) = b.num
maxrobots(b::Blueprint) = b.maxrobots

# Blueprint is immutable so only needs 3 methods to function as an AbstractVector
Base.IndexStyle(::Blueprint) = IndexLinear()
Base.size(b::Blueprint) = size(b.robots)
Base.getindex(b::Blueprint, i) = b.robots[i]

splitline(line) = split(line, ['.', ':']; keepempty = false)
splitlines(lines) = splitline.(lines)

"""
`readdata() -> Vector{Blueprint}`

Read from "input.txt" and return a vector of `Blueprint` corresponding to the
data in it.
"""
function readdata()
    @_ "input.txt"              |>
        readlines               |>
        splitlines              |>
        Blueprint.(__)
end
