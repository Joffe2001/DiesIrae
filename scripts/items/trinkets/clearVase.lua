local ClearVase = {}
ClearVase.TRINKET_ID = Enums.Trinkets.ClearVase

local game = Game()
local brokenPots = {}

function ClearVase:TrackPotDestruction()
    local room = game:GetRoom()

    for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == GridEntityType.GRID_POT then
            if grid:ToRock():IsBroken() and not brokenPots[i] then
                brokenPots[i] = true
            end
        end
    end
end

function ClearVase:OnNewRoom()
    brokenPots = {}
end

function ClearVase:OnEntitySpawn(type, variant, subtype, position, velocity, spawner, seed)
    local player = Isaac.GetPlayer(0)
    if not player:HasTrinket(ClearVase.TRINKET_ID) then return end

    local golden = player:HasGoldenTrinket(ClearVase.TRINKET_ID)
    local rng = RNG()
    rng:SetSeed(seed, 35)

    if type == EntityType.ENTITY_SPIDER or type == EntityType.ENTITY_ATTACKFLY then
        return { Remove = true }
    end

    if type == EntityType.ENTITY_PICKUP then
        if variant == PickupVariant.PICKUP_HEART or variant == PickupVariant.PICKUP_COIN then
            if not golden or rng:RandomFloat() > 0.5 then
                return { Remove = true }
            end
        end
    end
end

function ClearVase:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() ClearVase:TrackPotDestruction() end)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() ClearVase:OnNewRoom() end)
    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, ClearVase.OnEntitySpawn)
end

return ClearVase
