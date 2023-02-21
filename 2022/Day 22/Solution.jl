# Part 1 implements a number of custom types:
#   * Turn, Move to represent the different instructions in the path. Turn is
#     also used in part 2 to represent changes in orientation of cube faces.
#   * Orientation to represent a particular facing when traversing the path.
#     This is also used in part 2 to represent the orientation of the different
#     cube faces.
#   * BoardPos represents a position and facing on the board.
#   * Board represents the 2D board that we are traversing in part 1.

# The solution to part 2 is fully generic and modular. Custom types used are:
#   * Net to represent those portions of a Board that contain walls/ground. That
#     is, the parts that form a net that can be folded into a cube, as well as
#     the size of each size.
#   * Face to encapsulate the name and orientation of each cube face, once
#     assigned. Faces are named U, D, L, R, F, and B and have canonical
#     orientations assigned to them.
#   * Tracing to represent the folding of the cube by assigning a name and
#     orientation to each face in a Net. Tracing contains the topographic
#     information to allow for calculating which face, and in which orientation
#     we move to when leaving a face.
#   * Cube to encapsulate a Board, Net, and Tracing. This is sufficient to allow
#     for traversal following a path.

module Day22
export Turn, Move, Orientation, BoardPos, Board
export ◌, ↷, ↻, ↶, ↑, →, ↓, ←
export Net, Face, Tracing, Cube, trace, printboard
export readinput, doinstruction!, password

include("part1.jl")
include("part2.jl")
include("display.jl")

# these methods are generic for both Board and Cube arguments
doinstruction!(boardorcube, p::BoardPos, t::Turn) =
    BoardPos(p.x, p.y, p.facing + t)
function doinstruction!(boardorcube, position, m::Move)
    for _ ∈ 1:steps(m)
        iswall(boardorcube, step(boardorcube, position)) && break
        position = step(boardorcube, position)
    end
    return position
end

password(location) = (1000, 4, 1) ⋅ location

"""
`day22(part2) -> Int`

Solve Advent of Code 2022, day 22, reading the input data from "input.txt". That
is, returns the password determined by the final position on the board from
following a path across the board given by a sequence of instructions. Treats
the board either as a flat 2D board and wrapping at the edges (`part2 == false`,
which is the default) or as a cube shape (`part2 == true`).
"""
function day22(part2=false)
    path, board = readinput()
    part2 && (board = Cube(board))
    location = start(board)
    for instruction ∈ path
        location = doinstruction!(board, location, instruction)
    end
    return password(location)
end
end;
Day22.day22.(false:true)
