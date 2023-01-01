const CHAMBER_WIDTH = 7
const BUFFER_HEIGHT = 10_000
const DROP_WIDTH = 3
const DROP_OFFSET = 4
const COMPACT_THRESHOLD = 100

mutable struct Chamber
    buffer::BitMatrix
    floorHeight::Int
    dropHeight::Int
end
Chamber() = Chamber(falses(CHAMBER_WIDTH, BUFFER_HEIGHT), 0, DROP_OFFSET)
function reset!(c::Chamber)
    c.buffer .= false
    c.floorHeight = 0
    c.dropHeight = DROP_OFFSET
    return c
end

mutable struct ChamberState
    chamber::Chamber
    blocks::StatefulCycle
    wind::StatefulCycle
    blocksDropped::Int
end
ChamberState(str) = ChamberState(Chamber(), standardBlocks(), wind(str), 0)
function reset!(cs::ChamberState)
    reset!(cs.chamber)
    reset!(cs.blocks)
    reset!(cs.wind)
    cs.blocksDropped = 0
    return cs
end

canDrop(c::Chamber) = c.dropHeight + MAX_BLOCK_HEIGHT - 1 ≤ BUFFER_HEIGHT
canDrop(cs::ChamberState) = canDrop(cs.chamber)
towerHeight(c::Chamber) = c.floorHeight + c.dropHeight - DROP_OFFSET
towerHeight(cs::ChamberState) = towerHeight(cs.chamber)

safeDrops(c::Chamber) = fld(BUFFER_HEIGHT - c.dropHeight, MAX_BLOCK_HEIGHT) - 1
safeDrops(cs::ChamberState) = safeDrops(cs.chamber)

function dropDepth(c::Chamber)
    droppable = trues(CHAMBER_WIDTH, 2)
    depth = c.dropHeight - DROP_OFFSET + 1

    while true
        @views droppable[:,1] .= .!c.buffer[:,depth] .&& droppable[:,2]
        for x ∈ 2:CHAMBER_WIDTH
            !c.buffer[x,depth] && droppable[x-1,1] && droppable[x-1,2] && (droppable[x,1] = true)
        end
        for x ∈ 1:CHAMBER_WIDTH-1
            !c.buffer[x,depth] && droppable[x+1,1] && droppable[x+1,2] && (droppable[x,1] = true)
        end
        canReach = any(@view droppable[:,1])
        (!canReach || depth == 1) && return depth
        depth -= 1
        for x ∈ 1:CHAMBER_WIDTH
            droppable[x,2] = droppable[x,1]
            droppable[x,1] = false
        end
    end
end
dropDepth(cs::ChamberState) = dropDepth(cs.chamber)

function dropMap!(droppable, c::Chamber)
    startDepth = c.dropHeight - DROP_OFFSET
    droppable[:,startDepth:BUFFER_HEIGHT] .= true
    droppable[:,1:startDepth-1] .= false

    y = startDepth-1
    while y ≥ 1
        for x ∈ 1:CHAMBER_WIDTH
            !c.buffer[x,y] && droppable[x,y+1] && (droppable[x,y] = true)
        end
        for x ∈ 2:CHAMBER_WIDTH
            !c.buffer[x,y] && droppable[x-1,y] && droppable[x-1,y+1] && (droppable[x,y] = true)
        end
        for x ∈ 1:CHAMBER_WIDTH-1
            !c.buffer[x,y] && droppable[x+1,y] && droppable[x+1,y+1] && (droppable[x,y] = true)
        end
        canReach = any(@view droppable[:,y])
        !canReach && break
        y -= 1
    end
    return @view droppable[:, y+1:startDepth-1]
end
dropMap!(droppable, cs::ChamberState) = dropMap!(droppable, cs.chamber)
makeDropMap() = falses(CHAMBER_WIDTH, BUFFER_HEIGHT)
dropMap(c::Chamber) = dropMap!(makeDropMap(), c)
dropMap(cs::ChamberState) = dropMap(cs.chamber)

function compact!(c::Chamber)
    depth = dropDepth(c)
    depth > 1 || throw(ErrorException("can't compact Chamber buffer! Try increasing BUFFER_HEIGHT ($BUFFER_HEIGHT)"))
    copyFromRange = depth:c.dropHeight - DROP_OFFSET
    c.dropHeight -= depth - 1
    c.floorHeight += depth - 1
    copyToRange = 1:c.dropHeight - DROP_OFFSET
    c.buffer[:, copyToRange] = @view c.buffer[:, copyFromRange]
    c.buffer[:, last(copyToRange) + 1:end] .= false
    return c
end
compact!(cs::ChamberState) = compact!(cs.chamber)