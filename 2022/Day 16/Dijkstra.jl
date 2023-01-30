function shortestpath!(valves, connections, source, distances)
    MAX_DIST = 100_000
    valvenums = axes(valves, 1)
    dist = fill(MAX_DIST, valvenums)
    dist[source] = 0

    queue = sort!(collect(valvenums), lt=(v1,v2) -> dist[v1] < dist[v2])

    while !isempty(queue)
        location = popfirst!(queue)
        neighbours = collect(valvenums)
        filter!(i -> connections[location, i], neighbours)
        for neighbour ∈ neighbours
            newdist = dist[location] + 1
            if newdist < dist[neighbour]
                dist[neighbour] = newdist
                sort!(queue, lt=(v1,v2) -> dist[v1] < dist[v2])
            end
        end
    end

    distances[source, :] = dist
end