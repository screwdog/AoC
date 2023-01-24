module Day14
using Underscores
include("Data.jl")
# Possible fall directions for each grain of sand, in order of precedence
const DIRECTIONS = [
    CartesianIndex( 0, 1),
    CartesianIndex(-1, 1),
    CartesianIndex( 1, 1)
]

"""
`isabyss(cave, location) -> Bool`

Returns whether the given location is in the "abyss" - that is, off the grid.
"""
isabyss(cave, location) = !checkbounds(Bool, cave, location)

"""
`canmoveto(cave, location) -> Bool`

Returns whether a grain of sand can move into the given location. That is,
whether that location is blocked.
"""
canmoveto(cave, location) = isabyss(cave, location) || !cave[location]
canmoveto(cave) = location -> canmoveto(cave, location)

"""
`dropgrain!(cave, source)`

Drops a grain of sand from `source` into `cave`, adding it to `cave` if it comes
to rest and returns its final location (either at rest or in the "abyss").
"""
function dropgrain!(cave, source)
    location = source
    while true
        # Ref(location) necessary but will be unnecessary in a future version
        # of Julia (https://github.com/JuliaLang/julia/issues/38432)
        newlocations = Ref(location) .+ DIRECTIONS
        i = findfirst(canmoveto(cave), newlocations)
        # If can't move then grain is at rest
        i === nothing && break
        location = newlocations[i]
        # Allow to move into the abyss, but don't try and write to that location
        isabyss(cave, location) && return location
    end
    # Grain is at rest
    cave[location] = true
    return location
end

"""
`dropsand!(cave, source, stopif) -> Int`

Drops grains of sand from `source` into `cave` until the condition `stopif`
returns true.
"""
function dropsand!(cave, source, stopif)
    # cave is a BitMatrix, so this counts how many locations are set initially
    blocks = count(cave)
    while true
        location = dropgrain!(cave, source)
        # count(cave) - blocks is the number of grains added to the cave
        stopif(cave, source, location) && return count(cave) - blocks
    end
end

# stopping condition for parts 1 and 2
stop = Dict([
    false   => (cave, source, location) -> isabyss(cave, location),
    true    => (cave, source, location) -> cave[source]
])

"""
`day14(part2::Bool) -> Int`

Calculates the solution to Advent of Code 2022 day 14, either part 1 or 2
depending on `part2`. Reads the definition of the cave from "input.txt" and
returns the number of grains dropped into the cave until either one falls into
the abyss (part 1) or blocks the source of sand (part 2).
"""
function day14(part2)
    cave, source = readdata(part2)
    return dropsand!(cave, source, stop[part2])
end
end;
Day14.day14.(false:true)
