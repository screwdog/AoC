const C_WEAPON = 1
const C_ARMOUR = 2
const C_RING = 3
const CATEGORY = Dict([
    C_WEAPON => "Weapons:",
    C_ARMOUR => "Armor:",
    C_RING => "Rings:"
])
const CAT_RANGE = Dict([
    C_WEAPON => 1:1,
    C_ARMOUR => 0:1,
    C_RING => 0:2
])

struct Item
    category::Int
    name::String
    cost::Int
    damage::Int
    armour::Int
end
Item(cat, n, c::AbstractString, d::AbstractString, a::AbstractString) =
    Item(cat, n, parse.(Int, (c,d,a))...)
function Item(c, str)
    @_ str                                  |>
        eachmatch(r"(\w+(?:\s\+\d)?)", __)  |>
        first.(__) |>
        Item(c, __...)
end
cost(item) = item.cost
damage(item) = item.damage
armour(item) = item.armour

function getItemCategory(cat)
    lines = "items.txt" |>
        readlines
    from = findfirst(line -> occursin(CATEGORY[cat], line), lines) + 1
    to = findnext(isempty, lines, from) - 1
    return Item.(cat, lines[from:to])
end
getItems() = getItemCategory.(C_WEAPON:C_RING)

function wearItems!(c::Character, items)
    c.damage += sum(damage, items)
    c.armour += sum(armour, items)
    return sum(cost, items)
end
function removeItems!(c::Character)
    c.damage = 0
    c.armour = 0
    return c
end