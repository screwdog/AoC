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

struct PlaceFinder
    transform::Vector{Vector{Int}}
    molecule::Vector{Int}
end
function Base.iterate(pf::PlaceFinder, state)
    N = length(pf.transform[1]) - 1
    M = length(pf.molecule)
    for i ∈ state:M-N
        if pf.molecule[i] == pf.transform[1][1]
            if all(pf.molecule[i:i+N] .== pf.transform[1][1:end])
                return (i:i+N, i+1)
            end
        end
    end
    return nothing
end
Base.iterate(pf::PlaceFinder) = iterate(pf, 1)
findplaces(transform, molecule) = PlaceFinder(transform, molecule)

function applytransform!(molecule, transform, newMolecules)
    places = findplaces(transform, molecule)
    for place in places
        push!(newMolecules, vcat(molecule[1:first(place)-1], transform[2], molecule[last(place)+1:end]))
    end
    return nothing
end

function dostep!(molecules, transforms, newMolecules)
    deleteat!(newMolecules, axes(newMolecules, 1))
    for molecule ∈ molecules, transform ∈ transforms
        applytransform!(molecule, transform, newMolecules)
    end
    unique!(newMolecules)
    return nothing
end

function day19p2(test = false)
    inputfile = test ? "p2test.txt" : "input.txt"
    inputmolecule, transforms = readdata(inputfile)

    molecules, target = [inputmolecule], str2VecInt("e")
    newMolecules = Vector{Int}[]
    for step ∈ 1:3
        dostep!(molecules, transforms, newMolecules)
        target ∈ newMolecules && return step
        molecules, newMolecules = newMolecules, molecules
        println("Step $step completed. $(length(molecules)) candidates.")
    end
    return nothing
end
day19p2(false)