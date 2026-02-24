local mod = DiesIraeMod
local DeliriumEcho = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_DELIRIUM_ECHO = Isaac.GetItemIdByName("Delirium Echo")

-- Per-player stored original active items
local storedActives = {}

-- Helper: get random active item ID
local function GetRandomActive(rng)
    local list = {}

    for id = 1, CollectibleType.NUM_COLLECTIBLES do
        local config = Isaac.GetItemConfig():GetCollectible(id)
        if config and config.Type == ItemType.ITEM_ACTIVE then
            table.insert(list, id)
        end
    end

    if #list == 0 then return 0 end
    return list[rng:RandomInt(#list) + 1]
end


---------------------------------------------------
-- GIVE RANDOM ACTIVE WHEN ENTERING *NEW* ROOM
---------------------------------------------------
function DeliriumEcho:OnNewRoom()
    local room = game:GetRoom()
    if not room:IsFirstVisit() then
        return -- Do nothing in visited rooms
    end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DELIRIUM_ECHO) then

            local id = player.Index
            storedActives[id] = storedActives[id] or {}

            local currentActive = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)

            -- Save original active if not saved already for this room
            storedActives[id].Original = currentActive

            -- Pick random new active
            local rng = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_DELIRIUM_ECHO)
            local newActive = GetRandomActive(rng)

            -- Replace current active
            if newActive > 0 then
                player:RemoveCollectible(currentActive)
                player:AddCollectible(newActive)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DeliriumEcho.OnNewRoom)



---------------------------------------------------
-- RESTORE ORIGINAL ACTIVE WHEN LEAVING ROOM
---------------------------------------------------
function DeliriumEcho:OnRoomClear()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DELIRIUM_ECHO) then
            local id = player.Index
            local stored = storedActives[id]

            if stored and stored.Original then
                local currentActive = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)

                -- Replace random active with original
                if currentActive ~= stored.Original then
                    if currentActive > 0 then
                        player:RemoveCollectible(currentActive)
                    end
                    player:AddCollectible(stored.Original)
                end

                -- Clear stored value
                stored.Original = nil
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, DeliriumEcho.OnRoomClear)
