General Hints
=============

The key task here is to search possible solutions to find the sequence of robot production that maximises geode harvesting. The obvious approach is to perform a depth-first search on a tree structure of a some kind.

However, a naive approach (like in day 16) leads to a very large number of states needing to be searched so we need to find ways of excluding a large number of them.

Firstly, if we decide to create a particular type of robot it is never optimal to delay building it any longer than necessary to gather sufficient resources. That is, if at some point during production the next robot we build is going to be a clay robot, say, then we should always build it as soon as possible.

So, as in day 16, instead of considering our actions minute-by-minute, we can instead consider a sequence of robots to be built. That is, the example given in the puzzle could be thought of as simply the sequence [clay, clay, obsidian, clay, obsidian, geode, geode].

Unfortunately this doesn't remove nearly enough states from consideration. The next optimisation we make is to not make superfluous robots. If no robot needs more than 5 ore to be made then we never need more than 5 ore robots because they will make enough ore every minute for any production.

This may still not be fast enough, so another optimisation we can make is to keep track of the best solution found so far and exclude any states that are incapable of beating it. A simple, but surprisingly effective upper bound is that the maximum geode production for a state is no more than 0 + 1 + ... + n = n(n-1)÷2, where n is the time remaining.

With these optimisations both parts should be solvable in a reasonable time.

Julia Functions
===============

This problem is embarrassingly parallel and Julia makes parallel processing easy.

- `Base.Threads` provides a simple interface for multi-threading. Set the number of threads available to Julia by using the command line option `julia --threads n` (or `julia --threads auto`).
    * `Threads.@threads` runs any `for` loop with independent loop bodies across multiple threads.
    * as long as we can write our loop body to, say, store the result in an array, this is all that's needed to make our code multi-threaded.
- The `Distributed` module in the standard library provides a more general distributed computing approach. The command line option `julia --procs n` (or `julia --procs auto`) sets the number of additional worker processes.
    * Julia always has an interactive process in addition to the worker processes. So `--procs 4` will start Julia with 5 processes in total.
    * `@distributed` runs any `for` loop across all worker processes. It can also optionally reduce the result.
    * `pmap` is a drop-in replacement for `map` that executes in parallel on all worker processes.
    * `@everywhere` evaluates expressions on worker processes. This is necessary as processes don't share memory, and don't share function definitions.
