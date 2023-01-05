module Day19
using Underscores
include("Data.jl")
include("Transforms.jl")
include("Search.jl")

const TARGET = element2Int("e")

function day19p2()
    transforms, molecule = readdata("input.txt")
    return mintransforms(transforms, molecule, TARGET)
end
end;