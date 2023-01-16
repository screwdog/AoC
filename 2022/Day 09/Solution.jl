"""
`movehead(head, dir::Char)`

Returns the new position of `head` when moved one step in the direction given
by `dir`.
"""
function movehead(head, dir)
    dirs = Dict([
        'U' => [ 0, -1],
        'D' => [ 0,  1],
        'L' => [-1,  0],
        'R' => [ 1,  0]
    ])
    return head + dirs[dir]
end

"""
`moveknot(tail, head)`

Returns the new position of `tail`, updating it to follow `head`.
"""
function moveknot(tail, head)
    δ = head - tail
    maximum(abs.(δ)) ≤ 1 && return tail
    return tail + sign.(δ)
end

"""
`day9(part2::Bool)`

Solve Advent of Code 2022 Day 9 puzzle, either part 1 or 2 depending on the
value of `part2`. Returns the number of unique locations visited by the tail
of the rope as the head follows the movement instructions given in "input.txt".
"""
function day9(part2)
    NUMKNOTS = !part2 ? 2 : 10
    # store positions as vectors as these sum and broadcast easily
    knotpos = [[0,0] for _ ∈ 1:NUMKNOTS]
    # store a Set of visited locations to avoid duplicates
    tailpositions = Set([[0,0]])
    
    for line ∈ eachline("input.txt")
        dir, dist = line[1], parse(Int, line[3:end])
        # move knots step by step
        for _ ∈ 1:dist
            # knotpos[1] is the position of the head
            knotpos[1] = movehead(knotpos[1], dir)
            # remaining knotpos are the other knots
            for i ∈ 2:NUMKNOTS
                knotpos[i] = moveknot(knotpos[i], knotpos[i-1])
            end
            # knotpos[end] is the tail
            push!(tailpositions, knotpos[end])
        end
    end
    # number of items in a Set is given by length
    return length(tailpositions)
end
day9.(false:true)