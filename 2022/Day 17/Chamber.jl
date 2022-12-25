!(@isdefined Wind) && include("Wind.jl")
!(@isdefined Blocks) && include("Blocks.jl")
!(@isdefined SimpleIndexQueue) && include("Queue.jl")

CHAMBER_WIDTH() = 7
BUFFER_HEIGHT() = 100_000

mutable struct Chamber
    buffer::Matrix{Bool}
    elidedHeight::Int
end
Chamber() = Chamber(fill(false, CHAMBER_WIDTH(), BUFFER_HEIGHT()), 0)

function _currentHeight(c::Chamber)
    y = findlast(any, eachcol(c.buffer))
    return y === nothing ? zero(Int64) : y
end
towerHeight(c::Chamber) = c.elidedHeight + _currentHeight(c)

function _placeData(x, y, b::Block, c::Chamber)
    xrange = x:x+width(b)-1
    yrange = y:y+height(b)-1
    return view(c.buffer, xrange, yrange)
end
_validLocation(x, y, c::Chamber) = (1 ≤ x ≤ CHAMBER_WIDTH()) && (1 ≤ y ≤ size(c.buffer, 2))
isplaceable(x, y, b::Block, c::Chamber) = !any(_placeData(x, y, b, c)[b.shape])
function placeBlock!(x, y, b::Block, c::Chamber)
    placeData = _placeData(x, y, b, c)
    placeData[b.shape] .= true
end

PLACES_HEIGHT() = 100
places() = fill(false, CHAMBER_WIDTH(), PLACES_HEIGHT())
queue() = SimpleIndexQueue()

function _fallingblockplaces!(places::Matrix{Bool}, queue::SimpleIndexQueue, c::Chamber)
    x, y = 4, _currentHeight(c)+1
    maxY = y
    placesYShift = PLACES_HEIGHT() - maxY

    fill!(places, false)
    push!(queue, x, y)

    while !isempty(queue)
        x, y = pop!(queue)
        places[x, y + placesYShift] && continue
        places[x, y + placesYShift] = true
        x > 1               && !c.buffer[x-1,y] && !places[x-1,y + placesYShift] && push!(queue, x-1, y)
        x < CHAMBER_WIDTH() && !c.buffer[x+1,y] && !places[x+1,y + placesYShift] && push!(queue, x+1, y)
        y < maxY            && !c.buffer[x,y+1] && !places[x,y+1 + placesYShift] && push!(queue, x, y+1)
        y > 1               && !c.buffer[x,y-1] && !places[x,y-1 + placesYShift] && push!(queue, x, y-1)
    end
end
function _fallingblockplaces!(c::Chamber)
    p, q = places(), queue()
    _fallingblockplaces!(p, q, c)
    return p
end

function _maxfalldepth(c::Chamber)
    p = _fallingblockplaces!(c)
    return _currentHeight(c) + findfirst(any, eachcol(p)) - 99
end

function compact!(c::Chamber)
    depth = _maxfalldepth(c)
    (depth === nothing || depth == 1) && throw(ErrorException("can't reduce size of Chamber buffer"))
    height = _currentHeight(c)

    newHeight = height - depth + 1
    c.buffer[:, 1:newHeight] = c.buffer[:, depth:height]
    fill!(view(c.buffer, :, newHeight+1:size(c.buffer,2)), false)
    c.elidedHeight += depth - 1
    return depth - 1
end