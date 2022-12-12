function readData(file)
    lines = filter((≠)(""), readlines(file))
    transformlines, inputmolecule = lines[1:end-1], lines[end]

    transforms = Pair{String, String}[]
    for line ∈ transformlines
        m = match(r"(\w+) => (\w+)", line)
        push!(transforms, m[1] => m[2])
    end
    return (inputmolecule, transforms)
end

replaceAt(str, at, substr) = str[1:first(at)-1] * substr * str[last(at)+1:end]
function replaceAll(str, transform)
    newstrs = String[]
    places = findall(first(transform), str)
    for place ∈ places
        push!(newstrs, replaceAt(str, place, last(transform)))
    end
    return newstrs
end

function nextGeneration(molecules, transforms)
    newMolecules = String[]
    for molecule ∈ molecules, transform ∈ transforms
        append!(newMolecules, replaceAll(molecule, transform))
    end
    return newMolecules |> unique
end

function day19p1(test=false)
    inputfile = test ? "p1test.txt" : "input.txt"
    inputmolecule, transforms = readData(inputfile)
    return nextGeneration([inputmolecule], transforms) |> length
end
day19p1()