parseRegister(str) = first(str) - '`'
parseOffset(str) = parse(Int, str)

abstract type Instruction end
abstract type JumpInstruction end
struct Half <: Instruction
    register::UInt8
end
Half(r::AbstractString) = Half(parseRegister(r))
struct Triple <: Instruction
    register::UInt8
end
Triple(r::AbstractString) = Triple(parseRegister(r))
struct Increment <: Instruction
    register::UInt8
end
Increment(r::AbstractString) = Increment(parseRegister(r))
struct Jump <: JumpInstruction
    offset::Int
end
Jump(o::AbstractString) = Jump(parseOffset(o))
struct JumpIfEven <: JumpInstruction
    register::UInt8
    offset::Int
end
JumpIfEven(r::AbstractString, o::AbstractString) = JumpIfEven(parseRegister(r), parseOffset(o))
struct JumpIfOne <: JumpInstruction
    register::UInt8
    offset::Int
end
JumpIfOne(r::AbstractString, o::AbstractString) = JumpIfOne(parseRegister(r), parseOffset(o))

doInstruction!(s::State, h::Half) = (s.registers[h.register] ÷= 2; return false)
doInstruction!(s::State, t::Triple) = (s.registers[t.register] *= 3; return false)
doInstruction!(s::State, i::Increment) = (s.registers[i.register] += 1; return false)
doInstruction!(s::State, j::Jump) = (s.instpointer += j.offset; return true)
function doInstruction!(s::State, j::JumpIfEven)
    iseven(s.registers[j.register]) && (s.instpointer += j.offset)
    return iseven(s.registers[j.register])
end
function doInstruction!(s::State, j::JumpIfOne)
    s.registers[j.register] == 1 && (s.instpointer += j.offset)
    return s.registers[j.register] == 1
end