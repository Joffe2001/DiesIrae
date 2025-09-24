local FixedMetabolism = {}
FixedMetabolism.TRINKET_ID = Isaac.GetTrinketIdByName("Fixed Metabolism")
local game = Game()

-- Replace red poops when a room loads
function FixedMetabolism:PostRoomLoad()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(FixedMetabolism.TRINKET_ID) then
            local room = game:GetRoom()
            for index = 1, room:GetGridSize() do
                local grid = room:GetGridEntity(index)
                if grid and grid:GetType() == GridEntityType.GRID_POOP then
                    local poop = grid:ToPoop()
                    if poop and poop:GetVariant() == 1 then  -- Variant 1 = burning poop
                        room:RemoveGridEntity(index, 0, false)
                        room:SetGridPath(index, 900) -- Needed to make the grid walkable again
                        room:SpawnGridEntity(index, GridEntityType.GRID_POOP, 0, 0, 0)
                    end
                end
            end
            break -- Only need to check one player with the trinket
        end
    end
end

function FixedMetabolism:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FixedMetabolism.PostRoomLoad)

    if EID then
        EID:addTrinket(
            FixedMetabolism.TRINKET_ID,
            "Red poops will be replaced with normal poops on room entry.",
            "Fixed Metabolism"
        )
    end
end

return FixedMetabolism