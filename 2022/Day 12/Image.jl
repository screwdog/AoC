include("Solution.jl")
using Underscores, Images, ColorSchemes

pathcolor() = colorant"red4"
# input has a strange vertical line of 'b' near the left edge, and 'b' occurs
# nowhere else. This is perhaps supposed to be the river in the scenario? We
# single this out as blue and use a green gradient for the other heights.
terraincolor() = ColorScheme(
    @_ sequential_palette(120.0, 25) |>
        insert!(reverse(__), 2, colorant"blue")
)

"""
`picture(data, colorscheme) -> pic`

Creates a picture from the given `data` in the `colorscheme`, suitable for
display or saving.
"""
function picture(data, colorscheme)
    tocolor = x -> colorscheme[x]
    a, z = extrema(data)
    picdata = (data .- a) ./ (z - a)
    return tocolor.(picdata)
end
drawpath!(data, path, color) = data[path] .= color

"""
`bigpicture(picture) -> pic`

Creates a bigger version of `picture` where each pixel in the original is
represented by a larger square of pixels in the result. Attempts to scale up
to as close to 1920x1080 while keeping the blocks square.
"""
function bigpicture(picture)
    BIG_SIZE = (1080, 1920)
    blocksize = minimum(BIG_SIZE .÷ size(picture))
    N, M = blocksize .* size(picture)
    bigpic = Matrix{eltype(picture)}(undef, N, M)
    # indices for the block representing the top-left pixel
    blockrange = CartesianIndex(1,1):CartesianIndex(blocksize, blocksize)
    for I ∈ CartesianIndices(picture)
        # index for the top-left of the current big block
        topleft = blocksize * (I - CartesianIndex(1,1))
        # topleft .+ blockrange is all of the indices for the current big block
        bigpic[topleft .+ blockrange] .= picture[I]
    end
    return bigpic
end

"""
`createpics()`

Create images of the solution to Advent of Code 2022 Day 12 puzzle, parts 1 and
2. Draws the shortest paths and saves in big and small formats as .png.
"""
function createpics()
    heights, S, E = Day12.readdata()
    p1path = last(Day12.shortestpath(heights, S, E))
    p2path = last(Day12.shortestpath(heights, Day12.lowest(heights), E))
    p1pic = picture(heights, terraincolor())
    p2pic = copy(p1pic)
    drawpath!.([p1pic, p2pic], [p1path, p2path], pathcolor())
    p1big, p2big = bigpicture.((p1pic, p2pic))
    save.(
        ["p1map.png", "p1mapbig.png", "p2map.png", "p2mapbig.png"],
        [p1pic, p1big, p2pic, p2big]
    )
    return nothing
end
createpics()