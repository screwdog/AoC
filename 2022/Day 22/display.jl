# Custom display methods for all types
# These aren't strictly necessary but help during development / debugging as
# these types are easier to work with in the REPL.

# since we've defined convenience constants, these are clear representations
# while also being valid Julia
Base.show(io::IO, t::Turn) = print(io, ['◌', '↷', '↻', '↶'][t.δ + 1])

Base.show(io::IO, ::MIME"text/plain", m::Move) = print(io, m.d)

# as with Turn, these are valid Julia and helpful representations
Base.show(io::IO, o::Orientation) = print(io, ['↑', '→', '↓', '←'][value(o)])

Base.show(io::IO, ::MIME"text/plain", p::BoardPos) =
    print(io, "($(p.x), $(p.y), $(p.facing))")

Base.show(io::IO, b::Board) = 
    print(io, "$(size(b)[1])x$(size(b)[2]) Board(start: $(b.start))")

#TODO: fix this to compact to fit screen space (using IOContext?)
function Base.show(io::IO, ::MIME"text/plain", b::Board)
    show(io, b)
    println(io, ":")
    printboard(io, b, start(b))
end

# print a Matrix{Char} as an unadorned block of characters
printmat(io::IO, g) = println.(io, join.(eachcol(g)))

function printboard(io::IO, b, p)
    newb = copy(b)
    c = repr(p.facing)
    newb[p.x, p.y] = only(c)
    printmat(io, newb)
end

# CORNERS[i] has a connector in direction d iff i has bit d set. That is, the
# final four bits of i indicate which connections are present.
const CORNERS = [
        #↑→↓← (little-endian)
' ',    #0000
'╵',    #1000
'╶',    #0100
'└',    #1100
'╷',    #0010
'│',    #1010
'┌',    #0110
'├',    #1110
'╴',    #0001
'┘',    #1001
'─',    #0101
'┴',    #1101
'┐',    #0011
'┤',    #1011
'┬',    #0111
'┼'     #1111
]

isline(chars, i) = checkbounds(Bool, chars, i) && chars[i] ≠ ' '

# return a Matrix{Char} with box chars drawing the grid represented by `b`. Each
# grid square is 3x4 chars.
function grid(b::BitMatrix)
    N, M = size(b)
    output = fill(' ', 3N+1, 2M+1)
    for x ∈ 1:N, y ∈ 1:M
        if b[x,y]
            output[[3x-2, 3x+1], 2y] .= '│'
            output[3x-1:3x, [2y-1, 2y+1]] .= '─'
        end
    end
    for x ∈ 1:N+1, y ∈ 1:M+1
        loc = CartesianIndex(3x-2,2y-1)
        pattern =   isline(output, loc + CartesianIndex( 0, -1)) +
                2 * isline(output, loc + CartesianIndex( 1,  0)) +
                4 * isline(output, loc + CartesianIndex( 0,  1)) +
                8 * isline(output, loc + CartesianIndex(-1,  0))
        output[loc] = CORNERS[pattern + 1]
    end
    return output
end

Base.show(io::IO, ::MIME"text/plain", n::Net) = printmat(io, grid(n.faces))

function Base.show(io::IO, ::MIME"text/plain", t::Tracing)
    net = .!isnothing.(collect(t))
    g = grid(net)
    for (location, face) ∈ t.faces
        chars = last.(repr.([face.n, face.o]))
        x, y = Tuple(location)
        g[CartesianIndices((3x-1:3x, 2y:2y))] .= chars
    end
    printmat(io, g)
end
