function day5p1()
    badStrings = ["ab", "cd", "pq", "xy"]
    readlines(raw"C:\Users\rayha\Desktop\AoC\2015\Day 5\input.txt") |>
        L -> filter(l -> count(c -> c ∈ "aeiou", l) ≥ 3, L)         |>
        L -> filter(l -> match(r"(.)\1", l) ≠ nothing, L)           |>
        L -> filter(l -> !any(occursin.(badStrings, l)), L)         |>
        length
end

function day5p2()
    readlines(raw"C:\Users\rayha\Desktop\AoC\2015\Day 5\input.txt") |>
        L -> filter(l -> match(r"(..).*\1", l) ≠ nothing, L)        |>
        L -> filter(l -> match(r"(.).\1", l) ≠ nothing, L)          |>
        length
end

(day5p1(), day5p2())