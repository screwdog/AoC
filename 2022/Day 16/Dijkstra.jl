function shortestPath!(valves, connections, source, distances)
    MAX_DIST = 100_000
    valveNums = axes(valves, 1)
    dist = fill(MAX_DIST, valveNums)
    dist[source] = 0

    queue = sort!(collect(valveNums), lt=(v1,v2) -> dist[v1] < dist[v2])

    while !isempty(queue)
        currentNode = popfirst!(queue)
        neighbours = collect(valveNums)
        filter!(i -> connections[currentNode, i], neighbours)
        for neighbour ∈ neighbours
            newDist = dist[currentNode] + 1
            if newDist < dist[neighbour]
                dist[neighbour] = newDist
                sort!(queue, lt=(v1,v2) -> dist[v1] < dist[v2])
            end
        end
    end

    distances[source, :] = dist
end