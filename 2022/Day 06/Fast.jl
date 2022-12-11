using StaticArrays

function day6f(p1)
    SIZE = p1 ? 4 : 14
    @inbounds open("input.txt") do file
        buffer = MArray{Tuple{SIZE}}(read(file, SIZE)) .- 96
        multi = MArray{Tuple{26}}(zeros(Int, 26))
        numunique = 0
        for n ∈ 1:SIZE
            multi[buffer[n]] == 0 && (numunique += 1)
            multi[buffer[n]] += 1
        end
        i = 1
        while !eof(file)
            numunique == SIZE && return position(file)
            multi[buffer[i]] -= 1
            multi[buffer[i]] == 0 && (numunique -= 1)
            buffer[i] = read(file, sizeof(UInt8))[1] - 96
            multi[buffer[i]] == 0 && (numunique += 1)
            multi[buffer[i]] += 1
            i = mod(i, SIZE) + 1
        end
    end
end

day6f.([true, false])