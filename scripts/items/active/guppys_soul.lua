local mod = DiesIraeMod

local GuppysSoul = {}

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

mod:AddCallback(ModCallbacks.MC_USE_ITEM, GuppysSoul.UseItem, mod.Items.GuppysSoul)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, GuppysSoul.OnNewRoom)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GuppysSoul.onEntityTakeDmg)

