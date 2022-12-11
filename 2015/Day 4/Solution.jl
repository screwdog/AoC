using MD5

global prefix = "ckczppom"

function day4p1()
    for n ∈ 1:1_000_000
        hash = md5("$prefix$n")[1:3]
        hash[1] == hash[2] == 0x00 && hash[3] ≤ 0x0F && return n
    end
    return nothing
end

function day4p2()
    for n ∈ 1:10_000_000
        hash = md5("$prefix$n")[1:3]
        hash[1] == hash[2] == hash[3] == 0 && return n
    end
    return nothing
end

(day4p1(), day4p2())