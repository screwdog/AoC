include("Dijkstra.jl")

line2heights(line) = Int.(collect(line))
function index2vector(index)
    t = Tuple(index)
    return [first(t), last(t)]
end
function startEnd(heights)
    S, E = findfirst((==)(83), heights), findfirst((==)(69), heights)
    return (index2vector(S), index2vector(E))
end
fixStartEnd!(heights) = replace!(heights, 83 => 97, 69 => 122)

function allLowest(heights)
    MAX_HEIGHT = 100_000
    lowest = MAX_HEIGHT
    places = Vector{Int}[]
    for i ∈ axes(heights, 1), j ∈ axes(heights, 2)
        if heights[i,j] < lowest
            lowest = heights[i,j]
            places = [[i,j]]
        elseif heights[i,j] == lowest
            push!(places, [i,j])
        end
    end
    return places
end

function day12(test=false)
    inputfile = test ? "test.txt" : "input.txt"
    lines = readlines(inputfile)
    heights = reduce(hcat, line2heights.(lines))'
    S, E = startEnd(heights)
    fixStartEnd!(heights)
    return (shortestPath(heights, S, E), shortestPath(heights, allLowest(heights), E))
end
day12(false)