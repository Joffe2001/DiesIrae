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
    LOW_COINS        = 5,  -- Cannot have more than 20 coins
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
            data.completed = true
            DavidGreedUtils.Complete(floor)
        else
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
        if data.damageTaken then return end
        if flags then
            if flags:HasBitFlag(DamageFlag.DAMAGE_SPIKES) then return end
            if flags:HasBitFlag(DamageFlag.DAMAGE_CURSED) then return end
        end

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

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_HIT_FLOOR)
        if data.damageTaken then
            DavidGreedUtils.Fail(player, floor)
        end
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

    OnNewRoom = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
        if not data then return end
        data.previousCoins = player:GetNumCoins()
    end,

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
        if not data then return end
        if data.coinsSpent > data.maxSpending then
            DavidGreedUtils.Fail(player, floor)
        end
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

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_SHOP)
        if data.shopVisits > data.maxVisits then
            DavidGreedUtils.Fail(player, floor)
        end
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
        
        local config = Isaac.GetItemConfig():GetCollectible(itemID)
        if not config then return end
        if config.MaxCharges == 0 then return end
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

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.NO_ACTIVES)
        if data.failed then return end
    end,
})

------------------------------------------------------------
-- NEVER HOLD MORE THAN 20 COINS AT ONCE
------------------------------------------------------------
DavidGreedUtils.Register(mod.GREED_CHALLENGES.LOW_COINS, {
    OnStart = function(floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)
        data.failed = false
    end,

    OnUpdate = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)
        if data.failed then return end

        if player:GetNumCoins() > 20 then
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnBossWavesComplete = function(player, floor)
    end,

    OnRender = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.LOW_COINS)
        local coins = player:GetNumCoins()

        local text, color
        if data.failed then
            text  = "Coins: FAILED (had 21+)"
            color = {1, 0.3, 0.3, 1}
        elseif coins >= 18 then
            text  = string.format("Coins: %d/20 [DANGER]", coins)
            color = {1, 0.8, 0.2, 1}
        else
            text  = string.format("Coins: %d/20", coins)
            color = {0.3, 1, 0.3, 1}
        end

        Isaac.RenderText(text, 80, 20, color[1], color[2], color[3], color[4])
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
        end

        local adjustedElapsed = elapsed - data.bonusTime

        -- Devil wave time check
        if game:GetRoom():IsClear() then
            if adjustedElapsed < data.timeLimit then
                data.completed = true
                DavidGreedUtils.Complete(floor)
            else
                data.failed = true
                DavidGreedUtils.Fail(player, floor)
            end
            return
        end

        if adjustedElapsed >= data.timeLimit then
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        end
    end,

    OnBossWavesComplete = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
        if data.failed or data.completed then return end
        DavidGreedUtils.SetBossWavesCompleted(floor)
    end,

    OnLevelSelect = function(player, floor)
        local data = DavidGreedUtils.GetData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
        if not data or data.failed or data.completed then return end

        local bossBeaten      = DavidGreedUtils.WereBossWavesCompleted(floor)
        local devilWaveStarted = DavidGreedUtils.GetDevilWaveElapsedFrames(floor) > 0

        if not bossBeaten then
        elseif not devilWaveStarted then
            -- Boss beaten but devil wave skipped is fail
            data.failed = true
            DavidGreedUtils.Fail(player, floor)
        else
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

    OnNewRoom = function(player, floor)
    end,
})