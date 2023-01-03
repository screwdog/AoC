INSTRUCTIONS = Dict([
    "hlf" => Half,
    "tpl" => Triple,
    "inc" => Increment,
    "jmp" => Jump,
    "jie" => JumpIfEven,
    "jio" => JumpIfOne
])
instruction(strs) = INSTRUCTIONS[strs[1]](strs[2:end]...)

tokenise(str) = split(str, [' ', ','], keepempty=false)
function readprogram(filename)
    @_ filename             |>
        readlines           |>
        lowercase.(__)      |>
        tokenise.(__)       |>
        instruction.(__)
end