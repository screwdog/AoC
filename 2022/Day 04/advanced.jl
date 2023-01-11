using Underscores
"""
Here we use some of the meta-programming capabilities of Julia to process the
input. Notice that the input format "1-93,2-11" is similar to the Julia syntax
of 1:93,2:11. To process a string as Julia source code is done using the `eval`
and `Meta.parse` methods (here we use ∘ (\circ<tab>) to compose them). We use
the `replace` function to convert the input into valid Julia syntax.

This is fine for a toy problem like this but is overkill for such simple data
processing. Generally, meta-programming at compile-time using macros is more
efficient and using this method is rarely needed.

The Base.Iterators package provides several convenient iterators that are
lightweight wrappers. Here we use `partition` to pair up the input ranges as
we have flattened them for processing. Several other iterators in the package
provide "lazy" versions of other functions: `flatten` (instead of `vcat`, etc),
`filter`, `accumulate`, and `reverse`.

We use a convenient method `sum(f, A)` which is equivalent (but more efficient
than) `sum(map(f, A))`. Since boolean values are treated as 0/1 for addition
and vectors are added element-wise, we can simply sum over boolean vector for
each part of the puzzle.
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