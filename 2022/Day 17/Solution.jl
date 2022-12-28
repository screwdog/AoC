module Day17
using Underscores
include("Wind.jl")
include("Blocks.jl")
include("Chamber.jl")
include("Physics.jl")
include("Part2.jl")

initialise(filename) = (Chamber(), standardBlocks(), wind(readchomp(filename)))

function part1(test=false)
    NUM_BLOCKS = 2022
    chamber, blocks, wind = (test ? "test.txt" : "input.txt") |> initialise
    dropBlocks!(chamber, blocks, wind, NUM_BLOCKS)
    return towerHeight(chamber)
end

function part2(test=false)
    NUM_BLOCKS = 1_000_000_000_000
    chamber, blocks, wind = (test ? "test.txt" : "input.txt") |> initialise
    periodInfo = findPeriod!(chamber, blocks, wind)
    return towerHeight(periodInfo, NUM_BLOCKS)
end
end;