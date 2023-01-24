using Images

const CAVE_EMPTY = 1
const CAVE_ROCK = 2
const CAVE_SAND = 3
const CAVE_SOURCE = 4

colorscheme() = [
    colorant"black",
    colorant"brown4",
    colorant"darkgoldenrod2",
    colorant"white"
]

# since we're only storing whether a location is blocked, but not what it is
# blocked by, we use the initial cave state to determine what should be drawn
# as rock rather than sand. Assemble this into a Matrix{Int} that indicates
# what is in each location of the cave.
function cavecombine(init, final, source)
    cave = fill(CAVE_EMPTY, size(init))
    cave[final] .= CAVE_SAND
    cave[init] .= CAVE_ROCK
    cave[source] = CAVE_SOURCE
    return cave
end

# Convert a Matrix{Int} into Matrix{RGB}. Also transpose as cave data was
# stored in column-major order and we need it [x,y]
picture(combinedcave) = colorscheme()[combinedcave]'

# given a picture, create a larger image where a square block of pixels
# corresponds to each pixel in the original image. Keeps each block square and
# tries to scale it up to as close to 1920x1080.
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

# create images for the solution to part 1
function makep1pics()
    cave, source = Day14.readdata()
    init = copy(cave)
    Day14.dropsand!(cave, source, Day14.stop[false])
    p1pic = picture(cavecombine(init, cave, source))
    p1big = bigpicture(p1pic)
    save("images/p1.png", p1pic)
    save("images/p1big.png", p1big)
end

# Creates animated gifs for the solution to part 2. Attempts to create an image
# that plays for about 15s at 10fps.
function makep2pics()
    ANIM_LENGTH = 15 # seconds
    FPS = 10
    cave, source = Day14.readdata(true)
    numgrains = Day14.day14(true)
    GRAINS_PER_FRAME = cld(numgrains, ANIM_LENGTH * FPS)
    NUM_FRAMES = cld(numgrains, GRAINS_PER_FRAME)

    numrocks = count(cave)
    # frames holds the cave state at periodic intevals during the sand drops
    frames = BitArray(undef, size(cave, 1), size(cave, 2), NUM_FRAMES)
    frames[:,:,1] .= cave

    # stop whenever we've dropped GRAINS_PER_FRAME grains. numrocks is the
    # amount of locations initially blocked, this stops whenever we're a whole
    # multiple of GRAINS_PER_FRAME grains dropped.
    framestop(cave, source, location) = 
        mod(count(cave) - numrocks, GRAINS_PER_FRAME) == 0

    for frame ∈ 2:NUM_FRAMES
        Day14.dropsand!(cave, source, framestop)
        frames[:,:,frame] .= cave
        frame += 1
    end
    frames[:,:,end] .= cave

    # we now convert the saved states into numerical form corresponding to
    # whether each location is CAVE_EMPTY, CAVE_ROCK, etc, frame by frame
    numdata = similar(frames, Int)
    for frame ∈ axes(frames, 3)
        numdata[:,:,frame] .= 
            cavecombine(frames[:,:,1], frames[:,:,frame], source)
    end

    # convert numeric data into pixel data, frame by frame
    picdata = Array{eltype(colorscheme())}(
        undef, size(numdata, 2), size(numdata, 1), NUM_FRAMES
    )
    for frame ∈ axes(frames, 3)
        picdata[:,:,frame] = picture(numdata[:,:,frame])
    end

    # create upsized versions, again frame by frame
    N, M = size(bigpicture(picdata[:,:,1]))
    bigdata = Array{eltype(picdata)}(undef, N, M, NUM_FRAMES)
    for frame ∈ axes(bigdata, 3)
        bigdata[:,:,frame] .= bigpicture(picdata[:,:,frame])
    end

    save("images/p2.gif", picdata)
    save("images/p2big.gif", bigdata)
end

makep1pics()
makep2pics()
