General Hints
=============

The key challenge here is in correctly scoring each round. This
could be done either by lookup or perhaps using modular arithmetic.
Also important is converting the input into a usable form.

Julia Functions
===============

- file access functions (per day 1 hints) include `open`, `read`, `readline`, and `readlines`
- modular arithmetic can be done using `%`, `mod(n, m)`, `mod(n, range)` or `mod1`, as necessary
- converting `Char`s to numeric types can be done with:
    * `Int(c)` to get the Unicode (ASCII) value of the char
    * `char1 - char2` gives the difference in values as an `Int`, so `'Y' - 'W' == 2`. This doesn't work for single character strings like `"Y"`, only chars like `'Y'`.
    * similarly, `'W' + 2 == 'Y'`
    * indexing a single location in a string returns a char: `"Julia"[3] == 'l'`
- matrix (2D array) literals can be entered using:
    * `A = [1 2 3; 4 5 6; 7 8 9]`: note the spaces between elements in each row, and semicolons at the end of each row
    * Julia uses the mathematical convention that `A[2,1] == 4`. That is, `A[i,j]` is the ith row and jth column
    * The rows can also be separated with new-lines instead of semicolons for a more readable format
- dictionaries can be created using `Dict`. Helpful functions are:
    * `d = Dict()` creates an empty dictionary
    * `d[key] = value` assigns a key-value pairing, from which `d[key] == value`
    * `a => b` creates a `Pair`, which is a simple data type in Julia. Any iterator (such as a vector) of pairs can be used to initialise a dictionary.
    * `d = Dict(["A" => 1, "B" => 2, "C" => 3])` creates a new dictionary that associates strings to integers. For example, `d["A"] == 1`.