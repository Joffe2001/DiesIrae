local mod = DiesIraeMod
local game = Game()
local SFX = SFXManager()
local itemConfig = Isaac.GetItemConfig()
local MAX_ITEM_ID = itemConfig:GetCollectibles().Size - 1

local SkullLives = {}

local function GetLives(player)
    return SkullLives[player.Index] or 0
end

local function UseLife(player)
    if GetLives(player) > 0 then
        SkullLives[player.Index] = GetLives(player) - 1
        return true
    end
    return false
end

function mod:FloweringSkull_OnUpdate(player)
    local count = player:GetCollectibleNum(mod.Items.FloweringSkull)
    if count > GetLives(player) then
        SkullLives[player.Index] = count
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.FloweringSkull_OnUpdate)

function mod:FloweringSkull_PreDeath(player)
    if player:HasCollectible(mod.Items.FloweringSkull) and player:WillPlayerRevive() then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.FloweringSkull_PreDeath)

function mod:FloweringSkull_PostRevive(player, playerType)
    if not player then return end
    if player:HasCollectible(mod.Items.FloweringSkull) and UseLife(player) then
        player:Revive()
        player:RemoveCollectible(mod.Items.FloweringSkull)

        if player:GetMaxHearts() > 0 then
            player:AddMaxHearts(-(player:GetMaxHearts() - 4))
            player:AddHearts(4)
        else
            player:AddSoulHearts(4)
        end
        player:SetMinDamageCooldown(90)
        player:GetData().ReviveIFrames = 90

        local room = game:GetRoom()
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy(false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                entity:TakeDamage(40, 0, EntityRef(player), 0)
            end
        end

        local passiveItems = {}
        for id = 1, MAX_ITEM_ID do
            local cfg = itemConfig:GetCollectible(id)
            if cfg 
               and player:HasCollectible(id)
               and cfg:IsAvailable()
               and cfg.Type == ItemType.ITEM_PASSIVE
               and id ~= mod.Items.FloweringSkull then
                table.insert(passiveItems, id)
            end
        end

        while #passiveItems > 0 do
            local removeIndex = math.random(1, #passiveItems)
            local oldID = passiveItems[removeIndex]
            player:RemoveCollectible(oldID)
            table.remove(passiveItems, removeIndex)
            local newID
            local tries = 0
            repeat
                newID = math.random(1, MAX_ITEM_ID)
                local cfg = itemConfig:GetCollectible(newID)
                tries = tries + 1
            until cfg 
                  and cfg:IsAvailable()
                  and cfg.Type == ItemType.ITEM_PASSIVE
                  and newID ~= mod.Items.FloweringSkull
                  or tries > 100
        
            if newID then
                player:AddCollectible(newID, 0, true)
            end
        end
        player:EvaluateItems()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, mod.FloweringSkull_PostRevive)