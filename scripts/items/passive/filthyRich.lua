local mod = DiesIraeMod

mod.CollectibleType.COLLECTIBLE_FILTHY_RICH = Isaac.GetItemIdByName("Filthy Rich")

local poisonEffects = {
    {color = Color(0.2, 1, 0.2, 1, 0, 0, 0), status = "poison"},
}

local function GetPoisonChance(player)
    local coinCount = player:GetNumCoins()
    local chance = 0.005 * coinCount
    if chance > 0.5 then
        chance = 0.5
    end
    
    return chance
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_FILTHY_RICH) then return end

    local chance = GetPoisonChance(player)
    
    if math.random() < chance then
        local data = tear:GetData()
        data.isPoisonTear = true
        local randomEffect = poisonEffects[1]
        data.PoisonEffect = randomEffect
        tear.Color = randomEffect.color
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    local data = tear:GetData()
    if not data.isPoisonTear then return end
    if not collider or not collider.Position then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local effectData = data.PoisonEffect
    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, collider.Position, Vector.Zero, player)
    local e = cloud:ToEffect()
    if e then
        e.Color = effectData.color
        e.SpriteScale = Vector(1.5, 1.5)
        e:SetTimeout(45)
        e:Update()
        e:GetData().Player = player
        e:GetData().PoisonEffect = effectData
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant ~= EffectVariant.DUST_CLOUD then return end
    local data = effect:GetData()
    if not data or not data.PoisonEffect then return end

    local player = data.Player
    local radius = 60
    local status = data.PoisonEffect.status

    for _, ent in ipairs(Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)) do
        local npc = ent:ToNPC()
        if npc and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            if status == "poison" then
                npc:AddPoison(EntityRef(player), 90, player.Damage)
            end
        end
    end
end)
