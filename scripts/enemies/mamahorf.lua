local mod = DiesIraeMod
local game = Game()

local BULLET_SPEED = 6
local ATTACK_RANGE = 200

---@param MamaHorf EntityNPC
function mod:MamaHorfInit(MamaHorf)
    MamaHorf:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.MamaHorfInit, mod.enemies.MamaHorf)

---@param MamaHorf EntityNPC
function mod:MamaHorfUpdate(MamaHorf)
    local sprite = MamaHorf:GetSprite()
    local target = MamaHorf:GetPlayerTarget()
    local distanceToPlayer = MamaHorf.Position:Distance(target.Position)

    if MamaHorf.State == NpcState.STATE_INIT then
        if sprite:IsFinished("Appear") then
            MamaHorf.State = NpcState.STATE_IDLE
            sprite:Play("Shake")
        end
    end
    if MamaHorf.State == NpcState.STATE_IDLE then
        if sprite:IsFinished("Shake") then
            if distanceToPlayer < ATTACK_RANGE then
                MamaHorf.State = NpcState.STATE_ATTACK
                sprite:Play("Attack")
            end
        end
    end

    if MamaHorf.State == NpcState.STATE_ATTACK then
        if sprite:IsEventTriggered("Shoot") then
            local params = ProjectileParams()
            params.BulletFlags = ProjectileFlags.SMART

            local velocity = (target.Position - MamaHorf.Position):Normalized() * BULLET_SPEED
            MamaHorf:FireProjectiles(MamaHorf.Position, velocity, 0, params)
        end

        if sprite:IsFinished("Attack") then
            MamaHorf.State = NpcState.STATE_IDLE 
            sprite:Play("Shake")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MamaHorfUpdate, mod.enemies.MamaHorf)
