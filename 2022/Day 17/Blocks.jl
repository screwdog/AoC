const EMPTY_CHAR = '.'
const BLOCK_CHAR = '#'
# These constants only apply to the standardBlocks as
# provided in the puzzle and in blocks.txt
const MAX_BLOCK_HEIGHT = 4

"""
`Block`

Represents an individual falling block. Block positions are tracked by their
bottom-left corner.
"""
struct Block
    data::BitMatrix
    width::Int8
    height::Int8
end
# create a block from a collection of strings, in the style presented in the
# problem statement. That is, like:
# ..#
# ###
# #..
function Block(lines)
    length(lines) == 0 && return Block(falses(0, 0), 0, 0)
    if !allequal(length.(lines))
        @warn "Block: unequal string lengths [fixed]"
        maxlength = maximum(length, lines)
        lines = rpad.(lines, maxlength, EMPTY_CHAR)
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

# we store the blocks in a file rather than in code
function standardBlocks()
    @_ "blocks.txt"         |>
        read(__, String)    |>
        split(__, "\n\n")   |>
        split.(__)          |>
        Block.(__)          |>
        StatefulCycle
end