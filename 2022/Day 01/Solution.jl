"""
We use a while loop as such iteration is highly performant in Julia and
often makes for very readable code (compare to Advanced.jl for readability).

Many functions in Julia take a function as their first argument and these can
be written using `do` blocks. These allow you to define an anonymous function
to pass as the first argument in a natural fashion. For example, `open` takes
a function as its first argument and applies this to the file that it opens,
ensuring the file is closed once the function is complete. We use a `do` block
to write this anonymous function.

Iterating over the lines in the file is not only an obvious approach but is also
efficient and means that we don't have to store the whole file in memory. In this
case it doesn't matter but the following code works for files of any size.

Julia allows, and even encourages usage of many Unicode characters from mathematics.
Here we use ≠ instead of the traditional !=, although they are equivalent. To input
this symbol, type \ne<tab> in most Julia editors. In the REPL, type ? to enter help
mode and copy and paste the symbol for more information.
"""
function day1()
    top3 = [0,0,0] # three highest calorie values found so far
    open(raw"input.txt") do file
        elfsum = 0
        while !eof(file)
            line = readline(file)
            if line ≠ "" # current elf's input is finished?
                cals = parse(Int, line)
                elfsum += cals
            else
                # current elf's calories is in the top 3?
                if elfsum > minimum(top3)
                    # replace the lowest value in the top 3 with the new value
                    top3[argmin(top3)] = elfsum
                end
                elfsum = 0
            end
        end
    end
    println("Part 1: $(maximum(top3))\nPart 2: $(sum(top3))")
end
day1()