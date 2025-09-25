local D8055 = {}
D8055.COLLECTIBLE_ID = Enums.Items.D8055

--TODO: Remove this script. It does not seem to be in use.

-- Main effect
function D8055:onUse(_, _, player, _, _)
    local room = GameRef:GetRoom()

    -- Only in boss rooms, and only if boss is alive
    if room:GetType() == RoomType.ROOM_BOSS then
        local hasBoss = false
        for _, e in ipairs(Isaac.GetRoomEntities()) do
            if e:IsActiveEnemy() and e:IsBoss() and not e:IsDead() then
                hasBoss = true
                break
            end
        end

        if hasBoss then
            -- Restart the room with a new boss
            local level = GameRef:GetLevel()
            local stage = level:GetStage()
            local stageType = level:GetStageType()

            -- Reroll the boss by reloading room layout
            room:RespawnEnemies()

            -- Force a different boss by re-seeding
            local seed = room:GetDecorationSeed() + math.random(1, 9999)
            room:SetSpawnSeed(seed)

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
