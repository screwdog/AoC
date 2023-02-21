General Hints
=============

Part 1 of the puzzle is quite straight-forward. We need to read the board and directions and then traverse the board, stopping for walls and wrapping as necessary.

Part 2 is significantly more complicated. To implement a general solution requires us to simulate "folding" the board into a cube. There are two main approaches: either move around the 2D board and only consider the cube aspect when stepping into a blank space, or convert the board into a cube and carry out 3D movements throughout.

The fully 3D approach has the advantage that familiar 3D movement can be utilised throughout, especially if we construct a 52x52x52 array of locations then each step simply increments or decrements one coordinate and changing faces and directions happen when moving out of bounds.

However, most of the complexity of part 2 comes from the "folding" process, which is still necessary in a fully 3D approach. Also, the example and the calculation of password implies a 2D approach. There we still need to calculate how each face is connected to each other but we only use this information when the current position is moved into a blank space or out of bounds.

One approach to folding the cube is to start at some face and then conduct a breadth-first search of all faces from that, keeping track of which direction each face is from the other. An alternative approach is to trace the outer edge of the cube net and assign these edges in pairs that connect to each other in the cube.
