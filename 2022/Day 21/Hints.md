General Hints
=============

Part 1 requires the equivalent of traversing a binary tree. Although the puzzle doesn't explicitly state it, it seems that each monkey is listened to by exactly one other (ie the graph of dependencies is not just acyclic but also a tree). The tricky part of the task is that the nodes of the tree (ie the monkeys that are listening for values) are given in no particular order, and ordering them is equivalent to constructing the tree.

So the first task is to determine how to (efficiently?) construct a tree or similar from a randomised ordered list of nodes.

Part 2 should probably be solved by some kind of reverse traversal of part of the tree. That is, since only one leaf node ("humn") doesn't have a value, one half of the tree (either left or right) can be calculated as in part 1. Then the task is to reverse engineer the required value for "humn".

Julia Functions
===============

- trees can be built from custom `mutable struct`s (as we need to build trees so we won't always know the parents/children at construction time).
    * references to other nodes can be left uninitialised using the incomplete initialisation pattern
    * or they can be declared as `Union{Nothing, Node}` type and initialised to `nothing`
- binary trees can also be compactly stored in a `Vector`
- functions are first-class objects in Julia so we can declare `structs` with `Function` fields
    * `+`, `-`, `*`, `÷` can be directly assigned to variables
    * if `f = +` then `f(1,2) == 1 + 2`
    