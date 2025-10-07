local mod = DiesIraeMod

mod.EIDescs = {
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
		--Passive
		[mod.Items.U2] = {
			en_us = { "↑ +0.2 Damage#↑ +0.2 Tears#↑ +0.2 Speed#↑ +0.2 Range#↑ +0.2 Shot Speed"}
		},
		[mod.Items.Muse] = {
			en_us = { "On damage: 20% Tarot card, 10% Rune, 20% non-heart pickup, 1% random item from current pool."}
		},
		[mod.Items.TheBadTouch] = {
			en_us = { "Touching an enemy instantly kills normal enemies.#Bosses are poisoned on contact."}
		},
		[mod.Items.Universal] = {
			en_us = { "Hold fire to charge.#On release, absorb projectiles near Isaac.#At the end, spawn Crack the Sky beams for each projectile absorbed."}
		},
		[mod.Items.RingOfFire] = {
			en_us = { "Standing at the center of a room releases a burst of fire outward."}
		},
		[mod.Items.KillerQueen] = {
			en_us = { "Will be added"}
		},
		[mod.Items.MomsDress ] = {
			en_us = { "Spawns 2 Rotten Hearts on pickup#↑ 20% chance to gain Holy Mantle effect in uncleared rooms"}
		},
		[mod.Items.EnjoymentOfTheUnlucky] = {
			en_us = { "For each point of negative Luck, gain:#↑ +0.4 Damage#↑ -0.7 Fire Delay#↑ +0.1 Speed#↑ +0.2 Range#↑ +0.05 Shot Speed"}
		},
		[mod.Items.EverybodysChanging] = {
			en_us = { "After clearing a room, all passive/familiar items are replaced with random ones."}
		},
		[mod.Items.Echo] = {
            en_us = { "{{Planetarium}} Adds +25% Planetarium chance, +10% on Womb and onward."}
        },
        [mod.Items.Engel] = {
            en_us = { "↑ +5 Luck#Grants spectral + homing tears#Disables flight"}
        },
        [mod.Items.ScaredShoes] = {
            en_us = { "↑ Sets speed to 2.0 when no enemies are alive#Spawns random small pee creep during combat"}
        },
        [mod.Items.DevilsLuck] = {
            en_us = { "↓ -6 Luck instantly#50% chance for pickups (coins, keys, bombs, hearts) to vanish#↑ Permanent damage up per vanished pickup"}
        },
        [mod.Items.HereToStay] = {
            en_us = { "Standing still spawns creep in growing steps.#Each tick the puddle gets bigger."}
        },
        [mod.Items.SkullCrasher] = {
            en_us = { "Allows you to damage skull-based enemies (Hosts, Hard Hosts, Mobile Hosts, and Floasts) even when invulnerable."}
        },
        [mod.Items.ProteinPowder] = {
            en_us = { "↑ Gain +1 Damage on first pickup, +2 on second, up to +4.#Further pickups always grant +1 damage."}
        },
        [mod.Items.Hysteria] = {
            en_us = { "When taking damage twice in a room, Isaac gains double damage for the rest of the room."}
        },
        [mod.Items.StabWound] = {
            en_us = { "↑ +1 Damage#↑ +0.5 Tears"}
        },
        [mod.Items.ThoughtContagion] = {
            en_us = { "Enemies mirror damage they take to other nearby enemies.#Only pure damage is shared."}
        },
        [mod.Items.DadsDumbbell] = {
            en_us = { "Each tear has a 10% chance to deal +2 damage"}
        },
        [mod.Items.GoldenDay] = {
            en_us = { "Spawns a random golden pickup.#{{SecretRoom}} Each floor, has a 50% chance to spawn one of them in the Secret Room."}
        },
        [mod.Items.Mutter] = {
            en_us = { "↑ +0.3 Speed up#↑ Stats up for each Mom item:# +0.5 Damage, -0.3 Tears Delay, +1 Luck, +0.05 Speed#↑ Increased chance to find Mom's items, Dr. Fetus and C-Section"}
        },
        [mod.Items.SolarFlare] = {
            en_us = { "Tears start slow#After ~0.2s they dash toward the nearest enemy#Leave a short fire trail while dashing#Burn enemies on hit"}
        },
        [mod.Items.EyeSacrifice] = {
            en_us = { "Shoot only from Isaac's right eye.#Upon entering the Devil Deal room, receive a free Devil Deal."}
        },
        [mod.Items.MonstersUnderTheBed] = {
            en_us = { "↑ Fire rate increases for each enemy in the room#Bonus decreases as enemies are defeated#Resets when room is cleared"}
        },
        [mod.Items.TravelerLogbook] = {
            en_us = { "Exploring a new room grants +0.1 to a random stat (Damage, Speed, Tears, or Range) for the floor.#Entering an I AM ERROR room resets floor boosts and gives +0.2 to a random stat permanently."}
        },
        [mod.Items.UltraSecretMap] = {
            en_us = { "Reveals the Ultra Secret Room on the map.#Drops a Cracked Key in the Secret Room."}
        },
        [mod.Items.RedCompass] = {
            en_us = { "Upon clearing a room, has a chance to open a nearby red room."}
        },
        [mod.Items.LastResort] = {
            en_us = { "When at half a heart, clearing a hostile room grants a permanent stat boost:#↑ +0.3 Damage OR ↑ +0.1 Speed OR ↑ Tears (random)"}
        },
        [mod.Items.SlaughterToPrevail] = {
            en_us = { "On enemy kill, 50% chance to increase Isaac's damage by +0.01. (Max 10 kills per room)"}
        },
        [mod.Items.CreatineOverdose] = {
            en_us = { "↑ +0.2 Damage#↑ All bonus damage is amplified by 20%."}
        },
        [mod.Items.FragileEgo] = {
            en_us = { "↑ Clearing a room grants a random minor stat boost (stacks)#↓ Taking damage removes all boosts #↓ Taking damage may cause a broken heart"}
        },
        [mod.Items.TouristMap] = {
            en_us = { "Adds a shop to every floor starting from Womb/Corpse (Stage 4 and above)"}
        },
        [mod.Items.BeggarsTear] = {
            en_us = { "Tears can collect pickups.#Consumables (coins, keys, bombs, hearts, batteries, golden variants, rotten hearts, etc.) are auto-collected when touched.#Other pickups (cards, trinkets, chests) are pulled toward Isaac."}
        },
        [mod.Items.BackInAnger] = {
            en_us = { "Isaac shoots from behind # +4 damage up"}
        },
        [mod.Items.BossCompass] = {
            en_us = { "Spawn the boss room near the starting room on the next floor."}
        },
        [mod.Items.BuriedTreasureMap] = {
            en_us = { "After defeating a boss, a crawl space appears in the next room you enter."}
        },
        [mod.Items.GooglyEyes] = {
            en_us = { "Isaac's tears randomly gain 1-3 chaotic tear variants simultaneously, mixing elemental and special effects."}
        },
        [mod.Items.Masochism] = {
            en_us = { "Taking damage grants a random small permanent stat boost"}
        },
        [mod.Items.Unsainted] = {
            en_us = { "All item pools are {{DevilRoom}} Devil Pool.#All collectibles cost {{Heart}} {{Heart}} 2 Red Heart Containers."}
        },
        [mod.Items.BigKahunaBurger] = {
            en_us = { "Gives either 1,2,3 full Red Heart Containers when picked up."}
        },
        [mod.Items.DadsEmptyWallet] = {
            en_us = { "↑ +1 Tears if you have no coins#↓-0.02 Tears bonus per coin"}
        },
		[mod.Items.FriendlessChild] = {
            en_us = { "Removes all familiars#Familiar items give stat boosts instead, based on quality:#Q0: +0.25 Speed#Q1: +0.5 Damage#Q2: +1 Damage, +0.5 Tears#Q3: +1.5 Damage, +1 Range#Q4: +2 Damage, +0.7 Tears"}
        },

		--Familiars
		[mod.Items.ParanoidAndroid] = {
            en_us = { "#Enemies touching the ring take damage every few frames"}
        },

		--Active
		[mod.Items.AnotherMedium] = { 
			en_us = { "Once per floor, swaps one random passive or familiar with a completely random one from any item pool"}
		},
		[mod.Items.ArmyOfLovers] = {
			en_us = {"Spawns 2 Mini Isaacs"}
		},
		[mod.Items.BigShot] = {
			en_us = {"Fires a massive, slow, piercing tear that destroys rocks and opens secret room doors. Explodes on wall impact","4s cooldown"}
		},
        [mod.Items.GuppysSoul] = {
            en_us = {"Grant Guppy transformation for the room"}
        },
    
        [mod.Items.ShBoom] = {
            en_us = {"Triggers a full-room Mama Mega explosion#Only once per floor#Isaac gains 1 broken heart as a cost"}
        },
    
        [mod.Items.HypaHypa] = {
            en_us = {"10% chance to spawn a quality 4 item #90% chance to spawn The Poop #Single-use item"}
        },
    
        [mod.Items.HelterSkelter] = {
            en_us = {"25% chance to turn each enemy into a friendly Bony"}
        },
    
        [mod.Items.HolyWood] = {
            en_us = {"Grants Holy Mantle for the current room"}
        },
    
        [mod.Items.DiaryOfAMadman] = {
            en_us = {"Randomly changes all stats for the current room"}
        },
    
        [mod.Items.ComaWhite] = {
            en_us = {"Grants 1 Eternal Heart#Removes boss item reward this floor"}
        },
    
        [mod.Items.GoodVibes] = {
            en_us = {"Transforms all red heart pickups in the room into soul hearts. Half red → half soul, double red → two soul hearts."}
        },

        [mod.Items.DevilsHeart] = {
            en_us = {"50%: Gain +1 Red Heart Container#50%: Gain +1 Broken Heart #On use: All item pedestals on this floor cost Hearts"}
        },
    
        [mod.Items.MomsDiary] = {
            en_us = {"Spawns a random pedestal item.#Charges only when Isaac takes damage."}
        },
    
        [mod.Items.LittleLies] = {
            en_us = {"Shrinks Isaac and grants +2 Tears for the current room"}
        },
    
        [mod.Items.SatansRemoteShop] = {
            en_us = {"Sacrifice one heart container or three soul hearts#Receive a random devil item pedestal#Can be used once per floor"}
        },
    
	},
	Trinket = {
		EIDadd = function(...) EID:addTrinket(...) end,

		[mod.Trinkets.BabyBlue] = {
			en_us = {"All red heart drops become Soul Hearts", "Golden: 5% of them become Black Hearts"}
		},
	},
	Card = {
		EIDadd = function(...) EID:addCard(...) end,

	},
	Pill = {
		EIDadd = function(...) EID:addPill(...) end,

		[mod.Pills.CURSED] = {
			en_us = {"Applies a random curse"}
		},
	}
}
