const LITRES = 150

struct Combinations
    numelements::Int
end
function Base.iterate(c::Combinations)
    c.numelements == 0 && return nothing
    return ([false for _ ∈ 1:c.numelements], [false for _ ∈ 1:c.numelements])
end
function Base.iterate(::Combinations, state)
    all(state) && return nothing
    index = findlast(!, state)
    state[index] = true
    state[(index+1):end] .= false
    return (state, state)
end
Base.eltype(::Combinations) = Vector{Bool}
Base.length(c::Combinations) = 2^c.numelements

function day17(part2)
    capacity(c, s) = sum(c[s])

    containers = parse.(Int, readlines("input.txt"))
    mincontainers = length(containers) + 1
    combinations = 0
    for combination ∈ Combinations(length(containers))
        if capacity(containers, combination) == LITRES
            if count(combination) < mincontainers && part2
                mincontainers = count(combination)
                combinations = 1
            elseif count(combination) == mincontainers || !part2
                combinations += 1
            end
        end
    end
    return combinations
end
day17.(false:true)