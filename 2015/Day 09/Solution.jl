function allperms(n)
    n == 1 && return [[1]]
    n == 2 && return [[1,2],[2,1]]
    partial = allperms(n-1)
    full = []
    for row ∈ partial
        for i ∈ 1:n
            push!(full, deepcopy(row))
        end
    end
    pos = repeat(vcat(n:-1:1, 1:n), outer=factorial(n-1)÷2)
    insert!.(full, pos, n)
end

function tripdist(trip, distances)
    Σ = 0
    for i ∈ 1:length(trip)-1
        Σ += distances[trip[i],trip[i+1]]
    end
    return Σ
end

const MAX_CITIES = 10
function day9()
    citynums = Dict{String,Int}()
    numcities = 0
    distances = Matrix{Int}(undef, MAX_CITIES, MAX_CITIES)
    open("input.txt") do file
        while !eof(file)
            line = readline(file)
            c1, c2, d = match(r"(\w+) to (\w+) = (\d+)", line)
            dist = parse(Int, d)
            if !haskey(citynums, c1)
                numcities += 1
                citynums[c1] = numcities
            end
            if !haskey(citynums, c2)
                numcities += 1
                citynums[c2] = numcities
            end
            distances[citynums[c1], citynums[c2]] = dist
            distances[citynums[c2], citynums[c1]] = dist
        end
    end

    perms = allperms(numcities)
    dists = tripdist.(perms, Ref(distances))
    return (minimum(dists), maximum(dists))
end

day9()