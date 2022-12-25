!(@isdefined Wind) && include("Wind.jl")
!(@isdefined Blocks) && include("Blocks.jl")
!(@isdefined Chamber) && include("Chamber.jl")
!(@isdefined dropBlock!) && include("Physics.jl")

readdata(filename) = filename |> readchomp |> Wind

init(test=false) = (standardBlocks(), Chamber(), readdata(test ? "test.txt" : "input.txt"))

function day17p1(test=false)
    NUM_BLOCKS = 2022
    blocks, chamber, wind = init(test)
    return dropBlocks!(NUM_BLOCKS, blocks, chamber, wind)
end

function day17p2(test=false)
    MAX_SEARCH_LENGTH = 10_000
    MATCH_LENGTH = 10
    NUM_BLOCKS = 1_000_000_000_000
    blocks, chamber, wind = init(test)
    wind.current = length(wind.directions)

    blocksDropped = 0
    windStates = Int[]
    for _ ∈ 1:MATCH_LENGTH+1
        dropBlocks!(5, blocks, chamber, wind)
        push!(windStates, wind.current)
    end

    while !issubarray(windStates[end-MATCH_LENGTH+1:end], windStates[1:end-1])
        dropBlocks!(5, blocks, chamber, wind)
        blocksDropped += 5
        push!(windStates, wind.current)
        blocksDropped > MAX_SEARCH_LENGTH && throw(ErrorException("no repetition found, try increasing MAX_SEARCH_LENGTH = $MAX_SEARCH_LENGTH"))
    end
    cycleStart, cycleEnd = findfirst((==)(wind.current), windStates), length(windStates)
    cycleLength = cycleEnd - cycleStart

    oldBlocks, oldChamber, oldWind = init(test)
    dropBlocks!(5*cycleStart, oldBlocks, oldChamber, oldWind)
    oldHeight, newHeight = towerHeight.((oldChamber, chamber))

    p1, p2, q = places(), places(), queue()
    _fallingblockplaces!(p1, q, oldChamber)
    _fallingblockplaces!(p2, q, chamber)

    blocksDropped = 0
    while p1 ≠ p2
        dropBlocks!()
    end
end
day17p2()

#=

15 + 35 = 50 -> 78
50 + 35 = 85 -> 131

50 blocks => height 78
every 35 after => + 53

total @ 1T => divrem(1T - 50, 35) = q, r
    78 + 53q + ??r

    dropBlocks!(r) ---> t
    t - height@50
    t - 78

=#