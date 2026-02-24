---@class ModReference
local mod = DiesIraeMod
local game = Game()
local conscience = {}

mod.CollectibleType.COLLECTIBLE_CONSCIENCE = Isaac.GetItemIdByName("Conscience")

local devilBoost = 0

function conscience:OnEnemyKilled(entity)
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
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, conscience.OnEnemyKilled)

function conscience:OnPreDevilApplyItems(baseChance)
    return baseChance + devilBoost
end
mod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, conscience.OnPreDevilApplyItems)

function conscience:OnNewLevel()
    devilBoost = 0
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, conscience.OnNewLevel)
