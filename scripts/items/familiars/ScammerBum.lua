local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")

local SCAMMER_BUM = mod.Entities.FAMILIAR_ScammerBum.Var
local BASE_CHANCE = 0.05

local sfx = SFXManager()

---@class scammerBum
local scammerBum = {}

scammerBum.Item = mod.Items.ScammerBum

scammerBum.Accepts = {
    [PickupVariant.PICKUP_COIN] = true
}

scammerBum.FollowDistance = 40
scammerBum.ReachDistance  = 20

function scammerBum.OnInit(fam)
    local data = fam:GetData()
    data.CoinsEaten = 0
end

function scammerBum.OnUpdate(fam)
    local player = fam.Player
    if not player then return end

    if player.Velocity:LengthSquared() < 0.1 then
        local dist = fam.Position:Distance(player.Position)

        if dist < scammerBum.FollowDistance then
            local push = (fam.Position - player.Position):Normalized() * 0.4
            fam.Velocity = fam.Velocity + push
        end
    end
end

function scammerBum.Reward(fam)
    local data   = fam:GetData()
    local rng    = fam:GetDropRNG()
    local pickup = data.TargetPickup
    if not pickup then return false end
    data.CoinsEaten = data.CoinsEaten or 0

    local subtype = pickup.SubType
    sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1.0, 0, false, 1.0)

    if subtype == CoinSubType.COIN_GOLDEN then
        data.ForceDoubleDrop = true
        return true
    end

    if subtype == CoinSubType.COIN_STICKYNICKEL then
        if rng:RandomFloat() < 0.5 then
            data.CoinsEaten = data.CoinsEaten + 1
        else
            data.CoinsEaten = data.CoinsEaten + 5
        end

    elseif subtype == CoinSubType.COIN_NICKEL then
        data.CoinsEaten = data.CoinsEaten + 5

    elseif subtype == CoinSubType.COIN_DIME then
        data.CoinsEaten = data.CoinsEaten + 10

    elseif subtype == CoinSubType.COIN_DOUBLEPACK then
        data.CoinsEaten = data.CoinsEaten + 2

    elseif subtype == CoinSubType.COIN_LUCKYPENNY then
        data.CoinsEaten = data.CoinsEaten + 1
        data.LuckyBonus = true

    else
        data.CoinsEaten = data.CoinsEaten + 1
    end
    local chance = BASE_CHANCE * (2 ^ (data.CoinsEaten - 1))

    if data.LuckyBonus then
        chance = chance + 0.10
    end

    if chance > 1 then chance = 1 end

    return rng:RandomFloat() < chance
end

function scammerBum.DoReward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()
    local pool = Game():GetItemPool()
    sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1.0, 0, false, 1.0)

    local pos = Isaac.GetFreeNearPosition(fam.Position, 20)

    if data.ForceDoubleDrop then
        local item1 = pool:GetCollectible(ItemPoolType.POOL_SHOP, false)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM,
            item1, pos, Vector.Zero, fam)

        if rng:RandomFloat() < 0.5 then
            local pos2 = Isaac.GetFreeNearPosition(fam.Position, 20)
            local item2 = pool:GetCollectible(ItemPoolType.POOL_SHOP, false)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM,
                item2, pos2, Vector.Zero, fam)
        end

        data.ForceDoubleDrop = false
        data.CoinsEaten = 0
        data.LuckyBonus = nil
        return
    end

    local item = pool:GetCollectible(ItemPoolType.POOL_SHOP, false)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM,
        item, pos, Vector.Zero, fam)

    data.CoinsEaten = 0
    data.LuckyBonus = nil
end

bumUtils.RegisterBum(SCAMMER_BUM, scammerBum)

return scammerBum