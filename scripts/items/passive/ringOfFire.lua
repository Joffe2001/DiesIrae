local mod = DiesIraeMod
local game = Game()

local RingOfFire = {}
RingOfFire.MAX_WISPS = 6


function RingOfFire:SpawnFireWisp(player)
    local wisp = player:AddWisp(mod.Items.RingOfFire, player.Position, false, true)
    if not wisp then return end

    local data = wisp:GetData()
    data.IsRingOfFireWisp = true
    wisp.Color = Color(1.3, 0.5, 0.1, 1, 0, 0, 0)

    return wisp
end

function RingOfFire:OnNewRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local idx = level:GetCurrentRoomIndex()

    local hadEnemies = room:GetAliveEnemiesCount() > 0

    local data = level:GetRoomByIdx(idx).Data
    if data then
        room:GetRoomConfigStage()
    end

    RingOfFire.LastRoomHadEnemies = hadEnemies
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RingOfFire.OnNewRoom)

function RingOfFire:GetFireWispCount(player)
    local count = 0
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, -1)) do
        local fam = ent:ToFamiliar()
        if fam and fam.Player == player then
            if fam:GetData().IsRingOfFireWisp then
                count = count + 1
            end
        end
    end
    return count
end

local function OnPlayerUpdate(_, player)
    if not player:HasCollectible(mod.Items.RingOfFire) then return end

    local data = player:GetData()
    if data.RingOfFire_Init then return end
    data.RingOfFire_Init = true

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP)) do
        local fam = ent:ToFamiliar()
        if fam and fam.Player == player then
            if fam:GetData().IsRingOfFireWisp then
                fam:Remove()
            end
        end
    end

    for i = 1, RingOfFire.MAX_WISPS do
        RingOfFire:SpawnFireWisp(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, OnPlayerUpdate)

local lastClearedRoom = -1

function RingOfFire:OnUpdate()
    local room = game:GetRoom()
    local idx = game:GetLevel():GetCurrentRoomIndex()

    if room:IsClear() and idx ~= lastClearedRoom then
        lastClearedRoom = idx

        if RingOfFire.LastRoomHadEnemies then
            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)
                if player:HasCollectible(mod.Items.RingOfFire) then

                    local count = RingOfFire:GetFireWispCount(player)
                    if count < RingOfFire.MAX_WISPS then
                        RingOfFire:SpawnFireWisp(player)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, RingOfFire.OnUpdate)


function RingOfFire:OnFamiliarCollision(fam, collider)
    if not fam:GetData().IsRingOfFireWisp then return end

    if collider:IsVulnerableEnemy() then
        local player = fam.Player
        collider:AddBurn(EntityRef(player), 45, player.Damage * 0.7)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, RingOfFire.OnFamiliarCollision, FamiliarVariant.WISP)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    if familiar.Variant ~= FamiliarVariant.WISP then return end
    if familiar:GetData().IsRingOfFireWisp then
        familiar.FireCooldown = 99999
        familiar.ShootDirection = Direction.NO_DIRECTION
    end
end)
