local Universal = {}
Universal.COLLECTIBLE_ID = Enums.Items.Universal
local game = Game()

local CHARGE_TIME = 40 
local ACTIVE_DURATION = 60 
local players = {}

local function getState(player)
    local id = player.InitSeed
    if not players[id] then
        players[id] = {charge = 0, activeTimer = 0, absorbed = 0, charged = false}
    end
    return players[id]
end

local function getRandomEnemy()
    local enemies = {}
    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() and e.HitPoints > 0 then  
            table.insert(enemies, e)
        end
    end
    if #enemies > 0 then
        return enemies[math.random(#enemies)] 
    else
        return nil
    end
end

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/chargebar.anm2", true) 

function Universal:onUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(Universal.COLLECTIBLE_ID) then
            goto continue
        end

        local state = getState(player)

        if player:GetFireDirection() ~= Direction.NO_DIRECTION and state.activeTimer <= 0 then
            if state.charge < CHARGE_TIME then
                state.charge = state.charge + 1
                if state.charge == CHARGE_TIME then
                    SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE, 1.0, 0, false, 1.0)
                    state.charged = true
                end
            end
        elseif state.charge >= CHARGE_TIME and state.activeTimer <= 0 then
            if player:GetFireDirection() == Direction.NO_DIRECTION then
                state.activeTimer = ACTIVE_DURATION
                state.absorbed = 0
                state.charge = 0
                state.charged = false
            end
        else
            if state.charge > 0 and state.charge < CHARGE_TIME and player:GetFireDirection() == Direction.NO_DIRECTION then
                state.charge = 0
                state.charged = false
            end
        end

        if state.activeTimer > 0 then
            state.activeTimer = state.activeTimer - 1
        
            for _, e in ipairs(Isaac.GetRoomEntities()) do
                if e.Type == EntityType.ENTITY_PROJECTILE then
                    local proj = e:ToProjectile()
                    if proj then
                        local dist = proj.Position:Distance(player.Position)
        
                        local pullStrength = 2.5 
                        local dir = (player.Position - proj.Position):Resized(pullStrength)
                        proj.Velocity = proj.Velocity * 0.8 + dir * 0.2 

                        if dist < player.Size + 10 then
                            proj:Die()
                            state.absorbed = state.absorbed + 1
                            SFXManager():Play(SoundEffect.SOUND_BEEP, 0.6, 0, false, 1.2)
                        end
                    end
                end
            end

            if state.activeTimer == 0 and state.absorbed > 0 then
                for i = 1, state.absorbed do
                    local target = getRandomEnemy() 
                    local pos = target and target.Position or player.Position
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, pos, Vector.Zero, player)
                end
                SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT, 1.0, 0, false, 1.0)
                game:ShakeScreen(10)
                state.absorbed = 0
            end
        end

        ::continue:: 
    end
end

function Universal:onPlayerDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if player and player:HasCollectible(Universal.COLLECTIBLE_ID) then
        local state = getState(player)
        if state.activeTimer > 0 and source.Type == EntityType.ENTITY_PROJECTILE then
            return false 
        end
    end
end

function Universal:onRender()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(Universal.COLLECTIBLE_ID) then
            goto continue
        end

        local state = getState(player)
        if state.charge > 0 then
            local chargeProgress = math.floor((state.charge / CHARGE_TIME) * 100)
            chargeBarSprite:SetFrame("Charging", chargeProgress)

            local screenPosition = Isaac.WorldToScreen(player.Position + Vector(0, -50))
            local adjustedPosition = screenPosition + Vector(0, -5)

            chargeBarSprite:Render(adjustedPosition)
            chargeBarSprite.Color = Color(1, 1, 1, 1)
        end

        ::continue::
    end
end

function Universal:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Universal.onUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, Universal.onRender)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Universal.onPlayerDamage, EntityType.ENTITY_PLAYER)

    if EID then
        EID:addCollectible(
            Universal.COLLECTIBLE_ID,
            "Hold fire to charge.#On release, absorb projectiles near Isaac.#At the end, spawn Crack the Sky beams for each projectile absorbed.",
            "Universal",
            "en_us"
        )
        EID:assignTransformation("collectible", Universal.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return Universal
