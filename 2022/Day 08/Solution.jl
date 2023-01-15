"""
`day8() -> (part 1 answer, part 2 answer)`

Solve Advent of Code 2022 Day 8 puzzle, parts 1 and 2. That is, a tuple of the
number of visible trees and the highest scenic score for all trees in the grid
given in "input.txt".
"""
function day8()
    lines = readlines("input.txt")
    # we calculate M from the first line of input, assuming all lines will be
    # equal length
    N, M = length(lines), length(first(lines))
    # undef keyword as we will initialise each entry individually
    trees = Matrix{Int}(undef, N, M)
    # no need for nested for-loops. trees[i,j] is the height of the tree at (i,j)
    for i ∈ 1:N, j ∈ 1:M
        trees[i, j] = parse(Int, lines[i][j])
    end

    # the following three functions are all defined as nested functions as they
    # are simpler if they can access trees, N, and M directly.
    """
    `isvisible(i,j) -> Bool`

    Test whether the tree at (i,j) is visible. That is, whether all other trees
    between it and some edge of the grid are shorter than it looking only left,
    right, up, or down.
    """
    function isvisible(i, j)
        # trees around the edge are all visible
        (i ∈ [1, N] || j ∈ [1, M]) && return true
        # if all trees in some direction are shorter then tree is visible
        return  all((<)(trees[i,j]), trees[1:i-1,j]) ||
                all((<)(trees[i,j]), trees[i+1:N,j]) ||
                all((<)(trees[i,j]), trees[i,1:j-1]) ||
                all((<)(trees[i,j]), trees[i,j+1:M])
    end

    """
    `viewdistance(i, j, look, rev) -> Int`

    Return the number of consecutive trees at the start of collection `look`
    that are shorter than the tree at location (i,j). Alternatively, if `rev`
    is true start at the end of `look`. If all trees in `look` are shorter than
    the tree at (i,j) then returns `length(look)`.
    """
    function viewdistance(i, j, look, rev)
        dist = findfirst((≥)(trees[i,j]), rev ? reverse(look) : look)
        return dist ≠ nothing ? dist : length(look)
    end

    """
    `scenicscore(i,j) -> Int`

    Calculates the "scenic score" for the tree at location (i,j). This is
    simply the product of the view distance (see `viewdistance`) in each
    direction (left, right, up, down).
    """
    function scenicscore(i, j)
        # viewdistance for any tree on the edge of the grid is 0, so the scenic
        # score is likewise 0.
        (i ∈ [1, N] || j ∈ [1, M]) && return 0
        # looking left or up we need to calculate viewdistance in reverse, so
        # rev == true. For looking right or down rev == false
        return  viewdistance(i, j, trees[1:i-1,j], true)  *
                viewdistance(i, j, trees[i+1:N,j], false) *
                viewdistance(i, j, trees[i,1:j-1], true)  *
                viewdistance(i, j, trees[i,j+1:M], false)
    end

    # count the number of visible trees (part 1) and the highest scenic score (part 2)
    visible, topscore = 0, 0
    for i ∈ 1:N, j ∈ 1:M
        isvisible(i,j) && (visible += 1)
        topscore = max(topscore, scenicscore(i,j))
    end
    return (visible, topscore)
end
day8()