function day2()
    rpsScore = [3mod((j - i + 1), 3) for i ∈ 1:3, j ∈ 1:3]
    p1scores = Dict(["$('@' + i) $('W' + j)" => j + rpsScore[i,j]   for i ∈ 1:3, j ∈ 1:3])
    p2scores = Dict(["$('@' + i) $('W' + j)" => mod(i+j,3) + 3j - 2 for i ∈ 1:3, j ∈ 1:3])

    score = scoreDict ->
        readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 2\input.txt") |>
        L -> map(s -> scoreDict[s], L) |>
        sum

    return score.((p1scores, p2scores))
end
day2()