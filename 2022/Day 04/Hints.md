General Hints
=============

The key task here is to identify whether two ranges are either subsets of each other (or in part 2, whether they overlap). This can be done easily using simple comparisons or perhaps with other language features if present.

The other task is to convert the input into a useable form - extracting the numbers from the separating characters, converting to a numeric type and possibly bundling into a helpful type.

Julia Functions
===============

- `split` (possibly with `isdigit`) can be used to separate a string into its substrings, along with removing some characters.
- alternatively, `match` uses regular expressions to process strings. Regexes can be defined with the `r"..."` syntax.
- strings are converted to numeric types with `parse` (especially `parse(Int,...)`) or `tryparse`.
- Julia accepts unicode equivalents for the usual comparison operators:
    * `≤` (\le<tab>) for `<=`
    * `≥` (\ge<tab>) for `>=`
    * `≠` (\ne<tab>) for `!=`
- ranges (particularly `UnitRange`) are lightweight data structures commonly used in Julia. These are used in expressions like `for x = 1:10` or `A[3:6]` but are also useful in their own right to represent a regular sequence.
    * construct a range using `a:b` or `range(a, b)`
    * different step sizes can be specified with `start:step:stop` or `range(; step = ...)`
    * non-integer types work as expected (ie `3.2:7.4`)
    * even chars can be used, like `'a':'e'`
    * Julia's base library has many different range types but we rarely need to worry about exactly which type we are using as `:` and `range` will generally select the most efficient one
    * care must be taken when using the `:` syntax as it has a very low operator precedence. This is so we can write natural expressions like `for x = 1:length(A)-2` - notice that we expect the subtraction to be applied first. So `a+b:c+d` won't work as expected and `(a+b):(c+d)` is needed instead.
- ranges can be used with all the usual set operations:
    * `intersect`/`∩`(\cap<tab>)
    * `union`/`∪`(\cup<tab>)
    * `setdiff`
    * `issubset`/`⊆`(\subseteq<tab>)/`⊇`(\supseteq<tab>)
    * `isdisjoint`
- `intersect(range1, range2)` and `setdiff(range1, range2)` return range objects (unless their result is the empty set, when they return `[]`), but because the union of disjoint ranges is not, itself, a range object, `union` returns a vector.
    * `r1 ∪ r2` returns the equivalent of `collect(r1) ∪ collect(r2)`. This ensures that it is type-stable (the type of the result doesn't depend on the *value* of it's operands).
    * this can cause performance problems. `sizeof((1:1_000_000)) == 16`, but `sizeof((1:1_000_000) ∪ (1:1)) == 8_000_000`
    * `reduce` (and variants) will often fail with `∪` because its intermediate values are a different type to its inputs. However, `union(A...)` can be used for an equivalent operation.