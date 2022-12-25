!(@isdefined Blocks) && include("Blocks.jl")
!(@isdefined Chamber) && include("Chamber.jl")

function Base.show(io::IO, c::Chamber)
    bufferCol2String(col) = join(map(x -> x ? '#' : '.', col))

    h = _currentHeight(c) + 1
    for y ∈ h:-1:1
        println(io, "|", bufferCol2String(c.buffer[:,y]), "|")
    end
    println("+-------+\n")
end

function Base.show(io::IO, t::Tuple{Vector{Int}, Block, Chamber})
    bufferCol2CharArray(col) = map(x -> x ? '#' : '.', col)

    location, b, c = t
    h = _currentHeight(c) + 1
    blockRange = last(location):last(location)+height(b)-1
    blockRow = height(b)
    h = max(h, last(blockRange))
    for y ∈ h:-1:1
        if y ∉ blockRange
            println(io, "|", bufferCol2CharArray(c.buffer[:,y])..., "|")
        else
            buff = bufferCol2CharArray(c.buffer[:,y])
            for i ∈ axes(b.shape, 1)
                b.shape[i, blockRow] && (buff[first(location) + i - 1] = '@')
            end
            blockRow -= 1
            println(io, "|", buff..., "|")
        end
    end
    println("+-------+\n")
end