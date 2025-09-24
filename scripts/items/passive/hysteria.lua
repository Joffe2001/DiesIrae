local Hysteria = {}
Hysteria.ID = Isaac.GetItemIdByName("Hysteria")
local game = Game()
local SFX = SFXManager()

-- Called when player takes damage
function Hysteria:OnTakeDamage(entity, amount, flags, source, countdown)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(Hysteria.ID) then return end

    local data = player:GetData()

    -- Increment damage counter when the player takes damage
    data.HHits = (data.HHits or 0) + 1
    print("Hysteria hits:", data.HHits)

    -- If 2 hits are taken in the room, activate double damage for the room
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

-- Called every frame for each player
function Hysteria:OnPlayerUpdate(_, player)
    if not player or not player:HasCollectible(Hysteria.ID) then return end
    local data = player:GetData()
    local room = game:GetRoom()

    -- On entering a new room, reset hit counter and effects
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

-- Modify stats when effect is active (double damage for the room)
function Hysteria:OnCache(player, cacheFlag)
    local data = player:GetData()
    if not data.HActive then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 2  -- Double the damage
    end
end

-- Reset the effect at the start of a new room
function Hysteria:OnNewRoom()
    local player = Isaac.GetPlayer(0)  -- Get first player
    local data = player:GetData()
    -- Reset the hit counter for each player on entering a new room
    data.HHits = 0
    if data.HActive then
        data.HActive = nil
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        print("Hysteria reset at new room")
    end
end

-- Register callbacks
function Hysteria:Init(mod)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Hysteria.OnTakeDamage)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Hysteria.OnPlayerUpdate)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Hysteria.OnCache)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Hysteria.OnNewRoom)

    if EID then
        EID:addCollectible(
            Hysteria.ID,
            "When taking damage twice in a room, Isaac gains double damage for the rest of the room.",
            "Hysteria",
            "en_us"
        )
    end
end

return Hysteria
