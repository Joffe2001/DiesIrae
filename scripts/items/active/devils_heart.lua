local mod = DiesIraeMod

local DevilsHeart = {}
local devilEffectActive = false

---@param rng RNG
---@param player EntityPlayer
---@param slot ActiveSlot
function DevilsHeart:OnUseItem(_, rng, player, _, slot, _)
    if rng:RandomFloat() < 0.5 then
        player:AddMaxHearts(2, true)
        player:AddHearts(2)
        SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1.0, 0, false, 1.0)
        Game():GetHUD():ShowItemText("A new heart beats within you...")
    else
        player:AddBrokenHearts(1)
        SFXManager():Play(SoundEffect.SOUND_SATAN_APPEAR, 1.0, 0, false, 1.0)
        Game():GetHUD():ShowItemText("A piece of your soul shatters...")
    end

    devilEffectActive = true

    DevilsHeart:ConvertPedestals()

    player:SetActiveCharge(0, slot)
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function DevilsHeart:ConvertPedestals()
    local entities = Isaac.GetRoomEntities()
    local itemConfig = Isaac.GetItemConfig()

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local pickup = entity:ToPickup()
            if pickup then
                local config = itemConfig:GetCollectible(pickup.SubType)
                if config then
                    if config.Quality == 4 then
                        pickup.Price = -2 -- 2 red hearts
                    else
                        pickup.Price = -1 -- 1 red heart
                    end
                    pickup.AutoUpdatePrice = false
                end
            end
        end
    end
end

function DevilsHeart:OnNewRoom()
    if devilEffectActive then
        DevilsHeart:ConvertPedestals()
    end
end

function DevilsHeart:OnNewLevel()
    devilEffectActive = false
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, DevilsHeart.OnUseItem, mod.Items.DevilsHeart)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DevilsHeart.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, DevilsHeart.OnNewLevel)

if EID then
    EID:addCollectible(
        mod.Items.DevilsHeart,
        "50%: Gain +1 Red Heart Container#50%: Gain +1 Broken Heart" ..
        "#On use: All item pedestals on this floor cost Hearts" ..
        "#6 charges",
        "Devil's Heart",
        "en_us"
    )
end
