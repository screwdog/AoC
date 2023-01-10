module Day19
using Underscores
include("Types.jl")
include("Generations.jl")
include("Search.jl")
include("Input.jl")

const TARGET = element2Int("e")

validroot(n::Node, molecule) = range(n) == axes(molecule, 1) && element(n) == TARGET

function day19p2()
    transforms, molecule = readdata("input.txt")
    generations = allgenerations(transforms, molecule)
    rootnodes = Iterators.filter(
        n -> validroot(n, molecule),
        allnodes(generations)
    )
    return isempty(rootnodes) ? nothing : minimum(numtransforms, rootnodes)
end
end;