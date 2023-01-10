using Underscores
"""

"""
function day4()
@_ "input.txt"                                          |>
    readchomp                                           |>
    replace(__, "-" => ":", "\n" => ",")                |>
    eval ∘ Meta.parse                                   |>
    Iterators.partition(__, 2)                          |>
    sum([⊆(_...) || ⊇(_...), !isdisjoint(_...)], __)
end
day4()