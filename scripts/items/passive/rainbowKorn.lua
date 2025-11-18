local mod = DiesIraeMod
local game = Game()

local KoRn = mod.Items.KoRn

local tearEffects = {
    {color = Color(1, 0.4, 1, 1, 0, 0, 0), status = "charm"},      -- Pink
    {color = Color(0.4, 0.6, 1, 1, 0, 0, 0), status = "freeze"},   -- Blue
    {color = Color(0.2, 1, 0.2, 1, 0, 0, 0), status = "poison"},   -- Green
    {color = Color(1, 1, 0.2, 1, 0, 0, 0), status = "midas"},      -- Yellow
    {color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0), status = "slow"},   -- Black
    {color = Color(0.7, 0.7, 0.7, 1, 0, 0, 0), status = "confuse"},-- Gray
    {color = Color(0.6, 0.2, 1, 1, 0, 0, 0), status = "fear"},     -- Purple
}

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(KoRn) then return end

    if math.random() < 0.10 then
        local data = tear:GetData()
        data.isRainbowTear = true
        local randomEffect = tearEffects[math.random(#tearEffects)]
        data.RainbowEffect = randomEffect
        tear.Color = randomEffect.color
    end
end)


mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    local data = tear:GetData()
    if not data.isRainbowTear then return end
    if not collider or not collider.Position then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local effectData = data.RainbowEffect
    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, collider.Position, Vector.Zero, player)
    local e = cloud:ToEffect()
    if e then
        e.Color = effectData.color
        e.SpriteScale = Vector(1.5, 1.5)
        e:SetTimeout(45)
        e:Update()
        e:GetData().Player = player
        e:GetData().RainbowEffect = effectData
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant ~= EffectVariant.DUST_CLOUD then return end
    local data = effect:GetData()
    if not data or not data.RainbowEffect then return end

    local player = data.Player
    local radius = 60
    local status = data.RainbowEffect.status

    for _, ent in ipairs(Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)) do
        local npc = ent:ToNPC()
        if npc and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            if status == "charm" then
                npc:AddCharmed(EntityRef(player), 90)
            elseif status == "freeze" then
                npc:AddFreeze(EntityRef(player), 90)
            elseif status == "poison" then
                npc:AddPoison(EntityRef(player), 90, player.Damage)
            elseif status == "midas" then
                npc:AddMidasFreeze(EntityRef(player), 90)
            elseif status == "slow" then
                npc:AddSlowing(EntityRef(player), 90, 0.5, Color(0,0,0,1))
            elseif status == "confuse" then
                npc:AddConfusion(EntityRef(player), 90, false)
            elseif status == "fear" then
                npc:AddFear(EntityRef(player), 90)
            end
        end
    end
end)