subsets(n, k::Int) = _subsets(n, k, 1)
subsets(n, r::AbstractRange) = vcat(subsets.(n, r)...)

function _subsets(n, k, from)
    k == 0 && return [Int[]]
    k == 1 && return [Int[j] for j ∈ from:n]
    sets = Vector{Int}[]
    for i ∈ from:n-1
        ss = _subsets(n, k-1, i+1)
        pushfirst!.(ss, i)
        append!(sets, ss)
    end
    return sets
end