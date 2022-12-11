function day2()
    points =   [3 6 0
                0 3 6
                6 0 3]
    Σ = 0
    open(raw"C:\Users\rayha\Desktop\AoC\2022\Day 2\input.txt") do file
        while !eof(file)
            line = readline(file)
            p1, p2 = line[1] - '@', line[3] - 'W'
            Σ += p2 + points[p1, p2]
        end
    end
    return Σ
end
day2()