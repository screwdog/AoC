readchomp(raw"C:\Users\rayha\Desktop\AoC\2022\Day 1\input.txt") |>
    s -> split(s, "\n\n")                |>
    L -> split.(L)                       |>
    L -> [parse.(Int,l) for l ∈ L]       |>
    L -> sum.(L)                         |>
    L -> partialsort(L, 1:3; rev = true) |>
    L -> (L[1], sum(L))