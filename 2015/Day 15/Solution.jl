cookieRegex = r"(?:\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)"
using Underscores
function next!(c)
    first(c) == 100 && begin c[1] = -1; return end
    if c[end] > 0
        c[end-1] += 1
        c[end] -= 1
    else
        index = findlast((>)(0), c[1:end-1])
        sum(c[1:index]) == 100 && (index -= 1)
        c[index] += 1
        c[index+1:end-1] .= 0
        c[end] = 100 - sum(c[1:index])
    end
end
function day15(part2)
    cookiedata = @_ readlines("input.txt")  |>
        match.(cookieRegex, __)             |>
        collect.(__)                        |>
        map(parse.(Int, _), __)

    bestscore = 0
    comb = zeros(Int, length(cookiedata))
    comb[end] = 100
    while first(comb) != -1
        vals = @_ comb .* cookiedata    |>
            sum                         |>
            max.(0, __)
        score = prod(vals[1:end-1])

        (!part2 || vals[end] == 500) && (bestscore = max(bestscore, score))
        next!(comb)
    end
    return bestscore
end
day15.(false:true)