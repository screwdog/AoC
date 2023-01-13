General Hints
=============

The main task here is to determine whether all elements of a collection are unique. As an isolated task this is generally done using a hash map or similar (or a type built on this like a dictionary or set) and most languages will have something like this built in. Here, though, we need to perform repeated duplicate detection on overlapping data and so efficiency improvements are available if we want to.

A secondary task is to extract the blocks of consecutive characters, which again is straight-forward in most languages but since we want sequential blocks there are opportunities for efficiency if interested.

Julia Functions
===============

- consecutive characters from a string (or other collection) can be extracted with `str[a:b]`
    * doing this without copying the data can be done with `view` (or `@view`/`@views` macros)
- `allunique` determines if the elements of a container are all unique
- related functions `unique`/`unique!` remove duplicates from collections
- `Set` is an unordered structure that can't contain duplicates
- Julia has built-in dictionaries called `Dict` that have unique keys