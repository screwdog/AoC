function allperms(n)
    n == 1 && return [[1]]
    n == 2 && return [[1, 2], [2, 1]]
    partperms = allperms(n-1)
    moreperms = [deepcopy(partperms[cld(i,n)]) for i ∈ 1:n*length(partperms)]
    insertpoints = Iterators.take(Iterators.cycle(Iterators.flatten((n:-1:1, 1:n))), factorial(n))
    return insert!.(moreperms, insertpoints, n)
end

function day13(part2)
    people = Dict{String, Int}()
    happiness = [[]]
    open("input.txt") do file
        while !eof(file)
            line = readline(file)
            m = match(r"(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)", line)
            p1, p2 = m[1], m[4]
            h = parse(Int, (m[2] == "gain" ? "" : "-")*m[3])
            haskey(people, p1) || (people[p1] = length(people) + 1)
            haskey(people, p2) || (people[p2] = length(people) + 1)
            while length(happiness) < people[p1]
                push!(happiness, [])
            end
            while length(happiness[people[p1]]) < people[p2]
                push!(happiness[people[p1]], 0)
            end
            happiness[people[p1]][people[p2]] = h
        end
    end

    if part2
        people["me"] = length(people) + 1
        push!(happiness[end], 0)
        push!.(happiness, 0)
        push!(happiness, [0 for _ ∈ 1:length(people)])
    end

    function permhappiness(perm)
        pairhappiness = t -> 
            happiness[first(t)][last(t)] + happiness[last(t)][first(t)]
        shifted = circshift(perm, 1)
        return sum(pairhappiness, zip(perm, shifted))
    end

    return maximum(permhappiness.(allperms(length(people))))
end
day13.(false:true)