mutable struct PeriodInfo
    prefixBlocks::Int
    prefixHeight::Int
    periodBlocks::Int
    periodHeight::Int 
end
PeriodInfo() = PeriodInfo(0,0,0,0)

function runIn!(cs::ChamberState)
    while dropDepth(cs) == 1
        dropBlocks!(cs, 1)
        canDrop(cs) || throw(ErrorException("Buffer full before run-in complete"))
    end
    compact!(cs)
end

function findNextRepeat!(cs::ChamberState, windStates)
    while true
        dropBlocks!(cs, BLOCK_CYCLE_LENGTH)
        newState = state(cs.wind)
        haskey(windStates, newState) && return nothing
        windStates[newState] = [cs.blocksDropped]
    end
end

function checkRepeats!(runIn::ChamberState, ahead::ChamberState, behind::ChamberState, windStates)
    repeats = windStates[state(ahead.wind)]
    first(repeats) < behind.blocksDropped && copy!(behind, runIn)

    aheadMap, behindMap = makeDropMap(), makeDropMap()
    aheadMapView = dropMap!(aheadMap, ahead)
    for ind ∈ repeats
        dropBlocks!(behind, ind - behind.blocksDropped)
        behindMapView = dropMap!(behindMap, behind)
        aheadMapView == behindMapView && return (behind.blocksDropped, ahead.blocksDropped)
    end
    push!(repeats, ahead.blocksDropped)
    return nothing
end

function findPeriod!(cs::ChamberState)
    runIn!(cs)  
    ahead, behind = deepcopy(cs), deepcopy(cs)
    windStates = Dict{Int,Vector{Int}}()
    while true
        findNextRepeat!(ahead, windStates)
        repeat = checkRepeats!(cs, ahead, behind, windStates)
        repeat === nothing || break
    end

    return PeriodInfo(
        behind.blocksDropped,
        towerHeight(behind),
        ahead.blocksDropped - behind.blocksDropped,
        towerHeight(ahead) - towerHeight(behind)
    )
end

function towerHeight!(cs::ChamberState, periodInfo::PeriodInfo, numBlocks)
    if numBlocks ≤ periodInfo.prefixBlocks
        toDrop = numBlocks - cs.blocksDropped
        if toDrop < 0
            reset!(cs)
            toDrop = numBlocks
        end
        additionalHeight = 0
    else
        targetRange = (1:periodInfo.periodBlocks) .+ cs.blocksDropped .- 1
        targetBlocks = mod(numBlocks, targetRange)
        toDrop = targetBlocks - cs.blocksDropped
        numPeriods = (numBlocks - targetBlocks)÷periodInfo.periodBlocks
        additionalHeight = numPeriods * periodInfo.periodHeight
    end
    dropBlocks!(cs, toDrop)
    return towerHeight(cs.chamber) + additionalHeight
end