local mod = DiesIraeMod
local game = Game()
local rng = RNG()

local PlayerType_BatKol = mod.Players.BatKol
local GhostVariant = mod.EntityVariant.BatKolGhost

function mod:PostPlayerInit(player)
    if player:GetPlayerType() == PlayerType_BatKol then
        local data = player:GetData()
        data.BatKolInit = true
        data.BatKolGhosts = data.BatKolGhosts or {}
        data.BatKolNumGhosts = player.MaxFireDelay or 3
        mod:SpawnBatKolGhosts(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.PostPlayerInit)

function mod:SpawnBatKolGhosts(player)
    local data = player:GetData()
    data.BatKolGhosts = data.BatKolGhosts or {}
    for _, ent in ipairs(data.BatKolGhosts) do
        if ent:Exists() then ent:Remove() end
    end
    data.BatKolGhosts = {}

    local numGhosts = math.max(1, player.MaxFireDelay or 3)
    for i = 1, numGhosts do
        local angle = (360 / numGhosts) * (i - 1)
        local offset = Vector(40, 0):Rotated(angle)

        local ghost = Isaac.Spawn(EntityType.ENTITY_CUSTOM, GhostVariant, 0, player.Position + offset, Vector.Zero, player)
        if ghost then
            ghost:GetData().BatKolOwner = player
            ghost:GetData().BatKolAngle = angle
            ghost:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            table.insert(data.BatKolGhosts, ghost)
        else
            print("[Dies Irae] ERROR: Failed to spawn Bat Kol Ghost!")
        end
    end
end

function mod:UpdateBatKolGhosts()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == PlayerType_BatKol then
            local data = player:GetData()
            if data.BatKolGhosts then
                for _, ghost in ipairs(data.BatKolGhosts) do
                    if ghost and ghost:Exists() then
                        local gData = ghost:GetData()
                        gData.BatKolAngle = (gData.BatKolAngle + 2) % 360
                        local offset = Vector(40, 0):Rotated(gData.BatKolAngle)
                        ghost.Position = player.Position + offset
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.UpdateBatKolGhosts)

function mod:OnNewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == PlayerType_BatKol then
            local data = player:GetData()
            if not data.BatKolGhosts or #data.BatKolGhosts == 0 then
                mod:SpawnBatKolGhosts(player)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

function mod:CheckBatKolGhostCount()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == PlayerType_BatKol then
            local data = player:GetData()
            local expected = math.max(1, player.MaxFireDelay or 3)
            if not data.BatKolGhosts or #data.BatKolGhosts ~= expected then
                mod:SpawnBatKolGhosts(player)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.CheckBatKolGhostCount)
