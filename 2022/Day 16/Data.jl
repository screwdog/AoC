# Given a vector of which valves a valve is connected to by tunnels (linkages),
# turn this into an adjacency matrix (where connections[x, y] is true iff x and
# y are directly connected with a tunnel)
function makeconnections(valvenums, linkages)
    connections = falses(length(linkages), length(linkages))
    for i ∈ axes(linkages, 1)
        links = linkages[i]
        for valve ∈ links
            connections[i, valvenums[valve]] = true
        end
    end
    return connections
end

const MAX_DIST = 10_000
# Create an initial distance matrix for a connections matrix. That is, the
# length of the connection between valves.
function initdist(connections)
    dist = similar(connections, Int)
    dist .= MAX_DIST
    dist[connections] .= 1
    dist[diagind(dist,0)] .= 0
    return dist
end

# Calculate the length of shortest paths between all valves using the Floyd-
# Warshall algorithm.
function shortestpaths(connections)
    dist = initdist(connections)
    numvertices = axes(connections, 1)
    for k ∈ numvertices, i ∈ numvertices, j ∈ numvertices
        dist[i,j] = min(dist[i,j], dist[i,k] + dist[k,j])
    end
    return dist
end

# Convert the minimally processed input. Calculate the shortest distances
# between valves, remove all valves that are broken (pressure = 0), and return
# the distance from our starting location to all valves. The last is important
# because our starting location may be a broken valve.
function processdata(valvenums, pressures, linkages)
    connections = makeconnections(valvenums, linkages)
    distances = shortestpaths(connections) .+ 1
    start = distances[valvenums["AA"], :]
    keep = pressures .> 0
    return (pressures[keep], distances[keep, keep], start[keep])
end

"""
`readdata() -> (pressures, distances, start)`

Read problem input from "input.txt" and process it, returning a vector of
pressures released by the valves, the shortest path distances between valves
and the distance from our starting location to all the valves. Data is included
only for those valves that aren't broken.
"""
function readdata()
    lines = readlines("input.txt")
    valvenums = @_ lines                |>
        match.(r" ([A-Z]{2}) ", __)     |>
        only.(__)                       |>
        (__ .=> axes(__, 1))            |>
        Dict

    pressures = @_ lines                |>
        match.(r"(\d+)", __)            |>
        only.(__)                       |>
        parse.(Int, __)

    linkages = @_ lines                 |>
        eachmatch.(r"([A-Z]{2})", __)   |>
        collect.(__)                    |>
        map(_[2:end], __)               |>
        map(first.(_), __)

    return processdata(valvenums, pressures, linkages)
end