General Hints
=============

Part 1 is not overly complex, requiring a structure to record which locations
are blocked, some way of representing the various falling blocks, and the jets
of air.

From there the physics are fairly straightforward and so we need only be
efficient enough that we can drop the required number of blocks.

Part 2 was, for me, the hardest task in all the puzzles this year. To drop a
trillion blocks is unfeasible on a modern PC, no matter how efficient your code.
This will require a different approach.

Since the blocks fall in a deterministic fashion, the state of the tower that is
built is entirely determined by the sequence of blocks, the sequence of air
jets, and the shape of the region that the blocks can fall into. For example,
if after dropping some number of blocks we find that we are again in a position
to drop the first shape of block, that the air jets are back to the first in the
sequence, and that the tower somehow has a flat top to it like the initial floor
then we can know for sure that the tower will continue to grow in exactly the
same way as in the beginning.

More broadly, if some state of the (chamber, blocks, air jets) is equivalent to
some previous state then the state will evolve identically from there. Once this
happens then the state of the system becomes periodic.

By finding a point where the sequence of states becomes periodic we can then
calculate the height of the tower at these points and use that to calculate how
high the tower would be after a trillion blocks.
