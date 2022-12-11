using Underscores, Base.Iterators
function printLights(lights)
    cs = @_ map(_ ? '■' : ' ', lights')
    lines = [join(cs[i, :]) for i ∈ axes(cs, 1)]
    println(join(lines, "\n"))
end

function day18(part2, test=false)
    function neighbours(i, j, N)
        ns = [[x,y] for x ∈ -1:1, y ∈ -1:1 if x ≠ 0 || y ≠ 0]
        ns .+= Ref([i, j])
        return @_ filter!(all(1 .≤ _ .≤ N), ns)
    end
    function dostep(lights)
        newlights = fill(false, (N, N))
        for i ∈ 1:N, j ∈ 1:N
            ns = neighbours(i,j,N)
            numon = count(@_ map(lights[_...], ns))
            newlights[i,j] = (lights[i,j] && numon ∈ 2:3) ||
                (!lights[i,j] && numon == 3)
        end
        part2 && for c ∈ corners
                newlights[c...] = true
            end
        return newlights
    end

    inputfile = test ? "test.txt" : "input.txt"
    N = test ? 6 : 100
    steps = test ? (part2 ? 5 : 4) : 100
    corners = [[1,1], [1,N], [N,1], [N,N]]

    lights = @_ read(inputfile)                 |>
        filter!((≠)(UInt8('\n')), __)           |>
        map(n -> n == 0x23 ? true : false, __)  |>
        reshape(__, (N, N))
    part2 && for c ∈ corners
            lights[c...] = true
        end
    newlights = fill(false, (N, N))

    for _ ∈ 1:steps
        lights = dostep(lights)
    end
    return count(lights)
end
day18.(false:true)