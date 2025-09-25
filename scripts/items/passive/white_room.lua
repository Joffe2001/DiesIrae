local MOD = RegisterMod("white room", 1)
local ITEM_ID = Isaac.GetItemIdByName("White room")
local rng = RNG()
local game = Game()
local hasWhiteRoom = false

function MOD:postNewRoom()
    local player = Isaac.GetPlayer(0) -- multiplayer?
loop players
    hasWhiteRoom = player:HasCollectible(ITEM_ID)
end
MOD:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MOD.postNewRoom)
function MOD:unChampion(npc)
    if hasWhiteRoom and npc:IsChampion() then
        npc:MakeChampion(0, -1, false) -- sets champion to normal
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_NPC_INIT, MOD.unChampion)