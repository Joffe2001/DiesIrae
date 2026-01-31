---@class ModReference
local mod = DiesIraeMod

local SPEED = 6
local ATTACK_RANGE = 200
local ATTACK_COOLDOWN = 60

---@param BlindedHorf EntityNPC
function mod:HorfInit(BlindedHorf)
    if BlindedHorf.Variant ~= mod.Entities.NPC_BlindedHorf.Var then return end

    local sprite = BlindedHorf:GetSprite()
    sprite:Play("Appear", true)
    BlindedHorf.State = NpcState.STATE_INIT
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.HorfInit, mod.Entities.NPC_BlindedHorf.Type)

---@param BlindedHorf EntityNPC
function mod:HorfUpdate(BlindedHorf)
    if BlindedHorf.Variant ~= mod.Entities.NPC_BlindedHorf.Var then return end

    local sprite = BlindedHorf:GetSprite()
    local target = BlindedHorf:GetPlayerTarget()
    local dirToPlayer = target.Position - BlindedHorf.Position

    BlindedHorf.Velocity = BlindedHorf.Velocity * 0.9

    if BlindedHorf.State == NpcState.STATE_INIT then
        if sprite:IsFinished("Appear") then
            BlindedHorf.State = NpcState.STATE_IDLE
            sprite:Play("Shake", true)
        end
    end
    
    if BlindedHorf.State == NpcState.STATE_IDLE then
        if not sprite:IsPlaying("Shake") then
            sprite:Play("Shake", true)
        end
        
        if BlindedHorf.I1 > 0 then
            BlindedHorf.I1 = BlindedHorf.I1 - 1
        end

        if BlindedHorf.I1 <= 0 then
            if dirToPlayer:Length() < ATTACK_RANGE
                and Game():GetRoom():CheckLine(target.Position, BlindedHorf.Position, 3, 900) then
                local cnt = 0

                for _, horf in ipairs(Isaac.FindByType(mod.Entities.NPC_Horfling.Type, mod.Entities.NPC_Horfling.Var)) do
                    if horf.Parent and GetPtrHash(horf.Parent) == GetPtrHash(BlindedHorf) then
                        cnt = cnt + 1
                    end
                end

                if cnt < 6 then
                    BlindedHorf.State = NpcState.STATE_ATTACK
                    sprite:Play("Attack", true)
                end
            end
        end
    end

    if BlindedHorf.State == NpcState.STATE_ATTACK then
        if sprite:IsEventTriggered("Shoot") then
            local vel = dirToPlayer:Resized(SPEED)
            local horfling = Isaac.Spawn(mod.Entities.NPC_Horfling.Type,
                mod.Entities.NPC_Horfling.Var,
                0,
                BlindedHorf.Position + dirToPlayer:Resized(30),
                vel,
                BlindedHorf):ToNPC()
            if horfling then
                horfling:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                horfling.State = NpcState.STATE_IDLE
                horfling.Parent = BlindedHorf
                mod.SaveManager.GetRoomSave(horfling).shoot_vel = vel
            end
        end

        if sprite:IsFinished("Attack") then
            BlindedHorf.State = NpcState.STATE_IDLE
            BlindedHorf.I1 = ATTACK_COOLDOWN
            sprite:Play("Shake", true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.HorfUpdate, mod.Entities.NPC_BlindedHorf.Type)