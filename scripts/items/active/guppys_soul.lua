local GuppysSoul = {}
GuppysSoul.COLLECTIBLE_ID = Enums.Items.GuppysSoul

---@param player EntityPlayer
function GuppysSoul:UseItem(_, _, player)
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false)

    player:AddNullCostume(NullItemID.ID_GUPPY)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim= true
    }
end

function GuppysSoul:OnNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasPlayerForm(PlayerForm.PLAYERFORM_GUPPY) then
            player:TryRemoveNullCostume(NullItemID.ID_GUPPY)
        end
    end
end

---@param entity Entity
function GuppysSoul:onEntityTakeDmg(entity)
    if GuppysSoul.hasGuppyEffect and entity:IsActiveEnemy(true) then
        if math.random() < 0.6 then
            local player = Isaac.GetPlayer(0)
            player:AddBlueFlies(1, player.Position, nil)
        end
    end
end

function GuppysSoul:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return GuppysSoul:UseItem(...)
    end, GuppysSoul.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        GuppysSoul:OnNewRoom()
    end)

    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
        GuppysSoul:onEntityTakeDmg(entity)
    end)

    if EID then
        EID:addCollectible(GuppysSoul.COLLECTIBLE_ID,
            "Grants flight for the room. Dealing damage has a 2/3 chance to spawn blue flies.",
            "Guppy's soul",
            "en_us"
        )
    end
end

return GuppysSoul


