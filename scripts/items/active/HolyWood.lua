local HolyWood = {}
HolyWood.COLLECTIBLE_ID = Isaac.GetItemIdByName("Holy Wood")

local mantle = CollectibleType.COLLECTIBLE_HOLY_MANTLE
local mantleActive = false
local mantleUsed = false

function HolyWood:UseItem(_, _, player)
    if mantleActive then
        return false -- already active this room
    end

    mantleActive = true
    mantleUsed = false

    -- Add the visual effect of Holy Mantle
    player:AddCollectibleEffect(mantle, true)

    return true
end

function HolyWood:OnNewRoom()
    mantleActive = false
    mantleUsed = false
end

function HolyWood:OnTakeDamage(entity, amount, flags, source, countdown)
    if not mantleActive then return end
    if not entity or entity.Type ~= EntityType.ENTITY_PLAYER then return end

    local player = entity:ToPlayer()
    if not player then return end

    if mantleUsed then return end

    mantleUsed = true

    -- block damage once
    return false
end

function HolyWood:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return HolyWood:UseItem(...)
    end, HolyWood.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        HolyWood:OnNewRoom()
    end)

    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ...)
        return HolyWood:OnTakeDamage(...)
    end)

    if EID then
        EID:addCollectible(HolyWood.COLLECTIBLE_ID,
            "Grants Holy Mantle for the current room",
            "Holy Wood",
            "en_us"
        )
    end
end

return HolyWood