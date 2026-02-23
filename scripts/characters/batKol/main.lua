local mod = DiesIraeMod
local game = Game()
local batKol = {}

mod.PlayerType.PLAYER_BAT_KOL = Isaac.GetPlayerTypeByName("Bat Kol", false)

batKol.BaseTearRate = 2.73
batKol.MaxGhosts = 6
batKol.StartGhosts = 2
batKol.Ghosts = {} 

local function GetDesiredGhostCount(player)
    local tears = player.MaxFireDelay
    local tearRate = 30 / (tears + 1)
    local tearUps = math.floor(tearRate - batKol.BaseTearRate)
    local count = batKol.StartGhosts + math.max(0, tearUps)
    return math.min(batKol.MaxGhosts, math.max(batKol.StartGhosts, count))
end

function batKol:BatKolPlayerUpdate(player)
    if player:GetPlayerType() ~= mod.PlayerType.PLAYER_BAT_KOL then return end
    if player:IsCoopGhost() then return end

    local id = player.InitSeed
    local desiredCount = GetDesiredGhostCount(player)
    local ghosts = batKol.Ghosts[id] or {}

    while #ghosts < desiredCount do
        local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EntityVariant.BatKolGhost, 0, player.Position, Vector.Zero, player)
        local sprite = ghost:GetSprite()
        sprite:Play("FloatDown", true)
        ghost:GetData().Owner = player
        ghost:GetData().Loose = false
        table.insert(ghosts, ghost)
    end

    while #ghosts > desiredCount do
        local g = table.remove(ghosts)
        if g and g:Exists() then g:Remove() end
    end

    batKol.Ghosts[id] = ghosts
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, batKol.PlayerUpdate)


function batKol:BatKolGhostUpdate(ghost)
    local data = ghost:GetData()
    local player = data.Owner
    if not player or not player:Exists() then ghost:Remove(); return end

    local ghosts = batKol.Ghosts[player.InitSeed] or {}
    local idx = 1
    for i, g in ipairs(ghosts) do
        if g.InitSeed == ghost.InitSeed then idx = i break end
    end

    local orbitRadius = 40
    local orbitSpeed = 0.05
    local angle = (game:GetFrameCount() * orbitSpeed + (idx * (360 / math.max(1, #ghosts)))) % 360
    local orbitPos = player.Position + Vector.FromAngle(angle) * orbitRadius
    local firing = player:GetFireDirection() ~= Direction.NO_DIRECTION

    if not firing then
        ghost.Velocity = (orbitPos - ghost.Position) * 0.3
        data.Loose = false
        return
    end

    local target
    local enemies = Isaac.FindInRadius(ghost.Position, 200, EntityPartition.ENEMY)
    for _, e in ipairs(enemies) do
        if e:CanShutDoors() and e:IsVulnerableEnemy() and not e:IsDead() then
            target = e
            break
        end
    end

    if target then
        data.Loose = true
        local dir = (target.Position - ghost.Position):Normalized()
        ghost.Velocity = dir * 8

        if ghost.Position:Distance(target.Position) < 20 then
            local dmg = (player.Damage * 0.5) / 30
            target:TakeDamage(dmg, DamageFlag.DAMAGE_FAKE, EntityRef(ghost), 0)
        end
    else
        ghost.Velocity = (orbitPos - ghost.Position) * 0.3
        data.Loose = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, batKol.GhostUpdate, mod.EntityVariant.BatKolGhost)

function batKol:BatKolCleanup()
    for _, ghosts in pairs(batKol.Ghosts) do
        for _, g in ipairs(ghosts) do
            if g and g:Exists() then g:Remove() end
        end
    end
    batKol.Ghosts = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, batKol.Cleanup)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, batKol.Cleanup)
