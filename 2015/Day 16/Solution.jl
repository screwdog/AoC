function day16(part2)
    output = Dict([
        "children"      => (==)(3),
        "cats"          => part2 ? (>)(7) : (==)(7),
        "samoyeds"      => (==)(2),
        "pomeranians"   => part2 ? (<)(3) : (==)(3),
        "akitas"        => (==)(0),
        "vizslas"       => (==)(0),
        "goldfish"      => part2 ? (<)(5) : (==)(5),
        "trees"         => part2 ? (>)(3) : (==)(3),
        "cars"          => (==)(2),
        "perfumes"      => (==)(1)
    ])
    extractItems(match) = match[1] => parse(Int, match[2])
    checkItem(item) = output[first(item)](last(item))

    for line ∈ readlines("input.txt")
        items = extractItems.(eachmatch(r"(\w+): (\d+)", line))
        if all(checkItem, items)
            return parse(Int, first(match(r"Sue (\d+)", line).captures))
        end
    end
end
#day16(false)
day16.(false:true)