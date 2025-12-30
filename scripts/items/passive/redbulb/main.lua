local mod = DiesIraeMod

--[[ DATA ]]--
local data = require("scripts.items.passive.redbulb.data")
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, data.functions.checkForRedBulb)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, data.functions.checkForRedBulb)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, data.functions.getCustomRoomData)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, data.functions.getCustomBackdropData)

local dataHolder = require("scripts.items.passive.redbulb.dataHolder")
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, dataHolder.GetEntityData_demonicAngel)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, dataHolder.GetEntityData_blockAngel)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, dataHolder.ClearDataOfEntity)

--[[ RED BULB ]]--
local room = require("scripts.items.passive.redbulb.room")
mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, room.swapRoomlayoutPools)
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, room.swapItemRoomPools)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, room.spawnKeyPieces, EntityType.ENTITY_URIEL)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, room.spawnKeyPieces, EntityType.ENTITY_GABRIEL)

local items = require("scripts.items.passive.redbulb.items")
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, items.demonicAngelNoRedHearts)
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, items.demonicAngelBrokenHearts)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, items.renderBrokenHeartsSprite)
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, items.blockDemonicAngel)

local unlock = require("scripts.items.passive.redbulb.unlock")
mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, unlock.isUnlocked) -- GetPersistentGameData() shall not be called outside of Callbacks
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, unlock.resetOnNewRun)
mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, unlock.checkRooms_unlock)

local sprites = require("scripts.items.passive.redbulb.sprites")
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, sprites.checkRoom)
mod:AddCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, sprites.changeBackdrop)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, sprites.changeDoorsInside)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, sprites.changeStatues)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, sprites.changeAngelBoss, EntityType.ENTITY_URIEL)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, sprites.changeAngelBoss, EntityType.ENTITY_GABRIEL)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, sprites.changeDoorsPostBoss)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, sprites.changeDoorsOutside)

--[[ SYNERGIES ]]--
local stairway = require("scripts.items.passive.redbulb.stairway")
mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, stairway.givePound)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, stairway.givePoundOnInit) -- AddInnateCollectible does not work after reentering run

local sanguine = require("scripts.items.passive.redbulb.sanguine")
mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, sanguine.blockSanguineBond)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, sanguine.checkForSanguine)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, sanguine.checkForSanguine)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, sanguine.spawnConfessional)
