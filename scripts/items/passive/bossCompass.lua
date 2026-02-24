---@class ModReference
local mod = DiesIraeMod
local game = Game()
local bossCompass = {}

mod.CollectibleType.COLLECTIBLE_BOSS_COMPASS = Isaac.GetItemIdByName("Boss Compass")

local damageBoosts = {}

local function GetPlayerIndex(player)
    return GetPtrHash(player)
end

local function ApplyDamageBoost(player, amount)
    local idx = GetPlayerIndex(player)
    damageBoosts[idx] = (damageBoosts[idx] or 0) + amount

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end

function bossCompass:OnEvaluateCache(player, cacheFlag)
    if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_BOSS_COMPASS) then return end

    local idx = GetPlayerIndex(player)
    local bonus = damageBoosts[idx] or 0
    player.Damage = player.Damage + bonus
end

function bossCompass:OnBossDeath(npc)
    if not npc:IsBoss() then return end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_BOSS_COMPASS) then
            local roomType = game:GetLevel():GetCurrentRoomDesc().Data.Type

            if roomType == RoomType.ROOM_BOSS then
                ApplyDamageBoost(player, 0.2)
            elseif roomType == RoomType.ROOM_MINIBOSS then
                ApplyDamageBoost(player, 0.1)
            end
        end
    end
end

function bossCompass:BossCompassRender()
    local level = game:GetLevel()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_BOSS_COMPASS) then
            for j = 0, level:GetRooms().Size - 1 do
                local roomDesc = level:GetRooms():Get(j)
                local rType = roomDesc.Data.Type
                if rType == RoomType.ROOM_BOSS or rType == RoomType.ROOM_MINIBOSS then
                    roomDesc.DisplayFlags = roomDesc.DisplayFlags | RoomDescriptor.DISPLAY_ICON
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, bossCompass.BossCompassRender)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bossCompass.OnEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, bossCompass.OnBossDeath)
