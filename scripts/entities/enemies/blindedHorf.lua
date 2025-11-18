local mod = DiesIraeMod

local SPEED = 6
local ATTACK_RANGE = 200
local ATTACK_COOLDOWN = 120

---@param MamaHorf EntityNPC
function mod:MamaHorfUpdate(MamaHorf)
    if MamaHorf.Variant ~= mod.Entities.MamaHorf.Var then return end

    local sprite = MamaHorf:GetSprite()
    local target = MamaHorf:GetPlayerTarget()
    local dirToPlayer = target.Position - MamaHorf.Position

    MamaHorf.Velocity = MamaHorf.Velocity - MamaHorf.Velocity:Resized(MamaHorf.Velocity:Length() * 0.1)

    if MamaHorf.State == NpcState.STATE_INIT then
        if sprite:IsFinished("Appear") then
            MamaHorf.State = NpcState.STATE_IDLE
            sprite:Play("Shake")
        end
    end
    if MamaHorf.State == NpcState.STATE_IDLE then
        if MamaHorf.I1 > 0 then
            MamaHorf.I1 = MamaHorf.I1 - 1
        end

        if MamaHorf.I1 <= 0 then
            if dirToPlayer:Length() < ATTACK_RANGE then
                local cnt = 0

                for _, horf in ipairs(Isaac.FindByType(mod.Entities.Horfling.Type, mod.Entities.Horfling.Var)) do
                    if GetPtrHash(horf.Parent) == GetPtrHash(MamaHorf) then
                        cnt = cnt + 1
                    end
                end

                if cnt < 3 then
                    MamaHorf.State = NpcState.STATE_ATTACK
                    sprite:Play("Attack", true)
                end
            end
        end
    end

    if MamaHorf.State == NpcState.STATE_ATTACK then
        if sprite:IsEventTriggered("Shoot") then
            local vel = dirToPlayer:Resized(SPEED)
            local horfling = Isaac.Spawn(mod.Entities.Horfling.Type,
                                        mod.Entities.Horfling.Var,
                                        math.random(0, 2),
                                        MamaHorf.Position + dirToPlayer:Resized(30),
                                        vel,
                                        MamaHorf):ToNPC()
            horfling:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            horfling.Parent = MamaHorf
            mod.Utils:GetData(horfling).shoot_vel = vel
        end

        if sprite:IsFinished("Attack") then
            MamaHorf.State = NpcState.STATE_IDLE 
            MamaHorf.I1 = ATTACK_COOLDOWN
            sprite:Play("Shake")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MamaHorfUpdate, mod.Entities.MamaHorf.Type)
