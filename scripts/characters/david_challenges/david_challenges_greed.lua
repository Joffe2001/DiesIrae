local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidGreedUtils = include("scripts/characters/david_challenges/david_challenges_utils_greed")
local DavidChord = include("scripts/items/pocketitems/DavidChord")

------------------------------------------------------------
-- GREED CHALLENGE DEFINITIONS
------------------------------------------------------------
mod.GREED_CHALLENGES = {
    FAST_WAVES       = 0,  -- Beat boss waves under 1 minute
    NO_HIT_FLOOR     = 1,  -- Complete full floor without damage
    LIMITED_SPENDING = 2,  -- Don't spend more than 15 pennies
    NO_SHOP          = 3,  -- Can visit shop only once
    NO_ACTIVES       = 4,  -- Don't use actives/consumables
    LOW_COINS        = 5,  -- First floor: end with 3 coins or less
    FAST_DEVIL_WAVE  = 6,  -- Beat devil wave in under 45 seconds
}

------------------------------------------------------------
-- Get David's Chord data
------------------------------------------------------------
local function GetChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save or not save.DavidGreedChordData then return nil end
    
    local key = "floor_" .. tostring(floor)
    return save.DavidGreedChordData[key]
end

------------------------------------------------------------
-- BEAT BOSS WAVES UNDER 1 MINUTE
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.FAST_WAVES, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
        data.timeLimit = 60 * 30  
        data.bonusTime = 0  -- David's Chord can add bonus time
        data.failed = false
        data.completed = false
    end,

    OnUpdate = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
        
        if data.failed or data.completed then return end

        local elapsed = DavidGreedUtils.GetBossWaveElapsedFrames(floor)
        if elapsed == 0 then return end
        
        -- Apply bonus time from David's Chord
        local adjustedElapsed = elapsed - data.bonusTime
        
        -- Fail if time exceeded
        if adjustedElapsed >= data.timeLimit then
            Isaac.DebugString("[Challenge 0] Time limit exceeded!")
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
        
        if data.failed or data.completed then return end
        
        DavidGreedUtils.SetBossWavesCompleted(floor)
        
        local elapsed = DavidGreedUtils.GetBossWaveElapsedFrames(floor)
        local adjustedElapsed = elapsed - data.bonusTime
        
        if adjustedElapsed < data.timeLimit then
            Isaac.DebugString(string.format("COMPLETE - %.1fs", adjustedElapsed / 30))
            data.completed = true
            DavidGreedUtils.Complete(floor)
        else
            Isaac.DebugString("Too slow!")
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_WAVES)

        local firstBoss = DavidGreedUtils.GetFirstBossWave()
        
        local elapsed = DavidGreedUtils.GetBossWaveElapsedFrames(floor)
        
        if elapsed == 0 then
            Isaac.RenderText(
                string.format("Fast Boss (< 1m)", firstBoss),
                80, 20, 1, 1, 1, 1
            )
        elseif data.failed or data.completed then
            return
        else
            -- Show remaining time
            local adjustedElapsed = elapsed - data.bonusTime
            local remaining = math.max(0, data.timeLimit - adjustedElapsed)
            local seconds = remaining / 30
            local color = remaining < 300 and {1, 0.3, 0.3, 1} or {1, 1, 1, 1}
            
            Isaac.RenderText(
                string.format("Boss: %.1fs left", seconds),
                80, 20, color[1], color[2], color[3], color[4]
            )
        end
    end,
})

------------------------------------------------------------
-- COMPLETE FULL FLOOR WITHOUT DAMAGE
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.NO_HIT_FLOOR, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_HIT_FLOOR)
        data.damageTaken = false
    end,

    OnPlayerDamage = function(player, floor, amount, flags, source)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_HIT_FLOOR)
        
        local chordData = GetChordData(floor)
        if chordData and chordData.mantleActive then
            return
        end
        
        data.damageTaken = true
        DavidGreedUtils.Fail(player, floor)
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_HIT_FLOOR)
        
        local statusText = data.damageTaken and "DAMAGED!" or "No Damage"
        local color = data.damageTaken and {1, 0.3, 0.3, 1} or {0.3, 1, 0.3, 1}
        
        local chordData = GetChordData(floor)
        local mantleText = (chordData and chordData.mantleActive) and " [MANTLE]" or ""
        
        Isaac.RenderText(
            string.format("Floor: %s%s", statusText, mantleText),
            80, 20, color[1], color[2], color[3], color[4]
        )
    end,
})

------------------------------------------------------------
-- DON'T SPEND MORE THAN 15 PENNIES
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.LIMITED_SPENDING, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
        data.maxSpending = 15
        data.previousCoins = Isaac.GetPlayer(0):GetNumCoins()
        data.coinsSpent = 0
    end,

    OnUpdate = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
        if not data then return end
        
        local currentCoins = player:GetNumCoins()
        
        -- Track spending
        if currentCoins < data.previousCoins then
            local spent = data.previousCoins - currentCoins
            data.coinsSpent = data.coinsSpent + spent
        end
        
        data.previousCoins = currentCoins
        
        -- Fail if overspent
        if data.coinsSpent > data.maxSpending then
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
        if not data then return end
        
        local color = data.coinsSpent <= data.maxSpending and {0.3, 1, 0.3, 1} or {1, 0.3, 0.3, 1}
        
        local chordData = GetChordData(floor)
        local freeText = (chordData and chordData.nextShopItemFree) and " [FREE]" or ""
        
        Isaac.RenderText(
            string.format("Spent: %d/%d%s", data.coinsSpent, data.maxSpending, freeText),
            80, 20, color[1], color[2], color[3], color[4]
        )
    end,
})

