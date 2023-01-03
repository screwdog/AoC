const NUM_REGISTERS = 2
const R_A = 1
const R_B = 2

mutable struct State
    instpointer::UInt
    registers::Vector{UInt}
end
function State(part2)
    regvals = zeros(UInt, NUM_REGISTERS)
    part2 && (regvals[R_A] = 1)
    State(1, regvals)
end

register(s::State, r) = s.registers[r]