"""
This is a more efficient method. The naive method calculates the number of
unique items in each block of SIZE but doesn't carry any information from each
calculation to the next. Also, the number of unique items in adjacent blocks
can differ by 1, at most. So if the number of unique items in a block is n less
than SIZE, then we need not check the next n-1 blocks.

Here we maintain a buffer with the current block and multi counts the number of
each letter currently in the buffer. We update multi as letters enter and leave
the buffer, which is more efficient than calculating it from scratch each time.
We also skip ahead and read in multiple characters at a time depending on the
number of unique items currently in the buffer.
"""
function day6f(part2)
    SIZE = !part2 ? 4 : 14
    open("input.txt") do file
        # working with strings is inefficient so since the input is known to be
        # valid we can treat everything as bytes.
        block = read(file, SIZE)
        inputbuf = Vector{UInt8}(undef, SIZE)
        for n ∈ 1:SIZE
            # shift from Unicode to simple a = 1, b = 2, etc so we can directly
            # index multi
            block[n] -= 0x60
        end
        multi = zeros(UInt8, 26)
        numunique = 0
        for n ∈ 1:SIZE
            multi[block[n]] == 0 && (numunique += 1)
            multi[block[n]] += 1
        end
        while !eof(file)
            numunique == SIZE && return position(file)
            # calculate minimum characters before needing to check
            k = SIZE - numunique
            # remove last k chars from multi
            for n ∈ 1:k
                multi[block[n]] -= 1
                multi[block[n]] == 0 && (numunique -= 1)
            end
            # remove last k chars from block
            for n ∈ 1:SIZE-k
                block[n] = block[k+n]
            end
            # there's no easy way to read bytes directly into a portion
            # of a buffer without constructing a view. So we use a temporary
            # input buffer instead
            readbytes!(file, inputbuf, k)
            # add new chars to block
            for n ∈ 1:k
                block[end-k+n] = inputbuf[n] - 0x60
            end
            # add new chars to multi
            for n ∈ 1:k
                multi[block[end-n+1]] == 0 && (numunique += 1)
                multi[block[end-n+1]] += 1
            end
        end
    end
end
day6f.(false:true)