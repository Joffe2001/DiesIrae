local mod = DiesIraeMod
local game = Game()

local BuriedTreasureMap = {}
local hasBeatenBoss = false
local crawlspaceSpawned = false

function BuriedTreasureMap:OnNewRoom()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()

    -- Check if player has the Buried Treasure Map
    if not player:HasCollectible(mod.Items.BuriedTreasureMap) then return end

    -- If we're in a boss room and the boss is defeated, set the flag
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() and not hasBeatenBoss then
        hasBeatenBoss = true
        crawlspaceSpawned = false
    end

    -- If boss was beaten and we haven't spawned a crawlspace, spawn it in a random empty grid space
    if hasBeatenBoss and not crawlspaceSpawned and room:GetType() ~= RoomType.ROOM_BOSS then
        for i = 0, room:GetGridSize() - 1 do
            local grid = room:GetGridEntity(i)
            -- Ensure grid is empty (no entity in the slot)
            if not grid then
                -- Random position within the room's grid
                local gridPosition = room:GetGridPosition(i)
                
                -- Spawn the trapdoor (GRID_TRAPDOOR) at that position
                room:SpawnGridEntity(i, GridEntityType.GRID_TRAPDOOR, 0, gridPosition.X, gridPosition.Y)
                
                -- Mark the crawlspace as spawned and reset the boss flag
                crawlspaceSpawned = true
                hasBeatenBoss = false
                break
            end
        end
    end
end

-- Add the callback for when a new room is entered
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BuriedTreasureMap.OnNewRoom)
