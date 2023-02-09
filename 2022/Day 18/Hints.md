General Hints
=============

Perhaps the obvious approach to part 1 is to create a 3D array of boolean values
that indicates whether a location has a cube of the droplet in it, then iterate
over these locations checking if its neighbouring locations are empty.

An alternative approach would be to keep the data as a list of locations. The
challenge then is to efficiently determine whether neighbouring locations are
present in the list.

Part 2 is more complex. One approach is to "fill in" voids within the droplet
and then repeat the process of part 1 now that all open sides will be on the
outside. However, attempting to find and fill voids directly would require
iterating over all open spaces and so it suffices to instead traverse all
outside spaces instead.

The input is likely structured so that all external open spaces form a single
connected space but this is not guaranteed and so additional steps may be
necessary.

Once the external space has been traversed we could use this data to fill in all
internal voids, but we could also simply count the external open sides while
doing this traversal.
