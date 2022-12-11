input = "1113122113"

function lookandsay(str)
    sayrun = r -> string(length(r), first(r))

    runs = first.(eachmatch(r"((.)(\2)*)", str))
    return join(sayrun.(runs))
end

function apply(f, x, n=1)
    for _ in 1:n
        x = f(x)
    end
    return x
end

day10 = p1 -> length(apply(lookandsay, input, p1 ? 40 : 50))

(day10(true), day10(false))