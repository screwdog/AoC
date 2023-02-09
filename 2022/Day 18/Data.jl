# Abstract supertype of our two droplet types
abstract type AbstractDroplet <: AbstractArray{Bool, 3} end

# read the input and return an iterator of points, where each point is an
# iterator of exactly three integer values
function readdata()
    @_ read("input.txt", String)    |>
        eachmatch(r"(\d+)", __)     |>
        only.(__)                   |>
        parse.(Int, __)             |>
        reshape(__, 3, :)           |>
        eachcol
end

ascartesian(points) = map(p -> CartesianIndex(p...), points)

# takes a sequence of points and returns a sequence of CartesianIndex's that
# represent them as well as the size of their bounding box. The values are
# shifted as their absolute location in space is unimportant for this problem
# and Julia arrays make it easier if all indices are positive.

# We also add a margin of empty space around the points (ie all indices are
# 2 ≤ index ≤ bound-1) so that the external empty space is a single connected
# region for traversal in part 2
function processdata(data)
    indices = ascartesian(data)
    extents = extrema(indices) .+ (CartesianIndex(-1,-1,-1), CartesianIndex(1,1,1))
    offset = first(extents) - CartesianIndex(1,1,1)
    return (indices .- Ref(offset), last(extents) - offset)
end

processed_input() = readdata() |> processdata

"""
`droplet(T::Type) -> droplet`

Returns a droplet of the specified type based on the data in "input.txt".
"""
droplet(T::Type) = T(processed_input())
