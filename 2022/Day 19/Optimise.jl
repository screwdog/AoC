const RESOURCE_OFFSET = 2
const ROBOTS_OFFSET = 6

const S_ROBOT = 1
const S_MAX_ROBOT = 2
const RS_RANGE = (R_ORE:R_GEODE) .+ RESOURCE_OFFSET
const RB_COST_RANGE = (R_ORE:R_OBSIDIAN) .+ RESOURCE_OFFSET
const RB_RANGE = (R_ORE:R_GEODE) .+ ROBOTS_OFFSET
const S_TIME = 11

const P1_MAX_TIME = 24
const P2_MAX_TIME = 32
const STATE_SIZE = 11

function initStack(part2)
    MAX_TIME = (part2 ? P2_MAX_TIME : P1_MAX_TIME)
    stack = Matrix{Int}(undef, (MAX_TIME+1, STATE_SIZE))
    top = 1
    stack[top, :] .= [R_ORE, R_ORE, 0, 0, 0, 0, 1, 0, 0, 0, MAX_TIME]
    stack[top+1, S_ROBOT] = R_CLAY
    return (top, stack)
end

idleGeodes(top, stack) = stack[top, RESOURCE_OFFSET + R_GEODE] +
    stack[top, ROBOTS_OFFSET + R_GEODE] * stack[top, S_TIME]
@inline function timeToBuild(blueprint, top, stack)
    robot = stack[top+1, S_ROBOT]
    resources = @view stack[top, RS_RANGE]
    robots = @view stack[top, RB_RANGE]
    oreTime = max(cld(blueprint[robot, R_ORE] - resources[R_ORE], robots[R_ORE]), 0)
    resource = robot - 1
    resource ≤ 1 && return oreTime + 1
    otherTime = max(cld(blueprint[robot, resource] - resources[resource], robots[resource]), 0)
    return max(oreTime, otherTime) + 1
end

@inline function buildRobot!(blueprint, top, stack, waitTime)
    for i ∈ S_MAX_ROBOT:S_TIME
        stack[top+1, i] = stack[top, i]
    end
    top += 1
    stack[top, S_MAX_ROBOT] = min(max(stack[top, S_ROBOT]+1, stack[top, S_MAX_ROBOT]), R_GEODE)
    for i ∈ R_ORE:R_GEODE
        stack[top, RESOURCE_OFFSET + i] += stack[top, ROBOTS_OFFSET + i] * waitTime
    end
    for i ∈ R_ORE:R_OBSIDIAN
        stack[top, RESOURCE_OFFSET + i] -= blueprint[stack[top, S_ROBOT], i]
    end
    stack[top, ROBOTS_OFFSET + stack[top, S_ROBOT]] += 1
    stack[top, S_TIME] -= waitTime
    stack[top+1, S_ROBOT] = stack[top, S_MAX_ROBOT]
    return top
end

function maxGeodes(blueprint, part2)
    p = ProgressUnknown("  Checking build plans:", spinner=true)
    top, stack = initStack(part2)
    currentMax = 0

    while true
        while stack[top+1, S_ROBOT] > 0 &&
            (waitTime = timeToBuild(blueprint, top, stack)) ≥ stack[top, S_TIME]
            stack[top+1, S_ROBOT] -= 1
        end

        if stack[top+1, S_ROBOT] > 0
            top = buildRobot!(blueprint, top, stack, waitTime)
        else
            ProgressMeter.next!(p)
            currentMax = max(currentMax, idleGeodes(top, stack))
            top == 1 && return (ProgressMeter.finish!(p); currentMax)
            stack[top, S_ROBOT] -= 1
            top -= 1
        end
    end
end