local mod = DiesIraeMod

local Hysteria = {}
local game = Game()
local SFX = SFXManager()

function Hysteria:OnTakeDamage(entity, amount, flags, source, countdown)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(mod.Items.Hysteria) then return end

    local data = player:GetData()
    data.HHits = (data.HHits or 0) + 1

    if data.HHits == 2 and not data.HActive then
        data.HActive = true
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
        SFX:Play(576)
    end

    if data.HHits == 3 then
        player:AddBrokenHearts(1)

        if data.HActive then
            data.HActive = nil
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end

        SFX:Play(SoundEffect.SOUND_THUMBS_DOWN)
    end

    if data.HHits == 4 then
        player:AddBrokenHearts(1)
        data.HTearsActive = true

        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()

        SFX:Play(SoundEffect.SOUND_POWERUP1)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Hysteria.OnTakeDamage)


function Hysteria:OnPlayerUpdate(_, player)
    if not player or not player:HasCollectible(mod.Items.Hysteria) then return end

    local data = player:GetData()
    local room = game:GetRoom()

    if room:GetFrameCount() == 1 then
        data.HHits = 0

        if data.HActive then
            data.HActive = nil
        end

        if data.HTearsActive then
            data.HTearsActive = nil
        end

        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Hysteria.OnPlayerUpdate)


function Hysteria:OnCache(player, cacheFlag)
    local data = player:GetData()

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.HActive then
            player.Damage = player.Damage * 2
        end
    end


    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        if data.HTearsActive then
            local currentTears = 30 / (player.MaxFireDelay + 1)
            local newTears = currentTears * 2 
            player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Hysteria.OnCache)


function Hysteria:OnNewRoom()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()
    data.HHits = 0

    data.HActive = nil
    data.HTearsActive = nil

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Hysteria.OnNewRoom)


mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    for i = 0, Game():GetNumPlayers() - 1 do
        local data = Isaac.GetPlayer(i):GetData()
        data.SkillIssueUnlocked = false
    end
end)

if EID then
    EID:assignTransformation("collectible", mod.Items.Hysteria, "Isaac's sinful Playlist")
end
