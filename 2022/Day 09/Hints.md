General Hints
=============

The main task here is the calculation of the tail/knot movement. Be sure to carefully read the puzzle description! The other task is to accurately count the number of spaces that the tail has traversed.

Julia Functions
===============

- `max`/`maximum`, `abs`, and `sign` may be useful in calculating the tail movement.
- `Set`, `unique`/`unique!` are useful in counting the number of unique elements
    * the size of a `Set` is given by `length`
    * elements can be added to a `Set` with `union`/`union!` or even `push!`
- Julia allows variables names to consist of all underscores (ie `_`, `__`, etc)
    * these can't be assigned to and are often used in iteration to indicate that the iteration variable is unimportant.
    * for example, `for _ = 1:10` will repeat the loop 10 times but the value of `_` can't be accessed