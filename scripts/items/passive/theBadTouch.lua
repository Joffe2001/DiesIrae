local mod = DiesIraeMod
local BadTouch = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_THE_BAD_TOUCH = Isaac.GetItemIdByName("The Bad Touch")

function BadTouch:onPlayerCollision(player, collider)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_THE_BAD_TOUCH) then return end
    if not collider:IsVulnerableEnemy() then return end

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
    EID:assignTransformation("collectible", mod.CollectibleType.COLLECTIBLE_THE_BAD_TOUCH, "Dad's Playlist")
end
