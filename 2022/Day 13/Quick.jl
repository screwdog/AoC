# My initial, quick solution to the problem. Done under time
# pressure, this doesn't necessarily reflect good practice,
# Julian or otherwise.

using Underscores

function readdata(file)
    @_ readchomp(file)                  |>
        split(__, "\n\n")               |>
        split.(__, "\n")                |>
        map.(eval(Meta.parse(_)), __)
end

correctOrder(p1::Int, p2::Int) = sign(p2 - p1)
correctOrder(p1::Int, p2::Vector) = correctOrder([p1], p2)
correctOrder(p1::Vector, p2::Int) = correctOrder(p1, [p2])
correctOrder(ps::Vector) = correctOrder(ps[1], ps[2])
function correctOrder(p1::Vector, p2::Vector)
    length(p1) == length(p2) == 0 && return 0
    length(p1) == 0 && return 1

    for i ∈ intersect(axes(p1,1), axes(p2,1))
        cmp = correctOrder(p1[i], p2[i])
        cmp ≠ 0 && return cmp
    end
    length(p1) == length(p2) && return 0
    length(p1) < length(p2) && return 1
    return -1
end
ispacketless(p1, p2) = correctOrder(p1, p2) ≥ 0

function flattenOnce(ps)
    newPs = []
    for p ∈ ps
        append!(newPs, p)
    end
    return newPs
end

function day13p1(test=false)
    inputfile = test ? "test.txt" : "input.txt"
    packets = readdata(inputfile)

    @_ correctOrder.(packets)       |>
        enumerate                   |>
        collect                     |>
        filter(last(_) == 1, __)    |>
        first.(__)                  |>
        sum
end

function day13p2(test=false)
    dividerPackets = [[[2]], [[6]]]

    inputfile = test ? "test.txt" : "input.txt"
    packets = readdata(inputfile)
    packets = flattenOnce(packets)
    append!(packets, dividerPackets)
    sort!(packets, lt=ispacketless)

    ds = searchsortedfirst.(Ref(packets), dividerPackets, lt=ispacketless) .- 1

    return reduce(*, ds)
end
(day13p1(), day13p2())