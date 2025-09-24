local HelterSkelter = {}
HelterSkelter.COLLECTIBLE_ID = Isaac.GetItemIdByName("Helter skelter")
local game = Game()

function HelterSkelter:UseItem(_, rngSeed, player)
    local roomEntities = Isaac.GetRoomEntities()
    local rng = RNG()
    
    local seedNumber = 0
    if type(rngSeed) == "userdata" and rngSeed.GetStartSeed then
        seedNumber = rngSeed:GetStartSeed()
    elseif type(rngSeed) == "number" then
        seedNumber = rngSeed
    else
        seedNumber = os.time()
    end

    rng:SetSeed(seedNumber, 35)

    for _, entity in ipairs(roomEntities) do
        if entity:IsActiveEnemy(false) and not entity:IsBoss() and entity:ToNPC() then
            if rng:RandomFloat() < 0.25 then
                local npc = entity:ToNPC()
                local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, npc.Position, Vector.Zero, player):ToNPC()
                bony:AddCharmed(EntityRef(player), -1)
                bony.HitPoints = npc.MaxHitPoints * 0.3
                bony:SetColor(Color(1, 1, 1, 0.5, 0, 0, 0), -1, 0, false)
                npc:Remove()
            end
        end
    end

    return true
end

function HelterSkelter:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, HelterSkelter.UseItem, HelterSkelter.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(HelterSkelter.COLLECTIBLE_ID,
            "25% chance to turn each enemy into a friendly Bony",
            "Helter Skelter",
            "en_us"
        )
        EID:assignTransformation("collectible", HelterSkelter.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return HelterSkelter
