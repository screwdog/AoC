!(@isdefined Wind) && include("Wind.jl")
!(@isdefined Blocks) && include("Blocks.jl")
!(@isdefined Chamber) && include("Chamber.jl")

X_INDENT() = 3
Y_GAP() = 4

canBlowLeft(x, y, b::Block, c::Chamber) = _validLocation(x-1, y, c) && isplaceable(x-1, y, b, c)
canBlowRight(x, y, b::Block, c::Chamber) = _validLocation(x+width(b), y, c) && isplaceable(x+1, y, b, c)
canFall(x, y, b::Block, c::Chamber) = _validLocation(x, y-1, c) && isplaceable(x, y-1, b, c)

function dropBlock!(startX, startY, b::Block, c::Chamber, w::Wind)
    x, y = startX, startY
    moved = true
    while moved
        wind = next(w)
        wind == '<' && canBlowLeft(x, y, b, c) && (x -= 1)
        wind == '>' && canBlowRight(x, y, b, c) && (x += 1)
        canFall(x, y, b, c) ? y -= 1 : moved = false
    end
    placeBlock!(x, y, b, c)
    return y + height(b) - 1
end
dropBlock!(startY, b::Block, c::Chamber, w::Wind) = dropBlock!(X_INDENT(), startY, b, c, w)
dropBlock!(startY, bs::Blocks, c::Chamber, w::Wind) = dropBlock!(startY, next(bs), c, w)
dropBlock!(b::Block, c::Chamber, w::Wind) = dropBlock!(_currentHeight(c) + Y_GAP(), b, c, w)
dropBlock!(bs::Blocks, c::Chamber, w::Wind) = dropBlock!(next(bs), c, w)

function dropBlocks!(n, bs::Blocks, c::Chamber, w::Wind)
    BUFFER_HEADSPACE = maximum(height, bs.blocks)
    dropY = _currentHeight(c) + Y_GAP()
    for i ∈ 1:n
        if dropY + BUFFER_HEADSPACE ≥ size(c.buffer, 2)
            print("Compacting...")
            dropY -= compact!(c)
            println("done!")
        end
        dropY = max(dropY, dropBlock!(dropY, bs, c, w) + Y_GAP())
    end
    return dropY - Y_GAP()
end