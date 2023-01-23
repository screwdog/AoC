"""
`tokenise(str) -> Vector{String}`

Split the input into a vector of tokens, where each token is `[`, `]` or a
string representing a number.
"""
function tokenise(str)
    # essentially, we strip out any whitespace and commas, leaving only the
    # tokens indicating the start, contents, and end of packets
    TOKEN = r"(\d+|\[|]),?\s*"
    return only.(eachmatch(TOKEN, str))
end

"""
`parsepacket(str) -> packet`

Converts `str` into a packet of data - a vector whose elements are `Int`s or,
recursively, data packets.
"""
function parsepacket(str)
    function dotoken(stack, token)
        actions = Dict([
            (==)('[')   => (stack, token) -> push!(stack, []),
            # current packet is finished, add it to the next lowest packet and
            # continue processing that packet
            (==)(']')   => (stack, token) -> push!(stack[end-1], pop!(stack)),
            isdigit     => (stack, token) -> push!(stack[end], parse(Int, token))
        ])
        for test ∈ keys(actions)
            # apply each test against the first char in token
            test(first(token)) && return actions[test](stack, token)
        end
        return nothing
    end
    
    isempty(str) && return nothing
    # stack[end] is the current packet
    stack = [[]]
    @_ str[2:end-1]                 |>
        tokenise                    |>
        dotoken.(Ref(stack), __)
    return only(stack)
end

"""
`readdata() -> Vector{packets}`

Returns a vector of the packets in the order listed in "input.txt". Blank lines
in the input are ignored.
"""
function readdata()
    @_ readlines("input.txt")   |>
        filter(!isempty, __)    |>
        parsepacket.(__)
end