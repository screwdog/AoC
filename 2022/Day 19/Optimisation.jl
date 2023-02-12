struct State
    robots::Robots
    resources::Resources
    timeleft::Int
end
State(maxtime) = State((1,0,0,0), (0,0,0,0), maxtime)
robots(s::State) = s.robots
robots(s::State, i) = s.robots[i]
resources(s::State) = s.resources
resources(s::State, i) = s.resources[i]
geode(r::Resources) = r[end]
timeleft(s::State) = s.timeleft

# calculates time required to build a robot given the current state. That is,
# how long necessary to wait for current robots to gather enough of each
# necessary resource.
function buildtime(robot, state)
    time = 0
    for i ∈ 1:NUM_RESOURCES
        if robots(state, i) == 0
            requires(robot, i) > resources(state, i) && return MAX_TIME
        else
            time = max(time, 
                cld(requires(robot, i) - resources(state, i), robots(state, i))
            )
        end
    end
    return time + 1
end

# calculate the current state after building the given robot, after waiting for
# sufficient resources to be gathered.
function build(robot, state)
    time = buildtime(robot, state)
    return State(
        robots(state) .+ produces(robot),
        resources(state) .- requires(robot) .+ time .* robots(state),
        timeleft(state) - time
    )
end

# from the current state, can we build the given robot before time runs out,
# and does it violate our restrictions on the number of each kind of robot?
function isbuildable(blueprint, robot, state)
    return buildtime(robot, state) < timeleft(state) && 
        all(robots(state) .+ produces(robot) .≤ maxrobots(blueprint))
end

"""
`maxgeodes(blueprint::Blueprint, time::Int) -> Int`

Calculate the maximum number of geodes that can be cracked in `time` minutes by
constructing robots from `blueprint`, assuming we start with 1 ore robot and no
other resources.
"""
function maxgeodes(blueprint::Blueprint, state::State, best=0)
    # if we don't build any more robots?
    geodes = geode(resources(state)) +  geode(robots(state)) * timeleft(state)
    # if we built a geode robot every minute from here could we out perform the
    # best currently known solution?
    geodes + timeleft(state) * (timeleft(state) - 1) ÷ 2 > best || return best
    # many branches are pruned based on having a good estimate of the best
    # solution so prioritise making geode robots before others.
    for robot ∈ Iterators.reverse(blueprint)
        if isbuildable(blueprint, robot, state)
            geodes = max(geodes, 
                maxgeodes(blueprint, build(robot, state), geodes)
        )
        end
    end
    return geodes
end
maxgeodes(b::Blueprint, t::Int) = maxgeodes(b, State(t))
