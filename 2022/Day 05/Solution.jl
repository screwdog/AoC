"""
We process the input line-by-line, setting up the stacks and then performing
the required moves.

We use a vector of Char[] as our crate stacks. It is easier to simply extract
crate labels for each stack line-by-line and discard blank labels later (as not
all stacks are equal height to begin with).

Once the stacks are initialised we process the instructions line-by-line and
execute each command in a single step. That is, we move all the crates in one
move rather than crate-by-crate.
"""
function day5(p1)
    # stacks can't be initialised until we know how many there will be - which
    # requires reading from the file. But that occurs within an anonymous function
    # and so we must declare the variable here so we can access it to calculate the
    # return value.
    local stacks
    open("input.txt") do file
        line = readline(file)
        # since vectors are mutable, a vector of vectors is best initialised with a
        # comprehension, rather than using `fill`
        stacks = [[] for i ∈ 1:(length(line)+1)÷4]
        while '[' ∈ line
            items = line[2:4:end]           # extract crate labels
            # putting . after a function name is called "broadcasting" and allows
            # functions for scalars to operate element-wise on collections. Here we
            # want to push!(stack, item) for stack ∈ stacks, item ∈ collect(items)
            # Since stacks and collect(items) have the same number of elements we can
            # simplify this using the . syntax.
            push!.(stacks, collect(items))
            line = readline(file)
        end
        # We again use broadcasting, but here isletter isn't a collection so it isn't
        # iterated over. This is equivalent to filter!(isletter, stack) for stack ∈ stacks
        filter!.(isletter, stacks) # remove blank labels from stacks
        readline(file)

        while !eof(file)
            line = readline(file)
            cmd = match(r"move (\d+) from (\d+) to (\d+)", line)
            n, s1, s2 = parse.(Int, cmd)
            # top of each stack is at the front, so extract from there
            items, stacks[s1] = stacks[s1][1:n], stacks[s1][n+1:end]
            p1 && reverse!(items)
            # add to front (top) of stack
            prepend!(stacks[s2], items)
        end
    end
    return join([first(stack) for stack ∈ stacks])
end
# To return results for part 1 and 2 we call twice, with p1 = true and p1 = false. By putting
# these values into a collection we can use the . syntax. Note the return value is the same kind
# of collection - a vector - as if we called map(day5, [true, false]).
day5.([true, false])