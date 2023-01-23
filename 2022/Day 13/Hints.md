General Hints
=============

The first key task here is interpreting the input. In a dynamic language like Python or Julia it is possible to use the language's own features to parse the input - particularly Python's `eval` or Julia's `eval ∘ Meta.parse`. This is simple but in this case the input is simple enough that we could parse it more efficiently.

The structure of the input suggests storing it in a tree structure (as a language parser does), although dynamic languages' can often use their list structures as trees. Reading each input line from left to right is equivalent to a depth-first traversal of the tree and so a recursive function seems natural. Or a stack of current depth could be used to implement a non-recursive algorithm.

The second key task is to implement the comparison operation as defined in the puzzle input. As the behaviour is defined in terms of the types of the "first" and "second" elements, some kind of polymorphism is likely to be useful here, and the recursive nature of the data structure suggests a recursive algorithm.

Alternatively, consideration of the results of the comparison algorithm reveals that it is functionally similar to a lexicographic ordering. That is, for many (but not all!) cases the ordering of two packets is determined by the ordering of the first element (or even character in the input) where they differ. A few complexities remain but it is possible to implement the required comparison algorithm without first interpreting the input data.

Julia Functions
===============

- `Meta.parse` takes a string and returns the equivalent Julia expression. This expression can then be evaluated using `eval`.
    * Defining functions this way has some complications, but data literals work as expected.
- `Ref` is commonly used when broadcasting (using `.` syntax) to treat an iterable as a scalar.
    * For example, `[1,2] .+ [[3,4],[5,6]]` causes an error as `.+` tries to add each element of the first vector to the corresponding element in the second vector. That is, it tries `1 + [3,4]`. But, `Ref([1,2]) .+ [[3,4],[5,6]]` works as expected.
    * Alternatively, wrapping the data in either a tuple or vector has the same result. That is, `([1,2],)` or `[[1,2]]`.
- Multiple dispatch is ideal for packet comparison as the behaviour depends very much on the *types* of data we are comparing
    * that is, `comesfirst(x::Int, y::Int) = x < y`, `comesfirst(x::Int, y::Vector) = comesfirst([x], y)`, etc.
- `findall(A)`, when `A` contains `bool` values, returns a vector of the indices where `A` is true.
- `sort`/`sort!` takes a named argument `lt` ("less than") which specifies the comparison operator to use.
- `searchsorted`/`searchsortedfirst`/`searchsortedlast` efficiently search sorted iterators. Note that the "first"/"last" versions function differently than the similarly named `findfirst`/`findlast`.