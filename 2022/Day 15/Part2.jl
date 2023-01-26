# we store the x-intercepts of the lines bounding each exclusion zone in a
# matrix where each column is [TR, BL, BR, TL]. TR is the x-intercept of the
# line at the top-right of the exclusion zone, BL is the bottom-left, etc
const TR = 1
const BL = 2
const BR = 3
const TL = 4

"""
`xintercepts(sensor, beacon) -> [TR, BL, BR, TL]`
`xintercepts(data) -> [TR, BL, BR, TL]`

Returns the four x-intercepts corresponding to the lines at the edges of the
exclusion zone defined by the `sensor`-`beacon` pair. `data` must contain four
elements, consisting of
    `[sensor_x, sensor_y, beacon_x, beacon_y]`
"""
function xintercepts(sensor, beacon)
    distance = dist(sensor, beacon)
    top, bottom = sensor[Y] .+ distance .* (-1, 1)
    return sensor[X] .+ [-top, -bottom, bottom, top]
end
xintercepts(data) = xintercepts(data[SENSOR], data[BEACON])

"""
`interceptdata(data) -> Matrix{Int}`

Calculates the x-intercepts for the four bounding lines for the exclusion zone
defined by each sensor-beacon pair in `data`.
"""
interceptdata(data) = mapslices(xintercepts, data, dims=1)

"""
`beaconpoint(left, right) -> point`

Calculates the possible beacon location defined by the two lines that have
x-intercepts at `left` and `right`. That is, where the line running diagonally
down-right from `left` and the line running diagonally down-left from `right`
intersect.

If no intersection exists returns `nothing`.
"""
function beaconpoint(left, right)
    iseven(left + right) || return nothing
    return [(right + left) ÷ 2, (right - left) ÷ 2]
end

dist(col) = dist(col[SENSOR], col[BEACON])

"""
`isexcluded(data, point) -> Bool`

Returns whether `point` is excluded from containing a beacon by the sensor-
beacon pairs in `data`.
"""
isexcluded(data, point) =
    any(c -> dist(c[SENSOR], point) ≤ dist(c), eachcol(data))

"""
`findpairs(intercepts, row1, row2) -> Int[]`

Searches for a pair of columns in `intercepts` where the value in `row1` of one
column is exactly 2 less than in `row2` of the other column. Returns a vector
containing the value between these two for each such pair.
"""
function findpairs(intercepts, row1, row2)
    len = axes(intercepts, 2)
    pairs = []
    for x ∈ len, y ∈ len
        x == y && continue
        a, b = intercepts[row1, x], intercepts[row2, y]
        a + 2 == b && push!(pairs, a+1)
    end
    return pairs
end

"""
`isin(point, range) -> Bool`

Returns whether both coordinates of `point` are within `range`.
"""
isin(point, range) = all(point .∈ Ref(range))