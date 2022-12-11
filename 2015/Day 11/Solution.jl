function day11(p1)
    str2ints = s -> collect(s) .- 96 |> l -> Int.(l)
    ints2str = l -> l .+ 96 |> l -> Char.(l) |> join
    function incints!(l)
        i = findlast((<)(26), l)
        l[i] += 1
        l[i+1:end] .= 1
        return l
    end

    function hasstraight(l)
        for i ∈ 3:length(l)
            diffs = l[i-1:i] .- l[i-2:i-1]
            all(diffs .== [1,1]) && return true
        end
        return false
    end
    hasforbidden = l -> any(Int.(['i', 'l', 'o'] .- 96) .∈ Ref(l))
    function haspairs(l)
        eqs = l[1:end-1] .== l[2:end]
        i = findfirst(eqs)
        i === nothing && return false
        j = findfirst(eqs[i+2:end])
        return !(j === nothing)
    end
    ispassword = l -> hasstraight(l) && !hasforbidden(l) && haspairs(l)

    input = p1 ? "hepxcrrq" : "hepxxyzz"
    ints = incints!(str2ints(input))
    while !ispassword(ints)
        incints!(ints)
    end

    return ints2str(ints)
end

day11.([true, false])