"""
`Turn(n::Int)`

Represents a clockwise turn of `n` multiples of 90°. For convenience, constants
`◌`, `↷`, `↻`, and `↶` are turns of 0°, 90°, 180°, and 270°, respectively.
"""
struct Turn
    δ::Int
    # inner constructor ensures 0 ≤ δ < 4
    Turn(x::Int) = new(mod(x, 4))
end
Turn(s::Symbol) = Turn(string(s))
function Turn(str::AbstractString)
    STR = uppercase(str)
    STR ∈ [" ", "NONE"] && return Turn(0)
    STR ∈ ["R", "RIGHT"] && return Turn(1)
    STR ∈ ["180", "U"] && return Turn(2)
    STR ∈ ["L", "LEFT"] && return Turn(3)
    return nothing
end
Base.:+(a::Turn, b::Turn) = Turn(a.δ + b.δ)
Base.:-(t::Turn) = Turn(-t.δ)
Base.:-(a::Turn, b::Turn) = a + (-b)
Base.:*(i::Integer, t::Turn) = Turn(i*t.δ)
Base.:*(t::Turn, i) = i*t

# since Turn is immutable and 0 ≤ δ < 4 there are literally only 4 different
# instances of Turn. Using Unicode chars helps somewhat with clarity and helps
# to differentiate them from Orientation.
const ◌ = Turn(:NONE)
const ↷ = Turn(:R)
const ↶ = Turn(:L)
const ↻ = Turn(:U)

"""
`Move(d::int)`

Represents a move of `d` steps forwards.
"""
struct Move
    d::Int
end
Move(str) = Move(parse(Int, str))
steps(m::Move) = m.d

"""
`Orientation(n::Int)`

Represents being oriented in one of the four cardinal directions, where `n` is
the number of clockwise quarter turns from north (ie north is `0`, east is `1`,
etc).

Constants `↑`, `→`, `↓`, and `←` are defined for convenience.
"""
struct Orientation
    facing::Int
    Orientation(x::Int) = new(mod(x, 4))
end
Orientation(s::Symbol) = Orientation(string(s))
function Orientation(str::AbstractString)
    STR = uppercase(str)
    STR ∈ ["U", "UP"] && return Orientation(0)
    STR ∈ ["R", "RIGHT"] && return Orientation(1)
    STR ∈ ["D", "DOWN"] && return Orientation(2)
    STR ∈ ["L", "LEFT"] && return Orientation(3)
    return nothing
end
# value is used to convert to an integer, for indexing into a matrix or
# calculating the password
value(o::Orientation) = o.facing + 1

# return a relative to b. This is used to calculate transitions between non-
# adjacent (as the board is lain out) cube faces.
relative(a::Orientation, b::Orientation) = Orientation(a.facing - b.facing)

# it makes sense to be able to combine orientations and turns. Note that
# subtracting orientations gives a turn, in contrast to `relative`.
Base.:+(o::Orientation, t::Turn) = Orientation(o.facing + t.δ)
Base.:+(t::Turn, o::Orientation) = o + t
Base.:-(o::Orientation, t::Turn) = o + (-t)
Base.:-(a::Orientation, b::Orientation) = Turn(a.facing - b.facing)

const ↑ = Orientation(:U)
const → = Orientation(:R)
const ↓ = Orientation(:D)
const ← = Orientation(:L)

# change in coordinates when moving a particular direction
δx(o::Orientation) = [0, 1, 0, -1][value(o)]
δy(o::Orientation) = [-1, 0, 1, 0][value(o)]

"""
`BoardPos(x, y, facing)`

Represents a position on the board (either treated as a flat board or as a
folded cube).

It is also usable as a _relative_ position - relative to a `Net`. 
"""
struct BoardPos
    x::Int
    y::Int
    facing::Orientation
end
BoardPos(x) = BoardPos(x, 1, →)
facing(p::BoardPos) = p.facing
Base.:+(p::BoardPos, itr) = BoardPos(
    p.x + first(itr), p.y + last(itr), p.facing
)
Base.:+(itr, p::BoardPos) = p + itr

⋅(a, b) = mapreduce(prod, +, zip(a, b))

# this is used to make `password` better match its expected form (row, column)
# order and having Orientation numbered from 0 facing right to 3 facing up.
⋅(itr, p::BoardPos) = itr ⋅ (p.y, p.x, mod(value(p.facing) - 2, 4))

# naive step in the direction of `facing`, without regard to the board/cube.
step(p::BoardPos) = BoardPos(p.x + δx(p.facing), p.y + δy(p.facing), p.facing)

# these methods are intended for *relative* positions. That is, where x,y are
# relative to some face (net). This way we don't need to normalise them to be
# within a particular range as when we convert them to be on a new face later
# we can just use mod.

# since x,y are 1-based, whenever we invert one we need to +1.
rotr90(p::BoardPos) = BoardPos(1 - p.y, p.x, p.facing + ↷)
rotl90(p::BoardPos) = BoardPos(p.y, 1 - p.x, p.facing + ↶)
rot180(p::BoardPos) = BoardPos(1 - p.x, 1 - p.y, p.facing + ↻)
const ROTATIONS = Dict(
    (◌) => identity,
    (↷) => rotr90,
    (↻) => rot180,
    (↶) => rotl90
)
rotate(p::BoardPos, t::Turn) = ROTATIONS[t](p)

const BOARD_ABYSS = ' '
const BOARD_EMPTY = '.'
const BOARD_WALL = '#'

"""
`Board(chars) <: AbstractMatrix{Char}`

A flat 2D board, represented as `Char`s.
"""
struct Board <: AbstractMatrix{Char}
    data::Matrix{Char}
    start::BoardPos
end
function Board(chars::Matrix{Char})
    startx = findfirst((==)(BOARD_EMPTY), chars[:,1])
    return Board(chars, BoardPos(startx))
end
start(b::Board) = b.start
Base.IndexStyle(::Board) = IndexLinear()
Base.size(b::Board) = size(b.data)
Base.getindex(b::Board, i) = b.data[i]
Base.getindex(b::Board, p::BoardPos) = b[p.x, p.y]
Base.checkbounds(::Type{Bool}, b::Board, p::BoardPos) =
    checkbounds(Bool, b, p.x, p.y)

isabyss(b::Board, p::BoardPos) = b[p] == BOARD_ABYSS
iswall(b::Board, p::BoardPos) = b[p] == BOARD_WALL

function wrap(b::Board, p::BoardPos)
    checkbounds(Bool, b, p) && return p
    return BoardPos(mod(p.x, axes(b, 1)), mod(p.y, axes(b, 2)), p.facing)
end

# step and wrap around the board as necessary. We check for the presence of
# walls elsewhere (as that process is the same for both boards and cubes).
function step(b::Board, p::BoardPos)
    newpos = wrap(b, step(p))
    while isabyss(b, newpos)
        newpos = wrap(b, step(newpos))
    end
    return newpos
end

# functions to read the input
function instruction(str)
    all(isdigit, str) && return Move(str)
    all(!isdigit, str) && return Turn(str)
    return nothing
end

function path(str)
    cs = eachmatch(r"(\d+|\D+)", str)
    return instruction.(only.(cs))
end

function board(lines)
    # not all lines in the input are equal length so add spaces to short ones
    len = maximum(length, lines)
    strs = rpad.(lines, len, ' ')
    chars = hcat(collect.(strs)...)
    return Board(chars)
end

function readinput(test=false)
    lines = readlines(test ? "test.txt" : "input.txt")
    boardlines = lines[1:end-2]
    pathline = lines[end]

    return path(pathline), board(boardlines)
end
