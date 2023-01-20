module Day12
using Underscores
include("Dijkstra.jl")

"""
`startend!(heights) -> (start, end)`

Returns the start and ending locations in `heights` and sets their height data
appropriately.
"""
function startend!(heights)
    findonly = c -> only(findall((==)(c), heights))
    S, E = findonly.(('S', 'E'))
    heights[S], heights[E] = 'a', 'z'
    return (S, E)
end

"""
`readdata() -> (heights::Matrix{Char}, S::CartesianIndex{2}, E::CartesianIndex{2})`

Reads the puzzle data from "input.txt" and returns the height data as well as
the locations for the start and end of the path as `S` and `E`.
"""
function readdata()
    heights = @_ "input.txt"    |>
        readlines               |>
        collect.(__)            |>
        hcat(__...)             |>
        permutedims
    S, E = startend!(heights)
    return heights, S, E
end

"""
`lowest(heights) -> Vector{CartesianIndex{2}}`

Returns a vector of all locations in `heights` that are at the minimum height.
"""
function lowest(heights)
    low = minimum(heights)
    return findall((==)(low), heights)
end

"""
`day12(part2::Bool)`

Calculates the answer to Advent of Code 2022, day 12, reading input from
"input.txt". That is, calculates the length of the shortest path from the given
start location to the ending location (part 1), or the shortest path from any
of the lowest places on the map to the ending location (part 2).
"""
function day12(part2)
    heights, S, E = readdata()
    part2 && (S = lowest(heights))
    return first(shortestpath(heights, S, E))
end
end;
Day12.day12.(false:true)
