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
include("scripts/characters/david_challenges/david_challenges_utils")
include("scripts/characters/david_challenges/david_challenges")

if EID then
	include("scripts.modcompat.eidescs")
	include("scripts.modcompat.eid")
end

---------------------------------------------------
--  Characters
---------------------------------------------------
include("scripts.characters.david")
include("scripts.characters.elijah")
---------------------------------------------------
--  Active items
----------------------------------------------------
include("scripts.items.active.SlingShot")
include("scripts.items.active.armyOfLovers")
include("scripts.items.active.shBoom")
include("scripts.items.active.helterSkelter")
include("scripts.items.active.littleLies")
include("scripts.items.active.kingsHeart")
include("scripts.items.active.personalBegger")
---------------------------------------------------
--  Passive items
----------------------------------------------------
include("scripts.items.passive.u2")
include("scripts.items.passive.echo")
include("scripts.items.passive.theBadTouch")
include("scripts.items.passive.muse")
include("scripts.items.passive.ringOfFire")
include("scripts.items.passive.proteinPowder")
include("scripts.items.passive.goldenDay")
include("scripts.items.passive.universal")
include("scripts.items.passive.creatineOverdose")
include("scripts.items.passive.everybodyChanging")
include("scripts.items.passive.fiendDeal")
include("scripts.items.passive.PTSD")
include("scripts.items.passive.floweringSkull")
include("scripts.items.passive.harpString")
include("scripts.items.passive.Harp")
include("scripts.items.passive.michelinstar")
---------------------------------------------------
--  Familiars
----------------------------------------------------
include("scripts.items.familiars.paranoidAndroid")
include("scripts.items.familiars.killerQueen")
include("scripts.items.familiars.RedBum")
include("scripts.items.familiars.ScammerBum")
include("scripts.items.familiars.runeBum")
include("scripts.items.familiars.fairBum")
include("scripts.items.familiars.tarotBum")
include("scripts.items.familiars.pastorBum")
include("scripts.items.familiars.pillBum")
---------------------------------------------------
--  Pocket items
----------------------------------------------------
include("scripts.items.pocketitems.customPills")
include("scripts.items.pocketitems.DavidChord")
---------------------------------------------------
--  Trinkets
----------------------------------------------------
include("scripts.items.trinkets.wonderOfYou")
include("scripts.items.trinkets.gaga")
include("scripts.items.trinkets.babyBlue")
---------------------------------------------------
--  PIck-ups
----------------------------------------------------

---------------------------------------------------
--  Curses
----------------------------------------------------
---------------------------------------------------
--  Effects
----------------------------------------------------

----------------------------------------------------
--  Challenges
----------------------------------------------------
---------------------------------------------------
--  Transformations
----------------------------------------------------
include("scripts.transformations.isaacsinfulmusic")
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
include("scripts.items.familiars.gellocostumes")
include("scripts.modcompat.deadseascrolls")
include("scripts.modcompat.encyclopedia")
