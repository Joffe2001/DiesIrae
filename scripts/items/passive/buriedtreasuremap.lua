local mod = DiesIraeMod

local BuriedTreasureMap = {}
local game = Game()

local hasBeatenBoss = false
local crawlspaceSpawned = false

function BuriedTreasureMap:OnNewRoom()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()

    -- Check if player has the item
    if not player:HasCollectible(mod.Items.BuriedTreasureMap) then return end

    -- If in boss room and it's clear, mark that the boss is defeated
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() and not hasBeatenBoss then
        hasBeatenBoss = true
        crawlspaceSpawned = false
    end

    -- If boss was beaten and we enter a non-boss room, spawn crawl space
    if hasBeatenBoss and not crawlspaceSpawned and room:GetType() ~= RoomType.ROOM_BOSS then
        for i = 0, room:GetGridSize() - 1 do
            local grid = room:GetGridEntity(i)
            if not grid then
                room:SpawnGridEntity(i, GridEntityType.GRID_TRAPDOOR, 0, 0, 0)
                crawlspaceSpawned = true
                hasBeatenBoss = false
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BuriedTreasureMap.OnNewRoom)
