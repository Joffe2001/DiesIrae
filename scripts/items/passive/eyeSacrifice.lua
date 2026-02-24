---@class ModReference
local mod = DiesIraeMod
local game = Game()
local EyeSacrifice = {}

mod.CollectibleType.COLLECTIBLE_EYE_SACRIFICE = Isaac.GetItemIdByName("Eye Sacrifice")

function EyeSacrifice:PreTear(player)
    if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_EYE_SACRIFICE) then
        local tearDisplacement = player:GetTearDisplacement()
        if tearDisplacement == -1 then
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, EyeSacrifice.PreTear)
