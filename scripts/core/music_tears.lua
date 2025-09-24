local MusicTears = {}

-- 🔁 Replace a tear's sprite with your music tear PNG
function MusicTears:Apply(tear)
    if not tear or tear.Type ~= EntityType.ENTITY_TEAR then return end

    local sprite = tear:GetSprite()
    sprite:ReplaceSpritesheet(0, "gfx/proj/music_tears.png") 
    sprite:LoadGraphics()

    -- optional: mark this tear so you can detect it later
    tear:GetData().isMusicTear = true
end

-- 📡 Optional helper: automatically apply to every tear fired
function MusicTears:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
        self:Apply(tear)
    end)
end

return MusicTears
