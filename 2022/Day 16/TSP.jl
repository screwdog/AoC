const MAX_TIME = 30

"""
`maxpressure(pressures, distances, start; [timelimit=30], [allow=all]) -> (Int, Int[])`

Calculates the maximum pressure that can be released by opening valves that
release `pressures`, separated by `distances`, where the distance from our
starting location (not necessarily a valve) to a valve is `start`. Optionally,
specify a custom `timelimit` and restrict our solutions to only those valves in
`allow`. Returns the pressure released and the sequence of valves that produces
that result.
"""
function maxpressure(pressures, distances, start;
        timelimit=MAX_TIME, allow=BitSet(axes(start,1)))

    # As our starting location may have a broken valve, which will have been
    # eliminated from the data, the first step has to be calculated differently.
    # This function does the recursion after the first valve.
    function _maxpressure(valve, valves, timeleft, pressure)
        newvalves = prepend!([valve], valves)
        best = (0, newvalves)
        for v ∈ setdiff(allow, newvalves)
            if distances[valve, v] < timeleft
                newresult = _maxpressure(
                        v,
                        newvalves,
                        timeleft - distances[valve, v],
                        pressures[v]
                    )
                first(newresult) > first(best) && (best = newresult)
            end
        end
        return (first(best) + timeleft * pressure, last(best))
    end

    bestresult = (0, [])
    for v ∈ allow
        result = _maxpressure(v, [], timelimit - start[v], pressures[v])
        first(result) > first(bestresult) && (bestresult = result)
    end
    return bestresult
end

"""
`subsets(set) -> Vector{Vector}`

Returns all subsets of `set`, ordered from smallest to largest.
"""
function subsets(set)
    function allsubsets(s)
        length(s) == 1 && return [[], s]
        without = allsubsets(s[2:end])
        with = pushfirst!.(deepcopy(without), first(s))
        return append!(without, with)
    end

    S = allsubsets(set)
    return sort!(sort!(S), by=length)
end
