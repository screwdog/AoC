using Underscores

function day8(p2)
    trees = @_ readlines("input.txt") |>
           collect.(__)               |>
           reduce(hcat, __)
end
day8.(false:true)