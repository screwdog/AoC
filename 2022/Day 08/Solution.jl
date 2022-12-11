function day8()
    lines = readlines("input.txt")
    N, M = length(lines), length(lines[1])
    trees = Matrix{Int}(undef, N, M)
    for (i,j) ∈ Iterators.product(1:N, 1:M)
            trees[i,j] = parse(Int, lines[i][j])
    end

    function isvisible(i,j)
        h = trees[i,j]
        return all((<)(h), trees[1:i-1,j]) ||
               all((<)(h), trees[i+1:N,j]) ||
               all((<)(h), trees[i,1:j-1]) ||
               all((<)(h), trees[i,j+1:M])
    end

    return count([isvisible(i,j) for (i,j) ∈ Iterators.product(1:N, 1:M)])
end
t = day8()

