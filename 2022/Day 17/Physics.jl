next!(itr) = itr |> iterate |> first

function blocked(c::Chamber, b::Block, x, y)
    1 ≤ x ≤ CHAMBER_WIDTH - b.width + 1 || return true
    y > c.floorHeight || return true
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

function dropBlocks!(c::Chamber, blocks, wind, numblocks)
    for _ ∈ 1:numblocks
        canDrop(c) || (@info "chamber buffer full, compacting."; compact!(c))
        dropBlock!(c, blocks, wind)
    end
    return towerHeight(c)
end