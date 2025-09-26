local ProteinPowder = {}
ProteinPowder.ID = Enums.Items.ProteinPowder
local game = Game()

local function ComputeBonus(count)
    local bonus = 0
    for i = 1, count do
        if i <= 4 then
            bonus = bonus + i
        else
            bonus = bonus + 1
        end
    end
    return bonus
end

function ProteinPowder:OnEvaluateCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local count = player:GetCollectibleNum(ProteinPowder.ID)
        local bonus = ComputeBonus(count)
        player.Damage = player.Damage + bonus
    end
end

function ProteinPowder:OnUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local count = player:GetCollectibleNum(ProteinPowder.ID)
        if count >= 4 and not player:GetData().ProteinPowderRemoved then
            game:GetItemPool():RemoveCollectible(ProteinPowder.ID)
            player:GetData().ProteinPowderRemoved = true
        end
    end
end

function ProteinPowder:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ProteinPowder.OnEvaluateCache)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ProteinPowder.OnUpdate)

    if EID then
        EID:addCollectible(
            ProteinPowder.ID,
            "↑ Gain +1 Damage on first pickup, +2 on second, up to +4.#Further pickups always grant +1 damage.",
            "Protein Powder",
            "en_us"
        )
    end
end

return ProteinPowder
