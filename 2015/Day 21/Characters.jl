mutable struct Character
    maxhp::Int
    currhp::Int
    damage::Int
    armour::Int
end
Character(hp, d, a) = Character(hp, hp, d, a)
Character(hp::Int) = Character(hp, 0, 0)
reset!(c::Character) = c.currhp = c.maxhp
isdead(c::Character) = c.currhp ≤ 0
attack!(c::Character, d) = c.currhp -= (d - c.armour > 0 ? d - c.armour : 1)
attack!(a::Character, b::Character) = attack!(a, b.damage)

function getBoss()
    @_ "input.txt"              |>
        read(__, String)        |>
        eachmatch(r"(\d+)", __) |>
        first.(__)              |>
        parse.(Int, __)         |>
        Character(__...)
end
testBoss() = Character(12,7,2)

function fight!(player::Character, boss::Character)
    while !isdead(player)
        attack!(boss, player)
        isdead(boss) && return true
        attack!(player, boss)
    end
    return false
end