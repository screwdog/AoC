BLIZZARD_CHARS = "^>v<"
const D_UP = 1
const D_RIGHT = 2
const D_DOWN = 3
const D_LEFT = 4

struct Point
    i::Int
    j::Int
    k::Int
end
Point(itr) = Point(itr...)
Base.:+(u::Point, v::Point) = Point(u.i + v.i, u.j + v.j, u.k + v.k)
Base.:-(u::Point) = Point(-u.i, -u.j, -u.k)
Base.:-(u::Point, v::Point) = Point(u.i - v.i, u.j - v.j, u.k - v.k)
Base.:*(n, p::Point) = Point(n*p.i, n*p.j, n*p.k)
Base.mod1(p::Point, t) = Point(mod1.(coords(p), t))
coords(p::Point) = (p.i, p.j, p.k)
Base.broadcastable(p::Point) = Ref(p)

sameLocation(u, v) = u.i == v.i && u.j == v.j

NEIGHBOURS = Point.([
    (-1,0,1), (0,1,1), (1,0,1), (0,-1,1), (0,0,1)
])

struct Blizzard
    i::Int
    j::Int
    direction::Int
end
Blizzard(i, j, c::Char) = Blizzard(i, j, findfirst(c, BLIZZARD_CHARS))

struct InputData
    width::Int
    height::Int
    blizzards::Vector{Blizzard}
end

function readdata(filename)
    lines = readlines(filename)
    height = length(lines)-2
    width = length(lines[1])-2
    blizzards = Blizzard[]
    for i ∈ 1:height
        js = findall((∈)(BLIZZARD_CHARS), lines[i+1])
        append!(blizzards, Blizzard.(i, js .- 1, collect(lines[i+1])[js]))
    end
    return InputData(width, height, blizzards)
end

function makeValley(data)
    depth = lcm(data.height, data.width)
    maxSize = (data.height, data.width, depth)
    valley = fill(false, maxSize)
    for blizzard ∈ data.blizzards
        start = Point(blizzard.i, blizzard.j, 1)
        for n ∈ 0:depth-1
            nextPoint = mod1(start + n*NEIGHBOURS[blizzard.direction], maxSize)
            valley[coords(nextPoint)...] = true
        end
    end
    return valley
end

include("Dijkstra.jl")

function day24(part2, test=false)
    valley = (test ? "test.txt" : "input.txt")           |>
        readdata                                |>
        makeValley                              |>
        (part2 ? shortestPaths : shortestPath)
end
day24.(false:true)