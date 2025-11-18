local mod = DiesIraeMod
local RingOfFire = {}
local game = Game()

local fireDamage = 3
local fireInterval = 60
local fireProjectiles = 12
local fireSpeed = 8

local lastBurstFrame = -9999
local spawnedRing = false
local markActive = true 

function RingOfFire:onUpdate()
    local room = game:GetRoom()
    local frame = game:GetFrameCount()
    local roomCenter = room:GetCenterPos()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.Items.RingOfFire) then
            if markActive and not spawnedRing then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, 1234, 0, roomCenter, Vector.Zero, nil)
                spawnedRing = true
            end

            if player.Position:Distance(roomCenter) < 30 then
                if frame - lastBurstFrame >= fireInterval then
                    RingOfFire:spawnFireBurst(player)
                    lastBurstFrame = frame

                    if markActive then
                        markActive = false
                        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, 1234, -1, false, false)) do
                            e:Remove()
                        end
                    end
                end
            end
        end
    end
end

function RingOfFire:onNewRoom()
    spawnedRing = false
    markActive = true
end

function RingOfFire:spawnFireBurst(player)
    for i = 1, fireProjectiles do
        local angle = (360 / fireProjectiles) * i
        local velocity = Vector.FromAngle(angle) * fireSpeed

        local flame = player:FireTear(player.Position, velocity, false, true, false):ToTear()
        flame.CollisionDamage = fireDamage
        flame:ChangeVariant(TearVariant.FIRE)
        flame:AddTearFlags(TearFlags.TEAR_BURN | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING)
    end

    game:ShakeScreen(5)
    SFXManager():Play(SoundEffect.SOUND_FLAME_BURST, 1.0, 0, false, 1.0)
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, RingOfFire.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RingOfFire.onNewRoom)

if EID then
    EID:assignTransformation("collectible", mod.Items.RingOfFire, "Dad's Playlist")
end
