General Hints
=============

Today's puzzle involves optimal traversal which suggests using a shortest path algorithm. Since the obstacles (blizzards) are moving one approach is to extend the problem space into a third, time, dimension. Since the blizzard movement patterns are cyclic, the state of the valley repeats every lcm(valley_width, valley_height) turns and so we can represent the state space as a 3D array, where position (x, y, t) is the position (x, y) in the valley at time t.

Then, the blizzards can be represented as fixed obstacles on each time slice with their arrangement changing predictably at each time step. This space can then be traversed using any graph traversal algorithm, with the proviso that the target space is now the set of spaces (finish_x, finish_y, :).

However, in this case the topology of the solution space is especially simple and we can do this much more efficiently. We need only ever keep track of the current state - where the blizzards are and which spaces the expedition could be in - in order to calculate the next state. And this can be done with fairly simple matrix operations.

Calculating step by step also makes part 2 simpler as we can just repeat the process three times.

Julia Functions
===============

* `circshift`/`circshift!` rotates the elements of an array (analogous to `bitrotate`), which can be useful to matrices of blizzard locations.

This is a fairly simple puzzle but can be surprisingly computationally intensive. The following may help:

* broadcasting (`.` syntax) generally creates a new array of results and so can be inefficient. This can be easily improved when performing array operations with the `@view` and `@views` macros.
* `@time` provides basic timing and memory use information.
   - `BenchmarkTools` provides `@btime` which is used similarly but provides much more accurate benchmarking information.
* `Profile` provides `@profile` to gather more detailed profiling information. This combines well with `PProf.pprof` for investigating performance issues.
* `Profile.Alloc.@profile` allows more precise tracking of memory allocations, and then the results can be viewed with `PProf.Alloc.pprof`.