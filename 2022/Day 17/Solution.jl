module Day17
using Underscores
include("Jets.jl")
include("Blocks.jl")
include("Chambers.jl")
include("CaveStates.jl")
include("Depth.jl")
include("Physics.jl")
include("Part2.jl")

initialise(filename) = CaveState(readchomp(filename))

"""
`part1() -> Int`

Solve Advent of Code 2022, day 17, part 1. That is, calculate the height of the
tower after 2022 blocks have been dropped where the pattern of air jets is given
in the file "input.txt".
"""
function part1()
    NUM_BLOCKS = 2022
    cavestate = initialise("input.txt")
    dropblocks!(cavestate, NUM_BLOCKS)
end

"""
`part2() -> Int`

Solve Advent of Code 2022, day 17, part 2. That is, calculate the height of the
tower after 1 trillion blocks have been dropped where the pattern of air jets is
given in the file "input.txt".

This is not calculated directly, but rather by finding patterns in how the
blocks fall.
"""
function part2()
    NUM_BLOCKS = 1_000_000_000_000
    cavestate = initialise("input.txt")
    periodinfo = findperiod!(cavestate)
    return towerheight!(cavestate, periodinfo, NUM_BLOCKS)
end
end;
(Day17.part1(), Day17.part2())
