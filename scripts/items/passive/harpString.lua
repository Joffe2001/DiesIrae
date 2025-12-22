local mod = DiesIraeMod
local game = Game()

local HarpString = {}

local HARP_COSTUMES = {
    [1] = {
        hair = mod.Costumes.Harpstring1_hair,
        eyes = mod.Costumes.Harpstring1_eyes
    },
    [2] = {
        hair = mod.Costumes.Harpstring2_hair,
        eyes = mod.Costumes.Harpstring2_eyes
    },
    [3] = {
        hair = mod.Costumes.Harpstring3_hair,
        eyes = mod.Costumes.Harpstring3_eyes
    },
    [4] = {
        hair = mod.Costumes.Harpstring4_hair,
        eyes = mod.Costumes.Harpstring4_eyes
    }
}

---@param player EntityPlayer
function HarpString:TrackHarpString(player)
    if not player then return end

    local pdata = player:GetData()

    if player:GetPlayerType() ~= mod.Players.David then
        pdata.harpStringCount = nil
        pdata.harpCostumeLevel = nil
        for _, data in pairs(HARP_COSTUMES) do
            player:TryRemoveNullCostume(data.hair)
            player:TryRemoveNullCostume(data.eyes)
        end
        return
    end

    local count = player:GetCollectibleNum(mod.Items.HarpString) or 0
    local level = math.min(count, 4)

    if pdata.harpStringCount == count then return end
    pdata.harpStringCount = count

    for _, data in pairs(HARP_COSTUMES) do
        player:TryRemoveNullCostume(data.hair)
        player:TryRemoveNullCostume(data.eyes)
    end

    if level > 0 then
        player:AddNullCostume(HARP_COSTUMES[level].hair)
        player:AddNullCostume(HARP_COSTUMES[level].eyes)
        pdata.harpCostumeLevel = level
    else
        pdata.harpCostumeLevel = nil
    end

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