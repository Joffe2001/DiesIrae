local ModRef = RegisterMod("Burning Heart", 1)
local BurningHeart = {}
local CUSTOM_HEART_BASE = 100
local rng = RNG()
rng:SetSeed(Random(), 35)
local game = Game()
local burningBoost = {}

local boostMap = {
    [CUSTOM_HEART_BASE + 0] = {stat = "DAMAGE", value = 0.5, sprite = "gfx/items/pick ups/heart_burning_red.png"},
    [CUSTOM_HEART_BASE + 1] = {stat = "SPEED", value = 0.5, sprite = "gfx/items/pick ups/heart_burning_blue.png"},
    [CUSTOM_HEART_BASE + 2] = {stat = "FIREDELAY", value = -0.5, sprite = "gfx/items/pick ups/heart_burning_purple.png"},
    [CUSTOM_HEART_BASE + 3] = {stat = "SHOTSPEED", value = 0.5, sprite = "gfx/items/pick ups/heart_burning_orange.png"},
}

function BurningHeart:PostEntityKill(entity)
    if entity.Type == EntityType.ENTITY_FIREPLACE then
        if rng:RandomFloat() <= 0.05 then
            local subtype = CUSTOM_HEART_BASE + rng:RandomInt(4)
            local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, subtype, entity.Position, Vector.Zero, nil)
            local spriteInfo = boostMap[subtype]
            if spriteInfo then
                local spr = heart:GetSprite()
                spr:ReplaceSpritesheet(0, spriteInfo.sprite)
                spr:LoadGraphics()
            end
        end
    end
end

function BurningHeart:PickupUpdate(pickup)
    if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType >= CUSTOM_HEART_BASE and pickup.SubType <= CUSTOM_HEART_BASE + 3 then
        if not pickup:GetData().IsInitialized then
            local spritePath = boostMap[pickup.SubType].sprite
            pickup:GetSprite():ReplaceSpritesheet(0, spritePath)
            pickup:GetSprite():LoadGraphics()
            pickup:GetData().IsInitialized = true
        end
    end
end

function BurningHeart:OnCollide(pickup, player)
    local id = player.InitSeed
    if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType >= CUSTOM_HEART_BASE and pickup.SubType <= CUSTOM_HEART_BASE + 3 then
        local statInfo = boostMap[pickup.SubType]
        burningBoost[id] = statInfo
        player:AddHearts(1)
        player:AddCacheFlags(CacheFlag["CACHE_" .. statInfo.stat])
        player:EvaluateItems()
        pickup:Remove()
        return true
    end
end

function BurningHeart:OnCache(player, cacheFlag)
    local statInfo = burningBoost[player.InitSeed]
    if not statInfo then return end

    if statInfo.stat == "DAMAGE" and cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + statInfo.value
    elseif statInfo.stat == "SPEED" and cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + statInfo.value
    elseif statInfo.stat == "FIREDELAY" and cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + statInfo.value
    elseif statInfo.stat == "SHOTSPEED" and cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + statInfo.value
    end
end

function BurningHeart:OnDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if player and burningBoost[player.InitSeed] then
        burningBoost[player.InitSeed] = nil
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
end

ModRef:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BurningHeart.PostEntityKill)
ModRef:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, BurningHeart.PickupUpdate)
ModRef:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BurningHeart.OnCollide, PickupVariant.PICKUP_HEART)
ModRef:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BurningHeart.OnCache)
ModRef:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BurningHeart.OnDamage)
