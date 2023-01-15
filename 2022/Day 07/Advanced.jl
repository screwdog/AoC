module Day7 # REPL complains when "redefining" types so development is easier using modules
const P1_THRESHOLD = 100_000
const P2_DISK_SPACE = 70_000_000
const P2_FREE_SPACE = 30_000_000

# mutable so we can update the size and filesize fields as we add new subdirectories and files
mutable struct Dir
    # Root node has no parent. Alternatively, we could have left it uninitialised
    # or had an AbstractDir as a super type and then maybe RootDir, SubDir types.
    parent::Union{Nothing, Dir}
    # size will eventually store the sum of all files within this directory and
    # all subdirectories, recursively. We initialise to -1 to indicate that it
    # has not yet been calculated and we will calculate it when needed
    size::Int
    # filesize is the sum of the sizes of all files within this directory. This
    # is updated as we process the input.
    filesize::Int
    # fields in a mutable struct can be declared const. Here the subdirs field
    # cannot be changed, even though its *contents* can be.
    const subdirs::Dict{String, Dir}
end
# Every struct provides a default constructer that simply takes values for each
# field in order. Here we define two convenience constructors. Note that size
# is initialised to -1 to indicate it hasn't been calculated.
Dir(parent) = Dir(parent, -1, 0, Dict{String, Dir}())
Dir() = Dir(nothing)
# Best practice is to not have other functions accessing fields directly unless
# strictly necessary. Here we define functions for field access as needed
parent(d::Dir) = d.parent
# return the total directory size if already calculated, otherwise calculate
# it and store the result. Sum requires init=0 when subdirs returns an empty
# collection.
dirsize(d::Dir) = d.size ≥ 0 ? d.size : (d.size = d.filesize + sum(dirsize, subdirs(d), init=0))
addfile!(d::Dir, size) = d.filesize += size
addsubdir!(d::Dir, name) = d.subdirs[name] = Dir(d)
subdir(d::Dir, name) = d.subdirs[name]
subdirs(d::Dir) = values(d.subdirs)

# custom types often display poorly in the REPL so having custom pretty-
# printing can be helpful
Base.show(io::IO, d::Dir) = print(io,
    d.parent === nothing ? "Root " : "Sub", "directory:\n   ",
    d.filesize, "b in files, ", length(d.subdirs), " subdirectories, ",
    d.size ≥ 0 ? d.size : "???", "b total size"
)

# "cd /" command requires knowledge of the root node and only occurs as the
# first line of input, so we can just commence processing at the root and
# ignore this command. We also ignore any "ls" commands as they have no
# effect on the directory tree
commands = Dict([
    r"\$ cd \.\."                   => (m, currdir) -> parent(currdir),
    r"\$ cd (?'dir'\w+)"            => (m, currdir) -> subdir(currdir, m["dir"]),
    r"dir (?'dir'\w+)"              => (m, currdir) -> (addsubdir!(currdir, m["dir"]); return currdir),
    r"(?'size'\d+) \w+(?:\.\w+)?"   => (m, currdir) -> (addfile!(currdir, parse(Int, m["size"])); return currdir)
])

function initfs(filename)
    root = Dir()
    currdir = root
    for line ∈ eachline(filename)
        for r ∈ keys(commands)
            m = match(r, line)
            m ≠ nothing && (currdir = commands[r](m, currdir))
        end
    end
    return root
end

# Sum size of all directories whose size is no more than threshold, recursively
sumsmall(d::Dir, threshold) = (dirsize(d) ≤ threshold ? dirsize(d) : 0) +
    sum(d -> sumsmall(d, threshold), subdirs(d), init=0)
# Smallest directory size that is at least threshold, calculated recursively
minbig(d::Dir, threshold) = min(
    dirsize(d) ≥ threshold ? dirsize(d) : P2_FREE_SPACE,
    minimum(d -> minbig(d, threshold), subdirs(d), init=P2_FREE_SPACE)
)

function day7()
    root = initfs("input.txt")
    return (
        sumsmall(root, P1_THRESHOLD),
        minbig(root, P2_FREE_SPACE - (P2_DISK_SPACE - dirsize(root)))
    )
end
end;
Day7.day7()