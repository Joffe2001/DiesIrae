local mod = DiesIraeMod
local game = Game()

local corruptedMantle = {
    NUM_BROKEN_HEART_PER_LEVEL = 1,
    DMG_MULTIPLIER_ACTIVE = 1.5,
    DMG_MULYIPLIER_PENALTY = 0.3,
    SPEED_ADDEND = 0.1,
    LUCK_ADDEND = 3,
    LUCK_ADDEND_PER_HURT = -5,
    shieldCount = {},
    hurtCount = {},
    state = {},
    spriteShimmer = {},
    spriteGlow = {},
    spriteHolyMantle = {},
    spriteMantleBreak = {},
}

---@enum
local CorruptedMantleState = {
    SHIELD_ON = 1,
    SHIELD_BROKEN = 2,
    HURT = 3,
}

function corruptedMantle:onPostNewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(mod.Items.CorruptedMantle) then
            local ptrHash = GetPtrHash(p)
            corruptedMantle.shieldCount[ptrHash] = 1
            corruptedMantle.state[ptrHash] = CorruptedMantleState.SHIELD_ON
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, corruptedMantle.onPostNewRoom)

function corruptedMantle:onEvaluateCache(player, cacheFlag)
    if player:HasCollectible(mod.Items.CorruptedMantle) then
        local ptrHash = GetPtrHash(player)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            local state = corruptedMantle.state[ptrHash]
            if state == CorruptedMantleState.SHIELD_ON then
                player.Damage = player.Damage * corruptedMantle.DMG_MULTIPLIER_ACTIVE
            elseif state == CorruptedMantleState.HURT then
                player.Damage = player.Damage * corruptedMantle.DMG_MULYIPLIER_PENALTY
            end
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + corruptedMantle.SPEED_ADDEND
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck
                + corruptedMantle.LUCK_ADDEND
                + (corruptedMantle.hurtCount[ptrHash] or 0) * corruptedMantle.LUCK_ADDEND_PER_HURT
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, corruptedMantle.onEvaluateCache)

function corruptedMantle:onPrePickupCollision(pickup, collider)
    if collider.Type == EntityType.ENTITY_PLAYER then
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType == mod.Items.CorruptedMantle then
            local ptrHash = GetPtrHash(collider)
            corruptedMantle.shieldCount[ptrHash] = 1
            corruptedMantle.state[ptrHash] = CorruptedMantleState.SHIELD_ON
            corruptedMantle.hurtCount[ptrHash] = 0
            collider = collider:ToPlayer()
            collider:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            collider:AddCacheFlags(CacheFlag.CACHE_SPEED)
            collider:AddCacheFlags(CacheFlag.CACHE_LUCK)
            if corruptedMantle.spriteShimmer[ptrHash] == nil then
                local s = Sprite('gfx/characters/313_holymantle.anm2', true)
                s:Play("Shimmer")
                corruptedMantle.spriteShimmer[ptrHash] = s
            end
            if corruptedMantle.spriteGlow[ptrHash] == nil then
                local s = Sprite('gfx/characters/313_holymantle.anm2', true)
                s:Play("HeadDown")
                corruptedMantle.spriteGlow[ptrHash] = s
            end
            if corruptedMantle.spriteHolyMantle[ptrHash] == nil then
                local s = Sprite('gfx/ui/ui_hearts.anm2', true)
                s:Play("HolyMantle")
                corruptedMantle.spriteHolyMantle[ptrHash] = s
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, corruptedMantle.onPrePickupCollision)

function corruptedMantle:onPrePlayerTakeDamage(player, damage, damageFlags)
    if player:HasCollectible(mod.Items.CorruptedMantle) then
        local ptrHash = GetPtrHash(player)
        if ((damageFlags & DamageFlag.DAMAGE_RED_HEARTS) ~= 0) then
            return true
        end
        if player:HasInvincibility() then
            return true
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART, false) and ((damageFlags & DamageFlag.DAMAGE_ISSAC_HEART) == 0) then
            return true
        end
        if corruptedMantle.shieldCount[ptrHash] > 0 then
            local mantleBreak = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 11, player.Position, Vector(0, 0), player)
            mantleBreak:ToEffect():FollowParent(player)

            corruptedMantle.state[ptrHash] = CorruptedMantleState.SHIELD_BROKEN
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()

            corruptedMantle.shieldCount[ptrHash] = corruptedMantle.shieldCount[ptrHash] - 1
            SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
            player:SetMinDamageCooldown(60)
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, corruptedMantle.onPrePlayerTakeDamage)

