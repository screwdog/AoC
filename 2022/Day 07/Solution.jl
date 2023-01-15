const P1_THRESHOLD = 100_000
const P2_DISK_SPACE = 70_000_000
const P2_FREE_SPACE = 30_000_000

fullname(location, name) = join(location)*name
# associate a regular expression that matches only that command with the effect that we want it
# to have. Functionally, `ls` commands have no effect on our data structures so we ignore them.
commands = Dict([
    # current directory is a vector of directory names, each with a trailing '/'
    r"\$ cd /" =>
        (m, loc, dirs, files) -> loc = ["/"],
    r"\$ cd \.\." =>
        (m, loc, dirs, files) -> pop!(loc),
    r"\$ cd (?'dir'\w+)" =>
        (m, loc, dirs, files) -> push!(loc, m["dir"]*"/"),
    # directories are stored as a fully qualified name, in a simple vector
    r"dir (?'dir'\w+)" =>
        (m, loc, dirs, files) -> push!(dirs, fullname(loc, m["dir"])*"/"),
    # files are stored as a length 2 vector, consisting of the fully qualified filename and its size,
    # in a simple vector
    r"(?'size'\d+) (?'file'\w+(?:\.\w+)?)" =>
        (m, loc, dirs, files) -> push!(files, [fullname(loc, m["file"]), parse(Int, m["size"])])
])

function processline!(cmds, line, loc, dirs, files)
    for regex ∈ keys(cmds)
        m = match(regex, line)
        if m ≠ nothing # m === nothing if there is no match
            cmds[regex](m, loc, dirs, files)
            return nothing
        end
    end
end

filesize(file) = last(file)
# since we store all our files / dirs as fully qualified names, a file is in
# some subdirectory of a given directory if the directory name is a prefix of
# the file name. So we can use startswith to find all files contained within
# a directory (or its subdirectories)
allfiles(dir, files) = filter(f -> startswith(first(f), dir), files)
dirsize(dir, files) = sum(filesize, allfiles(dir, files), init=0) # need init in case allfiles is empty
dirsizes(dirs, files) = [[d, dirsize(d, files)] for d ∈ dirs]
filterdirs(f, dirs, files) = filter(d -> f(filesize(d)), dirsizes(dirs, files))
smalldirs(dirs, files, threshold) = filterdirs((≤)(threshold), dirs, files)
bigdirs(dirs, files, threshold) = filterdirs((≥)(threshold), dirs, files)

function day7(part2)
    location, dirs, files = ["/"], ["/"], []
    for line ∈ eachline("input.txt")
        processline!(commands, line, location, dirs, files)
    end
    part2 || return sum(last, smalldirs(dirs, files, 100_000))
    extraspace = P2_FREE_SPACE - (P2_DISK_SPACE - dirsize("/", files))
    return minimum(last, bigdirs(dirs, files, extraspace))
end
day7.(false:true)