module Day24
using Underscores

"""
`Blizzards <: AbstractMatrix{Bool}`

Represents the current state of all blizzards in the valley. `blizzard[x, y]`
returns whether at least one blizzard is in location `x, y` (ie can't be moved
into by the expedition).

To move all blizzards forward one time step use `next!(b::Blizzards)`.
"""
struct Blizzards <: AbstractMatrix{Bool}
    # blizzards is an n x m x 4 array. each slice corresponds to blizzards
    # moving in a different direction (see `direction(i)`).
    blizzards::BitArray{3}
    # circshift! can't be performed in-place so to avoid unnecessary allocations
    # we maintain a temporary buffer for reuse.
    temp::BitMatrix
    function Blizzards(blizzards::BitArray{3})
        new(blizzards, similar(blizzards[:,:,end]))
    end
end
Base.size(b::Blizzards) = size(b.blizzards[:,:,begin])

# use @view as without the creation of the temporary array for the slice is a
# significant performance impact.
Base.getindex(b::Blizzards, i, j) = any(@view b.blizzards[i, j, :])
direction(i) = [(0, -1), (1, 0), (0, 1), (-1, 0)][i]

# use circshift! to move each layer of blizzards in the correct direction. This
# automatically "spawns" a new blizzard when one leaves the other side.
function next!(b::Blizzards)
    for i ∈ axes(b.blizzards, 3)
        circshift!(b.temp, b.blizzards[:,:,i], direction(i))
        b.blizzards[:,:,i] .= b.temp
    end
    return b
end

"""
`Valley <: AbstractMatrix{Bool}`

Represents where in the valley the expedition can reach at the current time.
That is, `valley[x, y]` is whether that location could contain the expedition
at the current time, having moved there from the starting location.
"""
mutable struct Valley <: AbstractMatrix{Bool}
    locations::BitMatrix
    start::CartesianIndex{2}
    finish::CartesianIndex{2}
end
Valley(dims::Tuple, start, finish) = Valley(falses(dims), start, finish)
Base.size(v::Valley) = size(v.locations)
Base.getindex(v::Valley, i, j) = v.locations[i, j]
Base.setindex!(v::Valley, val, i, j) = v.locations[i, j] = val
isfinished(v::Valley) = v[v.finish]

# calculate locations for the expedition in the next time step, starting from
# `prev` and with the given blizzard locations
function next!(v::Valley, prev::Valley, blizzards::Blizzards)
    # extensive broadcasting and sub-matrices generally means copying and
    # allocating new arrays. This is easily avoided with @views
    @views begin
        prev .= v

        # check if we can move up, down, left, right (ignoring blizzards)
        v[1:end-1, :] .= v[1:end-1, :] .|| prev[2:end, :]
        v[2:end, :]   .= v[2:end, :]   .|| prev[1:end-1, :]
        v[:, 1:end-1] .= v[:, 1:end-1] .|| prev[:, 2:end]
        v[:, 2:end]   .= v[:, 2:end]   .|| prev[:, 1:end-1]

        # since we only keep track of locations _within_ the valley (ie not the
        # walls and the true start/finish loctaions), we always include the
        # possibility of only entering the valley proper at this point.
        v[v.start] = true

        # remove all positions blocked by blizzards
        v .= v .&& .!blizzards
    end
end

# for part 2, reset and switch start and finish
function reverse!(v::Valley)
    v .= false
    v.start, v.finish = v.finish, v.start
end

empty_char() = '.'
wall_char() = '#'
dir_char(i) = "^>v<"[i]
function readinput()
    lines = readlines("input.txt")
    # -1 because we will remove the leading wall characters
    startcol = findfirst(empty_char(), lines[begin]) - 1
    finishcol = findlast(empty_char(), lines[end]) - 1
    start = CartesianIndex(startcol, 1)
    finish = CartesianIndex(finishcol, length(lines) - 2)

    # remove the outer walls
    chars = @_ lines[begin+1:end-1] |>
        strip.(__, wall_char())     |>
        collect.(__)                |>
        hcat(__...)

    # store the locations of all blizzards moving in a particular direction in
    # a single layer, one per direction
    blizzards = BitArray(undef, size(chars)..., 4)
    for i ∈ 1:4
        blizzards[:, :, i] .= chars .== dir_char(i)
    end

    return (Blizzards(blizzards), Valley(size(chars), start, finish))
end

max_time() = 10_000
function quickest!(blizzards, valley)
    prev = deepcopy(valley)
    for time ∈ 1:max_time()
        next!(blizzards)
        next!(valley, prev, blizzards)
        isfinished(prev) && return time
    end
end

"""
`day24(part2) -> Int`

Solve Advent of Code 2022 day 24. That is, determine the quickest time necessary
to cross the given valley while avoiding blizzards. If `part2` is `true` then
calculate the time to cross, return and then cross again.
"""
function day24(part2 = false)
    blizzards, valley = readinput()
    time = quickest!(blizzards, valley)
    !part2 && return time

    reverse!(valley)
    time += quickest!(blizzards, valley)
    reverse!(valley)
    return time += quickest!(blizzards, valley)
end
end;
Day24.day24.(false:true)
