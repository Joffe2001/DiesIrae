local mod = DiesIraeMod

local ArmyOfLovers = {
    REWARD_SPAWN_CHANCE_BASE = 0.12,
    REWARD_SPAWN_CHANCE_MIN = 0.08,
    REWARD_SPAWN_CHANCE_MAX = 0.2,
    REWARD_SPAWN_CHANCE_PER_LUCK = 0.005,
    CARD_CHANCE = 0.5,
    CARD_CHANCE_MAGDALENE = 0.75,
    REVERSE_CHANCE_BASE = 0.01,
    REVERSE_CHANCE_PER_CURSE = 0.1,
    REVERSE_CHANCE_PER_CURSED_EYE = 0.15,
    REVERSE_CHANCE_CURSED_ROOM = 0.1,
    REVERSE_CHANCE_T_MAGDALENE = 0.1,
}

---@param player EntityPlayer
function ArmyOfLovers:UseItem(_, _, player)
    local luck = player.Luck

    for _ = 1, 2 do
        player:AddMinisaac(player.Position)
    end

    local rng = player:GetCollectibleRNG(mod.Items.ArmyOfLovers)

    local rewardSpawnChance = ArmyOfLovers.REWARD_SPAWN_CHANCE_BASE
    rewardSpawnChance = rewardSpawnChance + luck * ArmyOfLovers.REWARD_SPAWN_CHANCE_PER_LUCK
    rewardSpawnChance = math.max(ArmyOfLovers.REWARD_SPAWN_CHANCE_MIN, math.min(ArmyOfLovers.REWARD_SPAWN_CHANCE_MAX, rewardSpawnChance))

    local cardChance = ArmyOfLovers.CARD_CHANCE
    if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE or player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B then
        cardChance = ArmyOfLovers.CARD_CHANCE_MAGDALENE
    end

    local reverseChance = ArmyOfLovers.REVERSE_CHANCE_BASE
    reverseChance = reverseChance + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CURSED_EYE) * ArmyOfLovers.REVERSE_CHANCE_PER_CURSED_EYE
    if Game():GetRoom():GetType() == RoomType.ROOM_CURSE then
        reverseChance = reverseChance + ArmyOfLovers.REVERSE_CHANCE_CURSED_ROOM
    end
    reverseChance = reverseChance + ArmyOfLovers:GetNumCurses() * ArmyOfLovers.REVERSE_CHANCE_PER_CURSE
    if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B then
        reverseChance = reverseChance + ArmyOfLovers.REVERSE_CHANCE_T_MAGDALENE
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        reverseChance = 0
    end

    if rng:RandomFloat() < rewardSpawnChance then
        for _ = 1, 5 do
            if rng:RandomFloat() < cardChance then
                if rng:RandomFloat() < reverseChance then
                    ArmyOfLovers:SpawnCardReversedLovers(player, rng)
                else
                    ArmyOfLovers:SpawnCardLovers(player, rng)
                end
            else
                ArmyOfLovers:SpawnHeart(player, rng)
            end
        end
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ArmyOfLovers.UseItem, mod.Items.ArmyOfLovers)

function ArmyOfLovers:GetNumCurses()
	local curses = Game():GetLevel():GetCurses()
    local cnt = 0
    local i = 0
    while curses > 0 do
        if (curses & (1 << i)) ~= 0 then
            cnt = cnt + 1
        end
        i = i + 1
        curses = curses >> 1
    end
    return cnt
end

function ArmyOfLovers:SpawnCardLovers(player, rng)
    Game():Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_TAROTCARD,
        Isaac.GetFreeNearPosition(player.Position, 40),
        Vector.Zero,
        player,
        Card.CARD_LOVERS,
        rng:GetSeed()
    )
end

function ArmyOfLovers:SpawnCardReversedLovers(player, rng)
    Game():Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_TAROTCARD,
        Isaac.GetFreeNearPosition(player.Position, 40),
        Vector.Zero,
        player,
        Card.CARD_REVERSE_LOVERS,
        rng:GetSeed()
    )
end

function ArmyOfLovers:SpawnHeart(player, rng)
    Game():Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_HEART,
        Isaac.GetFreeNearPosition(player.Position, 40),
        Vector.Zero,
        player,
        HeartSubType.HEART_FULL,
        rng:GetSeed()
    )
end

if EID then
    EID:assignTransformation("collectible", mod.Items.ArmyOfLovers, "Dad's Playlist")
end