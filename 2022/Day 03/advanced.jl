using Underscores

halve(str) = [first(str, length(str)÷2), last(str, length(str)÷2)]
letters = ('a':'z') ∪ ('A':'Z') # ∪ returns Vector{Char}
priority(c) = findfirst(c, join(letters))

# data transformation necessary for part 1. Split each string
# in half and then flatten the list so each half is a seperate
# item in the list. This leaves the list in part 1 similar in
# format to part 2: part 1 we want to compare every 2 lines, part
# 2 we want to compare every 3.
part1 = lines -> @_ lines |> halve.(__) |> vcat(__...)

function day3(part2)
    @_ "input.txt"                          |>
        readlines                           |>
        # choose between doing part1 transformation or identity for part 2
        # identity(x) == x for any x ie do nothing for part 2
        (part2 ? identity : part1)          |>
        # convert list into matrix of dimension either (2, :) or (3, :)
        # Note that these colons mean an unspecified length to be determined
        # by the size of the input. `part2 ? 3 : 2` has a colon which is part
        # of the `?` operator. These two uses are distinct from defining a
        # range (1:2). 
        reshape(__, (part2 ? 3 : 2, :))     |>
        # reduce along the 1st dimension (ie flatten each column) using the
        # ∩ operator. For less common reductions a neutral initial element
        # must be given.
        reduce(∩, __; dims=1, init=letters) |>
        # ∘ (\circ<tab>) is function composition, which allows us to define
        # a function of functions. Note this is the same as using an anonymous
        # function like `c -> first(priority(c))` 
        sum(priority ∘ first, __)
end

day3.(false:true)