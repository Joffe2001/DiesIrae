local D8055 = {}
D8055.COLLECTIBLE_ID = Enums.Items.D8055

--TODO: Remove this script. It does not seem to be in use.

-- Main effect
function D8055:onUse(_, _, player, _, _)
    local room = GameRef:GetRoom()

    -- Only in boss rooms, and only if boss is alive
    if room:GetType() == RoomType.ROOM_BOSS then
        local hasBoss = false
        local bossEntity = nil

        -- Find the current boss entity
        for _, e in ipairs(Isaac.GetRoomEntities()) do
            if e:IsActiveEnemy() and e:IsBoss() and not e:IsDead() then
                hasBoss = true
                bossEntity = e
                break
            end
        end

        -- Only proceed if there is a live boss
        if hasBoss then
            -- Restart the room with a new boss
            local level = GameRef:GetLevel()
            local stage = level:GetStage()
            local stageType = level:GetStageType()

            -- Restart the room layout, this will force all entities to respawn
            room:RespawnEnemies()

            -- Force a different boss by resetting the spawn seed for the room
            local level = GameRef:GetLevel()
            local stage = level:GetStage()

            -- Reseed the room for the different boss generation
            local seed = room:GetDecorationSeed() + math.random(1, 9999)
            room:SetSpawnSeed(seed)

            -- Reload the room layout with new enemy spawn conditions
            GameRef:GetLevel():Reset()

            -- Force a boss spawn with the new seed
            local newBoss = nil
            for _, e in ipairs(Isaac.GetRoomEntities()) do
                if e:IsActiveEnemy() and e:IsBoss() and not e:IsDead() then
                    newBoss = e
                    break
                end
            end

            -- If new boss is found, move it back to the original boss position
            if newBoss then
                newBoss.Position = bossPos
            end

            -- Extra effect: screen shake + SFX
            GameRef:ShakeScreen(20)
            SFXManager():Play(SoundEffect.SOUND_DICE_SHARD, 1.0, 0, false, 1.0)

            return true
        end
    end

    return false
end

-- Init
function D8055:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, D8055.onUse, D8055.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(
            D8055.COLLECTIBLE_ID,
            "Use in a boss room: Restarts the fight with a different boss.",
            "D8055",
            "en_us"
        )
    end
end

return D8055
