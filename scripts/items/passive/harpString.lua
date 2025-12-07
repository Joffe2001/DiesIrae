local mod = DiesIraeMod
local game = Game()

local HarpString = {}

function HarpString:TrackHarpString(player)
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then
        player:GetData().harpStringCount = nil
        return
    end

    local count = player:GetCollectibleNum(mod.Items.HarpString) or 0
    local pdata = player:GetData()

    if pdata.harpStringCount == nil then
        pdata.harpStringCount = count
        return
    end

    if pdata.harpStringCount ~= count then
        pdata.harpStringCount = count
    
        if count == 4 then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                mod.Items.Harp,
                player.Position,
                Vector(10, 0),
                player
            )
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HarpString.TrackHarpString)

function HarpString:SpawnTreasurePedestals()
    local room = game:GetRoom()
    local player = Isaac.GetPlayer(0)

    if player:GetPlayerType() ~= mod.Players.David then return end

    local pdata = player:GetData()
    local harpCount = pdata.harpStringCount or 0
    if harpCount <= 0 then return end

    if room:GetType() ~= RoomType.ROOM_TREASURE then return end

    if pdata.harpPedestalsSpawned == room:GetDecorationSeed() then return end
    pdata.harpPedestalsSpawned = room:GetDecorationSeed()

    local extra = harpCount
    local basePos = room:GetCenterPos()

    for i = 1, extra do
        local offset = Vector(100 * ((i - 1) - extra/2), 0)
        local spawnPos = basePos + offset

        local pedestal = Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            0,
            spawnPos,
            Vector(0, 0),
            nil
        )

        pedestal:GetData().isHarpPedestal = true
        pedestal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, HarpString.SpawnTreasurePedestals)