function day12(p1)
    input = read("input.txt", String)
    if !p1
        m = match(r":\"red\"", input)
        while m !== nothing
            i = m.offset - 1
            bracedepth = 1
            while input[i] != '{' || bracedepth > 0
                i -= 1
                input[i] == '{' && (bracedepth -= 1)
                input[i] == '}' && (bracedepth += 1)
            end
            j = m.offset + 5
            bracedepth = 1
            while input[j] != '}' || bracedepth > 0
                j += 1
                input[j] == '{' && (bracedepth += 1)
                input[j] == '}' && (bracedepth -= 1)
            end

            input = input[1:i] * input[j:end]
            m = match(r":\"red\"", input)
        end
    end

    input |>
        s -> eachmatch(r"(-?\d+)", s) |>
        l -> map(m -> m.match, l) |>
        l -> parse.(Int, l) |>
        sum
end

day12.([true, false])