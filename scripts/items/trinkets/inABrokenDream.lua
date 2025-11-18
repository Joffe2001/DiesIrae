local mod = DiesIraeMod
local game = Game()

mod.Trinkets = mod.Trinkets or {}
mod.Trinkets.InABrokenDream = Isaac.GetTrinketIdByName("In a Broken Dream")

local ENDGAME_BOSSES = {
    [EntityType.ENTITY_ISAAC] = true,
    [EntityType.ENTITY_BLUEBABY] = true,
    [EntityType.ENTITY_SATAN] = true,
    [EntityType.ENTITY_THE_LAMB] = true,
    [EntityType.ENTITY_MEGA_SATAN_2] = true,
    [EntityType.ENTITY_MOTHER] = true
}

function mod:OnBossDeath(npc)
    if not ENDGAME_BOSSES[npc.Type] then return end
    if npc.Type == EntityType.ENTITY_DELIRIUM or npc.Type == EntityType.ENTITY_BEAST then return end

    local hasTrinket = false
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(mod.Trinkets.InABrokenDream) then
            hasTrinket = true
            break
        end
    end

    if not hasTrinket then return end

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DELIRIUM_PORTAL, -1, false, false)) do
        if ent:Exists() then
            return
        end
    end
    mod:SchedulePortalSpawn(npc.Position)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnBossDeath)

function mod:UpdatePortalDelay()
    if not mod.PortalDelay then return end
    mod.PortalDelay.Timer = mod.PortalDelay.Timer - 1
    if mod.PortalDelay.Timer <= 0 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DELIRIUM_PORTAL, 0, mod.PortalDelay.Pos, Vector.Zero, nil)
        mod.PortalDelay = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.UpdatePortalDelay)
