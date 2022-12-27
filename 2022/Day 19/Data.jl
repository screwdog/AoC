const R_ORE = 1
const R_CLAY = 2
const R_OBSIDIAN = 3
const R_GEODE = 4

numbers(str) = eachmatch(r"(\d+)", str) |>
    matches -> first.(matches)          |>
    digits -> parse.(Int, digits)

function makeBlueprint(str)
    blueprint = fill(0, (4, 3))
    data = numbers(str)
    blueprint[R_ORE:R_GEODE, R_ORE] .= data[[2,3,4,6]]
    blueprint[R_OBSIDIAN, R_CLAY] = data[5]
    blueprint[R_GEODE, R_OBSIDIAN] = data[7]
    return blueprint
end

function readdata(filename, part2)
    lines = readlines(filename)
    part2 && (lines = first(lines, 3))
    return makeBlueprint.(lines)
end