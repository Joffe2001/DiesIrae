local mod = DiesIraeMod

local SPEED = 6
local ATTACK_RANGE = 200
local ATTACK_COOLDOWN = 60

local gfx = {
	[1] = "gfx/enemies/horfling1.png",
	[2] = "gfx/enemies/horfling2.png",
}

function mod:HorflingInit(horf)
	if horf.Variant ~= mod.Entities.NPC_Horfling.Var then return end

    horf.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    horf.State = NpcState.STATE_IDLE
    horf:GetSprite():Play("Shake", true)

	if horf.SubType ~= 0 then
		horf:GetSprite():ReplaceSpritesheet(0, gfx[horf.SubType] or "", true)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.HorflingInit, mod.Entities.NPC_Horfling.Type)

function mod:HorflingUpdate(horf)
	if horf.Variant ~= mod.Entities.NPC_Horfling.Var then return end

    local data = mod.Utils:GetData(horf)
	local sprite = horf:GetSprite()
    local target = horf:GetPlayerTarget()
    local dirToPlayer = target.Position - horf.Position

    if data.shoot_vel then
        horf.Velocity = data.shoot_vel
    else
        horf.Velocity = horf.Velocity - horf.Velocity:Resized(horf.Velocity:Length() * 0.1)
    end

    if horf.State == NpcState.STATE_IDLE then
        if horf.I1 > 0 then
            horf.I1 = horf.I1 - 1
        end

        if horf.I1 <= 0 then
            if dirToPlayer:Length() < ATTACK_RANGE 
                and Game():GetRoom():CheckLine(target.Position, horf.Position, 3, 900) then
                horf.State = NpcState.STATE_ATTACK
                sprite:Play("Attack", true)
            end
        end
    end

    if horf.State == NpcState.STATE_ATTACK then
        if sprite:IsEventTriggered("Shoot") then
            local params = ProjectileParams()
            params.Scale = 0.5

            horf:FireProjectiles(horf.Position,
            					dirToPlayer:Resized(SPEED),
            					0,
            					params)
        end

        if sprite:IsFinished("Attack") then
            horf.State = NpcState.STATE_IDLE 
            sprite:Play("Shake")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.HorflingUpdate, mod.Entities.NPC_Horfling.Type)

mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, function(_, horf)
    if horf.Variant ~= mod.Entities.NPC_Horfling.Var then return end

    if mod.Utils:GetData(horf).shoot_vel then
        mod.Utils:GetData(horf).shoot_vel = nil
    end
end, mod.Entities.NPC_Horfling.Type)

mod:AddCallback(ModCallbacks.MC_NPC_GRID_COLLISION, function(_, horf, _, grid)
    if not (horf.Variant == mod.Entities.NPC_Horfling.Var and grid) then return end

    if mod.Utils:GetData(horf).shoot_vel then
        mod.Utils:GetData(horf).shoot_vel = nil
    end
end, mod.Entities.NPC_Horfling.Type)
