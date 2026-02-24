local mod = DiesIraeMod

local Universal = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_UNIVERSAL = Isaac.GetItemIdByName("Universal")

local CHARGE_TIME = 40
local ACTIVE_DURATION = 60

local WARNING_BEEPS = 5
local WARNING_TIME = 30

local function getState(player)
    local data = player:GetData()

    if not data.universal_state then
        data.universal_state = {
            charge = 0,
            activeTimer = 0,
            absorbed = 0,
            charged = false,
            hasActiveCostume = false,
            lastBeepSegment = -1
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
    return (#enemies > 0) and enemies[math.random(#enemies)] or nil
end

function Universal:onUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_UNVERSAL) then
            goto continue
        end

        local state = getState(player)

        if player:GetFireDirection() ~= Direction.NO_DIRECTION and state.activeTimer <= 0 then
            if state.charge < CHARGE_TIME then
                state.charge = state.charge + 1
                if state.charge == CHARGE_TIME then
                    SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE, 1.0)
                    state.charged = true
                end
            end
        elseif state.charge >= CHARGE_TIME and state.activeTimer <= 0 then
            if player:GetFireDirection() == Direction.NO_DIRECTION then
                state.activeTimer = ACTIVE_DURATION
                state.absorbed = 0
                state.charge = 0
                state.charged = false
                state.lastBeepSegment = -1
            end
        else
            if state.charge > 0 and state.charge < CHARGE_TIME
                and player:GetFireDirection() == Direction.NO_DIRECTION then
                state.charge = 0
                state.charged = false
            end
        end

        if state.activeTimer > 0 then
            state.activeTimer = state.activeTimer - 1

            if state.activeTimer <= WARNING_TIME then
                local segment = math.floor(
                    (state.activeTimer / WARNING_TIME) * WARNING_BEEPS
                )

                if segment ~= state.lastBeepSegment then
                    SFXManager():Play(
                        SoundEffect.SOUND_BEEP,
                        0.8,
                        0,
                        false,
                        1.2
                    )
                    state.lastBeepSegment = segment
                end
                
                if game:GetFrameCount() % 6 < 3 then
                    player:SetColor(Color(1, 1, 1, 1, 0.3, 0.3, 0.3), 2, 1, true, false)
                else
                    player:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 1, 1, true, false)
                end
            end

            if not state.hasActiveCostume then
                player:AddNullCostume(mod.Costumes.Universal_active)
                state.hasActiveCostume = true
            end

            for _, e in ipairs(Isaac.GetRoomEntities()) do
                if e.Type == EntityType.ENTITY_PROJECTILE then
                    local proj = e:ToProjectile()
                    if proj then
                        local dist = proj.Position:Distance(player.Position)
                        local dir = (player.Position - proj.Position):Resized(2.5)

                        proj.Velocity = proj.Velocity * 0.8 + dir * 0.2

                        if dist < player.Size + 10 then
                            proj:Die()
                            state.absorbed = state.absorbed + 1
                            --SFXManager():Play(SoundEffect.SOUND_BEEP, 0.6, 0, false, 1.2) - What can we put here?
                        end
                    end
                end
            end

            if state.activeTimer == 0 and state.absorbed > 0 then
                for j = 1, state.absorbed do
                    local target = getRandomEnemy()
                    local pos = target and target.Position or player.Position
                    Isaac.Spawn(
                        EntityType.ENTITY_EFFECT,
                        EffectVariant.CRACK_THE_SKY,
                        0,
                        pos,
                        Vector.Zero,
                        player
                    )
                end

                SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT, 1.0)
                game:ShakeScreen(10)
                state.absorbed = 0
            end
        else
            if state.hasActiveCostume then
                player:TryRemoveNullCostume(mod.Costumes.Universal_active)
                state.hasActiveCostume = false
            end
            player:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 0, 0, true, false)
        end

        local pdata = player:GetData()
        if not pdata.universal_chargebar then
            pdata.universal_chargebar = Sprite("gfx/chargebar.anm2", true)
        end
        pdata.universal_chargebar:Update()

        ::continue::
    end
end

function Universal:onPlayerDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if player and player:HasCollectible(mod.CollectibleType.COLLECTIBLE_UNVERSAL) then
        local state = getState(player)
        if state.activeTimer > 0 and source.Type == EntityType.ENTITY_PROJECTILE then
            return false
        end
    end
end

function Universal:onRender()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_UNVERSAL) then
            goto continue
        end

        local state = getState(player)
        local pdata = player:GetData()

        if not pdata.universal_chargebar then
            pdata.universal_chargebar = Sprite("gfx/chargebar.anm2", true)
        end

        local chargeBarSprite = pdata.universal_chargebar

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
                chargeBarSprite:SetFrame(
                    math.floor((state.charge / CHARGE_TIME) * 100)
                )
            end
        else
            if chargeBarSprite:GetAnimation() ~= ""
                and chargeBarSprite:GetAnimation() ~= "Disappear" then
                chargeBarSprite:Play("Disappear", true)
            end
        end

        if state.activeTimer > 0 and state.activeTimer <= WARNING_TIME then
            if game:GetFrameCount() % 6 < 3 then
                chargeBarSprite:SetFrame(100)
            end
        end

        local chargebar_cnt = mod:CountActiveChargebars(player)
        if chargebar_cnt < 4 then
            local offset = mod.CHARGEBAR_POSITIONS[chargebar_cnt + 1]
            local pos = player.Position + offset
            if player.CanFly then
                pos = pos - Vector(0, 5.8)
            end

            chargeBarSprite:Render(
                Isaac.WorldToScreen(pos) - Game().ScreenShakeOffset
            )
        end

        ::continue::
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Universal.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, Universal.onRender)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Universal.onPlayerDamage, EntityType.ENTITY_PLAYER)

if EID then
    EID:assignTransformation("collectible", mod.CollectibleType.COLLECTIBLE_UNVERSAL, "Dad's Playlist")
end
