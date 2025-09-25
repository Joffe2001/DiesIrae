local SatansRemoteShop = {}
SatansRemoteShop.COLLECTIBLE_ID = Enums.Items.SatansRemoteShop

local usedThisFloor = false

---@param player EntityPlayer
---@return boolean
local function sacrificeHearts(player)
    if player:GetHearts() > 0 then
        player:AddHearts(-2)
        return true
    elseif player:GetSoulHearts() >= 3 then
        player:AddSoulHearts(-3)
        return true
    end
    return false
end

---@param player EntityPlayer
function SatansRemoteShop:UseItem(_, _, player)
    if usedThisFloor then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end

    if sacrificeHearts(player) then
        local itemId = GameRef:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, RNG():Next())
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemId, player.Position, Vector(0, 0), player)
        
        SfxManager:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1.0, 0, false, 1.0)
        GameRef:ShakeScreen(10)

        usedThisFloor = true

        return {
            Discharge = true,
            Remove = false,
            ShowAnim =true
        }

    else
        SfxManager:Play(SoundEffect.SOUND_SHELLGAME, 1.0, 0, false, 1.0)
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end
end

function SatansRemoteShop:OnNewLevel()
    usedThisFloor = false
    for i = 0, GameRef:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local slot = player:GetActiveItemSlot(SatansRemoteShop.COLLECTIBLE_ID)
        if slot then
            player:FullCharge(slot)
        end
    end
end

function SatansRemoteShop:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return SatansRemoteShop:UseItem(...)
    end, SatansRemoteShop.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        SatansRemoteShop:OnNewLevel()
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
