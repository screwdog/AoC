module Day22
using Underscores
include("Data.jl")
include("Spells.jl")
include("Fight.jl")

MAX_MANA = 10_000

function _leastMana(bs::BattleState, part2=false)
    possiblespells = filter(s -> cancast(bs, s), S_SPELLS)
    least = MAX_MANA
    for spell ∈ possiblespells
        newState = BattleState(bs)
        cost = gameround!(newState, spell, part2)
        isplayerdead(newState) && continue
        win = iswin(newState)
        if !win
            win, extracost = _leastMana(newState, part2)
            cost += extracost
        end
        win && cost < least && (least = cost)
    end
    least == MAX_MANA && return (false, 0)
    return (true, least)
end

function leastMana(bs::BattleState, part2=false)
    win, cost = _leastMana(bs, part2)
    win && return cost
    return nothing
end

function day22(part2)
    start = BattleState(standard)
    return leastMana(start, part2)
end
end;
#Part 1 is very slow (~4.5mins)
Day22.day22(false:true)