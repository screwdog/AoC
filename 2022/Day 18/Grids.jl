# Dense storage of droplet cube data
struct Grid <: AbstractDroplet
    cubes::BitArray{3}
end

# Convenience constructors to accept data as provided by `processdata`
function Grid(indices, extents)
    cubes = falses(Tuple(extents))
    cubes[indices] .= true
    return Grid(cubes)
end
Grid(t::Tuple) = Grid(t...)

# only 4 methods are necessary for Grid to function transparently as an Array
Base.IndexStyle(::Grid) = IndexLinear()
Base.size(g::Grid) = size(g.cubes)
Base.getindex(g::Grid, i) = checkbounds(Bool, g.cubes, i) ? g.cubes[i] : false
Base.setindex!(g::Grid, b, i) = g.cubes[i] = b
