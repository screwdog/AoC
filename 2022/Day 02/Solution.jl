"""
Hardcode the points for each play into matrices for parts 1 and 2.
Note the natural expression for matrix literals.
"""
function day2()
    p1points = [ # Points for result
        3 6 0
        0 3 6
        6 0 3
    ]     +    [ # Points for shape selected
        1 2 3
        1 2 3
        1 2 3
    ]

    p2points = [ # Points for shape selected
        3 1 2
        1 2 3
        2 3 1
    ]     +    [ # Points for result
        0 3 6
        0 3 6
        0 3 6
    ]

    Σ = [0, 0] # sums for parts 1 and 2
    open(raw"input.txt") do file
        while !eof(file)
            line = readline(file)
            # '@' is the character immediately preceding 'A'
            p1, p2 = line[1] - '@', line[3] - 'W'
            # Vectors of equal length can be added directly
            Σ += [p1points[p1, p2],
                  p2points[p1, p2]]
        end
    end 
    println("Part 1: $(Σ[1])\nPart 2: $(Σ[2])")
end
day2()