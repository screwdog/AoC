const dirs = Dict([
    'U' => [0, -1],
    'D' => [0, 1],
    'L' => [-1, 0],
    'R' => [1, 0]
])

movehead(head, dir) = head + dirs[dir]
function moveknot(tail, head)
    δ = head - tail
    δ = maximum(abs.(δ)) ≥ 2 ? sign.(δ) : [0,0]
    return tail + δ
end

function day9(part2)
    NUMKNOTS = part2 ? 10 : 2
    knotpos = [[0,0] for _ ∈ 1:NUMKNOTS]
    tailpositions = [[0,0]]
    
    for line ∈ readlines("input.txt")
        dir, dist = line[1], parse(Int, line[3:end])
        for _ ∈ 1:dist
            knotpos[1] = movehead(knotpos[1], dir)
            for i ∈ 2:NUMKNOTS
                knotpos[i] = moveknot(knotpos[i], knotpos[i-1])
            end
            insertpos = searchsorted(tailpositions, knotpos[end])
            isempty(insertpos) && insert!(tailpositions, first(insertpos), knotpos[end])
        end
    end
    return length(tailpositions)
end
day9.(false:true)