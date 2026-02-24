---@class ModReference
local mod = DiesIraeMod
local game = Game()
local skullCrasher = {}

mod.CollectibleType.COLLECTIBLE_SKULL_CRASHER = Isaac.GetItemIdByName("Skull Crasher")

local SKULL_ENEMIES = {
    [EntityType.ENTITY_HOST] = true,
    [EntityType.ENTITY_FLESH_MOBILE_HOST] = true,
    [EntityType.ENTITY_MOBILE_HOST] = true,
    [EntityType.ENTITY_FLOATING_HOST] = true
}

function skullCrasher:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    local npc = entity:ToNPC()
    if not npc or not SKULL_ENEMIES[npc.Type] then return end

    local hasSkullCrasher = false
    for i = 0, game:GetNumPlayers() - 1 do
        if Isaac.GetPlayer(i):HasCollectible(mod.Items.SkullCrasher) then
            hasSkullCrasher = true
            break
        end
    end
    if not hasSkullCrasher then return end

    if not source or not source.Entity or not source.Entity:ToPlayer() then
        return
    end

    local anim = npc:GetSprite():GetAnimation()
    if anim == "Close" or anim == "HeadClosed" or anim == "IdleClosed" then
        npc.HitPoints = math.max(0, npc.HitPoints - amount)
        npc:SetColor(Color(1, 0, 0, 1, 0, 0, 0), 5, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_MEAT_IMPACTS)

        if npc.HitPoints <= 0 then
            npc:Kill()
        end

        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, skullCrasher.OnEntityTakeDamage)
