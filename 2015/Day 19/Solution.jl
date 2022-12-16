splitElements(str) = eachmatch(r"([A-Z][a-z]?|e)", str) |> collect |> ms -> first.(ms)
element2Int(str) = parse(Int, str, base=36)
str2VecInt(str) = element2Int.(splitElements(str))
function readdata(file)
    lines = filter((≠)(""), readlines(file))
    transformlines, moleculeline = lines[1:end-1], lines[end]

    molecule = str2VecInt(moleculeline)
    transforms = Vector{Vector{Int}}[]
    for line ∈ transformlines
        m = match(r"(\w+) => (\w+)", line)
        push!(transforms, str2VecInt.([m[2], m[1]]))
    end
    return (molecule, transforms)
end