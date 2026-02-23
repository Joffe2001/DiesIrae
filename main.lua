---@class ModReference
DiesIraeMod = RegisterMod("Dies Irae", 1)

---@class SaveManager
DiesIraeMod.SaveManager = include("scripts.dependencies.save_manager")
DiesIraeMod.SaveManager.Init(DiesIraeMod)

DiesIraeMod.JSON = require("json")

include("scripts.core.enums")
include("scripts.core.pools")
DiesIraeMod.Utils = include("scripts.core.utils")
include("scripts.core.chargebar_utils")
include("scripts.core.unlocks")

--include("scripts/characters/david_challenges/david_challenges_utils")
--include("scripts/characters/david_challenges/david_challenges")

if EID then
	include("scripts.modcompat.eidescs")
	include("scripts.modcompat.eid")
end

include("scripts.characters.main")
include("scripts.items.main")

---------------------------------------------------
--  Curses
----------------------------------------------------
include("scripts.curses.curse_eval")
--include("scripts.curses.unloved")
---------------------------------------------------
--  Effects
----------------------------------------------------
include("scripts.effects.resonance")
include("scripts.effects.fragile")
----------------------------------------------------
--  Challenges
----------------------------------------------------
include("scripts.challenges.worsttouch")
---------------------------------------------------
--  Transformations
----------------------------------------------------
include("scripts.transformations.isaacsinfulmusic")
include("scripts.transformations.dadsoldplaylist")
---------------------------------------------------
--  NPCs
---------------------------------------------------
include("scripts.npcs.fiend_beggar")
include("scripts.npcs.tech_beggar")
include("scripts.npcs.guppy_beggar")
include("scripts.npcs.jys")
include("scripts.npcs.goldsmith")
include("scripts.npcs.familiars_beggar")
include("scripts.npcs.sacrifice_table")
include("scripts.npcs.lost_adventurer")
include("scripts.npcs.chaos_beggar")
--------Elijah's NPCs------------------------------
include("scripts.npcs.elijah.elijah_tech_beggar")
include("scripts.npcs.elijah.elijah_beggar")
include("scripts.npcs.elijah.elijah_bomb_beggar")
include("scripts.npcs.elijah.elijah_key_beggar")
include("scripts.npcs.elijah.elijah_rotten_beggar")
include("scripts.npcs.elijah.elijah_battery_beggar")
include("scripts.npcs.elijah.elijah_treasure_beggar")
include("scripts.npcs.elijah.elijah_shop_beggar")
include("scripts.npcs.elijah.elijah_angel_beggar")
include("scripts.npcs.elijah.elijah_demon_beggar")
include("scripts.npcs.elijah.elijah_planeterium_beggar")
include("scripts.npcs.elijah.elijah_secret_beggar")
include("scripts.npcs.elijah.elijah_ultra_secret_beggar")
include("scripts.npcs.elijah.elijah_error_beggar")
include("scripts.npcs.elijah.elijah_book_beggar")
include("scripts.npcs.elijah.elijah_goldsmith")
include("scripts.npcs.elijah.elijah_jys")
include("scripts.npcs.elijah.elijah_familiars_beggar")
include("scripts.npcs.elijah.elijah_restock")
include("scripts.npcs.elijah.elijah_lost_adventurer")
include("scripts.npcs.elijah.elijah_chaos_beggar")
---------------------------------------------------
--  ENEMIES
---------------------------------------------------
include("scripts.enemies.blindedhorf")
include("scripts.enemies.horfling")
---------------------------------------------------
--  Extras
---------------------------------------------------
include("scripts.core.voidlost")
include("scripts.items.familiars.gellocostumes")
include("scripts.modcompat.deadseascrolls")
---------------------------------------------------
--  TESTING ITEMS
---------------------------------------------------
--[[NEEDS REQUIRE!]] --require("scripts.items.passive.redbulb.main")
--include("scripts.items.passive.hitlist")
--include("scripts.items.passive.photonlink")
--include("scripts.items.passive.silentEcho")
--include("scripts.items.passive.conscience")
--include("scripts.items.passive.eyesacrifice")
--include("scripts.items.passive.the_path_of_the_righteous")
--include("scripts.items.passive.challengemap")
--include("scripts.items.passive.closecall")
--include("scripts.items.passive.TGS")
--include("scripts.items.passive.corona")
--include("scripts.items.trinkets.fixedmetabolism")
--include("scripts.items.pickup.burningheart")
--include("scripts.Challenges.sound_of_silence")
