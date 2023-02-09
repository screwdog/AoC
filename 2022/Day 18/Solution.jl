module Day18
using Underscores
using BenchmarkTools

const neighbours = CartesianIndex.([
    (-1, 0, 0), ( 1, 0, 0),
    ( 0,-1, 0), ( 0, 1, 0),
    ( 0, 0,-1), ( 0, 0, 1)
])

include("Data.jl")
include("Grids.jl")
include("Points.jl")
include("Part2.jl")

# Count the number of faces of cube that aren't connected to another cube
openfaces(droplet, cube) = 6 - sum(c -> droplet[c], [cube] .+ neighbours)
openfaces(droplet) = cube -> openfaces(droplet, cube)

# Fallback method. `Points` has a specialised version.
eachcube(droplet) = findall(droplet)

surfacearea(droplet) = sum(openfaces(droplet), eachcube(droplet))

"""
`day18() -> (Int, Int)`

Solve Advent of Code 2022 day 18, parts 1 and 2. That is, reads the location of
cubes forming a lava droplet from "input.txt" and calculates the total surface
area (including internal voids) and the external surface area of this droplet.
"""
function day18(datatype = Grid)
    drop = droplet(datatype)
    return (surfacearea(drop), outersurface(drop))
end

function comparison()
    println("Default implementation with dense data storage:")
    @btime day18(Grid)
    println("Using sparse storage:")
    @btime day18(Points)
    return nothing
end
end;
# Day18.day18()

Day18.comparison()
