local mod = DiesIraeMod
local Resonance = {}


function Resonance.ApplyResonance(tear)
    if not tear then return end
    tear.Color = Color(0.9, 0.5, 0.1, 1, 0, 0, 0)
    tear:GetData().HasResonance = true
end

function Resonance.OnTearCollision(_, tear, collider)
    if not tear or not tear:GetData().HasResonance then return end
    if not collider or not collider:ToNPC() then return end
    local npc = collider:ToNPC()

    local data = npc:GetData()
    data.ResonanceActive = true
    data.ResonanceTimer = 90
    data.ResonanceEffectTime = Game():GetFrameCount()
    local tearColor = tear.Color
    npc:SetColor(tearColor, 90, 1, false, false)

    npc:TakeDamage(tear.CollisionDamage * 0.5, 0, EntityRef(tear), 0)
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, Resonance.OnTearCollision)

function Resonance.OnNPCUpdate(_, npc)
    local data = npc:GetData()
    if data.ResonanceActive then
        data.ResonanceTimer = (data.ResonanceTimer or 0) - 1
        if data.ResonanceTimer <= 0 then
            data.ResonanceActive = false
            npc:SetColor(Color(1,1,1,1,0,0,0), 1, 0, false, false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Resonance.OnNPCUpdate)

return Resonance
