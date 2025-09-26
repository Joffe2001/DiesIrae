local BadTouch = {}
BadTouch.COLLECTIBLE_ID = Enums.Items.TheBadTouch
local game = Game()

function BadTouch:onPlayerCollision(player, collider)
    if not player:HasCollectible(BadTouch.COLLECTIBLE_ID) then return end
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
function BadTouch:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, BadTouch.onPlayerCollision)

    if EID then
        EID:addCollectible(
            BadTouch.COLLECTIBLE_ID,
            "Touching an enemy instantly kills normal enemies.#Bosses are poisoned on contact.",
            "The Bad Touch",
            "en_us"
        )
        EID:assignTransformation("collectible", BadTouch.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return BadTouch
