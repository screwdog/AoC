splitElements(str) = eachmatch(r"([A-Z][a-z]?)", str) |> collect |> ms -> first.(ms)
element2Int(str) = parse(Int, str, base=36)
function readdata(file)

end

struct PlaceFinder
    transform::Vector{Vector{Int}}
    molecule::Vector{Int}
end
function Base.iterate(pf::PlaceFinder, state)
    
end
Base.iterate(pf::PlaceFinder) = iterate(pf, 1)
findplaces(transform, molecule, start=1) = iterate(PlaceFinder(transform, molecule), start)

function applytransform!(molecule, transform, newMolecules)
    places = findplaces(transform, molecule)
    for place in places
        push!(newMolecules, vcat(molecule[1:first(place)-1], transform[1], molecule[last(place)+1:end]))
    end
    return nothing
end

function dostep!(molecules, transforms, newMolecules)
    deleteat!(newMolecules, axes(newMolecules, 1))
    for molecule ∈ molecules, transform ∈ transforms
        applytransform!(molecule, transform, newMolecules)
    end
    return nothing
end

function day19p2(test = false)
    inputfile = test ? "test.txt" : "input.txt"
    transforms, inputmolecule = readdata(inputfile)

    molecules, target = [inputmolecule], element2Int("e")
    newMolecules = Int[]
    for step ∈ 1:3
        dostep!(molecules, transforms, newMolecules)
        target ∈ newMolecules && return step
        molecules, newMolecules = newMolecules, molecules
    end
    return nothing
end
day19p2(true)