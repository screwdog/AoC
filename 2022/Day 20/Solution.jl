using Underscores

function readdata(filename)
    @_ filename         |>
        readlines       |>
        parse.(Int, __)
end

function processdata(nums, part2=false)
    DECRYPTION_KEY = 811589153
    data = Matrix{Int}(undef, length(nums), 2)
    data[:, 1] = nums .* (part2 ? DECRYPTION_KEY : 1)
    data[:, 2] = 1:length(nums)
    return data
end

function move!(data, from, to)
    step = sign(to - from)
    step == 0 && return
    item = data[from, :]
    for i ∈ from:step:to-step
        data[i, :] = data[i + step, :]
    end
    data[to, :] = item
end

function shift!(data, from, shift)
    to = mod1(from + shift, size(data, 1)-1)
    move!(data, from, to)
end

function mix!(data)
    for i ∈ axes(data,1)
        from = findfirst((==)(i), data[:,2])
        shift!(data, from, data[from, 1])
    end
end

function coords(data)
    COORD_INDICES = 1000:1000:3000
    start = findfirst((==)(0), data[:,1])
    indices = mod1.(COORD_INDICES .+ start, size(data, 1))
    return data[indices, 1]
end

function day20(part2, test=false)
    NUM_MIXES = part2 ? 10 : 1
    data = @_ (test ? "test.txt" : "input.txt") |>
        readdata                                |>
        processdata(__, part2)

    for n ∈ 1:NUM_MIXES
        mix!(data)
    end
    
    return sum(coords(data))
end

@time day20.(false:true)