using Underscores
"""
`readdata() -> Matrix{Char}`

Returns a matrix of the tree heights from "input.txt". Doesn't convert these to
a numeric type but leaves them as characters.
"""
readdata() = @_ readlines("input.txt")  |>
    collect.(__)                        |>
    hcat(__...)
    # for the chars '0'-'9', all comparisons return the same results as if we
    # were to convert them to a numeric type so we avoid the overhead of doing so

# four cardinal directions to look
δs = [(-1,0), (1,0), (0,-1), (0,1)]

"""
`treerange(k, δ, len) -> indices`

Returns the indices, in order, to examine trees at if the tree of interest is
at position `k`, the row or column is `len` long and we are moving `δ` along
the axis. Returns a range if `δ ∈ [-1,1]` or an `Int` if `δ == 0`.
"""
treerange(k, δ, len) = δ ≠ 0 ? ((k + δ):δ:(δ > 0 ? len : 1)) : k

"""
`treeranges(trees, ij, δij) -> (indices, indices)`

Returns a tuple of indices representing the tree locations to be examined, in
order, from the position `ij` out to the edge of the grid, in the direction
represented by `δij`.
"""
treeranges(trees, ij, δij) = treerange.(ij, δij, size(trees))

"""
`treesfrom(trees, i, j) -> vector(tree heights)`

Returns the tree heights, in order, looking in each of the cardinal directions
from the tree at location `(i,j)`.
"""
treesfrom(trees, i, j, δ) = trees[treeranges(trees, (i, j), δ)...]
# need to broadcast over δs but not trees, so we wrap trees in a Ref so it
# is treated as a single value passed intact to each iteration.
treesfrom(trees, i, j) = treesfrom.(Ref(trees), i, j, δs)

"""
`isvisible(trees, i, j) -> Bool`

Returns whether the tree at location `(i,j)` is visible from outside of the grid.
That is, whether all trees between `(i,j)` and some edge of the grid are shorter
than the tree at `(i,j)`.
"""
isvisible(trees, i, j) = mapreduce(ts -> all((<)(trees[i, j]), ts), |, treesfrom(trees, i, j))

"""
`lookdist(trees, h) -> Int`

Returns the number of consecutive trees in `trees` that are lower than height `h`.
"""
# findfirst either returns an index or `nothing`. `something` returns the first
# argument passed to it that isn't nothing. That is, here it's equivalent to
# f ≠ nothing ? f : trees but without recalculating f
lookdist(trees, h) = something(findfirst((≥)(h), trees), length(trees))

"""
`scenicscore(trees, i, j) -> Int`

Calculates the "scenic score" for the tree at location `(i,j)`.
"""
scenicscore(trees, i, j) = mapreduce(ts -> lookdist(ts, trees[i, j]), *, treesfrom(trees, i, j))

"""
`day8() -> (part 1 answer, part 2 answer)`

Solve Advent of Code 2022 Day 8 puzzle, parts 1 and 2. That is, a tuple of the
number of visible trees and the highest scenic score for all trees in the grid
given in "input.txt".
"""
function day8()
    trees = readdata()
    N, M = size(trees)
    # note we use generators here, which is like an array comprehension but
    # without constructing an array explicitly. This functions like an implicit
    # for-loop.
    return (count(isvisible(trees, i, j) for i ∈ 1:N,   j ∈ 1:M),
        maximum(scenicscore(trees, i, j) for i ∈ 2:N-1, j ∈ 2:M-1))
end
day8()
