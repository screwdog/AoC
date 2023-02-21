# calculate the size of each face if a board is folded as a cube. 
boardsize(b::Board) = Int(√(count(b .≠ BOARD_ABYSS)÷6))

"""
`Net(b::Board)`

Represents the geometry of the cube net represented by `b`. That is, the six
square regions in `b` that correspond to the faces of the cube when `b` is
folded.

Generally, cube faces in the net are expressed as `CartesianIndex`s.
"""
struct Net
    faces::BitMatrix
    facesize::Int
    function Net(b::Board)
        size = boardsize(b)
        faces = b[1:size:end, 1:size:end] .≠ BOARD_ABYSS
        return new(faces, size)
    end
end
# size represents the size of the _data_ in a net, used mainly when displaying
# the net
Base.size(n::Net) = size(n.faces)
Base.:∈(i, n::Net) = checkbounds(Bool, n.faces, i) && n.faces[i]
facesize(n::Net) = n.facesize

firstface(n::Net) = findfirst(n.faces)

const NEIGHBOURS = [
    (↑) => CartesianIndex( 0, -1),
    (→) => CartesianIndex( 1,  0),
    (↓) => CartesianIndex( 0,  1),
    (←) => CartesianIndex(-1,  0)
]

# returns all faces adjacent to face, as [dir => location, ...]
function adjfaces(n::Net, face)
    neighbours = []
    for (dir, location) ∈ NEIGHBOURS
        location + face ∈ n && push!(neighbours, dir => location + face)
    end
    return neighbours
end

# determine which face `p` is on in `n`
face(n::Net, p::BoardPos) =
    CartesianIndex(cld(p.x, n.facesize), cld(p.y, n.facesize))

# convert a position on the board into a position relative to the net. That is,
# consider the position relative to the face that it is on.
relpos(n::Net, p::BoardPos) =
    BoardPos(mod1(p.x, n.facesize), mod1(p.y, n.facesize), p.facing)

# p is a relative position, possibly with coords in range 1:facesize but also
# possibly outside of this range. Return the equivalent position on `face`.
function abspos(n::Net, face, p::BoardPos)
    x, y = Tuple(face)
    return BoardPos(
        (x - 1) * n.facesize + mod1(p.x, n.facesize),
        (y - 1) * n.facesize + mod1(p.y, n.facesize),
        p.facing
    )
end

# Tracing assigns a name and orientation to the faces of a cube. These are based
# on the canonical names and orientations used in the Rubik's cube community. In
# particular, we name them U ("up"), D ("down"), L ("left"), R ("right"), F
# ("front"), and B ("back").

# In addition, we need a canonical orientation for each face and we base this
# on the orientations used by some when solving a cube blindfolded - L, R, F, B
# are all oriented so their up directions are towards U. U is oriented away from
# F (so if you are holding a cube and looking at F, tilting the top slightly
# towards you will reveal U in its correct orientation). D is oriented towards F
# (so if you are again looking at F, tilting the bottom slightly towards you
# will reveal D in correct orientation).

# For example, here's a tracing with all faces oriented upwards:
#   ┌──┐      
#   │U↑│
#┌──┼──┼──┬──┐
#│L↑│F↑│R↑│B↑│
#└──┼──┼──┴──┘
#   │D↑│
#   └──┘

# In general, not all faces will be oriented upwards when a net is traced so we
# need to keep track of this to ensure that when leaving a face we enter the
# correct face at the correct position and with the correct orientation.

@enum FaceName U=1 D=2 L=3 R=4 F=5 B=6

# TRANSITION[face, direction] = (newface, δdir)
# Leaving `face` heading in `direction` (relative to face's orientation) results
# in entering `newface` with direction changed by `δdir`.

# This also means that if `face` has another face adjacent in `direction`
# (relative to its orientation), in the net, then that face is `newface` and its
# orientation is shifted by `δdir`.

# For example, if a net has two faces: [D←, ?] then ? is to the right, but
# relative to D's orientation (←) it is actually ↓ from D. So, TRANSITIONS[D, ↓]
# gives (B, ↻), which tells us that the new face is B, and the orientation is
# D's orientation (←) shifted by ↻: ← + ↻ = →. So the Tracing is [D←, B→]

# This logic is implemented in the Face(::Orientation, ::Face) constructor
const TRANSITIONS = [
#   ↑       →      ↓      ←                 ⇐ moving in this direction
    (B, ↻) (R, ↶) (F, ◌) (L, ↷); # U
    (F, ◌) (R, ↷) (B, ↻) (L, ↶); # D
    (U, ↶) (F, ◌) (D, ↷) (B, ◌); # L       ⇐ from this face
    (U, ↷) (B, ◌) (D, ↶) (F, ◌); # R
    (U, ◌) (R, ◌) (D, ◌) (L, ◌); # F
    (U, ↻) (L, ◌) (D, ↻) (R, ◌)  # B
]
transition(n::FaceName, o::Orientation) = TRANSITIONS[Int(n), value(o)]

"""
`Face(dir, from)`

Represents a face of a cube. The constructor takes as an argument a face `from`
and a direction `dir` from that face and returns a `Face` representing the face
that is directly adjacent in that direction and with the correct orientation.

Note that `dir` is an absolute direction (ie based on the board or net) rather
than relative to `from`.
"""
struct Face
    n::FaceName
    o::Orientation
