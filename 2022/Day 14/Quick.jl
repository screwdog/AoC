"""
Quick.jl
========

This is my initial attempt at solving the puzzle, under time constraints at the
time of release. It does not necessarily reflect good coding practices.
"""

allCoords(str) = eachmatch(r"(?:(\d+),(\d+))", str)

function addPath!(cave, topleft, p1, p2)
    if p1[1] == p2[1]
        x = p1[1]
        for y ∈ p1[2]:sign(p2[2]-p1[2]):p2[2]
            i, j = [x, y] - topleft
            cave[i,j] = 1
        end
    else
        y = p1[2]
        for x ∈ p1[1]:sign(p2[1]-p1[1]):p2[1]
            i, j = [x, y] - topleft
            cave[i,j] = 1
        end
    end
    return nothing
end

function parseLine!(line, cave, topleft)
    coordsAsStr = allCoords(line)
    coordsAsInt = map(c -> parse.(Int, c), coordsAsStr)
    lineSegs = hcat(coordsAsInt[1:end-1], coordsAsInt[2:end])
    for i ∈ axes(lineSegs, 1)
        addPath!(cave, topleft, lineSegs[i,1], lineSegs[i,2])
    end
    return nothing
end

function readdata(filename)
    SOURCE = [500, 0]
    dataAsString = read(filename, String)
    topleft, bottomright = SOURCE, SOURCE
    for coord in allCoords(dataAsString)
        x, y = parse.(Int, coord)
        topleft = min.(topleft, [x,y])
        bottomright = max.(bottomright, [x,y])
    end
    topleft = topleft .- [1,1]
    N, M = bottomright .- topleft
    cave = zeros(Int, N, M)

    lines = readlines(filename)
    for line ∈ lines
        parseLine!(line, cave, topleft)
    end
    return (cave, SOURCE .- topleft)
end

isabyss(cave, loc) = any(loc .∉ axes(cave))
function canMoveTo(cave, loc)
    isabyss(cave, loc) && return true
    return cave[loc...] == 0
end

function moveSand!(cave, loc)
    directions = [[0,1],[-1,1],[1,1]]
    atRest = false
    cave[loc...] = 3
    while !atRest
        moved = false
        for dir ∈ directions
            newLoc = loc + dir    
            if canMoveTo(cave, newLoc)
                cave[loc...] = 0
                if isabyss(cave, newLoc)
                    return newLoc
                else
                    cave[newLoc...] = 3
                end
                loc = newLoc
                moved = true
                break
            end
        end
        moved || (atRest = true)
    end
    return loc
end

function dropSand!(cave, source, numDrops=1)
    for _ ∈ 1:numDrops
        sandLoc = copy(source)
        moveSand!(cave, sandLoc)
    end
    return cave
end

function day14p1(test=false)
    MAX_DROPS = 10_000
    inputfile = test ? "test.txt" : "input.txt"
    cave, source = readdata(inputfile)

    for n ∈ 1:MAX_DROPS
        dropSand!(cave, source)
        count((==)(3), cave) == n || return n-1
    end
end
#day14p1(true)
#day14p1()

function day14p2(test=false)
    MAX_DROPS = 100_000
    inputfile = test ? "test.txt" : "input.txt"
    oldcave, source = readdata(inputfile)
    
    N, M = size(oldcave)
    newM = M + 2
    height = newM - source[2]
    newN = N + 2*height
    xShift = height

    source += [xShift, 0]
    cave = zeros(Int, newN, newM)
    for i ∈ axes(oldcave,1), j ∈ axes(oldcave,2)
        cave[i+xShift,j] = oldcave[i,j]
    end
    cave[:,end] .= 1

    for n ∈ 1:MAX_DROPS
        dropSand!(cave, source)
        cave[source...] ≠ 3 || return n
    end
    return cave
end
day14p2()