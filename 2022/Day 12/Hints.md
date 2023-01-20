General Hints
=============

The key task here is to calculate the length of the shortest path between two points. In most languages there are many, many libraries to do this on arbitrary graphs, but the structure here (locations are laid out on a grid with movement only possible between directly adjacent places) means that it is reasonable to implement a more efficient, custom solution here. The go-to approach for such problems is Dijkstra's algorithm.

For part 2, algorithms like Dijkstra's are easily adapted to have multiple possible end states, rather than starting places. So it is probably easier to calculate the shortest path in reverse order from the end back to a starting set. This also works for part 1.

Julia Functions
===============

- Since chars can be compared directly (ie `'b' - 'a' == 1`) we need not convert the input to a numeric format
    * a vector of strings can be indexed as `heights[row][column]`, as can a vector of `char[]`
    * `hcat(vv...)` converts a vector of vectors to a matrix. `permutedims` transposes an array, although this is probably not necessary
- searching collections is done with `findfirst`, `findnext`, `findlast`. To search for multiples use `findall`.
    * to find the location of the smallest/largest, use `argmin`/`argmax` or `findmin`/`findmax`
    * `extrema` returns both the maximum and minimum
- locations in matrices are returned as `CartesianIndex{2}` types.
    * these can be used directly to index a matrix, like `A[I]` where `I` is a `CartesianIndex`
    * `CartesianIndex` types can be summed like `CartesianIndex(1,2) + CartesianIndex(3,4) == CartesianIndex(4,6)`. Similarly, `n * CartesianIndex(a,b) == CartesianIndex(na, nb)`
    * unfortunately, the indices in a `CartesianIndex` can't be accessed directly, and must first be extracted with `Tuple(I)`.
    * collections of `CartesianIndex`es can be used to directly index an array. For example, if `S` is of type `CartesianIndex[]` and `A` is an array of matching dimension, `A[S]` is just those elements of `A` in the locations given by elements of `S`.
- a rectangular block of indices is represented by `CartesianIndices`. These are easily constructed with `topleft:bottomright` where both parts are `CartesianIndex`es.
    * analoguously to other ranges, `CartesianIndex(a,b) .+ CartesianIndices` shifts the block by `(a,b)`. Here, neither `a` nor `b` need be positive.
    * `CartesianIndices(A)` returns an iterator of all valid `CartesianIndex`es for the array `A`. These can also be `collect`ed or stored in other containers if necessary.
    * checking if a `CartesianIndex` is valid for an array `A` can be done with `checkbounds`
- alternatives to a `CartesianIndex` to refer to a location are vectors or tuples. To index an array `A` with either can be done with `A[x...]`.
    * vectors can be summed easily with `[1, 2] + [3, 4]`, tuples with `(1,2) .+ (3,4)`.
    * vectors of vectors can be broadcast over with `[1,2] .+ [[3,4], [5,6]]` but this doesn't work for tuples
    * tuples require `map(t -> t .+ (1,2), ((3,4), (5,6)))` or similar.
- initialising arrays with values can be done with `fill`, or more specialised elements can be done with `ones`/`zeros` or `trues`/`falses`. Uninitialised arrays can be allocated with `Matrix{type}(undef, ...)` or `similar`.