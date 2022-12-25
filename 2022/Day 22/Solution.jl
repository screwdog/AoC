using Underscores
using LinearAlgebra
const BLANK = ' '
const OPEN = '.'
const WALL = '#'

const RIGHT = 0
const DOWN = 1
const LEFT = 2
const UP = 3

SHIFT = [(0,1), (1,0), (0,-1), (-1,0)]
INV_SHIFT = Dict([
    (0,1) => 0,
    (1,0) => 1,
    (0,-1) => 2,
    (-1,0) => 3
])

include("Cubes.jl")

const START_DIRECTION = RIGHT

abstract type PathNode end
struct MoveNode <: PathNode
    distance::Int
end
MoveNode(text) = MoveNode(parse(Int, text))
struct TurnNode <: PathNode
    left::Bool
end
TurnNode(text) = TurnNode(text == "L")
node(text) = text ∈ ["L", "R"] ? TurnNode(text) : MoveNode(text)

function readdata(filename)
    lines = readlines(filename)
    return (lines[1:end-2], lines[end])
end

function makeBoard(boardData)
    n = length(boardData)
    m = maximum(length, boardData)

    board = fill(BLANK, n, m)
    for i ∈ axes(boardData,1), j ∈ 1:length(boardData[i])
        board[i,j] = boardData[i][j]
    end
    return board
end

function makePath(pathData)
    @_ eachmatch(r"(\d+|[L,R])", pathData)  |>
        first.(__)                          |>
        node.(__)
end

processData(boardData, pathData) = (makeBoard(boardData), makePath(pathData))
processData(t::Tuple) = processData(first(t), last(t))

wrap(board, location) = mod1.(location, size(board))
isblank(board, location) = board[location...] == BLANK
moveforward(location, direction) = location .+ SHIFT[direction+1]

function nextLocation(::Nothing, board, location, direction)
    newLocation = wrap(board, moveforward(location, direction))
    while isblank(board, newLocation)
        newLocation = wrap(board, moveforward(newLocation, direction))
    end
    return (newLocation, direction)
end

function nextLocation(c::Cube, board, location, direction)
    newLocation = moveforward(location, direction)
    all(newLocation .∈ axes(board)) && !isblank(board, newLocation) && return (newLocation, direction)
    currFace = findFace(c, location)
    newFace = ADJACENT_FACE[currFace, correctDirection(c, direction, currFace) + 1]
    return movetoface(c, newLocation, direction, currFace, newFace)
end
isblocked(cube, board, location, direction) = board[nextLocation(cube, board, location, direction)[1]...] == WALL

function move(cube, board, location, direction, steps)
    newLocation, newDirection = location, direction
    n = steps
    while !isblocked(cube, board, newLocation, newDirection) && n > 0
        newLocation, newDirection = nextLocation(cube, board, newLocation, newDirection)
        n -= 1
    end
    return (newLocation, newDirection)
end
turn(facing, L) = mod(facing + (L ? -1 : 1), 4)
followNode(cube, board, location, direction, m::MoveNode) = move(cube, board, location, direction, m.distance)
followNode(cube, board, location, direction, t::TurnNode) = (location, turn(direction, t.left))

start(board) = ((1, findfirst((==)(OPEN), board[1, :])), START_DIRECTION)

function followPath(cube, board, path)
    location, direction = start(board)
    for node ∈ path
        location, direction = followNode(cube, board, location, direction, node)
    end
    return (location, direction)
end
followPath(board, path) = followPath(nothing, board, path)
followPath(t) = followPath(t...)

password(location, direction) = (1000, 4) ⋅ location + direction
password(t) = password(t...)

function day22(part2, test=false)
    data = (test ? "test.txt" : "input.txt")   |>
        readdata                        |>
        processData                     |>
        (part2 ? makeCube : identity)   |>
        followPath                      |>
        password
end

day22.(false:true)