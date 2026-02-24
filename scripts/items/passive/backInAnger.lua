local mod = DiesIraeMod

local BackInAnger = {} 
local game = Game()

mod.CollectibleType.COLLECTIBLE_BACK_IN_ANGER = Isaac.GetItemIdByName("Back In Anger")

local fireCooldown = {}

function BackInAnger:onUpdate(player)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_BACK_IN_ANGER) then return end

    local id = player.InitSeed
    if fireCooldown[id] == nil then fireCooldown[id] = 0 end

    if fireCooldown[id] > 0 then
        fireCooldown[id] = fireCooldown[id] - 1
        return
    end

    local backDir = -player:GetAimDirection()
    if backDir:Length() == 0 then
        backDir = Vector(0,1)
    end

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() and not e:IsDead() then
            local toEnemy = (e.Position - player.Position):Normalized()
            if backDir:Dot(toEnemy) > 0.95 then
                local tear = player:FireTear(
                    player.Position,
                    toEnemy * 7, 
                    false, true, false, player, 0
                )
                if tear then
                    tear.CollisionDamage = player.Damage * 1.5
                    tear.Scale = tear.Scale * 1.3
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                    tear.Color = Color(1.5, 0.2, 0.2, 1, 0, 0, 0) 
                end

                fireCooldown[id] = math.floor(player.MaxFireDelay * 1.25)
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CollectibleType.COLLECTIBLE_BACK_IN_ANGER)

if EID then
   EID:addCollectible(mod.CollectibleType.COLLECTIBLE_BACK_IN_ANGER, {
        en_us = { 
            "Tears are fired from your bag (based on moving)",
            "↑ +4 Damage"
        },
        ru = { 
            "Стрельба сзади (зависит от направления движения)",
            "↑ +4 Урона"
        },
    })
end
