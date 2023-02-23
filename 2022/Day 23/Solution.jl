module Day23
using Underscores

# simple 2D location structure
struct Elf
    x::Int
    y::Int
end
Elf(itr) = Elf(itr...)
Elf(c::CartesianIndex) = Elf(Tuple(c))
x(e::Elf) = e.x
y(e::Elf) = e.y

# arithmetic to make calculating movements easier
Base.:+(a::Elf, b::Elf) = Elf(a.x + b.x, a.y + b.y)
Base.:-(a::Elf, b::Elf) = Elf(a.x - b.x, a.y - b.y)
Base.:*(n::Integer, e::Elf) = Elf(n*e.x, n*e.y)

function readinput()
    return @_ "input.txt"   |>
        readlines           |>
        collect.(__)        |>
        hcat(__...)         |>
        # findall returns [CartesianIndex...]
        findall(__ .== '#') |>
        Elf.(__)            |>
        Set{Elf}
end

# for part 2, max iterations while waiting for equilibrium
const MAX_ROUNDS = 10_000

const NW = Elf(-1, -1); const N = Elf(0, -1); const NE = Elf(1, -1);
const  W = Elf(-1,  0);                       const  E = Elf(1,  0);
const SW = Elf(-1,  1); const S = Elf(0,  1); const SE = Elf(1,  1);

const NEIGHBOURS = [NW, N, NE, W, E, SW, S, SE]
const LOOKS = [
    [NW, N, NE] => N,
    [SW, S, SE] => S,
    [NW, W, SW] => W,
    [NE, E, SE] => E
]

# efficient checking if any elves in [directions...]
function anydirection(elves, elf, directions)
    for direction ∈ directions
        elf + direction ∈ elves && return true
    end
    return false
end

# calculate where elf proposes to move to
function propose(elves, elf, rnd)
    !anydirection(elves, elf, NEIGHBOURS) && return elf
    for i ∈ 0:3
        # use round number (rnd) to cycle the order of directions to check
        look, to = LOOKS[mod1(rnd + i, 4)]
        if !anydirection(elves, elf, look)
            return elf + to
        end
    end
    return elf
end

# The only way that multiple elves can propose to move to the same location is
# when they are exactly two squares apart and moving in opposite directions.
# That is, something like e_e or similarly vertically. This means that instead
# of implementing the two-step process described in the puzzle, we can instead
# just move each elf into their proposed location in the new vector and then if
# another elf later wants to move their we can just push the first elf back.
# This avoids much of the complexity of the 2nd half of the round.
function doround!(elves, moves, rnd)
    # count how many elves have moved in order to detect when none move
    steps = 0
    for elf ∈ elves
        move = propose(elves, elf, rnd)
        if move ∉ moves
            push!(moves, move)
            elf ≠ move && (steps += 1)
        else
            # conflicting proposed moves so undo previous move
            push!(moves, elf)
            delete!(moves, move)
            # since we are at `elf` and want to move to `move`, which has an
            # elf already proposing to move there, then they must have started
            # at: (move - elf) + move = 2move - elf = 2(move - elf) + elf
            push!(moves, 2*move - elf)
            # don't count the other elf's previously counted move
            steps -= 1
        end
    end
    return steps == 0
end

# count number of empty spaces in smallest rectangle containing all elves
function countempty(elves)
    xs = range(extrema(x, elves)...)
    ys = range(extrema(y, elves)...)
    return length(xs) * length(ys) - length(elves)
end

"""
`day23(part2) -> Int`

Solve Advent of Code 2022, day 23, reading input from "input.txt". That is,
either calculate the number of empty spaces in the smallest rectangle containing
all elves (if `part2 == false`), or the first round where no elves move (if
`part2 == true`).
"""
function day23(part2=false)
    elves = readinput()
    moves = Set{Elf}()
    for rnd ∈ 1:(!part2 ? 10 : MAX_ROUNDS)
        equilibrium = doround!(elves, moves, rnd)
        part2 && equilibrium && return rnd
        # reuse elves, moves to avoid unnecessary allocations
        empty!(elves)
        elves, moves = moves, elves
    end
    return countempty(elves)
end
end;
Day23.day23.(false:true)
