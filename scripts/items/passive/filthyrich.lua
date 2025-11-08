local mod = DiesIraeMod
local game = Game()


local BASE_AURA_RADIUS = 40
local BASE_DAMAGE = 1
local MAX_COINS = 199

function mod:OnEvaluateCustomCache(player, tag)
    if not player:HasCollectible(mod.Items.FilthyRich) then return end
    if tag == "maxcoins" then
        if player:GetNumCoins() > MAX_COINS then
            player:SetNumCoins(MAX_COINS, true)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.OnEvaluateCustomCache)

function mod:FilthyRichAura()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.FilthyRich) then
            local coins = player:GetNumCoins()
            local radius = BASE_AURA_RADIUS + coins * 0.5
            local damage = BASE_DAMAGE + coins * 0.05

            local enemies = Isaac.FindInRadius(player.Position, radius, EntityPartition.ENEMY)
            for _, enemy in ipairs(enemies) do
                if enemy:IsVulnerableEnemy() and not enemy:IsDead() then
                    enemy:TakeDamage(damage, DamageFlag.DAMAGE_FIRE, EntityRef(player), 0)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.FilthyRichAura)
