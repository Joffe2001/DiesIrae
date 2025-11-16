local mod = DiesIraeMod
local game = Game()
local beggar = mod.Entities.MomBoxBeggarElijah.Var

local momItemPool = ItemPoolType.POOL_MOMS_CHEST

function mod:MomBoxCollision(beggarEntity, collider)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggarEntity:GetSprite()

    if player:GetPlayerType() ~= mod.Players.Elijah then return end

    local data = beggarEntity:GetData()

    if sprite:IsPlaying("Idle") then
        sprite:Play("Open")
    elseif sprite:IsPlaying("Opened") and not data.Donated then
        local paid = mod:DrainElijahStat(player)
        if paid then
            data.Donated = true
            sprite:Play("Donated")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.MomBoxCollision, beggar)

function mod:MomBoxUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local data = beggarEntity:GetData()
    local rng = beggarEntity:GetDropRNG()

    if sprite:IsFinished("Open") then
        sprite:Play("Opened")
    elseif sprite:IsFinished("Donated") then
        sprite:Play("Nothing")
    elseif sprite:IsFinished("Nothing") and not data.ItemSpawned then

        local item = game:GetItemPool():GetCollectible(momItemPool, true, rng)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
            beggarEntity.Position - Vector(0, 20), Vector.Zero, nil)
        data.ItemSpawned = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.MomBoxUpdate, beggar)
