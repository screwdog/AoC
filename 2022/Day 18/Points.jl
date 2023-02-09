# Sparse storage of droplet cube data
struct Points <: AbstractDroplet
    cubes::Set{CartesianIndex{3}}
    lengths::CartesianIndex{3}
end

# Convenience constructors to accept data as provided by `processdata`
Points(indices, extents) = Points(Set(indices), extents)
Points(t::Tuple) = Points(t...)

# Only 3 methods required for Points to function as an Array
Base.size(p::Points) = Tuple(p.lengths)
Base.getindex(p::Points, I::Vararg{Int, 3}) = CartesianIndex(I...) ∈ p.cubes
function Base.setindex!(p::Points, b, I::Vararg{Int, 3})
    i = CartesianIndex(I...)
    @boundscheck CartesianIndex(1,1,1) ≤ i ≤ p.lengths || throw(BoundsError(p, I))
    if b
        push!(p.cubes, i)
    else
        delete!(p.cubes, i)
    end
    return b
end

# More efficient than the fallback
eachcube(p::Points) = p.cubes
