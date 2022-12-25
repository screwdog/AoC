function solidify!(volume)
    X, Y, Z = size(volume)
    reachable = fill(false, X, Y, Z)
    queue = [[1,1,1]]
    while !isempty(queue)
        i, j, k = popfirst!(queue)
        reachable[i,j,k] && continue
        reachable[i,j,k] = true

        i > 1 && !volume[i-1,j,k] && !reachable[i-1,j,k] && push!(queue, [i-1,j,k])
        i < X && !volume[i+1,j,k] && !reachable[i+1,j,k] && push!(queue, [i+1,j,k])
        j > 1 && !volume[i,j-1,k] && !reachable[i,j-1,k] && push!(queue, [i,j-1,k])
        j < Y && !volume[i,j+1,k] && !reachable[i,j+1,k] && push!(queue, [i,j+1,k])
        k > 1 && !volume[i,j,k-1] && !reachable[i,j,k-1] && push!(queue, [i,j,k-1])
        k < Z && !volume[i,j,k+1] && !reachable[i,j,k+1] && push!(queue, [i,j,k+1])
    end
    volume .= .!reachable
end