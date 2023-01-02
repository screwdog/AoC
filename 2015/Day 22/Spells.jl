const S_MAGIC_MISSILE = 1
const S_DRAIN = 2
const S_SHIELD = 3
const S_POISON = 4
const S_RECHARGE = 5

const S_SPELLS = S_MAGIC_MISSILE:S_RECHARGE
const S_INSTANTS = S_MAGIC_MISSILE:S_DRAIN
const S_EFFECTS = S_SHIELD:S_RECHARGE

const E_DAMAGE = 1
const E_HEAL = 2
const INSTANT_EFFECT = [4 0; 2 2]
const EFFECT_TIME = [0, 0, 6, 6, 5]

const SPELL_COSTS = [53, 73, 113, 173, 229]

function isspellactive(bs::BattleState, spell)
    spell == S_SHIELD && return bs.shieldturns > 1
    spell == S_POISON && return bs.poisonturns > 1
    spell == S_RECHARGE && return bs.rechargeturns > 1
end

function cancast(bs::BattleState, spell)
    spell ∈ S_EFFECTS && isspellactive(bs, spell) && return false
    return bs.playermana ≥ SPELL_COSTS[spell]
end

function castSpell!(bs::BattleState, spell)
    bs.playermana -= SPELL_COSTS[spell]
    if spell ∈ S_INSTANTS
        bs.bosshealth -= INSTANT_EFFECT[spell, E_DAMAGE]
        bs.playerhealth += INSTANT_EFFECT[spell, E_HEAL]
    else
        spell == S_SHIELD   && (bs.shieldturns = EFFECT_TIME[spell])
        spell == S_POISON   && (bs.poisonturns = EFFECT_TIME[spell])
        spell == S_RECHARGE && (bs.rechargeturns = EFFECT_TIME[spell])
    end
    return SPELL_COSTS[spell]
end