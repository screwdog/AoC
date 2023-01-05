top3 = [0,0,0]
open(raw"input.txt") do file
    elfsum = 0
    while !eof(file)
        line = readline(file)
        if line != "" 
            cals = parse(Int, line)
            elfsum += cals
        else
            if elfsum > minimum(top3)
                top3[argmin(top3)] = elfsum
            end
            elfsum = 0
        end
    end
end
println("Task 1: $(maximum(top3))\nTask 2: $(sum(top3))")