using Underscores

function day7(puzzle1)
    gateregex = Regex(
        "(?:([a-z0-9]+)|\
        (NOT) ([a-z0-9]+)|\
        ([a-z0-9]+) (AND) ([a-z0-9]+)|\
        ([a-z0-9]+) (OR) ([a-z0-9]+)|\
        ([a-z0-9]+) (LSHIFT) ([a-z0-9]+)|\
        ([a-z0-9]+) (RSHIFT) ([a-z0-9]+)) \
        -> ([a-z0-9]+)")

    transforms = Dict([
        2 => (a,b) -> ["ID",[a],b],
        3 => (a,b,c) -> [a,[b],c],
        4 => (a,b,c,d) -> [b,[a,c],d]
    ])

    knowns = Dict{String,Int}()

    isnumber = s -> all(isdigit,s)
    isknown = s -> isnumber(s) || haskey(knowns,s)
    inputsknown = gate -> all(isknown, gate[2])
    
    fns = Dict([
        "ID"     => identity,
        "NOT"    => ~,
        "AND"    => &,
        "OR"     => |,
        "LSHIFT" => <<,
        "RSHIFT" => >>
    ])

    tonumber = s -> isnumber(s) ? parse(Int, s) : knowns[s]

    gates = @_ readlines(pwd()*"\\input"*(puzzle1 ? "" : "2")*".txt") |>
        match.(gateregex, __) |>
        collect.(__) |>
        filter.((!=)(nothing), __) |>
        map(transforms[length(_)](_...),__)
    
    while !haskey(knowns, "a")
        i = findfirst(inputsknown, gates)
        i === nothing && throw(ErrorException("No gate found!"))
        gate = gates[i]
        haskey(knowns, gate[end]) && throw(ErrorException("Wire already on!"))
        knowns[gate[end]] = fns[gate[1]](tonumber.(gate[2])...)
        deleteat!(gates, i)
    end
    return knowns["a"]
end

(day7(true), day7(false))