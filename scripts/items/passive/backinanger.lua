local BackInAnger = {} 
BackInAnger.COLLECTIBLE_ID = Isaac.GetItemIdByName("Back in Anger")
local game = Game()

-- Custom fire delay tracker
local fireCooldown = {}

function BackInAnger:onUpdate(player)
    if not player:HasCollectible(BackInAnger.COLLECTIBLE_ID) then return end

    local id = player.InitSeed
    if fireCooldown[id] == nil then fireCooldown[id] = 0 end

    if fireCooldown[id] > 0 then
        fireCooldown[id] = fireCooldown[id] - 1
        return
    end

    local backDir = -player:GetAimDirection() -- opposite of aim
    if backDir:Length() == 0 then
        backDir = Vector(0,1) -- default back direction (down) if idle
    end

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() and not e:IsDead() then
            local toEnemy = (e.Position - player.Position):Normalized()
            -- Check if enemy is in ~20° cone behind Isaac
            if backDir:Dot(toEnemy) > 0.95 then
                -- Fire a slower but stronger homing tear at them
                local tear = player:FireTear(
                    player.Position,
                    toEnemy * 7, -- slower velocity
                    false, true, false, player, 0
                )
                if tear then
                    tear.CollisionDamage = player.Damage * 1.5
                    tear.Scale = tear.Scale * 1.3
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                    tear.Color = Color(1.5, 0.2, 0.2, 1, 0, 0, 0) -- red
                end

                -- Set cooldown: 75% of normal fire delay
                fireCooldown[id] = math.floor(player.MaxFireDelay * 1.25)
                break
            end
        end
    end
end

function BackInAnger:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BackInAnger.onUpdate)

    if EID then
        EID:addCollectible(
            BackInAnger.COLLECTIBLE_ID,
            "Automatically fires slower, stronger red homing tears at enemies directly behind Isaac",
            "Back in Anger",
            "en_us"
        )
        EID:assignTransformation("collectible", BackInAnger.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return BackInAnger
