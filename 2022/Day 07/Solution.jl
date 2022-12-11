function day7()
    location = []
    files = []
    dirs = ["/"]

    function doCommand(prompt, cmd, arg="")
        if cmd == "cd"
            if arg == "/"
                location = ["/"]
            elseif arg == ".."
                pop!(location)
            else
                push!(location, arg*"/")
            end
        end
    end
    extendedname = fn -> join(location)*fn
    function addListing(dirOrSize, filename)
        if dirOrSize == "dir"
            push!(dirs, extendedname(filename)*"/")
        else
            push!(files, [extendedname(filename), parse(Int, dirOrSize)])
        end
    end

    open("input.txt") do file
        while !eof(file)
            line = strip(readline(file))
            parts = split(line)
            if first(parts) == "\$"
                doCommand(parts...)
            else
                addListing(parts...)
            end
        end
    end

    function dirsize(dir)
        filesInDir = filter(f -> startswith(first(f), dir), files)
        fileSizes = last.(filesInDir)
        return sum(fileSizes)
    end

    smallDirs = filter(d -> dirsize(d) ≤ 100_000, dirs)
    return sum(dirsize, smallDirs)
end
day7()