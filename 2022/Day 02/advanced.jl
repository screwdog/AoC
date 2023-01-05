using Underscores
"""
Programmatically calculate the pay-offs for each play, for both parts 1 and 2. We then
pair these with the appropriate string (like "A X") and use to initialise a dictionary.
Here the dictionary `scores["A X"]` returns a vector `[n m]` where `n` is the score for
part 1 and `m` for part 2.

To construct the dictionary we initialise with a matrix using an array comprehension
        `[str(i,j) => [p1(i,j), p2(i,j)] for i ∈ 1:3, j ∈ 1:3]`
This creates a 3x3 matrix where each element is a pair of a string to a length-2 vector.
Matrices in Julia can be iterated over as if they were a 1D collection, so although it's
convenient to construct as 2D it can still initialise a dictionary.

To create the strings we use string interpolation (`"$(...)"`) to insert values. Anything
within the brackets after a `"$"` is treated as a normal Julia expression and then converted
to a string.

Numeric literals directly in front of an identifier, without space between, (like `3j`) is
treated as multiplication (ie `3*j`) to better match mathematics. Similarly, ∈ (\in<tab>) in
the context of a `for` loop is a synonym for the more familiar =. (∈ can also be used as a
function to check set inclusion, like `2 ∈ 1:3 == true`).

The expression `1:3` is a lightweight range object representing 1, 2, 3 - but without
constructing them explicitly. In the context of a `for` loop (in an array comprehension or
a plain `for` loop) this works as you might expect. Ranges can also take a step: 1:2:5 is the
sequence 1, 3, 5 and 3:-1:1 is 3, 2, 1. Note that 3:1 (== 3:1:1) is an empty range and has
no elements.
"""
function day2()
    scores = Dict([
        "$('@' + i) $('W' + j)" => [j + 3mod(j-i+1, 3), mod(i+j, 3) + 3j-2]
            for i ∈ 1:3, j ∈ 1:3])

    @_ "input.txt"          |>
        readlines           |>
        sum(scores[_], __)
end
day2()