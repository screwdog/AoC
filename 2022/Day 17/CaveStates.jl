"""
`CaveState`

Represents the current state of the cave - which locations in the chamber are
blocked, which block is due to fall next, which air jet is due to blow and how
many blocks have already been dropped.

This is a convenience `struct` to bundle this state together.
"""
mutable struct CaveState
    chamber::Chamber
    blocks::StatefulCycle
    jet::StatefulCycle
    blocksdropped::Int
end
CaveState(str) = CaveState(Chamber(), standardBlocks(), jets(str), 0)
function reset!(cs::CaveState)
    reset!(cs.chamber)
    reset!(cs.blocks)
    reset!(cs.jet)
    cs.blocksdropped = 0
    return cs
end
candrop(cs::CaveState) = candrop(cs.chamber)
towerheight(cs::CaveState) = towerheight(cs.chamber)
safedrops(cs::CaveState) = safedrops(cs.chamber)
dropdepth(cs::CaveState) = dropdepth(cs.chamber)
dropmap!(droppable, cs::CaveState) = dropmap!(droppable, cs.chamber)
dropmap(cs::CaveState) = dropmap(cs.chamber)
compact!(cs::CaveState) = compact!(cs.chamber)
