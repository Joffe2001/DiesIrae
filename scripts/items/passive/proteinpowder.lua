local ProteinPowder = {}
ProteinPowder.ID = Isaac.GetItemIdByName("Protein Powder")
local game = Game()

-- recompute the damage bonus from total count
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

-- Apply the damage bonus
function ProteinPowder:OnEvaluateCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local count = player:GetCollectibleNum(ProteinPowder.ID)
        local bonus = ComputeBonus(count)
        player.Damage = player.Damage + bonus
    end
end

-- Keep pool clean after 4 copies
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

-- Init
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
