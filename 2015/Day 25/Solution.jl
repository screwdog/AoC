using Underscores
const CODE = 20151125
const MUL = 252533
const MOD = 33554393

function readdata()
    @_ "input.txt"              |>
        readchomp               |>
        eachmatch(r"(\d+)", __) |>
        first.(__)              |>
        parse.(Int, __)
end

onDiagonal(i, j) = i + j - 1
onDiagonal(n) = trunc(Int, cld(sqrt(8n+1)-1, 2))
endOfDiagonal(d) = d*(d+1)÷2
nextcode(code) = mod(code*MUL, MOD)

function nthcode(n)
    code = CODE
    for _ ∈ 2:n
        code = nextcode(code)
    end
    return code
end

function codeAt(i, j)
    diag = onDiagonal(i, j)
    prevDiag = endOfDiagonal(diag-1)
    posOnDiag = j
    return nthcode(prevDiag + posOnDiag)
end

function day25()
    i, j = readdata()
    return codeAt(i, j)
end
@time day25()