using Underscores

(
@_ readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 4\input.txt") |>
    match.(r"(\d+)-(\d+),(\d+)-(\d+)", __) |>
    map(_.captures, __) |>
    map(parse.(Int, _), __) |>
    count(issubset((_[1]):(_[2]), (_[3]):(_[4])) || issubset((_[3]):(_[4]), (_[1]):(_[2])), __)
,

@_ readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 4\input.txt") |>
    match.(r"(\d+)-(\d+),(\d+)-(\d+)", __) |>
    map(_.captures, __) |>
    map(parse.(Int, _), __) |>
    count(!isdisjoint(_[1]:_[2], _[3]:_[4]), __)
)