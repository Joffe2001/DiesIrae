local mod = DiesIraeMod
local ProteinPowder = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_PROTEIN_POWDER = Isaac.GetItemIdByName("Protein Powder")

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
        local count = player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_PROTEIN_POWDER)
        local bonus = ComputeBonus(count)
        player.Damage = player.Damage + bonus
    end
end

function ProteinPowder:OnUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local count = player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_PROTEIN_POWDER)
        if count >= 4 and not player:GetData().ProteinPowderRemoved then
            game:GetItemPool():RemoveCollectible(mod.CollectibleType.COLLECTIBLE_PROTEIN_POWDER)
            player:GetData().ProteinPowderRemoved = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ProteinPowder.OnEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ProteinPowder.OnUpdate)

