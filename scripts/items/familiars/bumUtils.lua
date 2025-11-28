local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BumUtils
local bumUtils = {}

local CHASE_SPEED = 3.5  
local PICKUP_REACH = 20 

bumUtils.BUM_TYPES = {}

function bumUtils.RegisterBum(variant, def)
    bumUtils.BUM_TYPES[variant] = def
end

function bumUtils.FindPickupAnywhere(fam, acceptsTable)
    local best, bestDist = nil, math.huge
    local pos = fam.Position

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local p = ent:ToPickup()
        if p and acceptsTable[p.Variant] then
            local dist = pos:Distance(p.Position)
            if dist < bestDist then
                best = p
                bestDist = dist
            end
        end
    end

    return best, bestDist
end

function bumUtils.UpdateMovement(fam)
    local data = fam:GetData()
    local def = bumUtils.BUM_TYPES[fam.Variant]
    if not def then return end

    if data.RewardActive then
        fam.Velocity = Vector.Zero
        return
    end

    if def.Accepts then
        if (not data.TargetPickup) or not data.TargetPickup:Exists() then
            local pickup = bumUtils.FindPickupAnywhere(fam, def.Accepts)
            data.TargetPickup = pickup
        end
    end

    local speed
    local targetPos

    if data.TargetPickup and data.TargetPickup:Exists() then
        targetPos = data.TargetPickup.Position
        speed = 2
    else
        local player = fam.Player
        targetPos = player and player.Position or fam.Position
        speed = 3.5 
        data.TargetPickup = nil
    end

    local direction = (targetPos - fam.Position):Normalized()
    local desiredVelocity = direction * speed
    fam.Velocity = fam.Velocity + (desiredVelocity - fam.Velocity) * 0.25

    if fam.Velocity:Length() > speed then
        fam.Velocity = fam.Velocity:Resized(speed)
    end
end

function bumUtils.PlayGenericAnimations(fam)
    local sprite = fam:GetSprite()
    local data = fam:GetData()

    if data.RewardActive then return end

    if fam.Velocity:Length() > 0.1 then
        if not sprite:IsPlaying("FloatDown") then
            sprite:Play("FloatDown", true)
        end
    else
        if not sprite:IsPlaying("IdleDown") then
            sprite:Play("IdleDown", true)
        end
    end
end

function bumUtils.DoRewardAnimation(fam, rewardCallback)
    local sprite = fam:GetSprite()
    local data = fam:GetData()

    fam.Velocity = Vector.Zero
    data.RewardActive = true
    data.RewardCallback = rewardCallback

    if not data.PlayedPreSpawn then
        sprite:Play("PreSpawn", true)
        data.PlayedPreSpawn = true 
        return
    end

    if sprite:IsFinished("PreSpawn") then
        sprite:Play("Spawn", true)
        return
    end

    if sprite:IsFinished("Spawn") then
        if data.RewardCallback then
            data.RewardCallback(fam)
        end

        data.RewardActive = nil
        data.RewardCallback = nil
        data.PlayedPreSpawn = nil

        sprite:Play("IdleDown", true)
    end
end

function bumUtils.CheckPickup(fam)
    local def = bumUtils.BUM_TYPES[fam.Variant]
    if not def or not def.Accepts then return end

    local data = fam:GetData()
    local pickup = data.TargetPickup
    if not pickup or not pickup:Exists() then return end

    if fam.Position:Distance(pickup.Position) <= PICKUP_REACH then
        pickup:Remove()
        data.TargetPickup = nil

        local wantsReward = def.Reward(fam)

        if wantsReward then
            if def.DoReward then
                bumUtils.DoRewardAnimation(fam, def.DoReward)
            end
        end
    end
end

function bumUtils:OnInit(fam)
    fam:GetSprite():Play("IdleDown", true)
end

function bumUtils:OnUpdate(fam)
    local def = bumUtils.BUM_TYPES[fam.Variant]
    if not def then return end

    local data = fam:GetData()

    if data.RewardActive then
        bumUtils.DoRewardAnimation(fam, data.RewardCallback)
        return
    end

    bumUtils.UpdateMovement(fam)
    bumUtils.CheckPickup(fam)
    bumUtils.PlayGenericAnimations(fam)

    if def.OnUpdate then
        def.OnUpdate(fam)
    end
end

function bumUtils:OnCache(player, cache)
    if cache == CacheFlag.CACHE_FAMILIARS then
        for variant, def in pairs(bumUtils.BUM_TYPES) do
            if def.Item and player:HasCollectible(def.Item) then
                player:CheckFamiliar(variant, 1, player:GetCollectibleRNG(def.Item))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam) bumUtils:OnInit(fam) end)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam) bumUtils:OnUpdate(fam) end)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cache) bumUtils:OnCache(player, cache) end)

return bumUtils