local mod = DiesIraeMod

local Hysteria = {}
local game = Game()
local SFX = SFXManager()

function Hysteria:OnTakeDamage(entity, amount, flags, source, countdown)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(mod.Items.Hysteria) then return end

    local data = player:GetData()
    data.HHits = (data.HHits or 0) + 1
    print("Hysteria hits:", data.HHits)

    if data.HHits >= 2 and not data.HActive then
        data.HActive = true
        -- Apply double damage to the room
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()

        -- Play SFX for the activation
        SFX:Play(576)
        print("Hysteria activated for this room!")
    end
end

function Hysteria:OnPlayerUpdate(_, player)
    if not player or not player:HasCollectible(mod.Items.Hysteria) then return end
    local data = player:GetData()
    local room = game:GetRoom()

    if room:GetFrameCount() == 1 then
        data.HHits = 0
        if data.HActive then
            data.HActive = nil
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
            print("Hysteria reset entering new room")
        end
    end
end

function Hysteria:OnCache(player, cacheFlag)
    local data = player:GetData()
    if not data.HActive then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 2 
    end
end

function Hysteria:OnNewRoom()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()
    data.HHits = 0
    if data.HActive then
        data.HActive = nil
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        print("Hysteria reset at new room")
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Hysteria.OnTakeDamage)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Hysteria.OnPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Hysteria.OnCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Hysteria.OnNewRoom)

