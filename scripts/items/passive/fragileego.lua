local mod = DiesIraeMod

local FragileEgo = {}

-- Per-player state
local players = {}

local function getState(player)
    local id = player.InitSeed
    if not players[id] then
        players[id] = { boosts = {damage = 0, speed = 0, tears = 0, luck = 0} }
    end
    return players[id]
end

-- Boost pool (minor values so it doesn’t snowball too hard)
local BOOSTS = {
    damage = 0.1,   -- small damage up
    speed = 0.05,   -- small speed up
    tears = 0.1,    -- small tears up
    luck = 0.5      -- small luck up
}

-- Apply cache
function FragileEgo:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.FragileEgo) then return end
    local state = getState(player)
    local boosts = state.boosts

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + boosts.damage
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + boosts.speed
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tears = 30 / (player.MaxFireDelay + 1)
        tears = tears + boosts.tears
        player.MaxFireDelay = (30 / tears) - 1
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + boosts.luck
    end
end

-- Room clear → add random boost
function FragileEgo:onRoomClear()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.FragileEgo) then
            local state = getState(player)
            local keys = {"damage", "speed", "tears", "luck"}
            local choice = keys[math.random(#keys)]

            -- Add one stack of that boost
            state.boosts[choice] = state.boosts[choice] + BOOSTS[choice]

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end
    end
end

-- Taking damage → wipe all boosts and maybe broken heart
function FragileEgo:onPlayerDamage(entity, amount, flags, source, countdown)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if player and player:HasCollectible(mod.Items.FragileEgo) then
        local state = getState(player)

        -- Reset boosts
        state.boosts = {damage = 0, speed = 0, tears = 0, luck = 0}
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 1.0, 0, false, 1.0)

        -- Chance for broken heart (33%)
        if math.random() < 0.33 then
            player:AddBrokenHearts(1)
            Game():ShakeScreen(10)
            SFXManager():Play(SoundEffect.SOUND_SAD_TROMBONE, 1.0, 0, false, 1.0)
        end
    end
end


-- Init
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FragileEgo.onCache)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, FragileEgo.onRoomClear)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FragileEgo.onPlayerDamage)
