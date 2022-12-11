using Underscores

const TIME = 2503

struct DeerData
    flyspeed::Int
    flytime::Int
    resttime::Int
end
DeerData(fs::AbstractString, ft::AbstractString, rt::AbstractString) = DeerData(parse.(Int, [fs, ft, rt])...)
DeerData(s::AbstractString) = DeerData(match(r"(?:\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", s)...)

_blocktime(d::DeerData) = d.flytime + d.resttime
_blockdist(d::DeerData) = d.flyspeed * d.flytime
_withinBlockDist(d::DeerData, time) = d.flyspeed * (time > d.flytime ? d.flytime : time)
function disttravelled(d::DeerData, time)
    blocks, remainder = divrem(time, _blocktime(d))
    return blocks * _blockdist(d) + _withinBlockDist(d, remainder)
end
speed(d::DeerData, time) = mod1(time, _blocktime(d)) ≤ d.flytime ? d.flyspeed : 0

function day14(part2)
    deer = @_ readlines("input.txt") |>
        DeerData.(__)

    !part2 && return @_ deer |>
        disttravelled.(__, TIME) |>
        maximum

    current = zeros(Int, length(deer))
    score = zeros(Int, length(deer))
    for t ∈ 1:TIME
        current += speed.(deer, t)
        score += current .== maximum(current)
    end
    return maximum(score)
end
day14.(false:true)