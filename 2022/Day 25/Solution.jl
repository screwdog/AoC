using Underscores
CHARS = Dict([
    -2 => '=',
    -1 => '-',
     0 => '0',
     1 => '1',
     2 => '2',
])
DIGITS = Dict(values(CHARS) .=> keys(CHARS))

padSNAFU(str, len) = lpad(str, len, CHARS[0])
SNAFU2vec(str) = map(c -> DIGITS[c], collect(str))
vec2Dec(v) = foldl((a,b) -> 5a + b, v)
function _normdigit!(v)
    r = mod(v[end], -2:2)
    v[1] += (v[end] - r)÷5
    v[end] = r
end
function normalise!(v)
    for i ∈ reverse(2:size(v, 1))
        abs(v[i]) > 2 && @views _normdigit!(v[i-1:i])
    end
    while abs(v[1]) > 2
        pushfirst!(v, 0)
        @views _normdigit!(v[1:2])
    end
    return v
end
vec2SNAFU(v) = join(map(d -> CHARS[d], normalise!(v)))

function day25(test=false)
    @_ (test ? "test.txt" : "input.txt")    |>
        readlines                           |>
        padSNAFU.(__, maximum(length, __))  |>
        SNAFU2vec.(__)                      |>
        sum                                 |>
        vec2SNAFU(__)
end
day25()
