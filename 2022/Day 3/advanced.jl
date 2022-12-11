using Underscores

function day3p1()
    @_ readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 3\input.txt")  |>
        map( [first(_, length(_)÷2), last(_, length(_)÷2)], __)         |>
        map( ∩(_...), __)                                               |>
        getindex.(__, 1)                                                |>
        map( _ - (isuppercase(_) ? '&' : '`'), __)                      |>
        sum
end

function day3p2()
    @_ readlines(raw"C:\Users\rayha\Desktop\AoC\2022\Day 3\input.txt")  |>
        reshape(__, (3, :))                                             |>
        [reduce(∩, __[:,i])[1] for i ∈ axes(__,2)]                      |>
        map( _ - (isuppercase(_) ? '&' : '`'), __)                      |>
        sum
end

(day3p1(), day3p2())