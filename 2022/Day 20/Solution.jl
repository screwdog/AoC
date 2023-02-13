module Day20
using Underscores

# returns the numbers as pairs (index => value) so we can keep track of the
# order they need to be processed in.
function readdata(part2)
    KEY = !part2 ? 1 : 811589153
    return @_ "input.txt"       |>
        readlines               |>
        parse.(Int, __)         |>
        __ .* KEY               |>
        (axes(__, 1) .=> __)
end

# convenience functions to access the (index => value) pairs
index(p) = first(p)
value(p) = last(p)

# convenience functions for indexing and for higher-order functions
index(data, i) = mod1(i, length(data))
indexof(i) = p -> index(p) == i
valueof(v) = p -> value(p) == v
valueat(data, i) = value(data[index(data, i)])
valueat(data) = i -> valueat(data, i)

function move!(data, i)
    from = findfirst(indexof(i), data)
    item = popat!(data, from)
    to = index(data, from + value(item))
    insert!(data, to, item)
end

mix!(data) = move!.(Ref(data), axes(data, 1))
function mix!(data, n)
    for _ ∈ 1:n
        mix!(data)
    end
end

function coords(data)
    zeroloc = findfirst(valueof(0), data)
    return sum(valueat(data), zeroloc .+ (1000:1000:3000))
end

"""
`day20([part2 = false]) -> Int`

Solve Advent of Code 2022 day 20, either part 1 or 2, reading data from
"input.txt". That is, "mixes" the list of numbers as a circular list and returns
the sum of values at positions 1000, 2000, and 3000 after the number 0.
"""
function day20(part2=false)
    data = readdata(part2)
    mix!(data, !part2 ? 1 : 10)
    return coords(data)
end
end;

Day20.day20.(false:true)
