---@class ModReference
local mod = DiesIraeMod
local game = Game()
local coolStick = {}

mod.CollectibleType.COLLECTIBLE_COOL_STICK = Isaac.GetItemIdByName("Cool Stick")
local coolStickId = mod.CollectibleType.COLLECTIBLE_COOL_STICK

function coolStick:OnCache(player, flag)
    local stacks = player:GetCollectibleNum(coolStickId)
    if stacks <= 0 then
        return
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.4 * stacks
    elseif flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 1 * stacks
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, coolStick.OnCache)

function coolStick:OnPlayerEffect(player)
    if player:HasCollectible(coolStickId) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, coolStick.OnPlayerEffect)

local chestWhitelist = {
    [PickupVariant.PICKUP_CHEST]        = 1,
    [PickupVariant.PICKUP_BOMBCHEST]    = 1,
    [PickupVariant.PICKUP_SPIKEDCHEST]  = 1,
    [PickupVariant.PICKUP_ETERNALCHEST] = 1,
    [PickupVariant.PICKUP_MIMICCHEST]   = 1,
    [PickupVariant.PICKUP_OLDCHEST]     = 1,
    [PickupVariant.PICKUP_MEGACHEST]    = 1,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = 1,
    [PickupVariant.PICKUP_LOCKEDCHEST]  = 1,
    [PickupVariant.PICKUP_REDCHEST]     = 1,
    [PickupVariant.PICKUP_MOMSCHEST]    = 1,
}

local function AnyPlayerHasStick()
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(coolStickId) then
            return true
        end
    end
    return false
end

function coolStick:OnPickupInit(pickup)
    if pickup.Type ~= EntityType.ENTITY_PICKUP then
        return
    end

    if not chestWhitelist[pickup.Variant] then
        return
    end

    if pickup.Variant == PickupVariant.PICKUP_WOODENCHEST then
        return
    end

    if not AnyPlayerHasStick() then
        return
    end

    local rng = RNG()
    rng:SetSeed(pickup.InitSeed, 0)

    if rng:RandomInt(100) < 15 then
        pickup:Morph(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_WOODENCHEST,
            0,
            true,
            false,
            false
        )
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, coolStick.OnPickupInit)

