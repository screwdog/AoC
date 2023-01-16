General Hints
=============

The key task in part 1 is accurately modelling the X register based on the input. For part 2, it is then necessary to check when these values overlap with the current cycle number (mod 40).

Julia Functions
===============

- to replace portions of a string use `replace`
    * regular expressions with `r"..."` can be used to match portions to replace
    * substitutions are then defined with `s"..."`
    * that is, use `replace(str, r"..." => s"...")`
- signal strength is calculated every 40 cycles, starting in the 20th. A range like `20:40:220` gives those cycle numbers.
- to check if a number occurs in a given range, use `number ∈ range`
- uninitialised matrices can be created with `Matrix{type}(undef, N, M)`
- a matrix initialised with a single value can be created with `fill`
- matrices offer linear indexing where their dimensions are ignored and are treated as a vector
    * `M[n]` accesses the nth element of a matrix
    * matrices in Julia are stored in column-major format, so `M[2] == M[2,1]`, `M[3] == M[3,1]`, etc
- `eachrow`/`eachcol` gives an iterator over the rows or columns of a matrix
- a collection of characters can be concatenated into a string with `join`. Delimiters can be added with `join(strs, delim)`.
- `Base.Iterators` provides several convenience iterators
    * `Iterators.partition(itr, n)` returns `n` items at a time from `itr`. This can be useful for converting a flat data structure into rows or columns.
    * `Iterators.cycle` creates an iterator that repeatedly loops over a given finite iterator
    * `Iterators.take(itr, n)` returns just the first `n` items from `itr`.
- `cumsum` calculates the cumulative sum of a list of numbers. This is sometimes called the partial sums or accumulation.