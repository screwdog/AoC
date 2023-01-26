module Day15
using Underscores
include("Data.jl")
include("Part1.jl")
include("Part2.jl")

"""
`day15p1() -> Int`

Solves Advent of Code 2022 day 15 puzzle part 1, reading input from "input.txt".
That is, calculates the number of locations in row `2_000_000` that are excluded
from containing a beacon, given the sensor-beacon pairs given in the input.
"""
function day15p1()
    ROW = 2_000_000
    data = readdata()
    # Beacons in given row don't count as excluded locations
    beacons = beaconsinrow(data, ROW)
    return @_ data              |>
        # data stores each sensor-beacon pair as a column
        eachcol                 |>
        excluderange.(__, ROW)  |>
        # convert the exclusion ranges into a set of disjoint ranges
        disjoint!               |>
        setdiff!(__, beacons)   |>
        sum(length, __)
end

tuningfreq(x,y) = 4_000_000*x + y
tuningfreq(point) = tuningfreq(point...)

"""
`day15p2() -> Int`

Solves Advent of Code 2022 day 15 puzzle part 2, reading input from "input.txt".
That is, calculates the "tuning frequency" of the only point within range that
could contain an undetected beacon.
"""
function day15p2()
    COORD_RANGE = 0:4_000_000
    data = readdata()
    # Calculate the x-intercepts of the lines running along the edges of the
    # exclusion zone around each sensor.
    intercepts = interceptdata(data)
    
    # find all pairs of intercepts that are spaced 2 apart
    lefts = findpairs(intercepts, TR, BL)
    rights = findpairs(intercepts, BR, TL)

    for left ∈ lefts, right ∈ rights
        # calculate the possible point from the intercepts
        point = beaconpoint(left, right)
        # check that the point exists and isn't excluded by some other pair
        if point ≠ nothing && !isexcluded(data, point)
            # check that it is actually in the correct range
            isin(point, COORD_RANGE) && return tuningfreq(point)
        end
    end
end
end;
(Day15.day15p1(), Day15.day15p2())