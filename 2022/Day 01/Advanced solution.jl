using Underscores
@_ "input.txt"                      |>
    readchomp                       |> # read input as a single string
    split(__, "\n\n")               |> # split at empty lines (ie into elves)
    split.(__)                      |> # split each elf's calories
    map(parse.(Int,_), __)          |> # convert all to integers
    sum.(__)                        |> # sum each elf's calories
    partialsort(__, 1:3; rev=true)  |> # only need top 3
    (__[1], sum(__))                   # return highest, and sum of top 3
