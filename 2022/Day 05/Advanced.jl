using Underscores

readdata(filename) = @_ filename    |>
    readchomp                       |>
    split(__, "\n\n")               |>
    split.(__, "\n")

initstacks(stacklines) = @_ stacklines[1:end-1] |>  # exclude the line of stack numbers
    reverse                                     |>  # work from the bottom up
    map(_[2:4:end], __)                         |>  # extract the crate labels only
    collect.(__)                                |>
    hcat(__...)                                 |>  # convert to matrix, each stack as a row
    eachrow                                     |>
    vec.(__)                                    |>
    filter.(isletter, __)                           # remove blank spaces from stacks

initcommands(commandlines) = @_ commandlines        |>
    match.(r"move (\d+) from (\d+) to (\d+)", __)   |>
    map(parse.(Int, _), __)

function docommand!(stacks, n, from, to, part2)
    # top of each stack is at the end, so remove the last n items
    items, stacks[from] = last(stacks[from], n), stacks[from][1:end-n]
    part2 || reverse!(items)
    append!(stacks[to], items)
end

function day5(part2)
    stacklines, commandlines = readdata("input.txt")
    stacks, commands = initstacks(stacklines), initcommands(commandlines)
    for (n, from, to) ∈ commands
        docommand!(stacks, n, from, to, part2)
    end
    # return a string of the top crate in each stack
    return join(last.(stacks))
end
day5.(false:true)