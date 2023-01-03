module Day23
using Underscores
include("CPUState.jl")
include("Instructions.jl")
include("Data.jl")
include("Program.jl")

function day23(part2)
    state, program = State(part2), readprogram("input.txt")
    runprogram!(state, program)
    return Int(register(state, R_B))
end
end;