end
function Face(dir::Orientation, from::Face)
    # transitions are specified in terms of relative direction from a face
    reldir = relative(dir, from.o)
    newface, δor = transition(from.n, reldir)
    newor = from.o + δor
    return Face(newface, newor)
end
Face(p::Pair) = Face(p...)
name(f::Face) = f.n
# treat Face as scalar for broadcasting
Base.broadcastable(f::Face) = Ref(f)

transition(f::Face, o::Orientation) = transition(f.n, o)

const MaybeFace = Union{Nothing, Face}
# Tracing is an assignment of faces and orientations to a Net. That is, a Net
# specifies where on the board each square face is but a Tracing specifies which
# one corresponds to the Up face of the cube and its orientation relative to the
# standard orientations. Construction of a Tracing is, roughly, equivalent to
# folding a net into a cube.

"""
`Tracing`

Represents the association with locations in a `Net` with a particular Face (ie
a named cube face with orientation of embedding). This is sufficient information
to determine, when moving off a face into an empty area of the board, which face
we move to and the resulting orientation.
"""
struct Tracing <: AbstractMatrix{MaybeFace}
    # Tracing is structurally similar to a sparse matrix, holding only the six
    # faces and not the blank areas.
    faces::Dict{CartesianIndex{2}, Face}
end
# functions to implement the AbstractMatrix interface
_max(t::Tracing) = maximum(keys(t.faces))
Base.size(t::Tracing) = Tuple(_max(t))
function Base.getindex(t::Tracing, i)
    @boundscheck i ∈ (CartesianIndex(1,1):_max(t)) || throw(BoundsError(t, i))
    return haskey(t.faces, i) ? t.faces[i] : nothing
end
Base.getindex(t::Tracing, i, j) = t[CartesianIndex(i, j)]

# return location (as CartesianIndex) of the given face
findface(t::Tracing, face::FaceName) = findfirst(f -> name(f) == face, t.faces)

# arbitrarily assign the first face as U↑. All tracings of the same net are
# isomorphic but given the first face is the top-left-most in the net this is
# most "natural".
function addfirst!(faces, face)
    faces[face] = Face(U, ↑)
end

# given neighbour == (dir => location) and the face it is adjacent to as oldface
# we convert this into (location, dir => oldface) for enqueing. This makes the
# subsequent processing easier as it will be:
#   (face to process, dir came from => face came from)
function queueable(neighbour, oldface)
    dir, location = neighbour
    return (location, dir => oldface)
end

# enqueue all neighbours of `face` which is at `faceloc`. Note: `adjfaces`
# only returns neighbours that actually exist in the net so we don't need to
# filter here.
function addneighbours!(queue, n::Net, faceloc, face)
    neighbours = adjfaces(n, faceloc)
    append!(queue, queueable.(neighbours, face))
    return queue
end
addneighbours!(n::Net, faceloc, face) = addneighbours!([], n, faceloc, face)

"""
`trace(n::Net) -> Tracing`

Create a tracing of the given net, returning a `Tracing` representing the cube
as it would be folded.
"""
function trace(n::Net)
    # we do a BFS of the net, adding each face in turn. A valid net will always
    # be traced to a valid Tracing.
    faces = Dict{CartesianIndex{2}, MaybeFace}()
    visited = falses(size(n))

    u = firstface(n)
    addfirst!(faces, u)
    visited[u] = true
    queue = addneighbours!(n, u, faces[u])

    while !isempty(queue)
        face, from = popfirst!(queue)
        visited[face] && continue
        visited[face] = true

        # Face(from) does the calculation of which face and orientation the new
        # face should have based on how it was reached
        faces[face] = Face(from)
        addneighbours!(queue, n, face, faces[face])
    end
    return Tracing(faces)
end

"""
`Cube(b::Board)`

Represents a cube based on folding `b` as if it were a net for a cube.
"""
struct Cube
    board::Board
    net::Net
    tracing::Tracing
end
Cube(b::Board) = (n = Net(b); return Cube(b, n, trace(n)))

# implement Cube counterparts to Board methods for the solution process
start(c::Cube) = start(c.board)
Base.checkbounds(::Type{Bool}, c::Cube, p::BoardPos) = checkbounds(Bool, c.board, p)

isabyss(c::Cube, p::BoardPos) = isabyss(c.board, p)
iswall(c::Cube, p::BoardPos) = iswall(c.board, p)

function step(c::Cube, p::BoardPos)
    newpos = step(p)
    checkbounds(Bool, c.board, newpos) && !isabyss(c, newpos) &&
        return newpos
    from = c.tracing[face(c.net, p)]
    return shift(c, from, newpos)
end

# for a position `p` that is not on a face (ie is out of bounds or is on a
# blank square), if it stepped off the face `from`, return the
# equivalent position on the new face.

# That is, calculate the correct next position on the board when stepping off a
# face, treating the board as a cubic net.
function shift(c::Cube, from::Face, p::BoardPos)
    # find the position relative to the net
    rel = relpos(c.net, p)
    # determine the correct face, and the change in orientation required
    to, turn = transition(from, relative(p.facing, from.o))
    # find the location (in the net/tracing) of the new face
    newface = findface(c.tracing, to)
    # rotate the relative position to the correct orientation for the new face
    rotated = rotate(rel, (c.tracing[newface].o - from.o) - turn)
    # shift it so it's on the new face, as required
    return abspos(c.net, newface, rotated)
end
