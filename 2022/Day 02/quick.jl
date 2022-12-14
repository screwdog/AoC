"""
Quick.jl
========

This file is my attempt at solving the puzzle at the time of release
and is not necessarily good practice. In particular, this should be
placed within a function rather than as a plain script.

Basic approach here is to predefine the winning scores for every combination
of letters.
"""

task1plays = Dict([
"A X" => 1 + 3,
"A Y" => 2 + 6,
"A Z" => 3 + 0,
"B X" => 1 + 0,
"B Y" => 2 + 3,
"B Z" => 3 + 6,
"C X" => 1 + 6,
"C Y" => 2 + 0,
"C Z" => 3 + 3
])

task2plays = Dict([
"A X" => 3 + 0,
"A Y" => 1 + 3,
"A Z" => 2 + 6,
"B X" => 1 + 0,
"B Y" => 2 + 3,
"B Z" => 3 + 6,
"C X" => 2 + 0,
"C Y" => 3 + 3,
"C Z" => 1 + 6
])

(readlines(raw"input.txt") |>
    L -> map(s -> task1plays[s], L) |>
    sum,
    # Actually don't need to map and then sum, as sum accepts a function to
    # apply to each item as a 1st argument ie sum(s -> task1plays[s], L) does
    # the same thing without creating an intermediate result.

readlines(raw"input.txt") |>
    L -> map(s -> task2plays[s], L) |>
    sum)