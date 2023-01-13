"""
We read the entire input and search for the first sequence of consecutive items
that are unique.
"""
function day6(part2)
    SIZE = !part2 ? 4 : 14
    buffer = readchomp("input.txt")
    # define a convenience function (actually a closure)
    uniquepart(i) = allunique(buffer[i-SIZE+1:i])
    return findnext(uniquepart, 1:length(buffer), SIZE)
end
day6.(false:true)