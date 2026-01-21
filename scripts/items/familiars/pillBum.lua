local mod = DiesIraeMod
local bumUtils = require("scripts.items.familiars.bumUtils")
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
	data.pillEffectSubClass = 0 --[[0 = neutral, 1 = positive, 2 = negative]]
	data.statChanges = {}
	data.statChanges.speed = 0
	data.statChanges.fireRate = 0
	data.statChanges.damage = 0
	data.statChanges.range = 0
	data.statChanges.shotSpeed = 0
	data.statChanges.luck = 0
end

function pillBum.OnUpdate(fam)
	local player = fam.Player
	local data = fam:GetData()
	local sprite = fam:GetSprite()
	
	if not player then
		return 
	end

	-- Handle anm2 switching for bad pills
	if data.pillEffectSubClass == 2 and not data.RewardActive and not data.BadPillAnm2Loaded then
		data.BadPillAnm2Loaded = true
		sprite:Load("gfx/familiar/pillbump.anm2", true)
		sprite:Play("IdleDown", true)
	end

	if data.BadPillAnm2Loaded and not data.RewardActive and data.pillEffectSubClass ~= 2 then
		data.BadPillAnm2Loaded = nil
		sprite:Load("gfx/familiar/pillbum.anm2", true)
		sprite:Play("IdleDown", true)
	end

	-- Custom following behavior when player is idle
	if player.Velocity:LengthSquared() < 0.1 then
		local distance = fam.Position:Distance(player.Position)

		if distance < pillBum.FollowDistance then
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
		return false 
	end
	if pickup.Variant ~= PickupVariant.PICKUP_PILL then
		return false 
	end

	local itemPool = Game():GetItemPool()
	local pillEffect = itemPool:GetPillEffect(pickup.SubType, fam.Player)
	local itemConfig_pillEffect = Isaac.GetItemConfig():GetPillEffect(pillEffect)

	data.pillEffectSubClass = itemConfig_pillEffect.EffectSubClass
	print("Pill SubClass: " .. data.pillEffectSubClass)
	sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.0, 0, false, 1.0)
	
	return rng:RandomFloat() < DROP_CHANCE
end

function pillBum.DoReward(fam)
	print("DoReward called")
	local data = fam:GetData()
	local rng = fam:GetDropRNG()

	print("SubClass in DoReward: " .. tostring(data.pillEffectSubClass))
	
	if data.pillEffectSubClass == 0 then --[[if neutral: activate a random pill effect]]
		local pillEffectAmount = Isaac.GetItemConfig():GetPillEffects().Size
		local randomPillEffect = rng:RandomInt(pillEffectAmount)

		fam.Player:UsePill(randomPillEffect, 0)

	elseif data.pillEffectSubClass == 1 then --[[if good: random minor stat up]]
		local randomNumber = rng:RandomInt(6)
		local cacheToAdd

		if randomNumber == 0 then
			data.statChanges.speed = data.statChanges.speed + 0.1
			cacheToAdd = CacheFlag.CACHE_SPEED
		elseif randomNumber == 1 then
			data.statChanges.fireRate = data.statChanges.fireRate + 0.1
			cacheToAdd = CacheFlag.CACHE_FIREDELAY
		elseif randomNumber == 2 then
			data.statChanges.damage = data.statChanges.damage + 0.1
			cacheToAdd = CacheFlag.CACHE_DAMAGE
		elseif randomNumber == 3 then
			data.statChanges.range = data.statChanges.range + 0.1
			cacheToAdd = CacheFlag.CACHE_RANGE
		elseif randomNumber == 4 then
			data.statChanges.shotSpeed = data.statChanges.shotSpeed + 0.1
			cacheToAdd = CacheFlag.CACHE_SHOTSPEED
		elseif randomNumber == 5 then
			data.statChanges.luck = data.statChanges.luck + 0.1
			cacheToAdd = CacheFlag.CACHE_LUCK
		end
		
		-- Add only the specific cache flag and evaluate
		fam.Player:AddCacheFlags(cacheToAdd)
		fam.Player:EvaluateItems()
		
		fam.Player:PlayExtraAnimation("Happy")

	elseif data.pillEffectSubClass == 2 then --[[if bad: poison all enemies in room]]
		local entities = Isaac.GetRoomEntities()

		for i, entity in ipairs(entities) do
			if entity:IsVulnerableEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				entity:AddPoison(EntityRef(fam.Player), 90, 1)
			end 
		end
		sfx:Play(SoundEffect.SOUND_POOP_LASER, 1.0)
	end
end

function pillBum.EvaluateCache(player, cacheFlag)
	-- Find the familiar's data
	local familiar = nil
	for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, PILL_BUM)) do
		local famObj = fam:ToFamiliar()
		if famObj and famObj.Player then
			-- Compare player indices instead of using GetPtrHash
			if famObj.Player.Index == player.Index and 
			   famObj.Player.Variant == player.Variant and
			   famObj.Player.SubType == player.SubType then
				familiar = famObj
				break
			end
		end
	end
	
	if not familiar then return end
	local data = familiar:GetData()

	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + data.statChanges.speed
	elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
		local tearsPerSecond = 30 / (player.MaxFireDelay + 1)
		tearsPerSecond = tearsPerSecond + data.statChanges.fireRate
		player.MaxFireDelay = (30 / tearsPerSecond) - 1	
	elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + data.statChanges.damage
	elseif cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + data.statChanges.range
	elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + data.statChanges.shotSpeed
	elseif cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + data.statChanges.luck
	end
	
	print("Cache evaluated - " .. cacheFlag .. " - Value: " .. tostring(data.statChanges.speed or 0))
end

bumUtils.RegisterBum(PILL_BUM, pillBum)

return pillBum