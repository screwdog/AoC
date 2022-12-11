function day8(p2)
    lines = readlines("input.txt")
    N, M = length(lines), length(lines[1])
    trees = Matrix{Int}(undef, N, M)

    for i ∈ 1:N
        for j ∈ 1:M
            trees[i,j] = parse(Int, lines[i][j])
        end
    end

    function isvisible(i,j)
        (i == 1 || j == 1) && return true
        (i == N) || (j == M) && return true

        h = trees[i,j]
        all((<)(h), trees[1:i-1,j]) && return true
        all((<)(h), trees[i+1:N,j]) && return true
        all((<)(h), trees[i,1:j-1]) && return true
        all((<)(h), trees[i,j+1:M]) && return true
    end

    if !p2
        Σ = 0
        for i ∈ 1:N
            for j ∈ 1:M
                if isvisible(i,j)
                    Σ += 1
                end
            end
        end
        return Σ
    end

    function look(i,j,dir)
        h = trees[i,j]
        δi, δj = first(dir), last(dir)
        x, y = i + δi, j + δj
        n = 1
        while 1 < x < N && 1 < y < M && trees[x,y] < h
            x += δi
            y += δj
            n += 1
        end
        return n
    end
    function viewdist(i,j)
        (i == 1 || i == N) && return 0
        (j == 1 || j == M) && return 0
        return [
            look(i,j,[-1,0]),
            look(i,j,[1,0]),
            look(i,j,[0,-1]),
            look(i,j,[0,1])
        ]
    end
    scenicscore = (i,j) -> prod(viewdist(i,j))

    ss = zeros(Int, axes(trees))
    for i ∈ 1:N
        for j ∈ 1:M
            ss[i,j] = scenicscore(i,j)
        end
    end
    return maximum(ss)
end
day8.(false:true)