General Hints
=============

Manipulating stacks of crates very strongly suggests some kind of stack data structure. The format of the input text is more complex than previously with it being divided into two sections and the top section being laid out in a way that is easy for humans to understand but challenging to convert into a useful format.

The first task is to read in and interpret the initial stack setup. Possible approaches include going line-by-line, starting at the bottom of the stacks and reading upwards, or converting to a 2D data structure and transposing to convert row-by-row input into column-by-column stacks.

The next task is to simulate the crate movement using stack operations. Most languages have built-in stack datatypes to make this easy.

Julia Functions
===============

- strings can be split at blank lines with `split(str, "\n\n")`, or into lines with `split(str, "\n")` (for Unix-style line terminators. Windows uses "\r\n", classic MacOS used "\r")
- equally spaced elements of a string can be extracted with `str[start:step:stop]`
- strings can be converted to vectors of chars with `collect(str)`
- regular expressions are:
    * defined with `r"regex string"`
    * applied with `match` or `eachmatch`
- vectors and strings can be reversed with `reverse`/`reverse!`, or iterated over in reverse using a range like `start:-1:stop`
- elements can be removed from strings or vectors with `filter`/`filter!`
    * char testing functions include `isletter` and `isspace`
- vectors can be used as stacks with:
    * `push!` or `pushfirst!` to add items
    * `pop!` or `popfirst!` to remove items
- multiple items can be accessed with:
    * `splice!` to add and remove
    * `append!` and `prepend!` to add
    * `V = V[1:n]` or `V = V[end-n+1:end]` to remove
    * `V = first(V, n)` or `V = last(V, n)` to remove
- be careful if using `fill` with mutable types (ie to initialize stacks). `fill([], ...)` will return a number of aliases to *the* *same* vector, which is rarely what is desired.