"""
`Period`

The structure of the sequence of tower heights for a particular sequence of
blocks and air jets. Such a sequence consists of a non-repeating "prefix",
followed by an endless repeating "period".
"""
mutable struct Period
    prefixlength::Int
    prefixheight::Int
    periodlength::Int
    periodheight::Int 
end
Period() = Period(0,0,0,0)

"""
`runin!(cavestate)`

Drops blocks, advancing `cavestate`, until a hypothetical next dropped block can
no longer reach the floor of the chamber.
"""
function runin!(cs::CaveState)
    while dropdepth(cs) == 1
        dropblocks!(cs, 1)
        candrop(cs) || throw(ErrorException("Buffer full before run-in complete"))
    end
    compact!(cs)
end

"""
`findnextrepeat!(cavestate, jets)`

Drop blocks, advancing `cavestate`, until the state of the jets is the same as
a previous state in `jets`. At each step we drop a full cycle of blocks.
"""
function findnextrepeat!(cs::CaveState, jets)
    while true
        dropblocks!(cs, cyclelength(cs.blocks))
        newstate = state(cs.jet)
        haskey(jets, newstate) && return nothing
        jets[newstate] = [cs.blocksdropped]
    end
end

"""
`checkrepeats!(runin, ahead, behind, jets)`

    `runin` is the tower state at the start of the search for repetition
    `behind` is a pointer to some previous state to be reused

Given that `ahead` represents a tower of blocks that is in the same place in the
cycle of blocks and air jets as some shorter tower, check if there is a previous
tower state that is equivalent in all important details.
"""
function checkrepeats!(runin::CaveState, ahead::CaveState, behind::CaveState, jets)
    repeats = jets[state(ahead.jet)]
    first(repeats) < behind.blocksdropped && copy!(behind, runin)

    # We've ensured that all positions in `jets` are in the same place in the
    # cycle of both blocks and air jets, and so we need only check the region
    # that the next block can fall into.

    aheadmap, behindmap = makedropmap(), makedropmap()
    aheadmapview = dropmap!(aheadmap, ahead)
    for ind ∈ repeats
        dropblocks!(behind, ind - behind.blocksdropped)
        behindmapview = dropmap!(behindmap, behind)
        aheadmapview == behindmapview && return (behind.blocksdropped, ahead.blocksdropped)
    end
    push!(repeats, ahead.blocksdropped)
    return nothing
end

"""
`findperiod!(cavestate) -> Period`

Calculate and return the periodic structure of the heights of the tower of
blocks in `cavestate`.
"""
function findperiod!(cs::CaveState)
    # The chamber starts with a flat floor so we drop blocks until we can no
    # longer reach it.
    runin!(cs)  

    # We need to keep track of only two states at a time - a pointer to the
    # highest tower (`ahead`), and another pointer that we use for comparisons
    # (`behind`).
    ahead, behind = deepcopy(cs), deepcopy(cs)

    # `jets[state] == [blocksdropped]` records the list of previous towers (ie
    # number of blocks dropped) that corresponded to each air jet state
    # previously encountered. 
    jets = Dict{Int,Vector{Int}}()
    while true
        findnextrepeat!(ahead, jets)
        repeat = checkrepeats!(cs, ahead, behind, jets)
        repeat === nothing || break
    end

    return Period(
        behind.blocksdropped,
        towerheight(behind),
        ahead.blocksdropped - behind.blocksdropped,
        towerheight(ahead) - towerheight(behind)
    )
end

# These two functions calculate how many additional blocks need to be dropped
# in `cs` to put it in a state that is functionally equivalent to the final
# state. Also, returns the additional height that the final state has once those
# extra blocks have been dropped.
function inprefix!(cs, period, numblocks)
    todrop = numblocks - cs.blocksdropped
    if todrop < 0
        reset!(cs)
        return (numblocks, 0)
    end
    return (topdrop, 0)
end

function afterprefix(cs, period, numblocks)
    periods, todrop = divrem(numblocks - cs.blocksdropped, period.periodlength)
    return (todrop, periods * period.periodheight)
end

"""
`towerheight!(cavestate, period, numblocks) -> Int`

Return the height of the tower in `cavestate` if its tower has a periodic
structure given by `period` and were we to drop `numblocks` blocks.
"""
function towerheight!(cs::CaveState, period::Period, numblocks)
    f = numblocks ≤ period.prefixlength ? inprefix! : afterprefix
    todrop, additionalheight = f(cs, period, numblocks)
    dropblocks!(cs, todrop)
    return towerheight(cs.chamber) + additionalheight
end