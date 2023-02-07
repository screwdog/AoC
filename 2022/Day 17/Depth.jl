# a simple two-row boolean buffer, representing two rows of a chamber. This is
# enough when calculating the depth that blocks can fall two and by having a
# custom type we can use dispatch to specialise our code.
mutable struct SmallBuffer <: AbstractMatrix{Bool}
    buff::AbstractMatrix{Bool}
    offset::Bool
    SmallBuffer() = new(trues(CHAMBER_WIDTH, 2), false)
end
Base.size(sb::SmallBuffer) = size(sb.buff)
Base.getindex(sb::SmallBuffer, i, j) = sb.buff[i, mod(j + sb.offset, 1:2)]
Base.setindex!(sb::SmallBuffer, b, i, j) = sb.buff[i, mod(j + sb.offset, 1:2)] = b
flip!(sb::SmallBuffer) = sb.offset = !sb.offset

# init! and endloop! represent the two places in the search algorithm where it
# differs depending on whether we want to simply calculate the fall depth, or a
# map of the drop region. We use SmallBuffer to specialise.
function init!(sb::SmallBuffer, depth)
    sb[:,2] .= true
    sb[:,1] .= false
    return 1
end

function init!(buffer, depth)
    buffer[:, depth+1:BUFFER_HEIGHT] .= true
    buffer[:, begin:depth] .= false
    return depth
end

function endloop!(sb::SmallBuffer, y)
    flip!(sb)
    for x ∈ 1:CHAMBER_WIDTH
        sb[x, 1] = false
    end
    return 1
end
endloop!(buffer, y) = y - 1

# we calculate which places a block could fall into in the current chamber `c`,
# storing this in `buf`. Since blocks always fall down one row and at most one
# column to the side, we can do this row by row.

# We use a hypothetical 1x1 block as this is much easier.
function _dropmap!(buf, c::Chamber)
    startdepth = c.dropheight - DROP_OFFSET
    y = init!(buf, startdepth)
    startdepth ≥ 1 ? (depth = startdepth) : return (1, 1)
    while true
        # check the point above
        for x ∈ 1:CHAMBER_WIDTH
            !c.buffer[x,depth] && buf[x,y+1] && (buf[x,y] = true)
        end
        # check to the left
        for x ∈ 2:CHAMBER_WIDTH
            !c.buffer[x,depth] && buf[x-1,y] && buf[x-1,y+1] && (buf[x,y] = true)
        end
        # check to the right
        for x ∈ 1:CHAMBER_WIDTH-1
            !c.buffer[x,depth] && buf[x+1,y] && buf[x+1,y+1] && (buf[x,y] = true)
        end
        all(.!(@view buf[:,y])) && return (depth + 1, startdepth)
        depth == 1 && return (depth, startdepth)
        depth -= 1
        y = endloop!(buf, y)
    end
end

# Calulate the lowest row that a block could fall to. Note that this is relative
# to the current state of chamber.buffer, not taking into account any compacting
# that has been done.
dropdepth(c::Chamber) = first(_dropmap!(SmallBuffer(), c))

# Calculates the region that a block can fall into, returned as a view
function dropmap!(buffer, c::Chamber)
    from, to = _dropmap!(buffer, c)
    return @view buffer[:, from:to]
end

makedropmap() = falses(CHAMBER_WIDTH, BUFFER_HEIGHT)
