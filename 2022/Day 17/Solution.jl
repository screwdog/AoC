module Day17
using Underscores
include("Wind.jl")
include("Blocks.jl")
include("Chamber.jl")
include("Physics.jl")
include("Part2.jl")

initialise(filename) = ChamberState(readchomp(filename))

function part1(test=false)
    NUM_BLOCKS = 2022
    chamberState = (test ? "test.txt" : "input.txt") |> initialise
    dropBlocks!(chamberState, NUM_BLOCKS)
end

function part2(test=false)
    NUM_BLOCKS = 1_000_000_000_000
    chamberState = (test ? "test.txt" : "input.txt") |> initialise
    periodInfo = findPeriod!(chamberState)
    return towerHeight!(chamberState, periodInfo, NUM_BLOCKS)
end
end;