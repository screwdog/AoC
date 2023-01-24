# Convert a string formatted as "NNN,NNN" into a CartesianIndex(NNN, NNN)
str2index(str) = @_ split(str, ",") |> parse.(Int, __) |> CartesianIndex(__...)

"""
`addpath!(cave, topleft, p1, p2)`

Adds the path given by endpoints `p1` and `p2` to the `cave`, assuming that the
top-left corner of `cave` is offset by `topleft`.
"""
function addpath!(cave, topleft, p1, p2)
    # since p1, p2 are CartesianIndex, these ranges create CartesianIndices
    path = p1 < p2 ? (p1:p2) : (p2:p1)
    cave[path .- topleft] .= true
end

"""
`addpaths!(cave, topleft, points)`

Adds the paths given by `points` to the `cave`, assuming that the top-left
corner of `cave` is offset by `topleft`. That is, draws the path from points[1]
to points[2], from points[2] to points[3], etc.
"""
addpaths!(cave, topleft, points) =
    addpath!.(Ref(cave), Ref(topleft), points[1:end-1], points[2:end])
# cave is a matrix, and topleft is a CartesianIndex, neither of which we want
# to broadcast over, so both are Ref()

"""
`makecave!(paths, [part2]) -> (cave, source)`

Returns a matrix representing the `cave` that has the `paths` drawn onto it,
and the location of the `source` of sand, relative to `cave`. If `part2` is
`true` (it defaults to `false`) then also add a floor two layers lower than the
lowest path drawn, and with the `cave` wide enough so that no grains of sand
will fall off the edge.
"""
function makecave!(paths, part2=false)
    # All locations here are their "raw" values, as given in the problem
    # definition.
    source = CartesianIndex(500, 0)
    locations = collect(Iterators.flatten(paths))
    push!(locations, source)
    # Since locations is an iterator of CartesianIndex, this actually returns
    # the corners of the bounding box, not the actual max/min element. That is,
    # actually calculates the extrema of x-values and y-values.
    topleft, bottomright = extrema(locations)

    if part2
        # make the bounding box bigger to fit a floor
        bottomright += CartesianIndex(0,2)
        # need to widen the bounding box so that no grains of sand can fall off
        # the edge. With a point source and a flat floor, the final layout will
        # be a subset of the triangle whose point is the source and the base
        # extends equally in both directions the same amount as the height.
        dropheight = last(Tuple(bottomright - topleft)) + 1
        left    = source - dropheight*CartesianIndex(1,0)
        right   = source + dropheight*CartesianIndex(1,0)

        # recalculate the bounding box to incorporate the new elements
        topleft     = min(topleft, left)
        bottomright = max(bottomright, right)
    end

    # since arrays are 1-based, shift so we can use it as an offset
    topleft -= CartesianIndex(1,1)
    cave = falses(Tuple(bottomright - topleft))
    # add a floor for part 2
    part2 && (cave[:, end] .= true)
    addpaths!.(Ref(cave), Ref(topleft), paths)
    return (cave, source - topleft)
end

"""
`readdata([part2]) -> (cave, source)`

Returns a matrix representing the `cave`, and the relative position of the
`source` of sand, including the rock paths described in "input.txt". If `part2`
is `true` (it defaults to `false`) then also includes a floor and a wide enough
`cave` so no sand falls off the edge.
"""
function readdata(part2=false)
    @_ readlines("input.txt")   |>
        split.(__, " -> ")      |>
        map(str2index.(_), __)  |>
        makecave!(__, part2)
end
