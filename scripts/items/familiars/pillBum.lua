local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()

local PILL_BUM = mod.Entities.FAMILIAR_PillBum.Var
local DROP_CHANCE = 1


---@class PillBum
local pillBum = {}
pillBum.Item = mod.Items.PillBum

pillBum.Accepts = {
	[PickupVariant.PICKUP_PILL] = true
}

pillBum.FollowDistance = 40
pillBum.ReachDistance = 20

function pillBum.OnInit(fam)
	local data = fam:GetData()
	local data.pillEffectSubClass = 0 --[[0 = neutral, 1 = positive, 2 = negative]]
	local data.statChanges = {}
	local data.statChanges.speed = 0
	local data.statChanges.fireRate = 0
	local data.statChanges.damage = 0
	local data.statChanges.range = 0
	local data.statChanges.shotSpeed = 0
	local data.statChanges.luck = 0
end

function pillBum.OnUpdate(fam)
	local player = fam.Player
	if not player then
		return end

	if player.Velocity:LengthSquared() < 0.1 then
		local distance = fam.Position:Distance(player.Position)

		if distance < pillBum.FollowDisctance then
			local push = (fam.Position - player.Position):Normalized() * 0.4
			fam.Velocity = fam.Velocity + push
		end
	end
end

function pillBum.Reward(fam)
	local data = fam:GetData()
	local rng = fam:GetDropRNG()
	local pickup = data.TargetPickup

	if not pickup then 
		return false end
	if pickup.Variant ~= PickupVariant.PICKUP_PILL then
		return false end

	local itemPool = Game():GetItemPool()
	local pillEffect = itemPool:GetPIllEffect(pickup.Subtype, fam.Player)

	data.pillEffectSubClass = pillEffect.EffectSubClass
	sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.0, 0, false, 1.0) --change sound effect?	
	return true --100% drop chance
end

function pillBum.DoReward(fam)
	local data = fam.GetData()
	local rng = fam.GetDropRNG()


	if data.pillEffectSubClass == 0 then --[[if neutral: activate a random pill effect]]
		local pillEffectAmount = Isaac.GetItemconfig():GetPillEffects().Size
		local randomPillEffect = rng:RandomInt(pillEffectAmount)

		fam.Player:UsePill(randomPillEffect, 0 --[[pill color; has nothing to do with effect but needs to be passed]])

	elseif data.pillEffectSubClass == 1 then --[[if good: random, minor stat up]]

		--https://isaacblueprints.com/tutorials/basics/stats_cache/

		local randomNumber = rng:RandomInt(6)
		local doEvaluateItems = true

		if randomNumber == 0 then
			data.statChanges.speed = data.statChanges.speed + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_SPEED, doEvaluateItems)
		elseif randomNumber == 1 then
			data.statChanges.fireRate = data.statChanges.fireRate + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, doEvaluateItems)
		elseif randomNumber == 2 then
			data.statChanges.damage = data.statChanges.damage + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, doEvaluateItems)
		elseif randomNumber == 3 then
			data.statChanges.range = data.statChanges.range + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_RANGE, doEvaluateItems)
		elseif randomNumber == 4 then
			data.statChanges.shotSpeed = data.statChanges.shotSpeed + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED, doEvaluateItems)
		elseif randomNumber == 5 then
			data.statChanges.luck = data.statChanges.luck + 0.1
			fam.Player:AddCacheFlags(CacheFlag.CACHE_LUCK, doEvaluateItems)
		end
		

	elseif data.pillEffectSubClass == 2 then --[[if bad: poison all enemies in room]]
		local entities = Isaa.GetRoomEntities()

		for i, entity in ipairs(entities) do
			if entity:IsVulnerableEnemy() then
				entity:AddPoison(fam, 90 --[[5 damage ticks]], 1 --[[damage]])
		end end
	end


	sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1.0, 0, false, 1.0) --change sound effect?
	data.pillEffectSubClass = nil
end


function pillBum.EvaluateCache(player, cacheFlag)
	--check for right player...
	if not player:HasCollectible(mod.Items.PillBum) then
	return end

	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + "data.statChanges.speed"
	elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
		local tearsPerSecond = 30 / (player.MayFireDelay + 1)
		tearsPerSecond = tearsPerSecond + "data.statChanges.fireRate"
		player.MaxFireDelay = (30 / tearsPerSecond) - 1	
	elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + "data.statChanges.damage" --flat damage up
	elseif cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + "data.statChanges.range"
	elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + "data.statChanges.shotSpeed"
	elseif cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + "data.statChanges.luck"
	end
end

bumUtils.Register(PILL_BUM, pillBum)

return pillBum
