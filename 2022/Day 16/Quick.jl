"""
Quick.jl
========

This represents my initial attempts at solving the puzzle and doesn't reflect
good programming practice.
"""

using Underscores
include("Dijkstra.jl")

valveNum(name, valves) = valves[findfirst((==)(name), valves[:,2]), 1]

function line2valve!(line, i, valves)
    textitems = collect(first.(eachmatch(r"([A-Z]{2}|\d+)", line)))
    valves[i,2] = parse(Int, textitems[1], base=36)
    valves[i,3] = parse(Int, textitems[2])
    return valves
end

function line2connections!(line, valves, connections)
    textitems = collect(first.(eachmatch(r"([A-Z]{2})", line)))
    items = parse.(Int, textitems, base=36)
    n = valveNum(items[1], valves)
    for item ∈ items[2:end]
        m = valveNum(item, valves)
        connections[n,m] = true
        connections[m,n] = true
    end
    return connections
end

function readdata(filename)
    lines = readlines(filename)

    valves = zeros(Int, length(lines), 3)
    valves[:,1] = axes(valves,1)
    connections = fill(false, length(lines), length(lines))

    line2valve!.(lines, axes(valves,1), Ref(valves))
    line2connections!.(lines, Ref(valves), Ref(connections))

    return valves, connections
end

function mostPressure(start, valves, distances, maxTime, include)
    function possibleSteps(valvesOn, location, timeLeft)
        steps = filter(i -> valves[i,3] > 0, include)
        filter!(i -> !valvesOn[i], steps)
        filter!(i -> distances[location, i] < timeLeft, steps)
    end

    function doStep(step, valvesOn, path, location, timeLeft, pressure)
        newPath = copy(path)
        push!(newPath, step)
        newTimeLeft = timeLeft - distances[location, step] - 1
        newPressure = pressure + newTimeLeft*valves[step,3]
        newValvesOn = copy(valvesOn)
        newValvesOn[step] = true
        return (newValvesOn, newPath, step, newTimeLeft, newPressure)
    end

    function _mostPressure(valvesOn, path, location, timeLeft, pressure)
        steps = possibleSteps(valvesOn, location, timeLeft)
        isempty(steps) && return pressure
        maxPressure = pressure
        for step ∈ steps
            newPressure = _mostPressure(doStep(step, valvesOn, path, location, timeLeft, pressure)...)
                maxPressure = max(maxPressure, newPressure)
        end
        return maxPressure
    end

    return _mostPressure(fill(false, axes(valves,1)), Int[], start, maxTime, 0)
end
mostPressure(start, valves, distances) = mostPressure(start, valves, distances, 30, collect(axes(valves,1)))

function day16p1(test=false)
    inputfile = test ? "test.txt" : "input.txt"

    valves, connections = readdata(inputfile)
    start = valveNum(parse(Int, "AA", base=36), valves)
    distances = similar(connections, Int)
    distances = reduce(hcat, shortestpath!.(Ref(valves), Ref(connections), axes(valves,1), Ref(distances)))
 
    mostPressure(start, valves, distances)
end

function day16p2(test=false)
    inputfile = test ? "test.txt" : "input.txt"

    valves, connections = readdata(inputfile)
    start = valveNum(parse(Int, "AA", base=36), valves)
    distances = similar(connections, Int)
    distances = reduce(hcat, shortestpath!.(Ref(valves), Ref(connections), axes(valves,1), Ref(distances)))
 
    maxPressure = 0
    
    valveNums = filter(i -> valves[i,3] > 0, valves[:,1])
    numValves = size(valveNums,1)    
    for i ∈ 0:2^(numValves-1)
        count_ones(i) ≤ numValves÷2 || continue
        mySelect = @_ last(bitstring(i), numValves) |> collect |> map(c -> c == '1', __)
        elephantSelect = .!mySelect

        mySet = valveNums[mySelect]
        elephantSet = valveNums[elephantSelect]

        newPressure = mostPressure(start, valves, distances, 26, mySet) +
            mostPressure(start, valves, distances, 26, elephantSet)
        maxPressure = max(maxPressure, newPressure)
    end
    return maxPressure
end
@time day16p2()