using Underscores
const CAVE_EMPTY = 0
const CAVE_ROCK = 1
const CAVE_SAND = 2
const DIRECTIONS = [[0,1],[-1,1],[1,1]]

include("DataEntry.jl")

isabyss(cave, location) = any(location .∉ axes(cave))
canMoveTo(cave, location) = isabyss(cave, location) || cave[location...] == CAVE_EMPTY
canMoveTo(cave) = l -> canMoveTo(cave, l)
function dropGrain!(cave, source)
    location = source
    while true
        newLocations = Ref(location) .+ DIRECTIONS
        i = findfirst(canMoveTo(cave), newLocations)
        i === nothing && break
        location = newLocations[i]
        isabyss(cave, location) && return location
    end
    cave[location...] = CAVE_SAND
    return location
end

function dropSand!(cave, source, endCondition)
    MAX_GRAINS = 100_000
    for _ ∈ 1:MAX_GRAINS
        location = dropGrain!(cave, source)
        endCondition(cave, source, location) && return cave
    end
end
countGrains(cave) = count((==)(CAVE_SAND), cave)

p1end(c, s, l) = isabyss(c,l)
p2end(c, s, l) = c[s...] == CAVE_SAND

function day14(part2, test=false)
    inputfile = test ? "test.txt" : "input.txt"
    cave, source = @_ readdata(inputfile) |> makeCave(__, part2)

    stopwhen = part2 ? p2end : p1end
    dropSand!(cave, source, stopwhen)
    return countGrains(cave)
end
day14.(false:true)