------------------------------------------------------------
-- CAN VISIT SHOP ONLY ONCE
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.NO_SHOP, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_SHOP)
        data.shopVisits = 0
        data.maxVisits = 1
    end,

    OnNewRoom = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_SHOP)
        local room = game:GetRoom()
        
        if room:GetType() == RoomType.ROOM_SHOP then
            data.shopVisits = data.shopVisits + 1
            
            if data.shopVisits > data.maxVisits then
                DavidGreedUtils.Fail(player, floor)
            end
        end
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_SHOP)
        
        local statusText, color
        if data.shopVisits == 0 then
            statusText = "Can Visit Shop Once"
            color = {0.3, 1, 0.3, 1}
        elseif data.shopVisits == 1 then
            statusText = "Used 1/1 - Don't Visit Again!"
            color = {1, 1, 0.3, 1}
        else
            statusText = "VISITED MULTIPLE TIMES!"
            color = {1, 0.3, 0.3, 1}
        end
        
        Isaac.RenderText(
            string.format("%s", statusText),
            80, 20, color[1], color[2], color[3], color[4]
        )
    end,
})

------------------------------------------------------------
-- DON'T USE ACTIVES OR CONSUMABLES
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.NO_ACTIVES, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_ACTIVES)
        data.failed = false
    end,

    OnUseItem = function(player, floor, itemID)
        -- Check if David's Chord allows one-time use
        local chordData = GetChordData(floor)
        if chordData and chordData.activeUseAllowed then
            chordData.activeUseAllowed = false
            return
        end
        
        DavidGreedUtils.Fail(player, floor)
    end,

    OnUseCard = function(player, floor, cardID)
        -- Allow David's Chord itself
        if cardID == mod.Cards.DavidChord then return end
        
        DavidGreedUtils.Fail(player, floor)
    end,

    OnUsePill = function(player, floor, pillEffect)
        DavidGreedUtils.Fail(player, floor)
    end,

    OnRender = function(player, floor)
        
        local text = "No Actives/Consumables!"
        local chordData = GetChordData(floor)
        if chordData and chordData.activeUseAllowed then
            text = text .. " [1 USE]"
        end
        
        Isaac.RenderText(
            string.format("%s", text),
            80, 20, 1, 1, 0.3, 1
        )
    end,
})

------------------------------------------------------------
-- FIRST FLOOR - END WITH 3 COINS OR LESS
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.LOW_COINS, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)
        data.isFirstFloor = (floor == 1)
    end,

    OnLevelSelect = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)
        
        -- Only applies to first floor
        if not data.isFirstFloor then return end
        
        local coins = player:GetNumCoins()
        
        if coins > 3 then
            DavidGreedUtils.Fail(player, floor)
        else
            DavidGreedUtils.Complete(floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)

        
        if not data.isFirstFloor then
            Isaac.RenderText(
                string.format("Low Coins"),
                80, 20, 0.5, 0.5, 0.5, 1
            )
            return
        end
        
        local coins = player:GetNumCoins()
        local statusText = coins <= 3 and "PASS" or "FAIL"
        local color = coins <= 3 and {0.3, 1, 0.3, 1} or {1, 0.3, 0.3, 1}
        
        Isaac.RenderText(
            string.format("F1: Coins %d (≤3) [%s]", coins, statusText),
            80, 20, color[1], color[2], color[3], color[4]
        )
    end,
})

------------------------------------------------------------
-- BEAT DEVIL WAVE IN UNDER 45 SECONDS
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.FAST_DEVIL_WAVE, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
        data.timeLimit = 45 * 30  -- 45 seconds
        data.bonusTime = 0  -- David's Chord can add bonus time
        data.failed = false
        data.completed = false
    end,

    OnUpdate = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
        
        if data.failed or data.completed then return end
        if not DavidGreedUtils.IsDevilWave() then return end
        
        local elapsed = DavidGreedUtils.GetDevilWaveElapsedFrames(floor)
        if elapsed == 0 then return end 
        
        if elapsed % 30 == 0 then
            Isaac.DebugString(string.format("[Challenge 6] Devil wave timer: %.1fs", elapsed / 30))
        end
        -- Apply bonus time from David's Chord
        local adjustedElapsed = elapsed - data.bonusTime
        
        if adjustedElapsed >= data.timeLimit then
            Isaac.DebugString("[Challenge 6] Time limit exceeded!")
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
        
        if data.failed or data.completed then return end
        
        DavidGreedUtils.SetBossWavesCompleted(floor)
        
        local elapsed = DavidGreedUtils.GetDevilWaveElapsedFrames(floor)
        local adjustedElapsed = elapsed - data.bonusTime
        
        if adjustedElapsed < data.timeLimit then
            Isaac.DebugString(string.format("[Challenge 6] COMPLETE - %.1fs", adjustedElapsed / 30))
            data.completed = true
            DavidGreedUtils.Complete(floor)
        else
            Isaac.DebugString("[Challenge 6] Too slow!")
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)

        local devilWave = DavidGreedUtils.GetDevilWave()
        
        local elapsed = DavidGreedUtils.GetDevilWaveElapsedFrames(floor)
        
        if elapsed == 0 then
            Isaac.RenderText(
                string.format("Fast Devil (< 45s) ", devilWave),
                80, 20, 1, 1, 1, 1
            )
        elseif data.failed or data.completed then
            return
        else
            local adjustedElapsed = elapsed - data.bonusTime
            local remaining = math.max(0, data.timeLimit - adjustedElapsed)
            local seconds = remaining / 30
            local color = remaining < 300 and {1, 0.3, 0.3, 1} or {1, 1, 1, 1}
            
            Isaac.RenderText(
                string.format("Devil: %.1fs left", seconds),
                80, 20, color[1], color[2], color[3], color[4]
            )
        end
    end,
})