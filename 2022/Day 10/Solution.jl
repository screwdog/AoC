function day10()
    function nextInstruction(file)
        line = readline(file)
        m = match(r"(?:noop|addx\s+(-?\d+))", line)
        return first(m) === nothing ? (false, 0) : (true, parse(Int, first(m)))
    end

    CYCLES = 20:40:220
    Σ = 0
    display = fill('.', 40, 6)

    cycle = 1; X = 1; skipread = false; δ = 0
    open("input.txt") do file
        while !eof(file)
            cycle ∈ CYCLES && (Σ += cycle*X)
            abs(X + 1 - mod1(cycle, 40)) ≤ 1 && (display[cycle] = '#')

            if skipread
                skipread = false
                X += δ
            else
                skipread, δ = nextInstruction(file)
            end
            cycle += 1
        end
    end
    formatOutput(M) = join(join.(eachrow(permutedims(M))), "\n")    
    return Σ, formatOutput(display)
end
println.(day10())