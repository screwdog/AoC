module Day13
using Underscores
include("Data.jl")

"""
`packetorder(p1, p2) -> Int`

Compares packets `p1` and `p2`, recursively if necessary, and returns one of
-1, 0, or 1 to indicate their ordering. That is:
                            -1, if p1 < p2
    packetorder(p1, p2) = {  0, if p1 == p2
                             1, if p1 > p2
"""
packetorder(p1::Int, p2::Int) = sign(p1 - p2)
packetorder(p1::Int, p2::Vector) = packetorder([p1], p2)
packetorder(p1::Vector, p2::Int) = packetorder(p1, [p2])
# implements the comparison algorithm as described in the problem, recursing as
# necessary and using the various methods above.
function packetorder(p1::Vector, p2::Vector)
    length(p1) == 0 && return length(p2) == 0 ? 0 : -1
    for i ∈ axes(p1,1) ∩ axes(p2,1)
        cmp = packetorder(p1[i], p2[i])
        cmp ≠ 0 && return cmp
    end
    # All comparable items are equivalent. If neither has items left then they
    # are equal, otherwise the shorter one comes first.
    return sign(length(p1) - length(p2))
end

"""
`ispacketless(p1, p2) -> Bool`
`ispacketless(itr) -> Bool`

Returns `true` if packet `p1` comes before packet `p2` and false otherwise. If
given an iterator expects exactly two elements and compares them.
"""
ispacketless(p1, p2) = packetorder(p1, p2) == -1
ispacketless(ps) = ispacketless(ps...)

"""
`day13p1() -> Int`

Calculates the solution to Advent of Code 2022 day 13, part 1, reading packet
data from "input.txt". That is, returns the sum of the indices where the pair
of packets are correctly ordered.
"""
function day13p1()
    @_ readdata()                   |>
        # pair the packets for comparison
        Iterators.partition(__, 2)  |>
        ispacketless.(__)           |>
        # returns the indexes where ispacketless is true
        findall                     |>
        sum
end

"""
`day13p2() -> Int`

Calculates the solution to Advent of Code 2022 day 13, part 2, reading packet
data from "input.txt". That is, the product of the indices of where the
divider packets are in the sorted list of packets.
"""
function day13p2()
    packets = sort!(readdata(), lt=ispacketless)
    dividers = [[[2]], [[6]]]
    # find where dividers would be in the list. Need Ref to treat packets as
    # not iterable (and just iterate over dividers). searchsortedfirst is
    # efficient but relies on the data being sorted, we could also use
    # findfirst(!ispacketless) or similar.
    locations = searchsortedfirst.(Ref(packets), dividers, lt=ispacketless)
    # location of the 2nd packet is off by one since the first packet isn't
    # actually in the list
    return locations + [0, 1] |> prod
end
end;
(Day13.day13p1(), Day13.day13p2())
