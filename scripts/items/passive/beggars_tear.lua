local BeggarsTear = {}
BeggarsTear.COLLECTIBLE_ID = Enums.Items.BeggarsTear

---@param tear EntityTear
function BeggarsTear:onFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:HasCollectible(BeggarsTear.COLLECTIBLE_ID) then
        tear:GetData().BeggarsTear = true
    end
end

---@param player EntityPlayer
---@param pickup EntityPickup
local function manualPickup(player, pickup)
    local v, sub = pickup.Variant, pickup.SubType

    if v == PickupVariant.PICKUP_COIN then
        if sub == CoinSubType.COIN_PENNY then
            player:AddCoins(1); SfxManager:Play(SoundEffect.SOUND_PENNYPICKUP)
        elseif sub == CoinSubType.COIN_NICKEL then
            player:AddCoins(5); SfxManager:Play(SoundEffect.SOUND_NICKELPICKUP)
        elseif sub == CoinSubType.COIN_DIME then
            player:AddCoins(10); SfxManager:Play(SoundEffect.SOUND_DIMEPICKUP)
        elseif sub == CoinSubType.COIN_LUCKYPENNY then
            player:AddCoins(1); player:AddLuck(1); SfxManager:Play(SoundEffect.SOUND_LUCKYPICKUP)
        elseif sub == CoinSubType.COIN_GOLDEN then
            player:AddCoins(1); SfxManager:Play(SoundEffect.SOUND_PENNYPICKUP)
        else
            player:AddCoins(1); SfxManager:Play(SoundEffect.SOUND_PENNYPICKUP)
        end
        pickup:Remove()

    elseif v == PickupVariant.PICKUP_KEY then
        if sub == KeySubType.KEY_NORMAL then
            player:AddKeys(1); SfxManager:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
        elseif sub == KeySubType.KEY_DOUBLEPACK then
            player:AddKeys(2); SfxManager:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
        elseif sub == KeySubType.KEY_GOLDEN then
            player:AddGoldenKey(); SfxManager:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
        else
            player:AddKeys(1); SfxManager:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
        end
        pickup:Remove()

    elseif v == PickupVariant.PICKUP_BOMB then
        if sub == BombSubType.BOMB_NORMAL then
            player:AddBombs(1); SfxManager:Play(SoundEffect.SOUND_FETUS_FEET)
        elseif sub == BombSubType.BOMB_DOUBLEPACK then
            player:AddBombs(2); SfxManager:Play(SoundEffect.SOUND_FETUS_FEET)
        elseif sub == BombSubType.BOMB_GOLDEN then
            player:AddGoldenBomb(); SfxManager:Play(SoundEffect.SOUND_GOLDENBOMB)
        else
            player:AddBombs(1); SfxManager:Play(SoundEffect.SOUND_FETUS_FEET)
        end
        pickup:Remove()

    elseif v == PickupVariant.PICKUP_HEART then
        if sub == HeartSubType.HEART_FULL then
            player:AddHearts(2); SfxManager:Play(SoundEffect.SOUND_VAMP_GULP)
        elseif sub == HeartSubType.HEART_HALF then
            player:AddHearts(1); SfxManager:Play(SoundEffect.SOUND_VAMP_GULP)
        elseif sub == HeartSubType.HEART_SOUL then
            player:AddSoulHearts(2); SfxManager:Play(SoundEffect.SOUND_HOLY)
        elseif sub == HeartSubType.HEART_HALF_SOUL then
            player:AddSoulHearts(1); SfxManager:Play(SoundEffect.SOUND_HOLY)
        elseif sub == HeartSubType.HEART_BLACK then
            player:AddBlackHearts(2); SfxManager:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
        elseif sub == HeartSubType.HEART_ETERNAL then
            player:AddEternalHearts(1); SfxManager:Play(SoundEffect.SOUND_SUPERHOLY)
        elseif sub == HeartSubType.HEART_GOLDEN then
            player:AddGoldenHearts(1); SfxManager:Play(SoundEffect.SOUND_GOLD_HEART)
        elseif sub == HeartSubType.HEART_BONE then
            player:AddBoneHearts(1); SfxManager:Play(SoundEffect.SOUND_BONE_HEART)
        elseif sub == HeartSubType.HEART_ROTTEN then
            player:AddRottenHearts(1); SfxManager:Play(SoundEffect.SOUND_ROTTEN_HEART)
        else
            player:AddHearts(2); SfxManager:Play(SoundEffect.SOUND_VAMP_GULP)
        end
        pickup:Remove()

    elseif v == PickupVariant.PICKUP_LIL_BATTERY then
        player:SetActiveCharge(player:GetActiveCharge() + 6)
        SfxManager:Play(SoundEffect.SOUND_BATTERYCHARGE)
        pickup:Remove()

    else
        -- not consumable (cards, trinkets, chests, pedestals) → pull in
        local dir = (player.Position - pickup.Position)
        if dir:Length() > 0 then
            pickup.Velocity = dir:Resized(6)
        end
    end
end

---@param tear EntityTear
function BeggarsTear:onTearUpdate(tear)
    if not tear:GetData().BeggarsTear then return end
    local player = tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local radius = 32
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == EntityType.ENTITY_PICKUP then
            local pickup = ent:ToPickup()
            if pickup and not pickup:IsDead() and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
                if tear.Position:DistanceSquared(pickup.Position) < radius * radius then
                    manualPickup(player, pickup)
                end
            end
        end
    end
end

function BeggarsTear:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, BeggarsTear.onFireTear)
    mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, BeggarsTear.onTearUpdate)

    if EID then
        EID:addCollectible(
            BeggarsTear.COLLECTIBLE_ID,
            "Tears can collect pickups.#Consumables (coins, keys, bombs, hearts, batteries, golden variants, rotten hearts, etc.) are auto-collected when touched.#Other pickups (cards, trinkets, chests) are pulled toward Isaac.",
            "Beggar's Tear",
            "en_us"
        )
    end
end

return BeggarsTear
