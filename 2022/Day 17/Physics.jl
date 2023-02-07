next!(itr) = itr |> iterate |> first

# check if block `b` collides with anything in chamber `c` if placed at position
# `x, y`.
function isblocked(c::Chamber, b::Block, x, y)
    1 ≤ x ≤ CHAMBER_WIDTH - b.width + 1 || return true
    1 ≤ y ≤ BUFFER_HEIGHT - b.height + 1 || return true
    for i ∈ 1:b.width, j ∈ 1:b.height
        b.data[i, j] && c.buffer[x - 1 + i, y - 1 + j] && return true
    end
    return false
end

# place `b` at location `x, y` in `c`. Doesn't check if it is blocked.
function placeblock!(c::Chamber, b::Block, x, y)
    for i ∈ 1:b.width, j ∈ 1:b.height
        b.data[i, j] && (c.buffer[x + i - 1, y + j - 1] = true)
    end
    return nothing
end

# drop the next block into the chamber. Advances blocks and jets as necessary.
function dropblock!(c::Chamber, blocks, jet)
    x, y = DROP_WIDTH, c.dropheight
    block = next!(blocks)
    while true
        δx = next!(jet) ? -1 : 1
        isblocked(c, block, x + δx, y) || (x += δx)
        if !isblocked(c, block, x, y - 1)
            y -= 1
        else
            placeblock!(c, block, x, y)
            c.dropheight = max(c.dropheight, y + block.height - 1 + DROP_OFFSET)
            return nothing
        end
    end
end
dropblock!(cs::CaveState) = dropblock!(cs.chamber, cs.blocks, cs.jet)
# doesn't check whether this may overflow the chamber
function unsafe_dropblocks!(cs::CaveState, numBlocks)
    for _ ∈ 1:numBlocks
        dropblock!(cs)
    end
    cs.blocksdropped += numBlocks
end

"""
`dropblocks!(cavestate, numblocks) -> Int`

Returns the height of the tower in the chamber after dropping `numblocks` blocks
"""
function dropblocks!(cs::CaveState, numblocks)
    while numblocks > 0
        todrop = min(numblocks, safedrops(cs))
        unsafe_dropblocks!(cs, todrop)

        safedrops(cs) ≤ COMPACT_THRESHOLD && compact!(cs)
        numblocks -= todrop
    end
    return towerheight(cs)
end