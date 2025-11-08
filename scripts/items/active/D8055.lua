local mod = DiesIraeMod
local game = Game()

function mod:UseD8055(item, rng, player, useFlags, activeSlot)
    local room = game:GetRoom()
    local level = game:GetLevel()
    local boss = nil

    -- Find the first active boss
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsBoss() and entity:IsActiveEnemy() and not entity:IsDead() then
            boss = entity
            break
        end
    end

    if boss then
        local bossPos = boss.Position
        boss:Remove()

        local stage = level:GetStage()
        local itemPool = game:GetItemPool()
        local rng = player:GetCollectibleRNG(mod.Items.D8055)
        local bossType, bossVariant, bossSubType = itemPool:GetBossID(stage, rng:RandomInt(100))

        -- Spawn new boss
        local newBoss = Isaac.Spawn(bossType, bossVariant, bossSubType, bossPos, Vector.Zero, nil):ToNPC()
        newBoss.MaxHitPoints = newBoss.MaxHitPoints * 1.5
        newBoss.HitPoints = newBoss.MaxHitPoints

        return true
    else
        SFXManager():Play(mod.Sounds.KINGS_FART)
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseD8055, mod.Items.D8055)
