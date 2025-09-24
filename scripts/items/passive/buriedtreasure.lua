local BuriedTreasure = {}
BuriedTreasure.COLLECTIBLE_ID = Isaac.GetItemIdByName("Buried Treasure")

-- Used to prevent multiple trapdoors from spawning per floor
local crawlspaceSpawned = false

function BuriedTreasure:OnNPCDeath(npc)
    if not npc:IsBoss() or Game():IsGreedMode() then return end
    if crawlspaceSpawned then return end

    local room = Game():GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end
    if not room:IsClear() then return end

    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(BuriedTreasure.COLLECTIBLE_ID) then return end

    -- Delay a bit before spawning crawlspace to avoid overlapping with other rewards
    crawlspaceSpawned = true
    Isaac.RunCallback(ModCallbacks.MC_POST_UPDATE, function()
        local room = Game():GetRoom()
        local level = Game():GetLevel()

        -- Try to find the door to the next floor
        for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(slot)
            if door and door.TargetRoomIndex == level:GetCurrentRoomIndex() + 1 then
                local pos = door.Position + Vector(40, 0) -- Offset to avoid blocking the door
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TRAPDOOR, 1, pos, Vector.Zero, nil)
                break
            end
        end
    end)
end

-- Reset on new level
function BuriedTreasure:OnNewLevel()
    crawlspaceSpawned = false
end

function BuriedTreasure:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, BuriedTreasure.OnNPCDeath)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BuriedTreasure.OnNewLevel)

    if EID then
        EID:addCollectible(
            BuriedTreasure.COLLECTIBLE_ID,
            "After defeating a boss, a crawl space appears near the exit to the next floor.",
            "Buried Treasure",
            "en_us"
        )
    end
end

return BuriedTreasure
