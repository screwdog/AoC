"""
Quick.jl
========

This represents my initial attempt at solving the puzzle, under time constraints
as the puzzle was released. It does not necessarily represent good practice. In
particular, the solution to part 2 is very inefficient and can take several
hours to run.
"""

using Underscores
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
    excludeRange(first(sensorAndBeacon, 2), last(sensorAndBeacon, 2), row)

function day15p1(test=false)
    ROW = test ? 10 : 2_000_000
    @_ test |>
        readdata |>
        eachcol |>
        excludeRange.(__, ROW) |>
        reduce(∪, __) |>
        extrema |>
        -(__...) |>
        abs
end

tuningFreq(x,y) = 4_000_000x + y
function day15p2(test=false)
    # WARNING! This code may take several hours to run. It was simply my first
    # (and worst) attempt at the puzzle

    COORD_RANGE = test ? (0:20) : (0:4_000_000)
    colData = @_ test |>
        readdata |>
        eachcol

    for y ∈ COORD_RANGE
        ranges = excludeRange.(colData, y)
        for x ∈ COORD_RANGE
            all(r -> x ∉ r, ranges) && return tuningFreq(x,y)
        end
        mod(y, 1000) == 0 && println("Finished row y = $y")
    end
    return "None found!"
end
@time day15p2()