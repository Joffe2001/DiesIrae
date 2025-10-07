local MusicTears = {}
function MusicTears:Apply(tear)
    if not tear or tear.Type ~= EntityType.ENTITY_TEAR then return end

    local sprite = tear:GetSprite()
    sprite:ReplaceSpritesheet(0, "gfx/proj/music_tears.png") 
    sprite:LoadGraphics()
    tear:GetData().isMusicTear = true
end

function MusicTears:Init(mod)
end

return MusicTears
