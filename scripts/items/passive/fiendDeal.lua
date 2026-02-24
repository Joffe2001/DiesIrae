---@class ModReference
local mod = DiesIraeMod
local game = Game()
local fiendDeal = {}

mod.CollectibleType.COLLECTIBLE_FIEND_DEAL = Isaac.GetItemIdByName("Fiend Deal")

function fiendDeal:FiendDeal()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_FIEND_DEAL) then
        return
    end

    local room = game:GetRoom()
    local spawnPos = Vector(room:GetTopLeftPos().X + 60, room:GetTopLeftPos().Y + 60)

    Isaac.Spawn(6, mod.Entities.BEGGAR_Fiend.Var, 0, spawnPos, Vector(0, 0), player):ToNPC()
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, fiendDeal.FiendDeal)
