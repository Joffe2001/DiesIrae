local mod = DiesIraeMod
local game = Game()
local EverybodysChanging = {}
local SFX = SFXManager()

mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING = Isaac.GetItemIdByName("Everybody's Changing")

local wasCombatRoom = false
local triggeredThisRoom = false

function EverybodysChanging:OnUpdate()
    local room = game:GetRoom()
    local enemyCount = room:GetAliveEnemiesCount()

    if enemyCount > 0 then
        wasCombatRoom = true
    end

    if wasCombatRoom and enemyCount == 0 and not triggeredThisRoom then
        triggeredThisRoom = true

        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING) then
                player:RemoveCollectible(mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING)
                player:EvaluateItems()

                player:UseActiveItem(
                    CollectibleType.COLLECTIBLE_D4,
                    UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD,
                    -1
                )

                player:AddCollectible(mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING, 0, true)
                player:EvaluateItems()

                player:AnimateCollectible(mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING)
                SFX:Play(SoundEffect.SOUND_EDEN_GLITCH, 1.0, 0, false, 1.0)
                Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.POOF01,
                    0,
                    player.Position,
                    Vector.Zero,
                    player
                )
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    EverybodysChanging:OnUpdate()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local queued = player.QueuedItem

        if queued and queued.Item and queued.Item.ID == mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING then
            SFXManager():Play(mod.Sounds.JEVIL_CHAOS, 1.0, 0, false, 1.0)
            player:FlushQueueItem()
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    wasCombatRoom = false
    triggeredThisRoom = false
end)

if EID then
    EID:assignTransformation("collectible", mod.CollectibleType.COLLECTIBLE_EVERYBODYS_CHANGING, "Dad's Playlist")
end
