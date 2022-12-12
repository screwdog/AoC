function day4()
    contain, overlap = 0, 0
    open(raw"C:\Users\rayha\Desktop\AoC\2022\Day 4\input.txt") do file
        while !eof(file)
            line = readline(file)
            sections = match(r"(\d+)-(\d+),(\d+)-(\d+)", line)
            nums = parse.(Int, sections)
            range1, range2 = nums[1]:nums[2], nums[3]:nums[4]
            (range1 ⊆ range2 || range1 ⊇ range2) && (contain += 1)
            !isdisjoint(range1, range2) && (overlap += 1)
        end
    end
    return (contain, overlap)
end
day4()