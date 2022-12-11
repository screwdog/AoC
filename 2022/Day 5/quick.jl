function day5(p1)
    stacks = []
    open("input.txt") do file
        line = readline(file)
        stacks = repeat([[]], length(line)÷4+1)
        while '[' ∈ line
            items = line[2:4:end]
            push!.(stacks, collect(items))
            line = readline(file)
        end
        filter!.((≠)(' '),stacks)
        readline(file)

        while !eof(file)
            line = readline(file)
            cmd = match(r"move (\d+) from (\d+) to (\d+)", line)
            n, s1, s2 = parse.(Int, cmd)
            items, stacks[s1] = stacks[s1][1:n], stacks[s1][n+1:end]
            p1 && reverse!(items)
            prepend!(stacks[s2], items)
        end
    end
    return String([first(stack) for stack ∈ stacks])
end

day5.([true, false])