local mod = DiesIraeMod

mod.CHARGEBAR_POSITIONS = {
    Vector(18, -54.2),
    Vector(29, -36.7),
    Vector(39.5, -54.2),
    Vector(50.5, -36.7)
}

function mod:CountActiveChargebars(player)
    local num = 0
    local weapons = player:GetWeaponModifiers()

    if ((
            (weapons & WeaponModifier.CHOCOLATE_MILK ~= 0
            or weapons & WeaponModifier.CURSED_EYE ~= 0
            or weapons & WeaponModifier.BRIMSTONE ~= 0
            or weapons & WeaponModifier.MONSTROS_LUNG ~= 0
            or weapons & WeaponModifier.NEPTUNUS ~= 0
            or player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)

        ) and weapons & WeaponModifier.LUDOVICO_TECHNIQUE == 0)
        or
        (
            (weapons & WeaponModifier.C_SECTION ~= 0
            or weapons & WeaponModifier.BONE ~= 0
            or player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
        )))
        and weapons & WeaponModifier.SOY_MILK == 0
        and weapons & WeaponModifier.ALMOND_MILK == 0 then

        num = num + 1
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID) then
        num = num + 1
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_REVELATION) then
        num = num + 1
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE) then
        num = num + 1
    end

    if player:GetPlayerType() == PlayerType.PLAYER_SAMSON_B
        and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
        num = num + 1
    end

    if player:GetPlayerType() == PlayerType.PLAYER_EVE_B then
        num = num + 1
    end

    return num
end
