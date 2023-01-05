General hints
=============

This is a straightforward task if you've been programming for a while but the key tasks (not necessarily in this order) are:
* read the input file
* convert the input into a numeric format
* sum the calories for each elf
* find:
    - the highest value (part 1)
    - sum of the highest three values (part 2)

Julia functions
===============

- if you need to refer to file paths, `raw"C:\Path\To\File"` is helpful for avoiding having to quote special characters
- file access functions include:
    * `open` (especially `open(...) do file ... end`), using `readline` and `eof`
    * `read(filename, String)` to read the whole file as a string
    * `readchomp` as above but discarding any final new line character
    * `readlines` returns a `Vector` of lines
- `parse` is used to convert strings to numeric types
- finding the largest/smallest in a collection can be done with functions like:
    * `maximum` (or `findmax`, `argmax`, etc)
    * `sort`/`sort!`
    * or more efficiently `partialsort`/`partialsort!`
- if you want to maintain a list (actually `Vector`) of values, you might find these functions helpful:
    * `push!` or `pushfirst!`
    * `pop!`
    * `insert!`
- finding items in vectors can be done with:
    * `findall`, `findfirst`, `findnext`, etc
    * if the vector is already sorted, using `searchsorted`, `searchsortedfirst`, etc