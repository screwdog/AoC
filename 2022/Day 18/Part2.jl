"""
`outersurface(droplet) -> Int`

Count the number of cube sides that can be reached by the water and steam.
"""
function outersurface(droplet)
    # this is a basic modification of Dijkstra's algorithm.

    # we search the space external to the droplet, counting the number of
    # adjacent cube sides we encounter. This works because every externally
    # facing side is between an external open space and a filled cube, and since
    # `droplet` has a margin of open air around it (added during creation) we
    # can be sure that the external open space forms a single connected region.
    outerfaces = 0

    # processed keeps track of which locations we've processed. By copying
    # droplet and using the standard array indexing we can leverage the
    # custom behaviour of the droplet type without changing our algorithm.
    processed = copy(droplet)
    stack = [CartesianIndex(1,1,1)]

    while !isempty(stack)
        cube = popfirst!(stack)
        processed[cube] && continue
        processed[cube] = true

        ns = filter(c -> checkbounds(Bool, droplet, c), Ref(cube) .+ neighbours)
        outerfaces += sum(droplet[ns])
        filter!(c -> !droplet[c], ns)
        append!(stack, ns)
    end
    return outerfaces
end
