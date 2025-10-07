local BuriedTreasure = {}
BuriedTreasure.COLLECTIBLE_ID = Enums.Items.BuriedTreasure
local game = Game()

local function SpawnCrawlSpaceNearExit()
    local room = game:GetRoom()
    local center = room:GetCenterPos()

    local crawlPos = center + Vector(80, 0)
    Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, crawlPos, true) 
end

function BuriedTreasure:onBossClear(rng, pos)
    local level = game:GetLevel()
    local roomType = level:GetCurrentRoomDesc().Data.Type
    if roomType == RoomType.ROOM_BOSS then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(BuriedTreasure.COLLECTIBLE_ID) then
                SpawnCrawlSpaceNearExit()
            end
        end
    end
end

function BuriedTreasure:Init(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, BuriedTreasure.onBossClear)

    if EID then
        EID:addCollectible(
            BuriedTreasure.COLLECTIBLE_ID,
            "After defeating a boss, spawns a Crawl Space entrance next to the floor exit",
            "Buried Treasure",
            "en_us"
        )
    end
end

return BuriedTreasure
