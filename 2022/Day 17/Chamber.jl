const CHAMBER_WIDTH = 7
const BUFFER_HEIGHT = 10_000
const DROP_WIDTH = 3
const DROP_OFFSET = 4

mutable struct Chamber
    buffer::BitMatrix
    floorHeight::Int
    dropHeight::Int
end
Chamber() = Chamber(falses(CHAMBER_WIDTH, BUFFER_HEIGHT), 0, DROP_OFFSET)
canDrop(c::Chamber) = c.dropHeight + MAX_BLOCK_HEIGHT - 1 ≤ BUFFER_HEIGHT
towerHeight(c::Chamber) = c.floorHeight + c.dropHeight - DROP_OFFSET

function dropDepth(c::Chamber)
    droppable = falses(CHAMBER_WIDTH, 2)
    depth = c.dropHeight - DROP_OFFSET
    for x ∈ 1:CHAMBER_WIDTH
        droppable[x, 2] = true
    end

    while true
        for x ∈ 1:CHAMBER_WIDTH
            !c.buffer[x,depth] && droppable[x,2] && (droppable[x,1] = true)
        end
        for x ∈ 2:CHAMBER_WIDTH
            !c.buffer[x,depth] && droppable[x-1,1] && droppable[x-1,2] && (droppable[x,1] = true)
        end
        for x ∈ 1:CHAMBER_WIDTH-1
            !c.buffer[x,depth] && droppable[x+1,1] && droppable[x+1,1] && (droppable[x,1] = true)
        end
        canReach = false
        for x ∈ 1:CHAMBER_WIDTH
            if droppable[x,1]
                canReach = true
                break
            end
        end
        (!canReach || depth == 1) && return depth
        depth -= 1
        for x ∈ 1:CHAMBER_WIDTH
            droppable[x,2] = droppable[x,1]
            droppable[x,1] = false
        end
    end
end

function compact!(c::Chamber)
    depth = dropDepth(c)
    depth > 1 || throw(ErrorException("can't compact Chamber buffer! Try increasing BUFFER_HEIGHT ($BUFFER_HEIGHT)"))
    c.dropHeight -= depth - 1
    c.floorHeight += depth - 1
    for x ∈ 1:CHAMBER_WIDTH, y ∈ 1:c.dropHeight-DROP_OFFSET
        c.buffer[x,y] = c.buffer[x,y+depth-1]
    end
    return c
end