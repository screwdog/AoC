"""
Quick.jl
========

This is my first attempt at solving this puzzle under time constraints at time
of release and doesn't necessarily reflect good coding practices.
"""
function day7(p1)
    input = readlines("input.txt")

    location = []
    files = []
    dirs = Set(["/"])
    for line ∈ input
        if line[1] == '$'
            if line[3:4] == "cd"
                if line[6] == '/'
                    location = ["/"]
                elseif line[6:7] == ".."
                    pop!(location)
                else
                    # cd into a directory
                    push!(location, line[6:end]*"/")
                end
            else
                # ls command
                nothing
            end
        else
            # ls listing in progress
            filesize, filename = split(line)
            if filesize == "dir"
                push!(dirs, join(location)*filename*"/") 
            else
                push!(files, [join(location)*filename, parse(Int, filesize)])
            end
        end
    end

    if p1
        smalldirs = []
        for dir ∈ dirs
            # dirsize = sum(last, files[startswith.(first.(files), dir)])
            dirsize = filter(f -> startswith(f[1], dir), files) |>
                L -> map(f -> f[2], L) |>
                sum
            dirsize ≤ 100_000 && push!(smalldirs, dirsize)
        end
        return sum(smalldirs)
    else
        dirsizes = []
        for dir ∈ dirs
            dirsize = filter(f -> startswith(f[1], dir), files) |>
                L -> map(f -> f[2], L) |>
                sum
            push!(dirsizes, [dir, dirsize])
        end
        # sort!(dirsizes, by=last)
        sort!(dirsizes, lt=(d1, d2) -> d1[2] < d2[2])
        totalsize = dirsizes[findfirst(d -> d[1] == "/", dirsizes)][2]
        dir = findfirst(d -> totalsize - d[2] ≤ 40_000_000, dirsizes)
        return dirsizes[dir][2]
    end
end
day7.([true, false])