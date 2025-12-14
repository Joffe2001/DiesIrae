local mod = DiesIraeMod

local Universal = {}
local game = Game()

local CHARGE_TIME = 40 
local ACTIVE_DURATION = 60

local function getState(player)
    local data = mod:GetData(player) -- mod ref should NOT store data use mod.SaveManager

    if not data.universal_state then
        data.universal_state = {
            charge = 0, 
            activeTimer = 0, 
            absorbed = 0, 
            charged = false
        }
    end

    return data.universal_state
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

function Universal:onUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(mod.Items.Universal) then
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

            if not state.hasActiveCostume then
                player:AddNullCostume(mod.Costumes.Universal_active)
                state.hasActiveCostume = true
            end
        
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
        else
            if state.hasActiveCostume then
                player:TryRemoveNullCostume(mod.Costumes.Universal_active)
                state.hasActiveCostume = false
            end
        end

        if not mod:GetData(player).universal_chargebar then
            mod:GetData(player).universal_chargebar = Sprite("gfx/chargebar.anm2", true)
        end

        mod:GetData(player).universal_chargebar:Update()

        ::continue:: 
    end
end

function Universal:onPlayerDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if player and player:HasCollectible(mod.Items.Universal) then
        local state = getState(player)
        if state.activeTimer > 0 and source.Type == EntityType.ENTITY_PROJECTILE then
            return false 
        end
    end
end

function Universal:onRender()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(mod.Items.Universal) then
            goto continue
        end

        local state = getState(player)

        if not mod:GetData(player).universal_chargebar then
            mod:GetData(player).universal_chargebar = Sprite("gfx/chargebar.anm2", true)
        end

        local chargeBarSprite = mod:GetData(player).universal_chargebar

        if player:GetFireDirection() ~= Direction.NO_DIRECTION
            and state.activeTimer == 0 then
            if state.charged then

                if chargeBarSprite:GetAnimation() ~= "StartCharged"
                    and chargeBarSprite:GetAnimation() ~= "Charged" then

                    chargeBarSprite:Play("StartCharged", true)
                elseif chargeBarSprite:IsFinished() then

                    chargeBarSprite:Play("Charged", true)
                end
            else
                if chargeBarSprite:GetAnimation() ~= "Charging" then
                    chargeBarSprite:SetAnimation("Charging")
                end

                chargeBarSprite:SetFrame(math.floor((state.charge / CHARGE_TIME) * 100))
            end

            local chargebar_cnt = mod:CountActiveChargebars(player)
            local offset

            if chargebar_cnt < 4 then
                offset = mod.CHARGEBAR_POSITIONS[chargebar_cnt + 1]
                local position = player.Position + offset

                if player.CanFly then
                    position = position - Vector(0, 5.8)
                end

                chargeBarSprite:Render(Isaac.WorldToScreen(position) - Game().ScreenShakeOffset)
            end
        else
            if chargeBarSprite:GetAnimation() ~= ""
                and chargeBarSprite:GetAnimation() ~= "Disappear" then
                chargeBarSprite:Play("Disappear", true)
            end

            if not chargeBarSprite:IsFinished() then
                
                local chargebar_cnt = mod:CountActiveChargebars(player)
                local offset

                if chargebar_cnt < 4 then
                    offset = mod.CHARGEBAR_POSITIONS[chargebar_cnt + 1]
                    local position = player.Position + offset

                    if player.CanFly then
                        position = position - Vector(0, 5.8)
                    end

                    chargeBarSprite:Render(Isaac.WorldToScreen(position) - Game().ScreenShakeOffset)
                end
            end
        end
        ::continue::
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Universal.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, Universal.onRender)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Universal.onPlayerDamage, EntityType.ENTITY_PLAYER)

if EID then
    EID:assignTransformation("collectible", mod.Items.Universal, "Dad's Playlist")
end
