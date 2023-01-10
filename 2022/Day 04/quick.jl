"""
Quick.jl
========

This represents my first attempt at solving this puzzle done under time constraints and is not
intended to show best practice. In particular, these should be defined within functions rather
than as a plain script.
"""

using Underscores
(
@_ readlines(raw"input.txt") |>
    match.(r"(\d+)-(\d+),(\d+)-(\d+)", __) |>
    # next line is actually unnecessary as RegexMatch returns its captures when iterated over
    map(_.captures, __) |>
    map(parse.(Int, _), __) |>
    count(issubset((_[1]):(_[2]), (_[3]):(_[4])) || issubset((_[3]):(_[4]), (_[1]):(_[2])), __)
,

@_ readlines(raw"input.txt") |>
    match.(r"(\d+)-(\d+),(\d+)-(\d+)", __) |>
    map(_.captures, __) |>
    map(parse.(Int, _), __) |>
    count(!isdisjoint(_[1]:_[2], _[3]:_[4]), __)
)