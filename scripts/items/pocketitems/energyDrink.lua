local mod = DiesIraeMod
local game = Game()

local ENERGY_DRINK_DURATION = 15 * 30 
local ENERGY_DRINK_BONUS = 0.5
local ENERGY_DRINK_PENALTY = -0.1

local function IsEnergyDrinkActive(player)
    local data = player:GetData()
    return data.EnergyDrinkActive and game:GetFrameCount() - data.EnergyDrinkStartFrame < ENERGY_DRINK_DURATION
end

function mod:UseEnergyDrink(card, player, flags)
    if card == mod.Cards.EnergyDrink then
        local data = player:GetData()
        data.EnergyDrinkActive = true
        data.EnergyDrinkStartFrame = Game():GetFrameCount()
        data.EnergyDrinkPenalty = false
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()

        SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseEnergyDrink)

function mod:OnEvaluateCache(player, cacheFlag)
    local data = player:GetData()

    if IsEnergyDrinkActive(player) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + ENERGY_DRINK_BONUS
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = math.max(1, player.MaxFireDelay - 1)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + ENERGY_DRINK_BONUS
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + ENERGY_DRINK_BONUS * 40
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + ENERGY_DRINK_BONUS
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + ENERGY_DRINK_BONUS
        end
    
    elseif data.EnergyDrinkPenalty then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + ENERGY_DRINK_PENALTY
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = math.max(1, player.MaxFireDelay + 1)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + ENERGY_DRINK_PENALTY
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + ENERGY_DRINK_PENALTY * 40
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + ENERGY_DRINK_PENALTY
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + ENERGY_DRINK_PENALTY
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnEvaluateCache)

function mod:OnUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if data.EnergyDrinkActive and not IsEnergyDrinkActive(player) then
            data.EnergyDrinkActive = false
            data.EnergyDrinkPenalty = true
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)

function mod:OnNewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        data.EnergyDrinkActive = false
        data.EnergyDrinkPenalty = false
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
