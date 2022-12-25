using Underscores

struct Block
    shape::Matrix{Bool}
    width::Int
    height::Int
end
width(b::Block) = b.width
height(b::Block) = b.height

function _string2block(str)
    line2row(l) = map((==)('#'), collect(l))

    shape = @_ str          |>
        split(__, "\n")     |>
        collect.(__)        |>
        reverse             |>
        hcat(__...)         |>
        map((==)('#'), __)
    width, height = size(shape)

    return Block(shape, width, height)
end

Block(str::AbstractString) = _string2block(str)

mutable struct Blocks
    blocks::Vector{Block}
    current::Int
    function Blocks(blocks::Vector{Block}, current::Int)
        isempty(blocks) && throw(ErrorException("Blocks requires blocks to be non-empty but received $blocks"))
        0 ≤ current ≤ length(blocks)-1 || throw(ErrorException("Blocks requires 0 ≤ current ≤ length(blocks)-1 but received current $current and blocks $blocks"))
        new(blocks, current)
    end
end
Blocks(blocks::Vector{Block}) = Blocks(blocks, 0)
function Base.iterate(b::Blocks, state)
    b.current = mod(b.current, length(b.blocks)) + 1
    (b.blocks[b.current], b.current)
end
Base.iterate(b::Blocks) = iterate(b, 0)
next(b::Blocks) = b |> iterate |> first
Base.IteratorSize(::Blocks) = Base.IsInfinite()
Base.eltype(::Blocks) = Block
Base.isdone(::Blocks) = false
Base.isdone(::Blocks, state) = false
Base.getindex(b::Blocks, i::Int) = b.blocks[i]

standardBlocks() = Blocks(Block.(
        ["####",
         ".#.\n###\n.#.",
         "..#\n..#\n###",
         "#\n#\n#\n#",
         "##\n##"]
        )
    )