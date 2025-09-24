local Guppys_soul = {}
Guppys_soul.COLLECTIBLE_ID = Isaac.GetItemIdByName("Guppy's soul")

local json = require("json")
local game = Game()

-- Internal state
Guppys_soul.hasGuppyEffect = false
Guppys_soul.hasGuppyCostume = false
Guppys_soul.currentRoom = nil

-- Store mod reference for saving/loading
local mod = nil

-- Wrapper methods to call mod's save/load functions
function Guppys_soul:SaveData(data)
    if mod then
        mod:SaveData(data)
    end
end

function Guppys_soul:HasData()
    if mod then
        return mod:HasData()
    end
    return false
end

function Guppys_soul:LoadData()
    if mod then
        return mod:LoadData()
    end
    return nil
end

function Guppys_soul:useItem(_, _, player)
    player:AddNullCostume(NullItemID.ID_GUPPY)
    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    Guppys_soul.hasGuppyEffect = true
    player:EvaluateItems()
    Guppys_soul.hasGuppyCostume = true
    Guppys_soul.currentRoom = game:GetLevel():GetCurrentRoomIndex()

    Guppys_soul:SaveData(json.encode({
        hasGuppyCostume = true,
        hasGuppyEffect = true,
        currentRoom = Guppys_soul.currentRoom
    }))

    print("Guppy effect applied, CanFly:", player.CanFly) -- Debug
    return true
end

function Guppys_soul:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FLYING and Guppys_soul.hasGuppyEffect then
        player.CanFly = true
    end
end

function Guppys_soul:onNewRoom()
    if Guppys_soul.hasGuppyCostume then
        local newRoom = game:GetLevel():GetCurrentRoomIndex()
        if newRoom ~= Guppys_soul.currentRoom then
            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)
                player:TryRemoveNullCostume(NullItemID.ID_GUPPY)
                if player.CanFly then
                    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
                    player:EvaluateItems()
                end
            end
            Guppys_soul.currentRoom = newRoom
            Guppys_soul.hasGuppyCostume = false
            Guppys_soul.hasGuppyEffect = false

            Guppys_soul:SaveData(json.encode({
                hasGuppyCostume = false,
                hasGuppyEffect = false,
                currentRoom = nil
            }))
        end
    end
end

function Guppys_soul:onEntityTakeDmg(entity)
    if Guppys_soul.hasGuppyEffect and entity:IsEnemy() then
        if math.random() < 0.60 then
            local player = Isaac.GetPlayer(0)
            player:AddBlueFlies(1, player.Position, nil)
        end
    end
end

function Guppys_soul:loadData()
    if self:HasData() then
        local data = json.decode(self:LoadData())
        if data then
            self.hasGuppyCostume = data.hasGuppyCostume
            self.hasGuppyEffect = data.hasGuppyEffect
            self.currentRoom = data.currentRoom
        end
    end
end

function Guppys_soul:Init(pMod)
    mod = pMod -- store the mod instance for save/load

    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return Guppys_soul:useItem(...)
    end, Guppys_soul.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
        Guppys_soul:onCache(player, cacheFlag)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        Guppys_soul:onNewRoom()
    end)

    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
        Guppys_soul:onEntityTakeDmg(entity)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        Guppys_soul:loadData()
    end)

    if EID then
        EID:addCollectible(Guppys_soul.COLLECTIBLE_ID,
            "Grants flight and spawns blue flies on enemy damage (66% chance)",
            "Guppy's soul",
            "en_us"
        )
    end
end

return Guppys_soul


