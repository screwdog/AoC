"""
We process the input line-by-line, reading the input file, processing the text
and calculating whether it represents ranges that are subsets or overlap.

`split` returns a vector of substrings, and here we use `!isdigit` so that only
the digits remain and `keepempty=false` to discard all consecutive non-digit
characters.

Detecting whether two ranges are subsets of each other can be done easily using
⊆ or ⊇. Detecting whether they overlap at all is the opposite of whether they
are disjoin, so we use `isdisjoint`.
"""
function day4()
    subsets, overlaps = 0, 0
    open("input.txt") do file
        while !eof(file)
            line = readline(file)
            sections = split(line, !isdigit, keepempty=false)
            nums = parse.(Int, sections)
            range1, range2 = nums[1]:nums[2], nums[3]:nums[4]
            (range1 ⊆ range2 || range1 ⊇ range2) && (subsets += 1)
            !isdisjoint(range1, range2) && (overlaps += 1)
        end
    end
    return (subsets, overlaps)
end
day4()