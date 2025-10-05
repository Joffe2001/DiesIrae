local mod = DiesIraeMod

local BadTouch = {}
local game = Game()

function BadTouch:onPlayerCollision(player, collider)
    if not player:HasCollectible(mod.Items.TheBadTouch) then return end
    if not collider:IsEnemy() then return end

    local npc = collider:ToNPC()
    if npc then
        if npc:IsBoss() then
            npc:AddPoison(EntityRef(player), 120, 3.0) 
        else
            npc:Kill()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, BadTouch.onPlayerCollision)

if EID then
    EID:addCollectible(
        mod.Items.TheBadTouch,
        "Touching an enemy instantly kills normal enemies.#Bosses are poisoned on contact.",
        "The Bad Touch",
        "en_us"
    )
    EID:assignTransformation("collectible", mod.Items.TheBadTouch, "Dad's Playlist")
end
