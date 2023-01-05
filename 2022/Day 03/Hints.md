General Hints
=============

The key task here is to determine which letters strings have in common. Underpinning this we also need to read the input, split it appropriately and convert characters to numbers to calculate their "priority".

Julia Functions
===============

- reading the input line by line is still possible here using `open`, `readline`, and `eof`. Part 2 is trickier and might be easier with `readlines`.
- to find the common items in two collections we can use `intersect`/`∩` (\cap<tab>). This works for any iterables, including strings (which get treated as vectors of chars). Note that `a ∩ b` returns a vector of chars, rather than a string.
- splitting a string by length can be done by:
    * indexing using a range: `str[a:b]` returns the substring between positions `a` and `b`
    * `first(str, n)` returns the first n characters. `last(str, n)` returns the last n.
- `length(str)` returns the length of a string
- `/` performs floating point division in Julia, and `round(x)` rounds to an integer but doesn't convert to an integer type!
    * integer division is done using `div`/`÷` (\div<tab>)
    * alternatively, `round(Int, x)` converts to an integer type
    * since Julia is heavily used in numerical computing there are a host of related functions: `trunc`, `floor`, and `ceil` for working with floating point numbers
    * functions like `divrem`, `fld`, `cld`, etc do integer division without intermediate floating point types
- converting chars to numbers can be done with `char1 - char2` (see hints for previous days)
    * alternatively we can `findfirst(c, alphabet)` to give us the index of a character
    * ranges of characters are possible (like `'a':'z'`) and `join` can convert them into strings
    * strings can be concatenated with `*` (not `+` like in other languages!)
    * analogously, repeating a string is `str^n`, not `str*n` as in other languages