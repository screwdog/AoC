const EMPTY_CHAR = '.'
const BLOCK_CHAR = '#'
# These constants only apply to the standardBlocks as
# provided in the puzzle and in blocks.txt
const MAX_BLOCK_HEIGHT = 4
const BLOCK_CYCLE_LENGTH = 5 

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
        StatefulCycle
end