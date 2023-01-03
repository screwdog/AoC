function _subsets(set, target, size)
    if size == 2
        ns = filter(n -> 2n < target && target - n ∈ set, set)
        return map(n -> [n, target - n], ns)
    end
    ss = Vector{Int}[]
    max_ind = length(set) - size + 1
    max_ind < 1 && return ss

    for i ∈ 1:max_ind
        newSubset = _subsets(set[i+1:end], target - set[i], size - 1)
        append!(ss, pushfirst!.(newSubset, set[i]))
    end
    return ss
end

"""
    Return all subsets of set, of a given size, that
    sum to target
"""
function subsets(set, target, size)
    size > length(set) && return Vector{Int}[]
    size == 0 && return target == 0 ? [Int[]] : Vector{Int}[]
    size == 1 && return filter((==)(target), set)
    _subsets(set, target, size)
end

"""
    Returns whether S can be split into two subsets
    of equal sum
"""
function equalpartition(S)
    n = length(S)
    K = sum(S)
    iseven(K) || return false
    P = falses(K÷2 + 1 + 1, n + 1 + 1)
    P[1,:] .= true
    for i ∈ 1:K÷2
        for j ∈ 1:n
            x = S[j]
            P[i+1,j+1] = P[i+1,j] || ((i-x) ≥ 0 ? P[i-x+1, j] : false)
        end
    end
    return P[K÷2+1, n+1]
end

function equalSplit(S, n)
    n == 2 && return equalpartition(S)
    mod(sum(S), n) == 0 || return false
    target = sum(S)÷n
    maxsize = length(S)÷n
    for size ∈ 1:maxsize
        sets = subsets(S, target, size)
        any(s -> equalSplit(setdiff(S, s), n-1), sets) && return true
    end
    return false
end