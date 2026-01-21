local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()
local RUNE_BUM = mod.Entities.FAMILIAR_RuneBum.Var

---@class RuneBum
local runeBum = {}

runeBum.Item = mod.Items.RuneBum

runeBum.Accepts = {
    [PickupVariant.PICKUP_TAROTCARD] = true
}

runeBum.FollowDistance = 40
runeBum.ReachDistance  = 20

-- Stackable rewards
runeBum.BaseRewardChance  = 0.50
runeBum.StackRewardChance = true

function runeBum.OnInit(fam)
    fam:GetData().RunesEaten = 0
end

function runeBum.Reward(fam)
    local data = fam:GetData()
    local pickup = data.TargetPickup
    if not pickup then return false end

    if not mod.Pools.RuneOrSoul[pickup.SubType] then
        return false
    end

    sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.0, 0, false, 1.0)
    data.RunesEaten = (data.RunesEaten or 0) + 1

    local chance = bumUtils.GetCurrentRewardChance(fam, runeBum)
    if chance > 1 then chance = 1 end
    return fam:GetDropRNG():RandomFloat() < chance
end

function runeBum.DoReward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()
    local pool = Game():GetItemPool()
    local pos  = Isaac.GetFreeNearPosition(fam.Position, 20)
    local config = Isaac.GetItemConfig()

    sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1.0, 0, false, 1.0)

    local roll = rng:RandomFloat()
    local targetQuality = 0
    if roll < 0.60 then
        targetQuality = 0
    elseif roll < 0.90 then
        targetQuality = 1
    else
        targetQuality = 2
    end

    local selectedItem = 0
    for _ = 1, 50 do
        local item = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false)
        local entry = config:GetCollectible(item)
        if entry and entry.Quality == targetQuality then
            selectedItem = item
            break
        end
    end

    if selectedItem == 0 then
        selectedItem = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false)
    end

    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, pos, Vector.Zero, fam)
    data.RunesEaten = 0
end

bumUtils.RegisterBum(RUNE_BUM, runeBum)
return runeBum
