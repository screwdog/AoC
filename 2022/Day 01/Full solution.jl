top3 = [0,0,0]
open(raw"C:\Users\rayha\Desktop\AoC\2022\Day 1\input.txt") do file
    elfSum = 0
    while !eof(file)
        line = readline(file)
        if line != ""
            cals = parse(Int, line)
            elfSum += cals
        else
            if elfSum > top3[1]
                position = searchsortedfirst(top3, elfSum)
                insert!(top3, position, elfSum)
                popfirst!(top3)
            end
            elfSum = 0
        end
    end
end
println("Task 1: $(top3[end])\nTask 2: $(sum(top3))")