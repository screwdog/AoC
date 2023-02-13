General Hints
=============

The first task here is to represent the list of numbers in a format where their original position can be tracked so they can be shuffled in the correct order. The next task is to efficiently move the elements around, either by extracting and reinsertion or by shifting the elements in the structure.

Julia Functions
===============

- `mod` and `mod1` are useful for indexing a "circular" buffer.
    * the form `mod(i, axes(A,1))` restricts `i` to being a valid for `A[i]`.
- `popat!` and `insert!` are useful for removing and adding items to a `Vector`.
- types that bundle two `int`s together include tuples, vectors, pairs, and 2xN matrices.
    * tuples are constructed with `(1, 2)` or `Tuple([1,2])` and are immutable.
    * vectors are constructed with `[1,2]` and are mutable.
    * pairs are constructed with `1 => 2` and are immutable.
    * 2xN (or Nx2) matrices are constructed with `Matrix(undef, 2, N)`, `fill`, `zeros`, `ones`, or `similar`.
- `first` and `last` are convenient functions for accessing the elements of types (and allow for generic programming).
