module Day24
using Underscores
include("Combinat.jl")

function readdata()
    @_ "input.txt"      |>
        readlines       |>
        parse.(Int, __)
end

quantumEntanglement(set) = prod(set)
mingroupsize(set, target) = @_ set  |>
    sort(__, rev=true)              |>
    cumsum                          |>
    findfirst((≥)(target), __)

function bestSplit(weights, part2)
    numgroups = part2 ? 4 : 3
    target = sum(weights)÷numgroups
    size = mingroupsize(weights, target)
    groups = subsets(weights, target, size)
    while true
        while groups == []
            size += 1
            groups = subsets(weights, target, size)
        end
        sort!(groups, by=quantumEntanglement)
        remaining = setdiff.(Ref(weights), groups)
        best = findfirst(r -> equalSplit(r, numgroups-1), remaining)
        best === nothing || return groups[best]
        groups = []
    end
end

function day24(part2)
    weights = readdata()
    best = bestSplit(weights, part2)
    return quantumEntanglement(best)
end
end;