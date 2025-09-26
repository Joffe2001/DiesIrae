local LastResort = {}
LastResort.COLLECTIBLE_ID = Enums.Items.LastResort
local game = Game()
local sfx = SFXManager()

local statGains = {}
local bonusGivenThisRoom = {}
local wasHostileRoom = {}

local STAT_OPTIONS = {
    { flag = CacheFlag.CACHE_DAMAGE, key = "damage", value = 0.3 },
    { flag = CacheFlag.CACHE_SPEED, key = "speed", value = 0.1 },
    { flag = CacheFlag.CACHE_FIREDELAY, key = "tears", value = -0.3 },
}

function LastResort:GiveStatBoost(player)
    local index = player:GetPlayerIndex()
    statGains[index] = statGains[index] or { damage = 0, speed = 0, tears = 0 }

    local rng = player:GetCollectibleRNG(LastResort.COLLECTIBLE_ID)
    local chosen = STAT_OPTIONS[rng:RandomInt(#STAT_OPTIONS) + 1]

    statGains[index][chosen.key] = statGains[index][chosen.key] + chosen.value

    player:AddCacheFlags(chosen.flag)
    player:EvaluateItems()

    sfx:Play(SoundEffect.SOUND_POWERUP1, 1.0, 0, false, 1.0)
end

function LastResort:OnEvaluateCache(player, cacheFlag)
    local index = player:GetPlayerIndex()
    local gain = statGains[index]
    if not gain then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + gain.damage
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = math.min(player.MoveSpeed + gain.speed, 2.0)
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + gain.tears
    end
end

function LastResort:OnUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(LastResort.COLLECTIBLE_ID) then return end
        if player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then return end

        local index = player:GetPlayerIndex()
        local room = game:GetRoom()
        local hp = player:GetHearts() + player:GetSoulHearts()

        if room:IsClear() and hp == 1 and wasHostileRoom[index] and not bonusGivenThisRoom[index] then
            LastResort:GiveStatBoost(player)
            bonusGivenThisRoom[index] = true
        end
    end
end

function LastResort:OnNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local index = player:GetPlayerIndex()
        bonusGivenThisRoom[index] = false

        local room = game:GetRoom()
        local enemies = room:GetAliveEnemiesCount()

        wasHostileRoom[index] = enemies > 0 or room:IsAmbushActive()
    end
end

function LastResort:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, LastResort.OnUpdate)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LastResort.OnEvaluateCache)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, LastResort.OnNewRoom)

    if EID then
        EID:addCollectible(
            LastResort.COLLECTIBLE_ID,
            "When at half a heart, clearing a hostile room grants a permanent stat boost:#↑ +0.3 Damage OR ↑ +0.1 Speed OR ↑ Tears (random)",
            "Last Resort",
            "en_us"
        )
    end
end

return LastResort
