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
function correctOrder(p1::Vector, p2::Vector)
    length(p1) == length(p2) == 0 && return 0
    length(p1) == 0 && return 1
    for i ∈ axes(p1,1) ∩ axes(p2,1)
        cmp = correctOrder(p1[i], p2[i])
        cmp ≠ 0 && return cmp
    end
    length(p1) < length(p2) && return 1
    length(p1) == length(p2) && return 0
    return -1
end
ispacketless(p1, p2) = correctOrder(p1, p2) == 1
ispacketless(ps) = ispacketless(ps[1], ps[2])

function day13p1(test=false)
    inputfile = test ? "test.txt" : "input.txt"
    @_ readdata(inputfile)          |>
        ispacketless.(__)           |>
        map(*, 1:length(__), __)    |>
        sum
end

function day13p2(test=false)
    inputfile = test ? "test.txt" : "input.txt"
    packets = @_ readdata(inputfile)    |>
        vcat(__...)                     |>
        sort!(__, lt=ispacketless)

    dividerPackets = [[[2]], [[6]]]
    return @_ searchsortedfirst.(Ref(packets), dividerPackets, lt=ispacketless) + [0,1] |>
        reduce(*, __)
end
(day13p1(), day13p2())

