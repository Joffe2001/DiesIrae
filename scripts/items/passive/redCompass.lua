---@class ModReference
local mod = DiesIraeMod
local game = Game()

local RED_ROOM_CHANCE = 0.40

local VALID_DOOR_SLOTS = {
    DoorSlot.LEFT0,
    DoorSlot.UP0,
    DoorSlot.RIGHT0,
    DoorSlot.DOWN0
}

function mod:OnRoomClear()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.Items.RedCompass) then
            if math.random() < RED_ROOM_CHANCE then
                local level = game:GetLevel()
                local roomDesc = level:GetCurrentRoomDesc()
                local currentRoomIdx = roomDesc.SafeGridIndex

                local slot = VALID_DOOR_SLOTS[math.random(1, #VALID_DOOR_SLOTS)]

                if level:MakeRedRoomDoor(currentRoomIdx, slot) then
                    print("[Dies Irae] Red Compass: Opened a red room door!")
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnRoomClear)
