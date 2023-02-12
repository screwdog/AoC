# for interpreting the input file
const RESOURCE_NUMBERS = Dict(
    "ore" => 1,
    "clay" => 2,
    "obsidian" => 3,
    "geode" => 4
)

const MAX_TIME = 100
const NUM_RESOURCES = 4
# convenience type definitions as these don't need full custom types
const Resources = Tuple{Int, Int, Int, Int}
const Robots = Resources

# construct Resource from input values read from file
resources(n) = Tuple(Int.(1:4 .== n))
function resources(n, ns)
    res = [first(ns), 0, 0, 0]
    length(ns) == 2 && (res[n-1] = last(ns))
    return Resources(res)
end

# record of a robot type in a blueprint. produces is a 1-hot vector (tuple) so
# we can later do current_robots += robot.produces (or equivalent)
struct Robot
    produces::Resources
    requires::Resources
end
Robot(makes::Int, requires) = Robot(resources(makes), requires)
requires(r::Robot) = r.requires
requires(r::Robot, i) = r.requires[i]
produces(r::Robot) = r.produces
produces(r::Robot, i) = r.produces[i]

number(str) = @_ match(r"(\d+)", str) |> only |> parse(Int, __)
function robot(str)
    make = @_ match(r"Each (\w+) robot", str) |> only |> RESOURCE_NUMBERS[__]
    nums = @_ eachmatch(r"(\d+)", str) |> only.(__) |> parse.(Int, __)
    return Robot(make, resources(make, nums))
end
