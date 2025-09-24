local BadTouch = {}
BadTouch.COLLECTIBLE_ID = Isaac.GetItemIdByName("The Bad Touch")
local game = Game()

-- Callback when Isaac touches another entity
function BadTouch:onPlayerCollision(player, collider)
    if not player:HasCollectible(BadTouch.COLLECTIBLE_ID) then return end
    if not collider:IsEnemy() then return end

    local npc = collider:ToNPC()
    if npc then
        if npc:IsBoss() then
            -- Apply poison effect to boss
            npc:AddPoison(EntityRef(player), 120, 3.0)  -- 120 frames (2 sec), 3 DPS
        else
            npc:Kill()
        end
    end
end

-- EID description
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
