local mod = DiesIraeMod

local BackInAnger = {} 
local game = Game()

local fireCooldown = {}

function BackInAnger:onUpdate(player)
    if not player:HasCollectible(mod.Items.BackInAnger) then return end

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

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.Items.BackInAnger)

if EID then
    EID:addCollectible(
        mod.Items.BackInAnger,
        "Automatically fires slower, stronger red homing tears at enemies directly behind Isaac",
        "Back in Anger",
        "en_us"
    )
    EID:assignTransformation("collectible", mod.Items.BackInAnger, "Dad's Playlist")
end
