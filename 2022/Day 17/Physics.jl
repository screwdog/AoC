next!(itr) = itr |> iterate |> first

function blocked(c::Chamber, b::Block, x, y)
    1 ≤ x ≤ CHAMBER_WIDTH - b.width + 1 || return true
    1 ≤ y ≤ BUFFER_HEIGHT - b.height + 1 || return true
    for i ∈ 1:b.width, j ∈ 1:b.height
        b.data[i, j] && c.buffer[x + i - 1, y + j - 1] && return true
    end
    return false
end

function placeBlock!(c::Chamber, b::Block, x, y)
    for i ∈ 1:b.width, j ∈ 1:b.height
        b.data[i, j] && (c.buffer[x + i - 1, y + j - 1] = true)
    end
    return nothing
end

function dropBlock!(c::Chamber, blocks, wind)
    x, y = DROP_WIDTH, c.dropHeight
    block = next!(blocks)
    while true
        δx = next!(wind) ? -1 : 1
        blocked(c, block, x + δx, y) || (x += δx)
        if !blocked(c, block, x, y - 1)
            y -= 1
        else
            placeBlock!(c, block, x, y)
            c.dropHeight = max(c.dropHeight, y + block.height - 1 + DROP_OFFSET)
            return nothing
        end
    end
end
dropBlock!(cs::ChamberState) = dropBlock!(cs.chamber, cs.blocks, cs.wind)
function unsafe_dropBlocks!(cs::ChamberState, numBlocks)
    for _ ∈ 1:numBlocks
        dropBlock!(cs)
    end
    cs.blocksDropped += numBlocks
end

function dropBlocks!(cs::ChamberState, numblocks)
    while numblocks > 0
        toDrop = min(numblocks, safeDrops(cs))
        unsafe_dropBlocks!(cs, toDrop)

        safeDrops(cs) ≤ COMPACT_THRESHOLD && compact!(cs)
        numblocks -= toDrop
    end
    return towerHeight(cs)
end