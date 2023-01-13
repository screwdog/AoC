"""
Quick.jl
========

This represents my initial attempt at solving this puzzle under time
constraints at time of release. It is not necessarily a reflection of good
coding practices.
"""
function day6(p1)
    SIZE = p1 ? 4 : 14
    stream = readchomp("input.txt")
    for i ∈ SIZE:length(stream)
        allunique(stream[i-SIZE+1:i]) && return i
    end
end
day6.([true, false])