
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local bumUtils = {}


local DEFAULT_SPEED_FOLLOW_PLAYER  = 3.5
local DEFAULT_SPEED_CHASE_PICKUP   = 2.0
local COLLISION_RADIUS             = 18
local PICKUP_REACH                 = 22
local TARGET_RECALC_INTERVAL       = 10

---@class BumDefinition
--- @field Item? integer                   -- Item that spawns this familiar
--- @field Accepts? table<integer, boolean> | function -- Allowed pickup variants
--- @field Reward fun(fam):boolean         -- Should the bum reward?
--- @field DoReward? fun(fam)              -- Reward spawn callback
--- @field OnUpdate? fun(fam)              -- Optional extra logic
--- @field OnInit? fun(fam)                -- Optional init logic
--- @field BaseRewardChance? number        -- Base chance per pickup (e.g., 0.02 for 2%)
--- @field StackRewardChance? boolean      -- If true, chance stacks with each pickup


bumUtils.BUM_DEFS = {} -- variant → BumDefinition

----------------------------------
---      Register the bums
----------------------------------
function bumUtils.RegisterBum(variant, def)
    bumUtils.BUM_DEFS[variant] = def
end

----------------------------------
---What kind of pickup the bum should accept (And he won't take it from the shops!)
----------------------------------
function bumUtils.ShouldAcceptPickup(fam, pickup)
    if not pickup or not pickup:Exists() then
        return false
    end

    if pickup.Price and pickup.Price > 0 then
        return false
    end

    return true
end

----------------------------------
---      Pickup locate
----------------------------------
function bumUtils.FindNearestPickup(fam, accepts)
    local pos = fam.Position
    local best, bestDist

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local p = ent:ToPickup()
        if p then
            local shouldAccept = false
            if type(accepts) == "function" then
                shouldAccept = accepts(fam, p)
            elseif type(accepts) == "table" then
                shouldAccept = accepts[p.Variant]
            end
            
            if shouldAccept and (not p.Price or p.Price <= 0) then
                local d = pos:Distance(p.Position)
                if not bestDist or d < bestDist then
                    best = p
                    bestDist = d
                end
            end
        end
    end
    return best
end

----------------------------------
---     Familiar AI
----------------------------------
function bumUtils.UpdateAI(fam, def)
    local data = fam:GetData()
    local player = fam.Player

    if data.RewardActive then return end

    data.TargetTimer = (data.TargetTimer or 0) - 1
    if data.TargetTimer <= 0 then
        data.TargetTimer = TARGET_RECALC_INTERVAL
        data.TargetPickup = nil

        if def.Accepts then
            local pickup = bumUtils.FindNearestPickup(fam, def.Accepts)
            if bumUtils.ShouldAcceptPickup(fam, pickup) then
                data.TargetPickup = pickup
            else
                data.TargetPickup = nil
            end
        end
    end

    local targetPos
    local speed

    if data.TargetPickup and data.TargetPickup:Exists() then
        targetPos = data.TargetPickup.Position
        speed = DEFAULT_SPEED_CHASE_PICKUP
    elseif data.ReturningToPlayer then
        targetPos = player.Position
        speed = DEFAULT_SPEED_FOLLOW_PLAYER * 0.6
        
        if fam.Position:Distance(player.Position) < 10 then
            data.ReturningToPlayer = nil
            fam:FollowParent()
        end
    else
        ---Follow parent
        fam:FollowParent()
        targetPos = nil
    end
    ---Go to the pickup
    if targetPos then
        local dir = (targetPos - fam.Position):Normalized()
        local desired = dir * speed
        fam.Velocity = fam.Velocity + (desired - fam.Velocity) * 0.25
    end

    local pos = fam.Position
    for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
        if e.Index ~= fam.Index and e.Variant ~= fam.Variant then
            local dist = pos:Distance(e.Position)
            if dist < COLLISION_RADIUS then
                local push = (pos - e.Position):Normalized() * 0.8
                fam.Velocity = fam.Velocity + push
            end
        end
    end

    if data.TargetPickup and fam.Position:Distance(data.TargetPickup.Position) <= PICKUP_REACH then
        local pickup = data.TargetPickup
        pickup:Remove()

        if def.StackRewardChance then
            data.PickupStack = (data.PickupStack or 0) + 1
        end

        local shouldReward = false
        if def.Reward then
            shouldReward = def.Reward(fam)
        end

        if shouldReward then
            if def.DoReward then
                bumUtils.DoRewardAnimation(fam, def.DoReward)
            end
            
            if def.StackRewardChance then
                data.PickupStack = 0
            end
        end

        data.TargetPickup = nil
        data.ReturningToPlayer = true
    end
end

----------------------------------
---      What is the reward chance
----------------------------------
function bumUtils.GetCurrentRewardChance(fam, def)
    if not def.BaseRewardChance then
        return 0
    end
    
    if not def.StackRewardChance then
        return def.BaseRewardChance
    end
    
    local data = fam:GetData()
    local stack = data.PickupStack or 0

    return def.BaseRewardChance * (stack + 1)
end

----------------------------------
---         Animations
----------------------------------
function bumUtils.PlayAnimations(fam)
    local sprite = fam:GetSprite()
    local data   = fam:GetData()

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

function bumUtils.DoRewardAnimation(fam, callback)
    local sprite = fam:GetSprite()
    local data   = fam:GetData()

    fam.Velocity = Vector.Zero
    data.RewardActive = true
    data.RewardCallback = callback

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

        data.RewardActive   = nil
        data.RewardCallback = nil
        data.PlayedPreSpawn = nil

        sprite:Play("IdleDown", true)
    end
end

function bumUtils:OnInit(fam)
    fam:AddToFollowers()
    fam:GetSprite():Play("IdleDown", true)
    
    local def = bumUtils.BUM_DEFS[fam.Variant]
    if def and def.OnInit then
        def.OnInit(fam)
    end
end
function bumUtils:OnUpdate(fam)
    local def = bumUtils.BUM_DEFS[fam.Variant]
    if not def then return end

    local data = fam:GetData()

    if data.RewardActive then
        bumUtils.DoRewardAnimation(fam, data.RewardCallback)
        return
    end

    bumUtils.UpdateAI(fam, def)
    bumUtils.PlayAnimations(fam)

    if def.OnUpdate then
        def.OnUpdate(fam)
    end
end

function bumUtils:OnCache(player, cache)
    if cache == CacheFlag.CACHE_FAMILIARS then
        for variant, def in pairs(bumUtils.BUM_DEFS) do
            if def.Item and player:HasCollectible(def.Item) then
                player:CheckFamiliar(variant, 1, player:GetCollectibleRNG(def.Item))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,   function(_, fam) bumUtils:OnInit(fam) end)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam) bumUtils:OnUpdate(fam) end)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,  function(_, player, cache) bumUtils:OnCache(player, cache) end)

return bumUtils