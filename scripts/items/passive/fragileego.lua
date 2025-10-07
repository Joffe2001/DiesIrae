local FragileEgo = {}
FragileEgo.COLLECTIBLE_ID = Enums.Items.FragileEgo

local players = {}

local function getState(player)
    local id = player.InitSeed
    if not players[id] then
        players[id] = { boosts = {damage = 0, speed = 0, tears = 0, luck = 0} }
    end
    return players[id]
end

local BOOSTS = {
    damage = 0.1,   
    speed = 0.05,   
    tears = 0.1,    
    luck = 0.5     
}

function FragileEgo:onCache(player, cacheFlag)
    if not player:HasCollectible(FragileEgo.COLLECTIBLE_ID) then return end
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

function FragileEgo:onRoomClear()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(FragileEgo.COLLECTIBLE_ID) then
            local state = getState(player)
            local keys = {"damage", "speed", "tears", "luck"}
            local choice = keys[math.random(#keys)]

            state.boosts[choice] = state.boosts[choice] + BOOSTS[choice]

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end
    end
end

function FragileEgo:onPlayerDamage(entity, amount, flags, source, countdown)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if player and player:HasCollectible(FragileEgo.COLLECTIBLE_ID) then
        local state = getState(player)

        state.boosts = {damage = 0, speed = 0, tears = 0, luck = 0}
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 1.0, 0, false, 1.0)

        if math.random() < 0.33 then
            player:AddBrokenHearts(1)
            Game():ShakeScreen(10)
            SFXManager():Play(SoundEffect.SOUND_SAD_TROMBONE, 1.0, 0, false, 1.0)
        end
    end
end


function FragileEgo:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FragileEgo.onCache)
    mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, FragileEgo.onRoomClear)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FragileEgo.onPlayerDamage)

    if EID then
        EID:addCollectible(
            FragileEgo.COLLECTIBLE_ID,
            "↑ Clearing a room grants a random minor stat boost (stacks)#↓ Taking damage removes all boosts #↓ Taking damage may cause a broken heart",
            "Fragile Ego",
            "en_us"
        )
    end
end

return FragileEgo
