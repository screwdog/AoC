function canGo(loc, dir, heights)
    newLoc = loc + dir
    newLoc[1] ∈ axes(heights, 1) || return false
    newLoc[2] ∈ axes(heights, 2) || return false
    return heights[loc...] - heights[newLoc...] ≤ 1
end

shortestPath(heights, S::Vector{Int}, E) = shortestPath(heights, [S], E)
function shortestPath(heights, S::Vector{Vector{Int}}, E)
    MAX_DIST = 100_000
    function nextLoc(visited, dist)
        minDist, minI, minJ = MAX_DIST, 0, 0
        for i ∈ axes(visited, 1), j ∈ axes(visited, 2)
            if !visited[i,j] && dist[i,j] < minDist
                minDist, minI, minJ = dist[i,j], i, j
            end
        end
        return [minI, minJ]
    end

    directions = [[-1,0],[0,1],[1,0],[0,-1]]
    N = size(heights, 1)
    M = size(heights, 2)

    visited = falses(N, M)
    dist = fill(MAX_DIST, N, M)
    dist[E...] = 0

    while !any(s -> visited[s...], S)
        location = nextLoc(visited, dist)
        visited[location...] = true
        neighbours = filter(d -> canGo(location, d, heights), directions) .+ Ref(location)
        for neighbour ∈ neighbours
            if dist[neighbour...] > dist[location...]
                dist[neighbour...] = dist[location...] + 1
            end
        end
    end
    distances = map(s -> dist[s...], S)
    return minimum(distances)
end