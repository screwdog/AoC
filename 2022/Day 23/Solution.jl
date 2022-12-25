ELF_CHAR = '#'
EMPTY_CHAR = '.'

struct Point
    x::Int
    y::Int
end
Point(itr) = Point(itr...)
getX(p::Point) = p.x
getY(p::Point) = p.y
Base.:+(u::Point,v::Point) = Point(u.x + v.x, u.y + v.y)
Base.:-(p::Point) = Point(-p.x, -p.y)
Base.:-(u::Point,v::Point) = Point(u.x - v.x, u.y - v.y)
Base.:*(n, p::Point) = Point(n*p.x, n*p.y)
Base.broadcastable(p::Point) = Ref(p)

const D_NW = 8; const D_N = 1;  const D_NE = 2
const D_W  = 7;                 const D_E  = 3
const D_SW = 6; const D_S = 5;  const D_SE = 4

NEIGHBOURS = [
    Point(0,-1), Point(1,-1), Point(1,0), Point(1,1),
    Point(0,1), Point(-1,1), Point(-1,0), Point(-1,-1)
]
LOOKS = [
    NEIGHBOURS[[D_NW, D_N, D_NE]],
    NEIGHBOURS[[D_SW, D_S, D_SE]],
    NEIGHBOURS[[D_NW, D_W, D_SW]],
    NEIGHBOURS[[D_NE, D_E, D_SE]]
]
MOVE_DIR = NEIGHBOURS[[D_N, D_S, D_W, D_E]]

function readdata(filename)
    elves = Set{Point}()
    open(filename) do file
        y = 1
        while !eof(file)
            line = readline(file)
            xs = findall((==)(ELF_CHAR), line)
            elves = elves ∪ Set(Point.(xs, y))
            y += 1
        end
    end
    return elves
end

neighbours(location) = location .+ NEIGHBOURS
noNeighbour(elves, location) = all(neighbours(location) .∉ Ref(elves))
look(location, direction) = location .+ LOOKS[direction]
canGo(elves, location, direction) = all(look(location, direction) .∉ Ref(elves))
getDirections(startDir) = mod1.(startDir .+ collect(0:3), 4)
function proposedMove(elves, elf::Point, directions)
    noNeighbour(elves, elf) && return elf
    for dir ∈ directions
        canGo(elves, elf, dir) && return elf + MOVE_DIR[dir]
    end
    return elf
end
function proposedMoves(elves::Set{Point}, startDir)
    directions = getDirections(startDir)
    proposed = Set{Point}()
    doubles = Set{Point}()
    for elf ∈ elves
        move = proposedMove(elves, elf, directions)
        move == elf && continue
        if move ∉ proposed
            proposed = proposed ∪ [move]
        else
            doubles = doubles ∪ [move]
        end
    end
    return setdiff(proposed, doubles)
end

function doMoves(elves, startDir, proposed)
    directions = getDirections(startDir)
    newElves = Set{Point}()
    for elf ∈ elves
        move = proposedMove(elves, elf, directions)
        if move ∈ proposed
            newElves = newElves ∪ [move]
        else
            newElves = newElves ∪ [elf]
        end
    end
    return newElves
end

function doRound(elves, startDir)
    proposed = proposedMoves(elves, startDir)
    return doMoves(elves, startDir, proposed)
end

function doRounds(elves, nrounds=10, startDir=1)
    for round ∈ 0:nrounds-1
        elves = doRound(elves, mod1(startDir + round, 4))
    end
    return elves
end

#TODO: refactor this to improve performance. Currently only manages
#   ~6.8 rounds per second
function findEquilibrium(elves)
    MAX_ITER = 10_000
    for round ∈ 1:MAX_ITER
        newElves = doRound(elves, mod1(round, 4))
        newElves == elves && return round
        elves = newElves
    end
    return -1
end

_getRange(elves, f) = range(extrema(f.(elves))...)
xRange(elves) = _getRange(elves, getX)
yRange(elves) = _getRange(elves, getY)
width(elves) = length(xRange(elves))
height(elves) = length(yRange(elves))

function printElves(elves)
    grid = fill(EMPTY_CHAR, height(elves), width(elves))
    origin = Point(first.((xRange(elves), yRange(elves)))...) - Point(1,1)
    for elf ∈ elves
        gridIndex = elf - origin
        grid[getY(gridIndex), getX(gridIndex)] = ELF_CHAR
    end
    for i ∈ axes(grid, 1)
        println(join(grid[i, :]))
    end
end

countGround(elves) = width(elves) * height(elves) - length(elves)

function day23(part2, test=false)
    elves = (test ? "test.txt" : "input.txt") |> readdata                          
    part2 && return findEquilibrium(elves)
    elves |> doRounds |> countGround
end