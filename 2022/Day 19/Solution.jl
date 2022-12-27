module Day19
using ProgressMeter
export solve, readdata, maxGeodes
include("Data.jl")
include("Optimise.jl")

quality(geodes) = geodes .* (1:length(geodes)) |> sum

# Solving part 2 takes ~35 mins on my computer. Be warned.
function solve(part2, test=false)
    blueprints = readdata(test ? "test.txt" : "input.txt", part2)
    optima = map(bp -> maxGeodes(bp, part2), blueprints)
    return optima |> (part2 ? prod : quality)
end
end;