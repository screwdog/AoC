done(s::State, program) = s.instpointer ∉ axes(program, 1)

function step!(s::State, program)
    instruction = program[s.instpointer]
    doInstruction!(s, instruction) || (s.instpointer += 1)
end

function runprogram!(s::State, program)
    while !done(s, program)
        step!(s, program)
    end
    return s
end