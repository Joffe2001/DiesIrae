local Masochism = {}
Masochism.COLLECTIBLE_ID = Isaac.GetItemIdByName("Masochism")

-- Table to track how many times player has taken damage
local playerStatTracker = {}

function Masochism:OnTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(Masochism.COLLECTIBLE_ID) then return end

    local id = player:GetCollectibleRNG(Masochism.COLLECTIBLE_ID):GetSeed()
    if not playerStatTracker[id] then
        playerStatTracker[id] = {
            damage = 0,
            tears = 0,
            speed = 0,
            range = 0,
            luck = 0,
            shotspeed = 0
        }
    end

    local boosts = {"damage", "tears", "speed", "range", "luck", "shotspeed"}
    local chosen = boosts[math.random(#boosts)]

    playerStatTracker[id][chosen] = playerStatTracker[id][chosen] + 1
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

function Masochism:onCache(player, cacheFlag)
    local id = player:GetCollectibleRNG(Masochism.COLLECTIBLE_ID):GetSeed()
    local data = playerStatTracker[id]
    if not data then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + data.damage * 0.2
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay - (data.tears * 0.2)
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + data.speed * 0.1
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight - (data.range * 0.5)
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + data.luck * 0.5
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + data.shotspeed * 0.1
    end
end

function Masochism:Init(mod)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Masochism.OnTakeDamage)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Masochism.onCache)

    if EID then
        EID:addCollectible(
            Masochism.COLLECTIBLE_ID,
            "Taking damage grants a random small permanent stat boost",
            "Masochism",
            "en_us"
        )
    end
end

return Masochism
