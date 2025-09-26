local RingOfFire = {}
RingOfFire.COLLECTIBLE_ID = Enums.Items.RingOfFire
local game = Game()

local fireDamage = 3
local fireInterval = 60  
local fireProjectiles = 12
local fireSpeed = 8
local lastBurstFrame = -9999

function RingOfFire:onUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(RingOfFire.COLLECTIBLE_ID) then
            local room = game:GetRoom()
            local roomCenter = room:GetCenterPos()
            local frame = game:GetFrameCount()

            if player.Position:Distance(roomCenter) < 30 then
                if frame - lastBurstFrame >= fireInterval then
                    RingOfFire:spawnFireBurst(player)
                    lastBurstFrame = frame
                end
            end
        end
    end
end

function RingOfFire:spawnFireBurst(player)
    for i = 1, fireProjectiles do
        local angle = (360 / fireProjectiles) * i
        local velocity = Vector.FromAngle(angle) * fireSpeed

        local flame = player:FireTear(player.Position, velocity, false, true, false):ToTear()
        flame.CollisionDamage = fireDamage

        flame:ChangeVariant(TearVariant.FIRE)
        flame:AddTearFlags(TearFlags.TEAR_BURN | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING)

        flame.TearFlags = flame.TearFlags & ~TearFlags.TEAR_EXPLOSIVE
        flame.TearFlags = flame.TearFlags & ~TearFlags.TEAR_BRIMSTONE_BOMB
    end

    game:ShakeScreen(5)
    SFXManager():Play(SoundEffect.SOUND_FLAME_BURST, 1.0, 0, false, 1.0)
end

function RingOfFire:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        RingOfFire:onUpdate()
    end)

    if EID then
        EID:addCollectible(
            RingOfFire.COLLECTIBLE_ID,
            "Standing at the center of a room releases a burst of fire outward.",
            "Ring of Fire",
            "en_us"
        )
        EID:assignTransformation("collectible", RingOfFire.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return RingOfFire
