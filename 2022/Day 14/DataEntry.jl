str2coord(str) = @_ split(str, ",") |> parse.(Int, __)

function readdata(filename)
    @_ readlines(filename)      |>
        split.(__, " -> ")      |>
        map(str2coord.(_), __)
end

function addPath!(cave, topleft, p1, p2)
    Δ = p2 - p1
    δ = sign.(Δ)
    for n ∈ 0:maximum(abs, Δ)
        cave[(p1 + n*δ - topleft)...] = CAVE_ROCK
    end
    return nothing
end

function addPaths!(cave, topleft, points)
    for n ∈ 1:length(points)-1
        addPath!(cave, topleft, points[n], points[n+1])
    end
    return nothing
end

function makeCave(data, part2=false)
    source = [500, 0]
    xR, yR = @_ reduce(vcat, data)  |>
        push!(__, source)           |>
        reduce(hcat, __)            |>
        extrema(__, dims=2)         |>
        map((:)(_...), __)
    
    if part2
        yR = first(yR):last(yR) + 2
        sourceheight = last(yR) - source[2]
        xs = source[1] .+ [-1, 1]*sourceheight
        xR = (xs[1]:xs[2]) ∪ xR
    end
    
    topleft = first.([xR, yR]) .- 1
    bottomright = last.([xR, yR]) .- topleft
    source .-= topleft

    cave = fill(CAVE_EMPTY, bottomright...)
    part2 && (cave[:,end] .= CAVE_ROCK)
    addPaths!.(Ref(cave), Ref(topleft), data)
    return (cave, source)
end