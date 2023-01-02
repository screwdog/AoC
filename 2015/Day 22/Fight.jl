const E_SHIELD_ARMOUR = 7
const E_POISON_DAMAGE = 3
const E_RECHARGE_MANA = 101

function doEffects!(bs::BattleState)
    bs.poisonturns ≥ 1      && (bs.bosshealth -= E_POISON_DAMAGE)
    bs.rechargeturns ≥ 1    && (bs.playermana += E_RECHARGE_MANA)

    bs.shieldturns > 0      && (bs.shieldturns -= 1)
    bs.poisonturns > 0      && (bs.poisonturns -= 1)
    bs.rechargeturns > 0    && (bs.rechargeturns -= 1)
end

function playerturn!(bs::BattleState, spell, part2=false)
    part2 && (bs.playerhealth -= 1)
    isplayerdead(bs) && return 0
    doEffects!(bs)
    return isbossdead(bs) ? 0 : castSpell!(bs, spell)
end

function bossturn!(bs::BattleState)
    doEffects!(bs)
    isbossdead(bs) && return
    damage = bs.bossdamage
    isshielded(bs) && (damage = max(1, damage - E_SHIELD_ARMOUR))
    bs.playerhealth -= damage
end

function gameround!(bs::BattleState, spell, part2=false)
    cost = playerturn!(bs, spell, part2)
    part2 && isplayerdead(bs) && return cost
    isbossdead(bs) || bossturn!(bs)
    return cost
end