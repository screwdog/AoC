# ensure code is defined for all worker processes
@everywhere module Day19
using Underscores
using Distributed
include("RobotsAndResources.jl")
include("Blueprints.jl")
include("Optimisation.jl")

# use pmap for parallel computation
quality(blueprints) = pmap(quality, blueprints) |> sum
quality(b::Blueprint) = number(b) * maxgeodes(b, 24)

part2(b::Blueprint) = maxgeodes(b, 32)
part2(blueprints) = @_ blueprints   |>
    first(__, 3)                    |>
    # again, pmap to run in parallel
    pmap(part2, __)                 |>
    prod

"""
`day19() -> (Int, Int)`

Solve Advent of Code 2022, day 19, reading the input data from "input.txt". That
is, calculate the sum of the "qualities" of each blueprint for part 1, and the
product of the maximum geodes producible for the first 3 blueprints for part 2.
"""
function day19()
    blueprints = readdata()
    return (quality(blueprints), part2(blueprints))
end
end;

Day19.day19()
