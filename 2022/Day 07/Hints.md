General Hints
=============

Since the task requires simulating a file system, it is natural to think about building a tree structure. But for a problem this size a simple list of files, a list of directories, and a stack to store the current directory would also be sufficient.

The input here is a lot more structured than the problem text might suggest. The command `cd /` only occurs as the first instruction and never again, and each directory is listed exactly once. This means that there is no opportunity for potentially contradictory information (ie multiple directory listings that aren't the same).

Julia Functions
===============

- regular expressions are defined with `r"..."`, and matched using `match(regex, string)`.
- vectors can be used as stacks with the functions `push!`/`pushfirst!` and `pop!`/`popfirst!`
    * `push!` is also a common way in Julia to add new items to a vector
- string concatenation is:
    * `a * b` for two strings
    * `join(itr)` for a collection of strings and `join(itr, delim)` to insert delimiters
- to check if a string is a prefix of another use `startswith`
    * to use this as an argument to another function like `filter`/`filter!` we can use `filter(startswith(prefix), strings)`
    * the single argument form of `startswith(prefix)` is equivalent to `s -> startswith(prefix, s)`
- to extract just the first or last element from a container, use `first` and `last`
    * these are useful when storing data in ad-hoc structures like `(name, size)`
    * `first.(vectorofpairs)` returns a vector of just the first in each pair. Similar for `last.(vec)`
    * `sum`, `maximum`, `sort` can take an argument, so `sort(itr, by=first)` will sort a collection by comparing the first element in each item. Similarly, `sum(last, itr)` will sum the last element of each item.