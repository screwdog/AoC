using Underscores
include("DisjointRanges.jl")
function readdata(test=false)
    @_ (test ? "test.txt" : "input.txt")    |>
        read(__, String)                    |>
        eachmatch(r"(-?\d+)", __)           |>
        first.(__)                          |>
        parse.(Int, __)                     |>
        reshape(__, (4,:))
end

dist(p1, p2) = +(abs.(p1 - p2)...)
function excludeRange(sensor, beacon, row)
    d = dist(sensor, beacon)
    δy = abs(row - sensor[2])
    width = d - δy
    return sensor[1]-width:sensor[1]+width
end
excludeRange(sensorAndBeacon, row) =
    excludeRange(sensorAndBeacon[1:2], sensorAndBeacon[3:4], row)

function day15p1(test=false)
    ROW = test ? 10 : 2_000_000
    @_ test                     |>
        readdata                |>
        eachcol                 |>
        excludeRange.(__, ROW)  |>
        reduce(∪, __)           |>
        extrema                 |>
        -(__...)                |>
        abs
end

function day15p2(test=false)
    COORD_RANGE = test ? (0:20) : (0:4_000_000)
    colData = @_ test   |>
        readdata        |>
        eachcol

    for y ∈ COORD_RANGE
        excluded = DisjointRanges(excludeRange.(colData, y))
        excluded ≠ COORD_RANGE && return setdiff(COORD_RANGE, excluded)
    end
    return nothing
end
@time day15p2(true)