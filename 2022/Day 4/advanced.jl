using Underscores

function day4adv()
@_ readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 4\input.txt") |>
    match.(r"(\d+)-(\d+),(\d+)-(\d+)", __)                         |>
    map(parse.(Int, _), __)                                        |>
    map([(:)(_[1:2]...), (:)(_[3:4]...)], __)                      |>
    map([⊆(_...) || ⊇(_...), !isdisjoint(_...)], __)              |>
    reduce(+, __)
end
day4adv()