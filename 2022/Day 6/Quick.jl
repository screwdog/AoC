function day6q(p1)
    SIZE = p1 ? 4 : 14
    stream = readchomp("input.txt")
    for i ∈ SIZE:length(stream)
        allunique(stream[i-SIZE+1:i]) && return i
    end
end
day6q.([true, false])