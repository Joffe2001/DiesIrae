local TrinketCollector = {}
TrinketCollector.TRINKET_ID = DiesIraeMod.Trinkets.TrinketCollector
local game = Game()

local swallowedTrinkets = {}

function TrinketCollector:onPickupUpdate(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_TRINKET then return end
    if pickup.FrameCount > 1 then return end 

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(TrinketCollector.TRINKET_ID) then
            local newTrinket = pickup.SubType
            if newTrinket == TrinketCollector.TRINKET_ID then return end

            local data = player:GetData()
            data.SwallowedTrinkets = data.SwallowedTrinkets or {}

            if not data.SwallowedTrinkets[newTrinket] then
                player:AddTrinket(newTrinket)
                player:TryRemoveTrinket(newTrinket)

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1.0)

                data.SwallowedTrinkets[newTrinket] = true

                pickup:Remove()
                break
            end
        end
    end
end

function TrinketCollector:onPlayerUpdate(player)
    local data = player:GetData()
    if not data.SwallowedTrinkets then return end

    for trinketId, _ in pairs(data.SwallowedTrinkets) do
        if not player:HasTrinket(trinketId) then
            player:AddTrinket(trinketId)
            player:TryRemoveTrinket(trinketId)
        end
    end
end

function TrinketCollector:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, TrinketCollector.onPickupUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, TrinketCollector.onPlayerUpdate)

    if EID then
        EID:addTrinket(
            TrinketCollector.TRINKET_ID,
            "Automatically gulps every other trinket you pick up.#Their effects apply passively without using a slot.#Cannot gulp itself.",
            "Trinket Collector",
            "en_us"
        )
    end
end

return TrinketCollector
