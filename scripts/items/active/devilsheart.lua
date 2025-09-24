local DevilsHeart = {}
DevilsHeart.COLLECTIBLE_ID = Isaac.GetItemIdByName("Devil's Heart")
local game = Game()
local devilEffectActive = false -- floor-wide flag

---------------------------------------------------------
-- ON USE
---------------------------------------------------------
function DevilsHeart:OnUseItem(_, rng, player, flags, slot, varData)
    local rand = rng:RandomFloat()

    if rand < 0.5 then
        -- GOOD OUTCOME: +1 Red Heart Container
        player:AddMaxHearts(2, true)
        player:AddHearts(2)
        SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1.0, 0, false, 1.0)
        game:GetHUD():ShowItemText("A new heart beats within you...")
    else
        -- BAD OUTCOME: +1 Broken Heart
        player:AddBrokenHearts(1)
        SFXManager():Play(SoundEffect.SOUND_SATAN_APPEAR, 1.0, 0, false, 1.0)
        game:GetHUD():ShowItemText("A piece of your soul shatters...")
    end

    -- Activate devil pedestal effect for the floor
    devilEffectActive = true

    -- Also convert pedestals in the current room immediately
    DevilsHeart:ConvertPedestals(rng)

    player:SetActiveCharge(0, slot)
    return true
end

---------------------------------------------------------
-- CONVERT PEDESTALS
---------------------------------------------------------
function DevilsHeart:ConvertPedestals(rng)
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

---------------------------------------------------------
-- APPLY EFFECT IN NEW ROOMS
---------------------------------------------------------
function DevilsHeart:OnNewRoom()
    if devilEffectActive then
        local rng = RNG()
        rng:SetSeed(game:GetSeeds():GetStartSeed(), 35)
        DevilsHeart:ConvertPedestals(rng)
    end
end

---------------------------------------------------------
-- RESET FLAG EACH FLOOR
---------------------------------------------------------
function DevilsHeart:OnNewLevel()
    devilEffectActive = false
end

---------------------------------------------------------
-- INIT
---------------------------------------------------------
function DevilsHeart:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, DevilsHeart.OnUseItem, DevilsHeart.COLLECTIBLE_ID)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DevilsHeart.OnNewRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, DevilsHeart.OnNewLevel)

    if EID then
        EID:addCollectible(
            DevilsHeart.COLLECTIBLE_ID,
            "50%: Gain +1 Red Heart Container#50%: Gain +1 Broken Heart" ..
            "#On use: All pedestal items on this floor cost hearts (Devil-style)" ..
            "#6 charges",
            "Devil's Heart",
            "en_us"
        )
    end
end

return DevilsHeart
