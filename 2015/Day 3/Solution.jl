move = Dict([
        '^' => [ 0, 1],
        'v' => [ 0,-1],
        '>' => [ 1, 0],
        '<' => [-1, 0]
        ])

function day3p1()
    loc = [0,0]
    houses = Set([loc])
    open(raw"C:\Users\rayha\Desktop\AoC\2015\Day 3\input.txt") do file
        while !eof(file)
            loc += move[read(file,Char)]
            houses = houses ∪ [loc]
        end
    end
    return length(houses)
end

function day3p2()
    santaloc = [0,0]
    roboloc = [0,0]
    houses = Set([santaloc])
    open(raw"C:\Users\rayha\Desktop\AoC\2015\Day 3\input.txt") do file
        while !eof(file)
            santaloc += move[read(file,Char)]
            houses = houses ∪ [santaloc]
            eof(file) && break
            roboloc += move[read(file,Char)]
            houses = houses ∪ [roboloc]
        end
    end
    return length(houses)    
end

(day3p1(), day3p2())