local mod = DiesIraeMod
local game = Game()

local devilBoost = 0

function mod:OnEnemyKilled(entity)
    if not entity:IsVulnerableEnemy() or entity:IsBoss() then return end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.Conscience) then
            if math.random() < 0.5 then
                devilBoost = math.min(devilBoost + 0.01, 1.0)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.OnEnemyKilled)

function mod:OnPreDevilApplyItems(baseChance)
    return baseChance + devilBoost
end
mod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, mod.OnPreDevilApplyItems)

function mod:OnNewLevel()
    devilBoost = 0
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevel)
