module Day16
using LinearAlgebra: diagind
using Underscores
using ProgressMeter
include("Data.jl")
include("TSP.jl")

"""
`day16p1() -> Int`

Solves Advent of Code 2022 day 16, part 1, reading its input from "input.txt".
That is, returns the maximum amount of pressure that can be released in 30
minutes by opening valves as per the input.
"""
function day16p1()
    return @_ readdata() |> maxpressure(__...) |> first
end

"""
`day16p2() -> Int`

Solves Advent of Code 2022 day 16, part 2, reading its input from "input.txt".
That is, returns the maximum amount of pressure that can be released in 26
minutes by opening valves as per the input, given that an elephant can help you.
This function is slow and displays a progress meter.
"""
function day16p2()
    pressures, distances, start = readdata()
    valves = axes(start,1)
    # we track the maximum pressure releasable by a single actor, and the best
    # solution found so far
    myresult = maxpressure(pressures, distances, start; timelimit=26)
    maxsingle = first(myresult)
    bestpair = maxsingle + first(maxpressure(
        pressures,
        distances,
        start;
        timelimit=26,
        allow=setdiff(valves, last(myresult))
    ))

    allsubsets = subsets(collect(valves))
    mysubsets = filter(s -> length(s) ≤ length(valves)÷2, allsubsets)
    @showprogress 1 "Checking paths..." for s ∈ mysubsets
        myresult = maxpressure(pressures, distances, start; timelimit=26, allow=s)
        # if pressure released is too low then we can skip calculating the
        # elephant's path
        if first(myresult) ≥ bestpair - maxsingle
            elephantresult = first(maxpressure(
                pressures,
                distances,
                start;
                timelimit=26,
                allow=setdiff(valves, last(myresult))
            ))
            bestpair = max(bestpair, sum(first, [myresult, elephantresult]))
        end
    end
    return bestpair
end
end;