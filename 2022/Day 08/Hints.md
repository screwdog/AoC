General Hints
=============

The key task here is to traverse partial rows and columns in a data structure. This can be done in most languages with for loops or similar, but many languages have higher order functions like "all"/"find" to process a list of data at once.

The initial task is to read an array of numeric data in text format and convert to a more useful format, such as a 2D array.

Julia Functions
===============

- `collect` converts strings to vectors of char
- `hcat(ls...)` converts vectors of vectors into a matrix (although usually transposed)
- `M[i, j:k]` extracts a partial row, `M[i:j, k]` a partial column
- nested for-loops are rarely needed in Julia as `for i ∈ 1:10, j ∈ 1:10` acts as a doubly-nested for-loop
- `all(f, itr)` checks whether `f` is true for all elements of `itr`
- `findfirst`/`findlast` returns the index of the first or last element matching a certain condition
    * these return `nothing` if no element is found. Checking is usually done with `x === nothing` or `x ≠ nothing`
    * `something`/`@something` can be used to ignore `nothing` values
- `count(f, itr)` returns the number of elements in `itr` for which `f` returns true
- `maximum(f, itr)` returns the maximum value of `f` when applied to each element of `itr`
- `[... for i ∈ 1:10, j ∈ 1:10]` constructs a vector where i and j range over these values, like in a nested for-loop
- `Iterators.product(1:3, 1:7))` creates an iterator that returns each `(x,y)` tuple in the given ranges
    * this can be used like `for (i,j) ∈ Iterators.product(1:3, 1:7)`