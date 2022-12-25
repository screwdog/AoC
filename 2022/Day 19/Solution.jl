module Day19
using Underscores

include("Data.jl")
include("Optimise.jl")

function part1(test=false)
    blueprints = @_ (test ? "test.txt" : "input.txt")   |>
        readdata                                        |>
        makeblueprints

    #maxGeodes.(blueprints)
    maxGeodes(blueprints[1])
    
    #.* 1:length(blueprints) |> sum
end

end;