General Hints
=============

For part 1, we need to determine the locations that are excluded in a given row. Each row of input corresponds to a sensor and beacon pair, and each pair excludes a (possibly empty) range of locations in a given row. In fact, this range corresponds to all points a within a given Manhattan Distance of the sensor.

The naive approach is to simply enumerate all excluded points, but we can do better as any set of intervals are equivalent to a set of disjoint ranges. That is, we can detect and eliminate all overlaps between ranges and then simply sum the lengths of these intervals. (Note that we also need to account for any beacons present in the ranges).

Part 2 is more complex and a naive approach - scanning all possible points - can take an extremely long time. Fortunately we can do better. If we assume that (as with every other puzzle) the input can be trusted, then there is exactly one point in the given range that is not excluded by the sensors.

Considering how this could be the case, it should be clear that all adjacent points must be excluded and because they use Manhattan geometry, the shape of exclusion zones is always a diamond. So, the point that has a beacon must be at the edge of four exclusion zones, one to the top-left, one to the top-right, one to the bottom-left and one to the bottom-right.

    .\./.
    \.X./
    .XoX.
    /.X.\
    ./.\.

If the beacon location is 'o', then the grid above attempts to show the edges of the four exclusion zones. Now, for there to only be one possible point for the beacon, then the edges of these exclusion zones must be exactly 2 rows/columns apart. So we need only find four zones appropriately spaced.

One way to calculate these zones is to treat the four edges of an exclusion zone as hypothetical infinite lines and convert them to their x-intercept. Then, each pair of appropriately spaced edges correspond to pairs of x-intercepts that are 2 spaces apart. Then, the x-intercept between corresponds to the "line" that the beacon must be on. Given the two pairs - two lines - we then calculate their intersection and that gives us a possible beacon point. If that point is not excluded by any sensor-beacon pair then it is the point we're looking for.

If d = |sensor - beacon| is the Manhattan Distance between a given sensor and beacon, then the point exactly d rows above the sensor is the top of the exclusion zone, the point d rows below is the bottom. If (x,y) are the coordinates of the apex of the exclusion zone, then the x-intercepts of the two lines through the apex are just x-y and x+y. Similarly for the bottom corner.

Then, if l and r are the x-intercepts of the lines that contain the possible beacon position, then the possible point is p = ((r+l)/2, (r-l)/2). And this is not excluded from a sensor-beacon pair if |sensor - p| > |sensor - beacon|.

Good luck!
