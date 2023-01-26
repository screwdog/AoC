"""
`dist(p1, p2) -> Int`
`dist(points) -> Int`

Calculate the Manhattan distance between two points. `points` must have four
elements and is interpreted as `[point1_x, point1_y, point2_x, point2_y]`.
"""
dist(p1, p2) = +(abs.(p1 - p2)...)

"""
`excluderange(sensor, beacon, row) -> range`
`excluderange(data, row) -> range`

Return the range of x-coordinates in `row` that cannot contain a beacon, given
that the nearest beacon to the sensor at position `sensor` is at point `beacon`.
`data` must have four elements and is interpreted as
    `[sensor_x, sensor_y, beacon_x, beacon_y]`
"""
function excluderange(sensor, beacon, row)
    d = dist(sensor, beacon)
    δy = abs(row - sensor[Y])
    width = d - δy
    return sensor[1] .+ (-width:width)
end
excluderange(data, row) = excluderange(data[SENSOR], data[BEACON], row)

"""
`beaconsinrow(data, row) -> Int[]`

Returns the x-coordinates of all known beacons in `row`.
"""
beaconsinrow(data, row) = @_ data   |> 
    eachcol                         |> 
    last.(__, 2)                    |>
    filter(last(_) == row, __)      |>
    first.(__)                      |>
    unique