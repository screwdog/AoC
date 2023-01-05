using Underscores
# Underscores.jl allows use of @_ which simplifies anonymous function definitions with __ and _.
# Many, many, alternatives exist: Pipe.jl, Lazy.jl, Chain.jl, Hose.jl, DataPipes.jl, etc
# There are advantages to each so definitely explore your options if you don't already use a
# package like these.

"""
This solution uses the pipe |> operator to represent the work-flow as a sequence of functions.
Here, __ represents the results of the previous step (usually the entire vector) and _ represents
a single item in that vector (here itself a vector of strings).

Best practice in Julia is to define functions rather than scripts, which we do here.
"""
function day1()
    @_ "input.txt"                      |>
        readchomp                       |> # read input as a single string
        split(__, "\n\n")               |> # split at empty lines (ie into elves)
        split.(__)                      |> # split each elf's calories
        map(parse.(Int,_), __)          |> # convert all to integers
        sum.(__)                        |> # sum each elf's calories
        partialsort(__, 1:3; rev=true)  |> # only need top 3
        (__[1], sum(__))                   # return highest, and sum of top 3
end
day1()
