function boss()
    @_ "input.txt"              |>
        readchomp               |>
        eachmatch(r"(\d+)", __) |>
        first.(__)              |>
        parse.(Int, __)
end
player() = (50, 500)

standard = (
    player = player(),
    boss = boss()
)

const test1 = (
    player = (10, 250),
    boss = (13, 8)
)

const test2 = (
    player = (10, 250),
    boss = (14, 8)
)

mutable struct BattleState
    playerhealth::Int8
    playermana::Int16
    bosshealth::Int8
    bossdamage::Int8
    shieldturns::Int8
    poisonturns::Int8
    rechargeturns::Int8
end
BattleState(player, boss) = BattleState(player[1], player[2], boss[1], boss[2], 0, 0, 0)
BattleState(nt::NamedTuple) = BattleState(nt.player, nt.boss)
function BattleState(bs::BattleState)
    BattleState(
        bs.playerhealth,
        bs.playermana,
        bs.bosshealth,
        bs.bossdamage,
        bs.shieldturns,
        bs.poisonturns,
        bs.rechargeturns
    )
end
Base.broadcastable(bs::BattleState) = Ref(bs)
isplayerdead(bs::BattleState) = bs.playerhealth ≤ 0
isbossdead(bs::BattleState) = bs.bosshealth ≤ 0
isshielded(bs::BattleState) = bs.shieldturns > 0
iswin(bs::BattleState) = isbossdead(bs) && !isplayerdead(bs)