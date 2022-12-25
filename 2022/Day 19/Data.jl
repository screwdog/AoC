ORE = 1
CLAY = 2
OBSIDIAN = 3
GEODE = 4
TIME = 5

resourceLabels = ["ore", "clay", "obsidian", "geode"]

function readdata(filename)
    @_ read(filename, String) |>
        eachmatch(r"(\d+)", __) |>
        first.(__) |>
        parse.(Int, __) |>
        Iterators.partition(__, 7) |>
        map([_...], __)
end

function makeblueprints(data)
    function makeblueprint(d)
        blueprint = fill(0, 4, 3)
        blueprint[1:2, 1] = d[2:3]
        blueprint[3, 1:2] = d[4:5]
        blueprint[4, 1] = d[6]
        blueprint[4, 3] = d[7]
        return blueprint
    end
    return makeblueprint.(data)
end