function corruptedMantle:onEntityTakeDamage(entity, amount, damageFlags)
    if entity.Type == EntityType.ENTITY_PLAYER then
        local p = entity:ToPlayer()
        if p:HasCollectible(mod.Items.CorruptedMantle) then
            local ptrHash = GetPtrHash(p)
            if ((damageFlags & DamageFlag.DAMAGE_NO_PENALTIES) == 0) and ((damageFlags & DamageFlag.DAMAGE_RED_HEARTS) == 0) then
                corruptedMantle.state[ptrHash] = CorruptedMantleState.HURT
                corruptedMantle.hurtCount[ptrHash] = corruptedMantle.hurtCount[ptrHash] + 1
                p:AddBrokenHearts(2)
                p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                p:AddCacheFlags(CacheFlag.CACHE_LUCK)
                p:EvaluateItems()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, corruptedMantle.onEntityTakeDamage)

function corruptedMantle:onPreRenderPlayerBody()
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(mod.Items.CorruptedMantle) then
            local ptrHash = GetPtrHash(p)
            if corruptedMantle.state[ptrHash] == CorruptedMantleState.SHIELD_ON then
                local spriteShimmer = corruptedMantle.spriteShimmer[ptrHash]
                if spriteShimmer then
                    spriteShimmer:RenderLayer(0, Isaac.WorldToScreen(p.Position) - Game().ScreenShakeOffset)
                end
                local spriteGlow = corruptedMantle.spriteGlow[ptrHash]
                if spriteGlow then
                    spriteGlow:RenderLayer(1, Isaac.WorldToScreen(p.Position) - Game().ScreenShakeOffset)
                end
                local spriteMantleBreak = corruptedMantle.spriteMantleBreak[ptrHash]
                if spriteMantleBreak then
                    spriteMantleBreak:Render(Isaac.WorldToScreen(p.Position) - Game().ScreenShakeOffset)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_BODY, corruptedMantle.onPreRenderPlayerBody)

function corruptedMantle.onPostPlayerHUDRenderHearts()
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(mod.Items.CorruptedMantle) then
            local ptrHash = GetPtrHash(p)
            if corruptedMantle.state[ptrHash] == CorruptedMantleState.SHIELD_ON then
                local spriteHolyMantle = corruptedMantle.spriteHolyMantle[ptrHash]
                if spriteHolyMantle then
                    local heartCount = math.ceil((p:GetMaxHearts() / 2) + (p:GetSoulHearts() / 2) + p:GetBrokenHearts() + p:GetBoneHearts())
                    local stepX = 12
                    local stepY = 10
                    local maxHeartsPerRow = 6
                    local maxHeartRows = 2
                    if (p:GetPlayerType() == PlayerType.PLAYER_MAGDALENE) and p:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, false) then
                        maxHeartRows = 3
                    end
                    local offsetX = 68 + (heartCount % maxHeartsPerRow) * stepX
                    local offsetY = 24 + math.floor(heartCount / maxHeartsPerRow) * stepY
                    if heartCount == maxHeartsPerRow * maxHeartRows then
                        offsetX = offsetX + stepX * (maxHeartsPerRow - 0.5)
                        offsetY = offsetY - stepY
                    end
                    spriteHolyMantle:Render(Vector(offsetX, offsetY))
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, corruptedMantle.onPostPlayerHUDRenderHearts)

function corruptedMantle.onUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(mod.Items.CorruptedMantle) then
            local ptrHash = GetPtrHash(p)
            if corruptedMantle.state[ptrHash] == CorruptedMantleState.SHIELD_ON then
                local spriteShimmer = corruptedMantle.spriteShimmer[ptrHash]
                spriteShimmer:Update()
                local spriteGlow = corruptedMantle.spriteGlow[ptrHash]
                spriteGlow:Update()
                local spriteHolyMantle = corruptedMantle.spriteHolyMantle[ptrHash]
                spriteHolyMantle:Update()
                local spriteMantleBreak = corruptedMantle.spriteMantleBreak[ptrHash]
                if spriteMantleBreak then
                    spriteMantleBreak:Update()
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, corruptedMantle.onUpdate)