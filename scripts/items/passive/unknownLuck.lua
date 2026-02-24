local mod = DiesIraeMod
local game = Game()
local UnknownLuck = {}

mod.CollectibleType.COLLECTIBLE_UNKNOWN_LUCK = Isaac.GetItemIdByName("Unknown Luck")

function UnknownLuck:OnNewRoom()
    local room = game:GetRoom()

    if not room:IsFirstVisit() then
        return
    end

    local roomType = room:GetType()
    local hostile =
        roomType == RoomType.ROOM_DEFAULT or
        roomType == RoomType.ROOM_BOSS or
        roomType == RoomType.ROOM_MINIBOSS or
        roomType == RoomType.ROOM_CHALLENGE or
        roomType == RoomType.ROOM_CURSE

    if not hostile then
        return
    end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_UNKNOWN_LUCK) then
            local rng = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_UNKNOWN_LUCK)

            local newLuck = rng:RandomInt(41) - 20
            player.Luck = newLuck
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, UnknownLuck.OnNewRoom)
