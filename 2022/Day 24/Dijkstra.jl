const MAX_DIST = 10_000

wrap(p::Point, v) = mod1(p, size(v))
wrapTime(p::Point, v) = Point(p.i, p.j, mod1(p.k, size(v, 3)))

startLocation(valley, startTime=1) = wrapTime(Point(1,1,0) + Point(0,0,startTime), valley)
finishLocation(valley, startTime=1) = wrapTime(Point(size(valley)) + Point(0,0,startTime), valley)
function setupStart!(valley, distances, start)
    queue = Point[]
    for t ∈ 1:size(valley, 3)
        p = wrapTime(start + Point(0,0,t), valley)
        valley[coords(p)...] && continue
        distances[coords(p)...] = t
        push!(queue, p)
    end
    return queue
end

dequeue!(queue) = popfirst!(queue)
function enqueue!(distances, queue, location)
    function lessthan(u, v)
        distances[coords(u)...] < distances[coords(v)...] && return true
        distances[coords(u)...] > distances[coords(v)...] && return false
        return (u.i, u.j) < (v.i, v.j)
    end

    insorted(location, queue, lt=lessthan) && return
    i = searchsortedfirst(queue, location, lt=lessthan)
    insert!(queue, i, location)
end
function update!(distances, queue, location, newDistance)
    distances[coords(location)...] = newDistance
    location ∉ queue && return
    filter!((≠)(location), queue)
    enqueue!(distances, queue, location)
end

function _calcDistances!(valley, distances, start, finish)
    visited = fill(false, size(valley))
    queue = setupStart!(valley, distances, start)

    while !isempty(queue)
        location = dequeue!(queue)
        visited[coords(location)...] && continue
        visited[coords(location)...] = true
        sameLocation(location, finish) && return distances

        newDist = distances[coords(location)...] + 1

        neighbours = location .+ NEIGHBOURS
        filter!(p -> p.i ∈ axes(valley, 1) && p.j ∈ axes(valley, 2), neighbours)
        neighbours = wrap.(neighbours, Ref(valley))
        filter!(p -> !valley[coords(p)...], neighbours)
        for neighbour ∈ neighbours
            newDist < distances[coords(neighbour)...] && update!(distances, queue, neighbour, newDist)
            enqueue!(distances, queue, neighbour)
        end
    end
end

shortestTime(distances, finish) = minimum(distances[finish.i, finish.j, :])

function shortestPath(valley, startTime=1, rev=false)
    distances = fill(MAX_DIST, size(valley))
    start = startLocation(valley, startTime)
    finish = finishLocation(valley, startTime)
    rev && ((start, finish) = (finish, start))

    _calcDistances!(valley, distances, start, finish)
    return shortestTime(distances, finish) + 1
end

function shortestPaths(valley)
    currTime = shortestPath(valley)
    currTime += shortestPath(valley, currTime, true)
    currTime += shortestPath(valley, currTime)
    return currTime - 1
end