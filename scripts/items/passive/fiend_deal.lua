local mod = DiesIraeMod
local game = Game()

local ITEM_FIEND_DEAL = mod.Items.FiendDeal

mod.FiendBeggarPending = {}

function mod:FiendDealNextFloor()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(ITEM_FIEND_DEAL) then
            mod.FiendBeggarPending[i] = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.FiendDealNextFloor)

function mod:SpawnFiendBeggarFirstRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    if not roomDesc or roomDesc.SafeGridIndex ~= level:GetStartingRoomIndex() then
        return
    end

    for i = 0, game:GetNumPlayers() - 1 do
        if mod.FiendBeggarPending[i] then
            mod.FiendBeggarPending[i] = nil

            local pos = Vector(40, 40)

            Isaac.Spawn(mod.EntityType.FiendBeggar, mod.EntityVariant.FiendBeggar, 0, pos, Vector.Zero, nil)
            print("[Dies Irae] Spawned Fiend Beggar in first room")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnFiendBeggarFirstRoom)
