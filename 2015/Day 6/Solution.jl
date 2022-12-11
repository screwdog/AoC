function day6p1()
    transforms = Dict([
        "turn on" => A -> fill(true, axes(A)),
        "turn off" => A -> fill(false, axes(A)),
        "toggle" => A -> .!A
        ])
    
    lights = fill(false, (1000,1000))
    open(raw"C:\Users\rayha\Desktop\AoC\2015\Day 6\input.txt") do file
        while !eof(file)
            line = readline(file)
            command = match(r"(.*) (\d+),(\d+) through (\d+),(\d+)", line)
            cmdtext = command.captures[1]
            top, left, bottom, right = parse.(Int, command.captures[2:end]) .+ 1
            lights[top:bottom, left:right] =
                transforms[cmdtext](lights[top:bottom, left:right])
        end
    end
    return count(lights)
end

function day6p2()
    transforms = Dict([
        "turn on" => 1,
        "turn off" => -1,
        "toggle" => 2
        ])
    
    lights = fill(0, (1000,1000))
    open(raw"C:\Users\rayha\Desktop\AoC\2015\Day 6\input.txt") do file
        while !eof(file)
            line = readline(file)
            command = match(r"(.*) (\d+),(\d+) through (\d+),(\d+)", line)
            cmdtext = command.captures[1]
            top, left, bottom, right = parse.(Int, command.captures[2:end]) .+ 1
            lights[top:bottom, left:right] .+= transforms[cmdtext]
            lights[top:bottom, left:right] = max.(lights[top:bottom, left:right], 0)
        end
    end
    return sum(lights)
end

(day6p1(), day6p2())