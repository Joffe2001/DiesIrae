local mod = DiesIraeMod
local game = Game()

local Grudge = {}
local GrudgeEnemies = {}

function Grudge:OnPlayerDamage(playerEntity, amount, flags, source, countdown)
    local player = playerEntity:ToPlayer()
    if not player then
        return nil
    end

    if not player:HasCollectible(mod.Items.Grudge) then
        return nil
    end

    local srcEntRef = source.Entity
    if srcEntRef and srcEntRef.Type == EntityType.ENTITY_PROJECTILE and srcEntRef.SpawnerEntity then
        srcEntRef = srcEntRef.SpawnerEntity
    end

    if srcEntRef and srcEntRef:ToNPC() then
        local npc = srcEntRef:ToNPC()
        local id = npc.Type .. "_" .. npc.Variant
        GrudgeEnemies[id] = true
        print("[Grudge] Recorded enemy type: " .. id)
    else
        print("[Grudge] Damage source was not an NPC.")
    end
    return nil
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Grudge.OnPlayerDamage, EntityType.ENTITY_PLAYER)

function Grudge:OnEnemyDamage(npcEntity, amount, flags, source, countdown)
    local npc = npcEntity:ToNPC()
    if not npc then
        return nil
    end

    local id = npc.Type .. "_" .. npc.Variant

    if not GrudgeEnemies[id] then
        return nil
    end

    local playerCount = game:GetNumPlayers()
    for i = 0, playerCount - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.Grudge) then
            return {
                Damage = amount * 2,
                DamageFlags = flags,
                DamageCountdown = countdown
            }
        end
    end

    return nil
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Grudge.OnEnemyDamage)

function Grudge:OnNewRun(isContinued)
    GrudgeEnemies = {}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Grudge.OnNewRun)
