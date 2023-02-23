General Hints
=============

The two basic approaches here are to either construct a 2D array to store which locations contain elves, or to store just the locations of the elves. The first is mostly straightforward but a general solution would require some method to expand the array if any elf tries to move off the edge. Also, if the elves are too spread out this could require quadratic storage for a constant number of elves.

A list of elf locations is most efficiently queried in some kind of hash set or similar structure. However, even using this, part 2 can be surprisingly computationally intensive. A significant optimisation comes from recognising that conflicting proposed moves can only occur when elves are in a very particular arrangement and so we need only check one particular location when proposing a move.

Julia Functions
===============

* `Set` implements a unique collection of items with amortised constant look-up time.
    - `union`/`union!` can add new items to a set but the new items must be in a collection.
    - `push!` allows adding individual items into a set.
    - `setdiff`/`setdiff!` removes items but again, they must be in a collection.
    - `delete!` removes individual items.
    