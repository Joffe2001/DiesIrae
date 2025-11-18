local mod = DiesIraeMod
local heartVariant = mod.Entities.PICKUP_BurningHeart.Var
local HeartColors = {"blue", "dark_blue", "white", "purple", "orange", "yellow"}

function mod:OnBurningHeartInit(pickup)
    if pickup.Variant ~= heartVariant then return end
    local data = pickup:GetData()
    if not data.Color then
        local rng = pickup:GetDropRNG()
        data.Color = HeartColors[rng:RandomInt(#HeartColors) + 1]
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnBurningHeartInit, heartVariant)

function mod:OnBurningHeartPickupCollision(_, pickup, collider)
    if pickup.Variant ~= heartVariant then return end
    local player = collider:ToPlayer()
    if not player then return end

    local pdata = player:GetData()
    pdata.BurningHearts = pdata.BurningHearts or {}

    table.insert(pdata.BurningHearts, pickup:GetData().Color)
    pickup:Remove()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnBurningHeartPickupCollision)

function mod:OnBurningHeartUpdate(pickup)
    if pickup.Variant ~= heartVariant or pickup:IsDead() then return end
    local players = Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1, false, false)
    for _, p in ipairs(players) do
        local player = p:ToPlayer()
        if player and player.Position:Distance(pickup.Position) < 20 then
            local pdata = player:GetData()
            pdata.BurningHearts = pdata.BurningHearts or {}
            table.insert(pdata.BurningHearts, pickup:GetData().Color)
            pickup:Remove()
            break
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnBurningHeartUpdate, heartVariant)

function mod:OnBurningHeartDamage(target, amount, flags, source, countdown)
    local player = target:ToPlayer()
    if not player then return end

    local pdata = player:GetData()
    if pdata.BurningHearts and #pdata.BurningHearts > 0 then
        pdata.BurningHearts = {}
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnBurningHeartDamage)

function mod:RenderBurningHeartsHUD(offset, heartsSprite, position, spriteScale, player)
    local pdata = player:GetData()
    if not pdata.BurningHearts or #pdata.BurningHearts == 0 then return end

    local spacing = 14 * spriteScale

    for i, color in ipairs(pdata.BurningHearts) do
        heartsSprite:Play("BurningHeart_" .. color, true)
        local renderPos = position + Vector((i - 1) * spacing, 0) + offset
        heartsSprite:Render(renderPos)
    end
end
