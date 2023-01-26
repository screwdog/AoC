# sensor-beacon pairs are stored in matrix columns - these are indexes into
# that data
const X = 1
const Y = 2
const SENSOR = 1:2
const BEACON = 3:4

"""
`readdata() -> Matrix{Int}`

Reads from "input.txt" and returns the sensor-beacon pair data as columns of a
matrix. Each column consists of [sensor_x, sensor_y, beacon_x, beacon_y].
"""
function readdata()
    @_ "input.txt"                  |>
        read(__, String)            |>
        eachmatch(r"(-?\d+)", __)   |>
        only.(__)                   |>
        parse.(Int, __)             |>
        reshape(__, (4,:))
end

# check if two ranges can be merged into a single range
mergeable(r1, r2) = !isdisjoint(r1, r2) ||
    first(r1) == last(r2) + 1 || first(r2) == last(r1) + 1
# returns a new range covering both ranges. Doesn't check for validity
merge(r1, r2) = min(first(r1), first(r2)):max(last(r1), last(r2))

"""
`disjoint!(ranges)`

Returns a vector of ranges that consists of exactly the elements contained
within `ranges` but such that each range is disjoint from all the others. That
is, `union(ranges...) == union(disjoint!(ranges)...)` but `isdisjoint(r1,r2)`
returns `true` for all `r1, r2 ∈ disjoint!(ranges)`.
"""
function disjoint!(ranges)
    filter!(!isempty, ranges)
    length(ranges) ≤ 1 && return ranges
    # mergeable ranges are sorted next to each other, simplifying our task
    sort!(ranges)
    i = 2
    while i ≤ length(ranges)
        if mergeable(ranges[i-1], ranges[i])
            ranges[i-1] = merge(ranges[i-1], popat!(ranges, i))
        else
            i += 1
        end
    end
    return ranges
end

function _setdiff!(ranges, n::Integer)
    # is n in one of the ranges? (only one since they are disjoint)
    i = findfirst(r -> n ∈ r, ranges)
    i === nothing && return ranges
    range = ranges[i]
    # split range into two parts, excluding n
    ranges[i] = first(range):n-1
    insert!(ranges, i+1, n+1:last(range))
    return ranges
end

"""
`setdiff!(ranges, itr) -> ranges`

Returns a vector of disjoint ranges `r` such that
    `union(r) == setdiff(union(ranges...), itr)`
but efficiently calculated without collecting all the elements.
"""
function setdiff!(ranges, itr)
    for n ∈ itr
        _setdiff!(ranges, n)
    end
    return ranges
end