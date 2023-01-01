module Day21
using Underscores
include("Combinat.jl")
include("Characters.jl")
include("Items.jl")
include("ItemSets.jl")

const MAX_COST = 1000
const DEFAULT_HP = 100

function bestSet(player, boss, items, part2)
    best = part2 ? 0 : MAX_COST
    for itemSet ∈ allItemSets(items)
        cost = wearItems!(player, itemSet)
        if part2
            !fight!(player, boss) && cost > best && (best = cost)
        else
            fight!(player, boss) && cost < best && (best = cost)
        end
        removeItems!(player)
        reset!.((player, boss))
    end
    return best
end

function day21(part2)
    bestSet(Character(DEFAULT_HP), getBoss(), getItems(), part2)
end
end;
Day21.day21.(false:true)