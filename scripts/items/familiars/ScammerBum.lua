local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()

local SCAMMER_BUM = mod.Entities.FAMILIAR_ScammerBum.Var
local BASE_CHANCE = 0.05

---@class ScammerBum
local scammerBum = {}

scammerBum.Item = mod.Items.ScammerBum

scammerBum.Accepts = {
    [PickupVariant.PICKUP_COIN] = true
}

scammerBum.FollowDistance = 40
scammerBum.ReachDistance  = 20

-- Stackable system
scammerBum.BaseRewardChance  = BASE_CHANCE
scammerBum.StackRewardChance = true

function scammerBum.OnInit(fam)
    local data = fam:GetData()
    data.CoinsEaten = 0
end

function scammerBum.Reward(fam)
    local data = fam:GetData()
    local pickup = data.TargetPickup
    if not pickup then return false end
    data.CoinsEaten = data.CoinsEaten or 0

    local subtype = pickup.SubType
    sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1.0, 0, false, 1.0)

    -- Golden coins always trigger reward
    if subtype == CoinSubType.COIN_GOLDEN then
        data.ForceDoubleDrop = true
        return true
    end

    -- Add stack based on coin type
    local stackAdd = 1
    if subtype == CoinSubType.COIN_STICKYNICKEL then
        stackAdd = fam:GetDropRNG():RandomFloat() < 0.5 and 1 or 5
    elseif subtype == CoinSubType.COIN_NICKEL then
        stackAdd = 5
    elseif subtype == CoinSubType.COIN_DIME then
        stackAdd = 10
    elseif subtype == CoinSubType.COIN_DOUBLEPACK then
        stackAdd = 2
    elseif subtype == CoinSubType.COIN_LUCKYPENNY then
        stackAdd = 1
        data.LuckyBonus = true
    end

    data.CoinsEaten = data.CoinsEaten + stackAdd

    -- Calculate reward chance
    local chance = bumUtils.GetCurrentRewardChance(fam, scammerBum)
    if data.LuckyBonus then
        chance = chance + 0.10
    end
    if chance > 1 then chance = 1 end

    return fam:GetDropRNG():RandomFloat() < chance
end

function scammerBum.DoReward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()
    local pool = Game():GetItemPool()
    local pos  = Isaac.GetFreeNearPosition(fam.Position, 20)

    sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1.0, 0, false, 1.0)

    local function spawnItem()
        local item = pool:GetCollectible(ItemPoolType.POOL_SHOP, false)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM, item, pos, Vector.Zero, fam)
    end

    if data.ForceDoubleDrop then
        spawnItem()
        if rng:RandomFloat() < 0.5 then
            local pos2 = Isaac.GetFreeNearPosition(fam.Position, 20)
            local item2 = pool:GetCollectible(ItemPoolType.POOL_SHOP, false)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM, item2, pos2, Vector.Zero, fam)
        end
        data.ForceDoubleDrop = false
        data.CoinsEaten = 0
        data.LuckyBonus = nil
        return
    end

    spawnItem()
    data.CoinsEaten = 0
    data.LuckyBonus = nil
end

bumUtils.RegisterBum(SCAMMER_BUM, scammerBum)
return scammerBum
