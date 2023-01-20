"""
`validstep(from, to, heights) -> Bool`

Return whether stepping between `from` and `to` is valid in `heights`. Doesn't
check that `to` is a valid location, nor that `from` and `to` are adjacent.
"""
validstep(from, to, heights) = checkbounds(Bool, heights, from) && heights[to] - heights[from] ≤ 1

"""
`nextloc(visited, dist) -> CartesianIndex`

Return the next location to be visited in Dijkstra's algorithm - the location
at the shortest distance that is unvisited.
"""
function nextloc(visited, dist)
    possibles = filter(loc -> !visited[loc], CartesianIndices(visited))
    return argmin(loc -> dist[loc], possibles)
end

"""
`neighbours(heights, location) -> Vector{CartesianIndex}`

Return all allowable steps from `location`.
"""
function neighbours(heights, location)
    possibles = Ref(location) .+ [
        CartesianIndex(-1,  0),
        CartesianIndex( 1,  0),
        CartesianIndex( 0, -1),
        CartesianIndex( 0,  1)
    ]
    return filter(from -> validstep(from, location, heights), possibles)
end

"""
`shortestpath(heights, S, E) -> (distance, path)`

Calculates the shortest path between either a starting location or a vector of
potential starting locations `S`, and an ending location `E`, along with the
length of the shortest path. This is for convenience as, by definition,
`distance == length(path) - 1`.
"""
shortestpath(heights, S::CartesianIndex{2}, E) = shortestpath(heights, [S], E)
function shortestpath(heights, S::Vector{CartesianIndex{2}}, E)
    MAX_DIST = 100_000

    visited = falses(axes(heights))
    dist = fill(MAX_DIST, axes(heights))
    # start at E and work backwards to (any of) S
    dist[E] = 0
    # record the location of the next step in shortest path for each location
    next = similar(heights, CartesianIndex{2})

    # visited[S] is equivalent to map(s -> visited[s], S) but neater
    while !any(visited[S])
        location = nextloc(visited, dist)
        visited[location] = true
        for neighbour ∈ neighbours(heights, location)
            if dist[neighbour] > dist[location] + 1
                dist[neighbour] = dist[location] + 1
                next[neighbour] = location
            end
        end
    end
    # equivalent to minimum(s -> dist[s], S)
    location = S[argmin(dist[S])]
    path = [location]
    while next[location] ≠ location
        location = next[location]
        push!(path, location)
    end
    return minimum(dist[S]), path
end
