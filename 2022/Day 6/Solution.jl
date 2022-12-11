function day6s(p1)
    SIZE = p1 ? 4 : 14
    open("input.txt") do file
        buffer = read(file, SIZE)
        multiset = Dict((=>).(buffer, 1))
        while !eof(file)
            length(multiset) == SIZE && return position(file)
            if get(multiset, buffer[1], 1) > 1
                multiset[buffer[1]] -= 1
            else
                delete!(multiset, buffer[1])
            end
            popfirst!(buffer)
            append!(buffer, read(file, sizeof(UInt8)))
            if haskey(multiset, buffer[end])
                multiset[buffer[end]] += 1
            else
                multiset[buffer[end]] = 1
            end
        end
    end
end
day6s.([true, false])