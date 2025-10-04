local Engel = {}
Engel.COLLECTIBLE_ID = Enums.Items.Engel
local game = Game()

local function IsAlwaysFlying(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_AZAZEL
        or playerType == PlayerType.PLAYER_THELOST
        or playerType == PlayerType.PLAYER_THELOST_B
end

local function IsInBeastFight()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE8 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B
end

function Engel:onCache(player, cacheFlag)
    if not player:HasCollectible(Engel.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 5

    elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING

    elseif cacheFlag == CacheFlag.CACHE_FLYING then
        -- Only disable flying if player isn’t supposed to fly
        if not IsAlwaysFlying(player) and not IsInBeastFight() then
            player.CanFly = false
        end
    end
end

function Engel:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Engel.onCache)

    if EID then
        EID:addCollectible(
            Engel.COLLECTIBLE_ID,
            "↑ +5 Luck#Grants spectral + homing tears#Disables flight",
            "Engel",
            "en_us"
        )
    end
end

return Engel

