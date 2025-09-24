local SatansRemoteShop = {}
SatansRemoteShop.COLLECTIBLE_ID = Isaac.GetItemIdByName("Satan's Remote Shop")
local game = Game()
local sfx = SFXManager()

local usedThisFloor = false

-- Sacrifice Hearts (Red Hearts or Soul Hearts)
local function sacrificeHearts(player)
    if player:GetHearts() > 0 then
        player:AddHearts(-2)  -- Sacrifice 1 Red Heart (2 halves)
        return true
    elseif player:GetSoulHearts() >= 3 then
        player:AddSoulHearts(-3)  -- Sacrifice 3 Soul Hearts
        return true
    end
    return false  -- No heart containers available to sacrifice
end

-- Use Item
function SatansRemoteShop:UseItem(_, _, player)
    if usedThisFloor then
        return false -- silently block reuse
    end

    -- Try to sacrifice hearts (either Red Hearts or Soul Hearts)
    if sacrificeHearts(player) then
        -- Spawn a random devil item pedestal
        local itemId = Isaac.GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, rng:Next())
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemId, player.Position, Vector(0, 0), player)
        
        -- Play sound effect and shake screen for flair
        sfx:Play(SoundEffect.SOUND_DEVILROOM, 1.0, 0, false, 1.0)
        game:ShakeScreen(10)

        -- Mark the item as used on the current floor
        usedThisFloor = true
        player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY) -- forcibly set to 0 to prevent use again

        return true
    else
        -- Play failure sound if no heart containers or soul hearts to sacrifice
        sfx:Play(SoundEffect.SOUND_THUNDER, 1.0, 0, false, 1.0)
        return false  -- Not enough heart containers or soul hearts
    end
end

-- Reset usage on new floor
function SatansRemoteShop:OnNewLevel()
    usedThisFloor = false
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(SatansRemoteShop.COLLECTIBLE_ID) then
            player:SetActiveCharge(4, ActiveSlot.SLOT_PRIMARY) -- full recharge manually
        end
    end
end

-- Prevent auto-recharge from room clears or batteries
function SatansRemoteShop:PreventAutoRecharge(player)
    if usedThisFloor and player:HasCollectible(SatansRemoteShop.COLLECTIBLE_ID) then
        player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY) -- Prevent recharging after use
    end
end

function SatansRemoteShop:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return SatansRemoteShop:UseItem(...)
    end, SatansRemoteShop.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        SatansRemoteShop:OnNewLevel()
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        SatansRemoteShop:PreventAutoRecharge(player)
    end)

    -- EID support
    if EID then
        EID:addCollectible(SatansRemoteShop.COLLECTIBLE_ID,
            "Sacrifice one heart container or three soul hearts#Receive a random devil item pedestal#Can be used once per floor",
            "Satan's Remote Shop",
            "en_us"
        )
    end
end

return SatansRemoteShop
