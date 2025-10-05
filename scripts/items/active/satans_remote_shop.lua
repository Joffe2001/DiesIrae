local mod = DiesIraeMod

local SatansRemoteShop = {}

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
        local itemId = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, RNG():Next())
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemId, player.Position, Vector(0, 0), player)
        
        SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1.0, 0, false, 1.0)
        Game():ShakeScreen(10)

        usedThisFloor = true

        return {
            Discharge = true,
            Remove = false,
            ShowAnim =true
        }

    else
        SFXManager():Play(SoundEffect.SOUND_SHELLGAME, 1.0, 0, false, 1.0)
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end
end

function SatansRemoteShop:OnNewLevel()
    usedThisFloor = false
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local slot = player:GetActiveItemSlot(mod.Items.SatansRemoteShop)
        if slot then
            player:FullCharge(slot)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, SatansRemoteShop.UseItem, mod.Items.SatansRemoteShop)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SatansRemoteShop.OnNewLevel)

-- EID support
if EID then
    EID:addCollectible(mod.Items.SatansRemoteShop,
        "Sacrifice one heart container or three soul hearts#Receive a random devil item pedestal#Can be used once per floor",
        "Satan's Remote Shop",
        "en_us"
    )
end
