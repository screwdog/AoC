General Hints
=============

The obvious approach here is to use a 2D array to record whether a location has sand/rock in it. This would make our first task to interpret the input, determine the required size of the grid and fill it with the rock formations as given. In part 2 we need only ensure we set up the grid appropriately, including deciding how wide the grid needs to be to accomodate all the sand.

The main task is to simulate the falling of sand grains, which should be fairly straightforward. In part 1 we stop when a sand grain doesn't come to rest in the grid, in part 2 we stop when one comes to rest at the source location.

Julia Functions
===============

- The input is very regular so regular expressions (`r"..."` and `match`/`eachmatch`) are fine, as is `split` with "," or " -> " as delimiters.
- To store location data we need pairs of integers. `Pair` and `Tuple` aren't particularly well suited but could be used, whereas `Vector` is better suited along with `CartesianIndex` or a custom `struct`.
    * One advantage of using `CartesianIndex`s is that `a:b` forms a `CartesianIndices` type which is a convenient way of selecting a subarray.
    * Also, `min`/`minimum`/`max`/`maximum`/`extrema` all work on iterables of `CartesianIndex`s, including `CartesianIndices` and instead of returning the actual element that is minimum (maximum, etc), it returns a `CartesianIndex` whose *indices* are minimum (maximum, etc).
    * That is, `min(CartesianIndex(3,1), CartesianIndex(1,3)) == CartesianIndex(1,1)`. This is different behaviour to other types where `min(a,b) ∈ [a,b]` but is generally what is wanted for array indices. In particular, it makes it easy to determine bounding boxes for a collection of indices.
- `findfirst(f, itr)` is useful for finding the first item in a collection for which `f` returns true
- `checkbounds(Bool, A, I)` determines if `I` is a valid index to array `A`