General Hints
=============

The input here is more complicated than in previous days as each monkey corresponds to multiple lines, and one of the input lines is a function. Fortunately, it seems that the functions are limited to addition with a constant, multiplication by a constant, or squaring the input. This means we don't need to implement a full parser but can concentrate on these three forms only.

Part 2 of the puzzle, solved naively would require using BigInts (or similar) which is not only slow, but the numbers got so large my PC ran out of memory (!). Since we aren't actually interested in the worry values, except for determining how they are passed around, we don't need to accurately record their values, only their divisibility. If you're unsure how to manage this, look up the Chinese Remainder Theorem and modular arithmetic.

Julia Functions
===============

- custom types can be defined with `struct`/`mutable struct`
    * functions have type `Function`
    * vectors in immutable structs can still be modified - they just can't be assigned to a *different* vector
- defining custom types is often best done in a `module` (along with defining constants with `const`)
- `include(file)` inserts the contests of `file` at that point in the code. This means that dividing content between files is largely independent of types, modules or even packages.
- to interpret a string as Julia code use `Meta.parse` and then pass the result to `eval`
    * creating and then calling functions in this way can cause "world age" problems. Essentially, Julia's default way of calling functions doesn't work if a function can be defined on-the-fly. Using `Base.invokelatest`/`Base.@invokelatest` avoids this problem. (This is different from the default dispatch method and is slower but unlikely to be noticeable here)
- modular arithmetic functions include `mod`/`mod1`, `lcm`, and `gcd`.