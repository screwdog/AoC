MAX_TIME = 24
function timeToBuild(robot, blueprint, resources, robots)
    maxTime = 0
    for res ∈ ORE:OBSIDIAN
        if robots[res] == 0
            blueprint[robot, res] > 0 && (maxTime = MAX_TIME + 1)
        else
            newTime = ceil(Int, (blueprint[robot, res] - resources[res]) / robots[res])
            maxTime = max(maxTime, newTime)
        end
    end
    return maxTime + 1
end
canBuild(robot, blueprint, resources, robots) =
    timeToBuild(robot, blueprint, resources, robots) ≤ resources[TIME]
buildable(blueprint, resources, robots) =
    filter(r -> canBuild(r, blueprint, resources, robots), ORE:GEODE)

function doBuild!(robot, blueprint, resources, robots)
    time = timeToBuild(robot, blueprint, resources, robots)

    resources[ORE:GEODE] += robots*time
    resources[TIME] -= time
    resources[ORE:OBSIDIAN] -= blueprint[robot, ORE:OBSIDIAN]
    robots[robot] += 1
    return nothing
end

function undoBuild!(robot, blueprint, resources, robots, time)
    robots[robot] -= 1
    resources[ORE:OBSIDIAN] += blueprint[robot, ORE:OBSIDIAN]
    resources[TIME] += time
    resources[ORE:GEODE] -= robots*time
    return nothing
end

function maxGeodes(blueprint)
    maxMined = 0
    resources = [0,0,0,0,MAX_TIME]
    robots = [1,0,0,0]

    buildStack = Int[]
    stateStack = Tuple{Vector{Int},Int}[]

    while true
        possibles = buildable(blueprint, resources, robots)
        if isempty(possibles)
            totalGeodes = resources[GEODE] + resources[TIME]*robots[GEODE]
            maxMined = max(maxMined, totalGeodes)

            while isempty(possibles) && !isempty(buildStack)
                possibles, δt = pop!(stateStack)
                robot = pop!(buildStack)
                undoBuild!(robot, blueprint, resources, robots, δt)
            end
            isempty(possibles) && isempty(buildstack) && return maxMined
        end

        robot = pop!(possibles)
        δt = timeToBuild(robot, blueprint, resources, robots)
        push!(buildStack, robot)
        push!(stateStack, (possibles, δt))
        doBuild!(robot, blueprint, resources, robots)
    end
end