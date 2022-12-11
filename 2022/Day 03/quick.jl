(readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 3\input.txt") |>
    L -> [[s[1:length(s)÷2], s[length(s)÷2+1:end]] for s ∈ L] |>
    L -> [l[1] ∩ l[2] for l ∈ L] |>
    L -> [l[1] for l ∈ L] |>
    L -> [isuppercase(c) ? c - '@' + 26 : c - '`' for c ∈ L] |>
    sum,

readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 3\input.txt") |>
    L -> reshape(L, (3, :)) |>
    L -> [reduce(∩, L[1:3, i]) for i ∈ axes(L,2)] |>
    L -> [l[1] for l ∈ L] |>
    L -> [isuppercase(c) ? c - '@' + 26 : c - '`' for c ∈ L] |>
    sum)