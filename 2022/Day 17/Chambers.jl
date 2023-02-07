const CHAMBER_WIDTH = 7
const BUFFER_HEIGHT = 10_000
const DROP_WIDTH = 3
const DROP_OFFSET = 4
const COMPACT_THRESHOLD = 100

"""
`Chamber`

Represents the space in the chamber. Is able to handle arbitrarily high stacks
of blocks.
"""
mutable struct Chamber
    buffer::BitMatrix
    floorheight::Int
    dropheight::Int
end
Chamber() = Chamber(falses(CHAMBER_WIDTH, BUFFER_HEIGHT), 0, DROP_OFFSET)
function reset!(c::Chamber)
    c.buffer .= false
    c.floorheight = 0
    c.dropheight = DROP_OFFSET
    return c
end

candrop(c::Chamber) = c.dropheight + MAX_BLOCK_HEIGHT - 1 ≤ BUFFER_HEIGHT
towerheight(c::Chamber) = c.floorheight + c.dropheight - DROP_OFFSET
safedrops(c::Chamber) = fld(BUFFER_HEIGHT - c.dropheight, MAX_BLOCK_HEIGHT) - 1

# Only those positions in the chamber that a block can actually reach is
# important so we can discard all information below that point, freeing up space
# for additional blocks.
function compact!(c::Chamber)
    depth = dropdepth(c)
    depth > 1 || throw(ErrorException("can't compact Chamber buffer! Try increasing BUFFER_HEIGHT ($BUFFER_HEIGHT)"))
    copyfrom = depth:c.dropheight - DROP_OFFSET
    c.dropheight -= depth - 1
    c.floorheight += depth - 1
    copyto = 1:c.dropheight - DROP_OFFSET
    c.buffer[:, copyto] = @view c.buffer[:, copyfrom]
    c.buffer[:, last(copyto) + 1:end] .= false
    return c
end
