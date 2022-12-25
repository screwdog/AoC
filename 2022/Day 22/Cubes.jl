"""
Uses standard cubing terminology for the faces of a cube: naming
them Front, Back, Left, Right, Up, Down. The standard orientations
are F, B, L, R point towards U, U points towards B and D points
towards F.

That is, holding a cube in front of you, the side you see is F,
oriented the way you see it. Rotating the cube about the U/D axis
allows you to see L, B and R, all of which are correctly oriented.
Facing F, tilting the cube backwards so you can see U has it correctly
oriented, as does tilting it forwards so you can see D.
"""
const C_FRONT = 1
const C_BACK = 2
const C_LEFT = 3
const C_RIGHT = 4
const C_UP = 5
const C_DOWN = 6

"""
Represents the rotation necessary when moving from one face to
an adjacent one. If rot_i is the current facing on face i, and
rot_j is the correct facing when moving on to face j, then we
have:
    rot_j = rot_i + TRANSITION_NUMBERS[i,j]

Note, TRANSITION_NUMBERS[i,j] + TRANSITION_NUMBERS[j,i] ≡ 0 (mod 4)
"""
TRANSITION_NUMBERS = [
  # F B L R U D
    0 0 0 0 0 0; # F
    0 0 0 0 2 2; # B
    0 0 0 0 1 3; # L
    0 0 0 0 3 1; # R
    0 2 3 1 0 0; # U
    0 2 1 3 0 0  # D
]

const F_TOP = 1
const F_LEFT = 2
const F_ORIENTATION = 3

struct Cube
    faceSize::Int
    faces::Matrix{Int}
    transitions::Matrix{Int}
end
function Cube(board)
    fs = facesize(board)
    faces = fill(3, (3, 6))

    cubeNet = net(board)
    traverseNet!(board, cubeNet, faces)
    transitions = calcTransitions(faces)
    return Cube(fs, faces, transitions)
end
faceRange(c::Cube, face) = range.(c.faces[F_TOP:F_LEFT,face], length=c.faceSize)

"""
Calculate the size of each face of a cube represented by board
"""
facesize(board) = round(Int, √(count((≠)(BLANK), board)÷6))

netIndex2FaceTL(board, index) = facesize(board) .* (index .- 1) .+ 1
function netIndex2BoardRanges(board, index)
    topLeft = netIndex2FaceTL(board, index)
    range.(topLeft, topLeft .+ facesize(board) .- 1)
end

"""
Calculate a Matrix{Bool} representing where on the board represents
cube faces.
"""
function net(board)
    fs = facesize(board)
    cubeNet = fill(false, size(board).÷fs)
    for i ∈ axes(cubeNet,1), j ∈ axes(cubeNet,2)
        ranges = netIndex2BoardRanges(board, (i, j))
        cubeNet[i,j] = any((≠)(BLANK), board[ranges...])
    end
    return cubeNet
end

ADJACENT_FACE = [
  # R       D       L       U
    C_RIGHT C_DOWN  C_LEFT  C_UP;   # C_FRONT
    C_LEFT  C_DOWN  C_RIGHT C_UP;   # C_BACK
    C_FRONT C_DOWN  C_BACK  C_UP;   # C_LEFT
    C_BACK  C_DOWN  C_FRONT C_UP;   # C_RIGHT
    C_RIGHT C_FRONT C_LEFT  C_BACK; # C_UP
    C_RIGHT C_BACK  C_LEFT  C_FRONT # C_DOWN
]

"""
Traverse net and fill the face matrix. Need to calculate:
    1. top-left location of each face on the board => faces[[1,2],:]
    2. orientation of each face => faces[3,:]
"""
function traverseNet!(board, cubeNet, faces)
    visited = fill(false, axes(cubeNet))
    j = findfirst(cubeNet[1, :])
    i = 1
    queue = [(i,j,C_FRONT,0)]
    while !isempty(queue)
        i, j, face, prev = popfirst!(queue)
        visited[i,j] && continue
        visited[i,j] = true

        faces[F_TOP:F_LEFT, face] .= netIndex2FaceTL(board, (i,j))
        if prev == 0
            faces[F_ORIENTATION, face] = 3
        else
            faces[F_ORIENTATION, face] = mod(faces[F_ORIENTATION, prev] + TRANSITION_NUMBERS[prev, face], 4)
        end
        for direction ∈ RIGHT:UP
            possible = (i,j) .+ SHIFT[direction+1]
            all(possible .∈ axes(cubeNet)) || continue
            visited[possible...] && continue
            trueExitDirection = mod(direction + faces[F_ORIENTATION, face] + 1, 4)
            newFace = ADJACENT_FACE[face, trueExitDirection+1]
            cubeNet[possible...] && push!(queue, (possible..., newFace, face))
        end
    end
    return faces
end

"""
Given the orientations of each face, calculate the transition rotations
between adjacent faces.
"""
function calcTransitions(faces)
    transitions = zeros(Int, (6, 6))
    for i ∈ 1:5, j ∈ i+1:6
        j ∈ ADJACENT_FACE[i, :] || continue
        transitions[i,j] = mod(faces[F_ORIENTATION, i] - faces[F_ORIENTATION, j] + TRANSITION_NUMBERS[i,j], 4)
    end
    for i ∈ 2:6, j ∈ 1:i-1
        transitions[i,j] = mod(-transitions[j,i], 4)
    end
    return transitions
end

ROTATIONS = Dict([
    0 => [ 1  0;  0  1],
    1 => [ 0  1; -1  0],
    2 => [-1  0;  0 -1],
    3 => [ 0 -1;  1  0]
])
TRANSLATIONS = Dict([
    0 => [0, 0],
    1 => [0, 1],
    2 => [1, 1],
    3 => [1, 0]
])

correctDirection(c::Cube, relDir, face) = mod(relDir + c.faces[F_ORIENTATION, face] + 1, 4)

"""
Rotate relPos to match the given facing.

relPos is in (1:n, 1:n) where a cube face is nxn. facing is the number
of 90 degree clockwise turns to make
"""
function rot(c::Cube, relPos, facing)
    return ((ROTATIONS[facing] * [relPos...] + (c.faceSize + 1) * TRANSLATIONS[facing])...,)
end

"""
Return which face of cube the given location is on
"""
findFace(cube, location) = findfirst(f -> all(location .∈ faceRange(cube, f)), C_FRONT:C_DOWN)

"""
Convert a board position location into a relative position on
a face of a cube.
"""
toRel(c::Cube, location) = mod1.(location, c.faceSize)

"""
Convert a relative position on a face of a cube to the equivalent
board location.
"""
toLoc(c::Cube, relPos, face) = c.faces[F_TOP:F_LEFT, face] .+ relPos .- 1

"""
Translate given location (which is blank) and direction into the
correct location and direction on the board - using the Cube data
"""
function movetoface(c::Cube, location, direction, from, to)
    relPos = toRel(c, location)
    δfacing = c.transitions[from, to]
    relPos = rot(c, relPos, δfacing)
    newLocation = toLoc(c, relPos, to)
    newDir = mod(direction + δfacing, 4)
    return (newLocation, newDir)
end

makeCube(board, path) = (Cube(board), board, path)
makeCube(t) = makeCube(t...)