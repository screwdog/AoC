global dirs = Dict([
    'U' => [0, -1],
    'D' => [0, 1],
    'L' => [-1, 0],
    'R' => [1, 0]
])

movehead(head, dir) = head + dirs[dir]
function movetail(tail, head)
    δ = head - tail
    δ = maximum(abs.(δ)) ≥ 2 ? sign.(δ) : [0,0]
    return tail + δ
end

function day9(part2)
    tailpositions = [[0,0]]
    part2 && (knotsposition = [[0,0] for _ ∈ 1:8])
    headposition = [0,0]

    open("input.txt") do file
        while !eof(file)
            line = readline(file)
            dir, dist = line[1], parse(Int, line[3:end])
            while dist > 0
                headposition = movehead(headposition, dir)
                if part2
                    knotsposition[1] = movetail(knotsposition[1], headposition)
                    for i ∈ 2:8
                        knotsposition[i] = movetail(knotsposition[i], knotsposition[i-1])
                    end
                    push!(tailpositions, movetail(tailpositions[end], knotsposition[end]))
                else
                    push!(tailpositions, movetail(tailpositions[end], headposition))
                end
                dist -= 1
            end
        end
    end
    return length(unique(tailpositions))
end
day9.(false:true)