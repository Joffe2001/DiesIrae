local mod = DiesIraeMod
local game = Game()

local COSTUME_HOLY = mod.Costumes.Holywood
local COSTUME_BROKEN = mod.Costumes.BrokenHolywood

local SPRITE_AURA = "gfx/characters/313_holymantle.anm2"
local SPRITE_UI = "gfx/ui/ui_hearts.anm2"

local HolyWood = {}
local state = {} 


local function GetData(player)
    local id = GetPtrHash(player)
    if not state[id] then
        state[id] = {
            Active = false,
            Broken = false,
            Aura = nil,
            Glow = nil,
            UIShield = nil
        }
    end
    return state[id]
end

function HolyWood:UseItem(_, _, player)
    local data = GetData(player)

    data.Active = true
    data.Broken = false

    player:TryRemoveNullCostume(COSTUME_BROKEN)
    player:AddNullCostume(COSTUME_HOLY)

    if not data.Aura then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("Shimmer")
        data.Aura = s
    end

    if not data.Glow then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("HeadDown")
        data.Glow = s
    end

    if not data.UIShield then
        local s = Sprite()
        s:Load(SPRITE_UI, true)
        s:Play("HolyMantle")
        data.UIShield = s
    end

    return { Discharge = true, Remove = false, ShowAnim = true }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, HolyWood.UseItem, mod.Items.HolyWood)


function HolyWood:OnDamage(entity, dmg, flags)
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    local data = GetData(player)

    if not data.Active then return end
    if player:HasInvincibility() then return end
    if (flags & DamageFlag.DAMAGE_RED_HEARTS) ~= 0 then return end

    data.Active = false
    data.Broken = true

    player:TryRemoveNullCostume(COSTUME_HOLY)
    player:AddNullCostume(COSTUME_BROKEN)

    local breakFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 11, player.Position, Vector.Zero, player)
    breakFX:ToEffect():FollowParent(player)

    player:SetMinDamageCooldown(50)

    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, HolyWood.OnDamage)


function HolyWood:OnNewRoom()
    for i = 0, game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        local data = GetData(player)

        if data.Active or data.Broken then
            data.Active = false

            player:TryRemoveNullCostume(COSTUME_HOLY)
            player:TryRemoveNullCostume(COSTUME_BROKEN)

            data.Aura = nil
            data.Glow = nil
            data.UIShield = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, HolyWood.OnNewRoom)


function HolyWood:RenderBody()
    for i = 0, game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = GetData(p)

        if data.Active and data.Aura and data.Glow then
            local pos = Isaac.WorldToScreen(p.Position) - game.ScreenShakeOffset

            data.Aura:Update()
            data.Aura:RenderLayer(0, pos)

            data.Glow:Update()
            data.Glow:RenderLayer(1, pos)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_BODY, HolyWood.RenderBody)


function HolyWood:RenderHUD()
    if (game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN) ~= 0 then return end

    for i = 0, game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = GetData(p)

        if data.Active and data.UIShield then
            local s = data.UIShield
            s:Update()
            local heartCount = math.ceil((p:GetEffectiveMaxHearts() + p:GetSoulHearts()) / 2)
            s:Render(Vector(68 + heartCount * 12, 24))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, HolyWood.RenderHUD)


return HolyWood
