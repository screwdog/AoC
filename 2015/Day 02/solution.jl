function day2()
    perm = [2, 3, 1]
    sides = dims -> dims.*dims[perm]
    paper = dims -> 2sum(sides(dims)) + minimum(sides(dims))
    ribbon = dims -> 2sum(partialsort(dims, 1:2)) + reduce(*, dims)

    readlines(raw"C:\Users\rayha\Desktop\AoC\2015\Day 2\input.txt") |>
        L -> split.(L, "x") |>
        L -> [parse.(Int, l) for l ∈ L] |>
        L -> [paper.(L), ribbon.(L)] |>
        L -> sum.(L)
end
day2()