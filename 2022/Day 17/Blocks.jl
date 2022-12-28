const EMPTY_CHAR = '.'
const BLOCK_CHAR = '#'
const MAX_BLOCK_HEIGHT = 4

struct Block
    data::Union{Matrix{Bool}, BitMatrix}
    width::Int8
    height::Int8
end
function Block(lines)
    length(lines) == 0 && return Block(fill(false, 0, 0), 0, 0)
    if !allequal(length.(lines))
        @warn "Block: unequal string lengths [fixed]"
        maxLength = maximum(length, lines)
        lines = rpad.(lines, maxLength, EMPTY_CHAR)
    end
    width = length(lines[1])
    height = length(lines)
    data = @_ lines         |>
        reverse             |>
        collect.(__)        |>
        hcat(__...)         |>
        (__ .== BLOCK_CHAR)
    
    return Block(data, width, height)
end

function standardBlocks()
    @_ "blocks.txt"         |>
        read(__, String)    |>
        split(__, "\n\n")   |>
        split.(__)          |>
        Block.(__)          |>
        Iterators.Cycle     |>
        Iterators.Stateful
end