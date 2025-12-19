
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
--- @field Accepts? table<integer, boolean> -- Allowed pickup variants
--- @field Reward fun(fam):boolean         -- Should the bum reward?
--- @field DoReward? fun(fam)              -- Reward spawn callback
--- @field OnUpdate? fun(fam)              -- Optional extra logic

bumUtils.BUM_DEFS = {} -- variant → BumDefinition

function bumUtils.RegisterBum(variant, def)
    bumUtils.BUM_DEFS[variant] = def
end

function bumUtils.FindNearestPickup(fam, accepts)
    local pos = fam.Position
    local best, bestDist

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local p = ent:ToPickup()
        if p and accepts[p.Variant] then
            if not p.Price or p.Price <= 0 then
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

local function AvoidBumCollision(fam)
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
end


function bumUtils.UpdateAI(fam, def)
    local data = fam:GetData()
    local player = fam.Player

    if data.RewardActive then return end

    data.TargetTimer = (data.TargetTimer or 0) - 1
    if data.TargetTimer <= 0 then
        data.TargetTimer = TARGET_RECALC_INTERVAL
        data.TargetPickup = nil

        if def.Accepts then
            data.TargetPickup = bumUtils.FindNearestPickup(fam, def.Accepts)
        end
    end

    local targetPos
    local speed

    if data.TargetPickup and data.TargetPickup:Exists() then
        targetPos = data.TargetPickup.Position
        speed = DEFAULT_SPEED_CHASE_PICKUP
    else
        local followDist = def.FollowDistance or 40
        local dist = fam.Position:Distance(player.Position)
    
        if dist > followDist then
            targetPos = player.Position
            speed = DEFAULT_SPEED_FOLLOW_PLAYER
        else
            targetPos = fam.Position
            speed = 0
            fam.Velocity = fam.Velocity * 0.7
        end
    end

    local dir = (targetPos - fam.Position):Normalized()
    local desired = dir * speed
    fam.Velocity = fam.Velocity + (desired - fam.Velocity) * 0.25

    AvoidBumCollision(fam)

    if data.TargetPickup and fam.Position:Distance(data.TargetPickup.Position) <= PICKUP_REACH then
        local pickup = data.TargetPickup
        pickup:Remove()

        if def.Reward and def.Reward(fam) then
            if def.DoReward then
                bumUtils.DoRewardAnimation(fam, def.DoReward)
            end
        end

        data.TargetPickup = nil
    end
end


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
    local def = bumUtils.BUM_DEFS[fam.Variant]

    fam:GetSprite():Play("IdleDown", true)
    
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