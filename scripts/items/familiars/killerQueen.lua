local mod = DiesIraeMod
local KillerQueen = {}

function KillerQueen:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(mod.Items.KillerQueen)
        player:CheckFamiliar(
            mod.Entities.FAMILIAR_KillerQueen.Var,
            count,
            player:GetCollectibleRNG(mod.Items.KillerQueen),
            Isaac.GetItemConfig():GetCollectible(mod.Items.KillerQueen)
        )
    end
end

function KillerQueen:onFamiliarInit(familiar)
    familiar:AddToFollowers()
    local data = familiar:GetData()
    data.State = "FOLLOW" 
    data.AttackTimer = 0
    data.HasExploded = false
end

function KillerQueen:onFamiliarUpdate(familiar)
    local data = familiar:GetData()
    local sprite = familiar:GetSprite()
    local player = familiar.Player
    local room = Game():GetRoom()

    if not familiar.IsFollower then
        familiar:AddToFollowers()
    end
    if room:IsClear() then
        data.State = "FOLLOW"
    end

    if data.State == "FOLLOW" then
        familiar:FollowParent()

        if not sprite:IsPlaying("Float") then
            sprite:Play("Float", true)
        end

        if not room:IsClear() and math.random(200) == 1 then
            data.State = "ATTACK"
            data.AttackTimer = 90 
            data.HasExploded = false
            sprite:Play("Float_attack", true)
        end

    elseif data.State == "ATTACK" then
        familiar.Velocity = Vector.Zero

        if not sprite:IsPlaying("Float_attack") then
            sprite:Play("Float_attack", true)
            SFXManager():Play(mod.Sounds.KILLER_QUEEN_DETONATE, 1.2, 0, false, 1)
        end

        local explodeFrame = 30
        if data.AttackTimer == explodeFrame and not data.HasExploded then
            local allEntities = Isaac.GetRoomEntities()
            local validEnemies = {}

            for _, e in ipairs(allEntities) do
                if e:IsVulnerableEnemy() and e:CanShutDoors() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    table.insert(validEnemies, e)
                end
            end

            if #validEnemies > 0 then
                local target = validEnemies[math.random(#validEnemies)]
                local damage = player.Damage * 20
                local pos = target.Position

                Game():BombExplosionEffects(
                    pos,
                    damage,
                    TearFlags.TEAR_NORMAL,
                    Color(1, 1, 1, 1),
                    familiar,
                    0.8,   
                    false,
                    false
                )
                SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1.2, 0, false, 1)

                data.HasExploded = true
            end
        end

        data.AttackTimer = data.AttackTimer - 1
        if data.AttackTimer <= 0 then
            data.State = "FOLLOW"
            sprite:Play("Float", true)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KillerQueen.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, KillerQueen.onFamiliarInit, mod.Entities.FAMILIAR_KillerQueen.Var)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KillerQueen.onFamiliarUpdate, mod.Entities.FAMILIAR_KillerQueen.Var)

if EID then
    EID:assignTransformation("collectible", mod.Items.KillerQueen, "Dad's Playlist")
end