function day3p1()
    Σ = 0
    open(raw"C:\Users\rayha\Desktop\AoC\2022\Day 3\input.txt") do file
        while !eof(file)
            backpack = readline(file)
            numitems = length(backpack)÷2
            pocket1, pocket2 = first(backpack, numitems), last(backpack, numitems)
            common = (pocket1 ∩ pocket2)[1] # we assume there's exactly 1 item in common!
            Σ += isuppercase(common) ? common - 'A' + 27 : common - 'a' + 1
        end
    end
    return Σ
end
day3p1()