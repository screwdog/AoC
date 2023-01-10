const NULL_ELEMENT = 0

splitElements(str) = @_ str             |> 
    eachmatch(r"([A-Z][a-z]?|e)", __)   |>
    collect                             |>
    first.(__)
element2Int(str) = parse(Int, str, base=36)
str2VecInt(str) = element2Int.(splitElements(str))

function readdata(file)
    lines = readlines(file)
    transformlines, moleculeline = lines[1:end-2], lines[end]

    molecule = str2VecInt(moleculeline)
    transforms = @_ transformlines      |>
        match.(r"(\w+) => (\w+)", __)   |>
        map(str2VecInt.(_), __)         |>
        Transform.(__)
    return (transforms, molecule)
end