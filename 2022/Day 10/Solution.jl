"""
`day10()`

Calculates the answer to both parts 1 and 2 of Advent of Code 2022, day 10,
reading input from "input.txt". That is, interprets the pseudo-assembly code
and calculates the correct value for the register X at each clock cycle. This
is then used to calculate the signal strength (for part 1) and the display
(for part 2).
"""
function day10()
    # returns a tuple of (Bool, Int), where the first element is whether this
    # instruction requires 2 cycles to process, and the 2nd element is the
    # change in the register X value.
    function nextinstruction(file)
        line = readline(file)
        m = match(r"(?:noop|addx\s+(-?\d+))", line)
        # noop instruction results in no capture group, so first(m) === nothing
        first(m) === nothing && return (false, 0)
        return (true, parse(Int, first(m)))
    end

    CYCLES = 20:40:220
    signal = 0
    display = fill(' ', 40, 6)

    cycle = 1; X = 1; skipread = false; δ = 0
    open("input.txt") do file
        while !eof(file)
            cycle ∈ CYCLES && (signal += cycle*X)
            # X register indicates a 0-based index into a 40-wide display. But
            # it is synced to a 1-based cycle number. That is, if the pixels
            # in positions X-1:X+1 in a 0-based array correspond to the current
            # cycle number, modulo the range 1:40, then the pixel is drawn.
            # Converting the X range to be 1-based gives the range X:X+2

            # Also, matrices can also accept linear indexing, so we don't need
            # to calculate the appropriate row/column when indexing it here
            X ≤ mod1(cycle, 40) ≤ X+2 && (display[cycle] = '█')

            # if the previous instruction takes two cycles to process, and we
            # are in the 2nd cycle, don't read the next instruction but instead
            # apply the change in X
            if skipread
                skipread = false
                X += δ
            else
                skipread, δ = nextinstruction(file)
            end
            cycle += 1
        end
    end
    # Because we wanted to set our display row-by-row, but Julia prefers to
    # store matrices in column-major, each row of the display actually
    # corresponds to a column of our display matrix.
    return signal, join(join.(eachcol(display)), "\n")
end
println.(day10());