local mod = DiesIraeMod

mod.EIDescs = {
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
		--Passive
		[mod.Items.U2] = {
			en_us = { 
                "↑ +0.2 {{Damage}}Damage",
                "↑ +0.2 {{Tears}}Tears",
                "↑ +0.2 {{Speed}}Speed",
                "↑ +0.2 {{Range}}Range",
                "↑ +0.2 {{Shotspeed}}Shot Speed"
            }
		},
		[mod.Items.Muse] = {
			en_us = { 
                "On hit has a chance to spawn a pickup from below:",
                "20% {{Card}}Tarot card",
                "10% {{Rune}}Rune",
                "20% non-heart pickup",
                "1% random item from current pool"
            }
		},
		[mod.Items.TheBadTouch] = {
			en_us = { 
                "Instantly kills non-boss enemies on contact",
                "Bosses are poisoned on contact"
            }
		},
		[mod.Items.Universal] = {
			en_us = { 
                "{{Chargeable}}Hold and release fire button to absorb projectiles near Isaac",
                "After absorbing {{Collectible160}}Crack the Sky beams will spawn for each projectile"
            }
		},
		[mod.Items.RingOfFire] = {
			en_us = { 
                "Standing in the room center releases a burst of fire outward"
            }
		},
		[mod.Items.KillerQueen] = {
			en_us = { 
                "Shoots rockets at enemies similar to {{Collectible168}}Epic Fetus"
            }
		},
		[mod.Items.MomsDress ] = {
			en_us = { 
                "Spawns 2 {{RottenHeart}}Rotten Hearts on pickup",
                "20% chance to gain {{Collectible313}}Holy Mantle effect in uncleared rooms"
            }
		},
		[mod.Items.EnjoymentOfTheUnlucky] = {
			en_us = { 
                "For each point of negative {{Luck}}Luck, gain:",
                "↑ +0.4 {{Damage}}Damage",
                "↑ -0.7 {{Tears}}Fire Delay",
                "↑ +0.1 {{Speed}}Speed",
                "↑ +0.2 {{Range}}Range",
                "↑ +0.05 {{Shotspeed}}Shot Speed"
            }
		},
		[mod.Items.EverybodysChanging] = {
			en_us = { 
                "All passive/familiar items are randomized on room clear"
            }
		},
		[mod.Items.Echo] = {
            en_us = { 
                "↑ +25% {{Planetarium}}Planetarium chance, +10% on Womb and onward"
            }
        },
        [mod.Items.Engel] = {
            en_us = { 
                "↑ +5 {{Luck}}Luck",
                "Grants spectral and homing tears",
                "Disables {{Seraphim}}Flight"
            }
        },
        [mod.Items.ScaredShoes] = {
            en_us = { 
                "↑ Sets speed to 2 when no enemies are alive",
                "Spawns random small pee creep during combat"
            }
        },
        [mod.Items.DevilsLuck] = {
            en_us = { 
                "↓ -6 {{Luck}}Luck",
                "50% chance for pickups to vanish",
                "↑ +0.05 {{Damage}}Damage per vanished pickup"
            }
        },
        [mod.Items.HereToStay] = {
            en_us = {  
                "Standing still spawns creep in growing steps",
                "The puddle gets bigger each frame"
            }
        },
        [mod.Items.SkullCrasher] = {
            en_us = { 
                "Allows you to damage skull-based enemies (Hosts, Hard Hosts, etc.) when invulnerable"
            }
        },
        [mod.Items.ProteinPowder] = {
            en_us = { 
                "↑ +1 {{Damage}}Damage on first pickup, +2 on second, up to +4",
                "Further pickups always grant +1 {{Damage}}Damage"
            }
        },
        [mod.Items.Hysteria] = {
            en_us = { 
                "Taking damage twice in a room doubles the damage for the room"
            }
        },
        [mod.Items.StabWound] = {
            en_us = { 
                "↑ +1 {{Damage}}Damage",
                "↑ +0.5 {{Tears}}Tears"
            }
        },
        [mod.Items.ThoughtContagion] = {
            en_us = { 
                "Enemies mirror damage they take to other nearby enemies",
                "Only pure damage is shared"
            }
        },
        [mod.Items.DadsDumbbell] = {
            en_us = { 
                "Each tear has a 10% chance to deal +2 Damage"
            }
        },
        [mod.Items.GoldenDay] = {
            en_us = { 
                "Spawns a random golden pickup",
                "{{SecretRoom}} On each floor has a 50% chance to spawn golden pickup in the Secret Room"
            }
        },
        [mod.Items.Mutter] = {
            en_us = { 
                "↑ +0.3 {{Speed}}Speed",
                "↑ Increased chance to find {{Mom}}Mom's items, Dr. Fetus and C-Section",
                "Stats up for each Mom item:",
                "↑ +0.5 {{Damage}}Damage",
                "↑ -0.3 {{Tears}}Tear Delay",
                "↑ +1 {{Luck}}Luck",
                "↑ +0.05 {{Speed}}Speed",
            }
        },
        [mod.Items.SolarFlare] = {
            en_us = { 
                "Tears start slow",
                "After 0.2 seconds they dash towards the nearest enemy, leaving a short fire trail",
                "{{Burning}}Tears burn enemies on hit"
            }
        },
        [mod.Items.EyeSacrifice] = {
            en_us = { 
                "Shoot only from Isaac's right eye",
                "Upon entering the Devil Deal room, receive a free Devil Deal"
            }
        },
        [mod.Items.MonstersUnderTheBed] = {
            en_us = { 
                "↑ -0.5 {{Tears}}Tear Delay for each enemy in the room"
            }
        },
        [mod.Items.TravelerLogbook] = {
            en_us = { 
                "Entering a new room grants +0.1 to a random stat for the floor",
                "Entering an I AM ERROR room resets stat boosts and gives +0.2 to a random stat permanently"
            }
        },
        [mod.Items.UltraSecretMap] = {
            en_us = { 
                "Reveals the {{UltraSecretRoom}}Ultra Secret Room on the map",
                "Drops a {{Card78}}Cracked Key in the {{SecretRoom}}Secret Room."
            }
        },
        [mod.Items.RedCompass] = {
            en_us = { 
                "Has a chance to open a nearby red room on room clear"
            }
        },
        [mod.Items.LastResort] = {
            en_us = { 
                "Clearing a hostile room while at half a heart grants a random permanent stat boost from below:",
                "↑ +0.3 {{Damage}}Damage",
                "↑ +0.1 {{Speed}}Speed",
                "↑ -0.3 {{Tears}}Tear Delay"
            }
        },
        [mod.Items.SlaughterToPrevail] = {
            en_us = { 
                "↑ 50% chance for +0.01 {{Damage}}Damage on enemy kill",
                "Max 10 kills per room"
            }
        },
        [mod.Items.CreatineOverdose] = {
            en_us = { 
                "↑ +0.2 {{Damage}}Damage",
                "↑ All bonus damage is amplified by 20%."
            }
        },
        [mod.Items.FragileEgo] = {
            en_us = { 
                "↑ Clearing a room grants a random minor stat up",
                "↓ Taking damage removes all boosts and may add a {{BrokenHeart}}Broken Heart"
            }
        },
        [mod.Items.TouristMap] = {
            en_us = { 
                "Adds a {{Shop}}Shop to every floor starting from Chapter 4"
            }
        },
        [mod.Items.BeggarsTear] = {
            en_us = { 
                "Tears can collect pickups",
                "Consumables are pulled towards Isaac, while other pickups are collected instantly"
            }
        },
        [mod.Items.BackInAnger] = {
            en_us = { 
                "Isaac shoots from behind",
                "↑ +4 {{Damage}}Damage"
            }
        },
        [mod.Items.BossCompass] = {
            en_us = { 
                "Spawn the {{Boss}}Boss Room near the starting room on the next floor"
            }
        },
        [mod.Items.BuriedTreasureMap] = {
            en_us = { 
                "Crawl space will appear in the next room after defeating a boss"
            }
        },
        [mod.Items.GooglyEyes] = {
            en_us = { 
                "Isaac's tears randomly gain 1-3 chaotic tear variants simultaneously, mixing elemental and special effects"
            }
        },
        [mod.Items.Masochism] = {
            en_us = { 
                "Taking damage grants a random small permanent stat up"
            }
        },
        [mod.Items.Unsainted] = {
            en_us = { 
                "All items are from {{ItemPoolDevil}}Devil Pool",
                "All collectibles cost 2 {{EmptyHeart}}Red Heart Containers"
            }
        },
        [mod.Items.BigKahunaBurger] = {
            en_us = { 
                "↑ +1-3 full {{Heart}}Red Heart Containers"
            }
        },
        [mod.Items.DadsEmptyWallet] = {
            en_us = { 
                "↑ +1 {{Tears}}Tears if you have no coins",
                "↓ -0.02 {{Tears}}Tears per coin"
            }
        },
		[mod.Items.FriendlessChild] = {
            en_us = { 
                "Removes all familiars",
                "Familiar items give stat boosts instead, based on quality:",
                "{{Quality0}} +0.25 {{Speed}}Speed",
                "{{Quality1}} +0.5 {{Damage}}Damage",
                "{{Quality2}} +1 {{Damage}}Damage, +0.5 {{Tears}}Tears",
                "{{Quality3}} +1.5 {{Damage}}Damage, +1 {{Range}}Range",
                "{{Quality4}} +2 {{Damage}}Damage, +0.7 {{Tears}}Tears"
            }
        },

		--Familiars
		[mod.Items.ParanoidAndroid] = {
            en_us = { 
                "Creates laser ring around itself",
                function(_, player)
                    local dmg = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and "{{ColorGold}}6{{ColorText}}" or 3
                    return "The ring deals " .. dmg .. " damage 6 times per second"
                end
            }
        },

		--Active
		[mod.Items.AnotherMedium] = { 
			en_us = { 
                "Once per floor randomizes one random passive or familiar item"
            }
		},
		[mod.Items.ArmyOfLovers] = {
			en_us = {   
                "Spawns 2 Mini Isaacs"
            }
		},
		[mod.Items.BigShot] = {
			en_us = {
                "Fires a massive slow piercing tear that destroys rocks and opens secret room doors",
                "Tear explodes on wall impact",
                "4 second cooldown"
            }
		},
        [mod.Items.GuppysSoul] = {
            en_us = {
                "Grants {{Guppy}}Guppy transformation for the room"
            }
        },
    
        [mod.Items.ShBoom] = {
            en_us = {
                "On use:",
                "Triggers {{Collectible483}}Mama Mega effect",
                "↓ +1 {{BrokenHeart}}Broken Heart",
                "Only once per floor",
            }
        },
    
        [mod.Items.HypaHypa] = {
            en_us = {
                "10% chance to spawn a quality {{Quality4}} item",
                "90% chance to spawn {{Collectible36}}The Poop",
                "Single-use"
            }
        },
    
        [mod.Items.HelterSkelter] = {
            en_us = {
                "25% chance to turn each enemy into a friendly Bony"
            }
        },
    
        [mod.Items.HolyWood] = {
            en_us = {
                "Grants {{Collectible313}}Holy Mantle for the current room"
            }
        },
    
        [mod.Items.DiaryOfAMadman] = {
            en_us = {
                "Randomizes stats for the current room"
            }
        },
    
        [mod.Items.ComaWhite] = {
            en_us = {
                "↑ +1 {{EternalHeart}}Eternal Heart",
                "Removes boss item reward on this floor"
            }
        },
    
        [mod.Items.GoodVibes] = {
            en_us = {
                "Transforms all {{Heart}}Red Hearts on the floor into {{SoulHeart}}Soul Hearts"
            }
        },

        [mod.Items.DevilsHeart] = {
            en_us = {
                "On use:",
                "50% chance for a {{Heart}}Red Heart Container",
                "50% chance for a {{BrokenHeart}}Broken Heart ",
                "All items on the floor costs hearts"
            }
        },
    
        [mod.Items.MomsDiary] = {
            en_us = {
                "Spawns a random item",
                "Charges when taking damage"
            }
        },
    
        [mod.Items.LittleLies] = {
            en_us = {
                "On use:",
                "Shrinks Isaac for the room",
                "↑ +2 {{Tears}}Tears for the room"
            }
        },

    
	},
	Trinket = {
		EIDadd = function(...) EID:addTrinket(...) end,

		[mod.Trinkets.BabyBlue] = {
			en_us = {
                "All {{Heart}}Red Heart pickups become {{SoulHeart}}Soul Hearts",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}5% chance for {{Heart}}Red Hearts to become {{BlackHeart}}Black Hearts"
                    end
                }
            }
		},
        [mod.Trinkets.MoneyForNothing] = {
            en_us = {
                "Description for Money for Nothing"
            }
        },
        [mod.Trinkets.CatchTheRainbow] = {
            en_us = {
                "Each {{Poop}} poop has a 2% chance to be {{RainbowPoop}} Rainbow poop",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.CatchTheRainbow + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}Each {{Poop}} poop has a 5% chance to be {{RainbowPoop}} Rainbow poop"
                    end
                }
            }
        },
        [mod.Trinkets.Gaga] = {
            en_us = {
                "Description for Gaga"
            }
        },
        [mod.Trinkets.FixedMetabolism] = {
            en_us = {
                "Description for Fixed Metabolism"
            }
        },
        [mod.Trinkets.ClearVase] = {
            en_us = {
                "Pots no longer spawn spiders or drop hearts/coins.",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.ClearVase + (1 << 15)
                    end,
                    function()
                        return "Pots no longer spawn spiders or drop hearts/coins.",
                        "{{ColorGold}}50% chance to drop hearts/coins as usual."
                    end
                }
            }
        },
        [mod.Trinkets.WonderOfYou] = {
            en_us = {
                "Description for Wonder of You"
            }
        },
        [mod.Trinkets.RottenFood] = {
            en_us = {
                "Description for Rotten Food"
            }
        },
        [mod.Trinkets.TrinketCollector] = {
            en_us = {
                "Description for Trinket Collector"
            }
        },
        [mod.Trinkets.SecondBreakfast] = {
            en_us = {
                "Description for Second Breakfast"
            }
        },
        [mod.Trinkets.BrokenDream] = {
            en_us = {
                "Description for In a Broken Dream"
            }
        }
	},
	Card = {
		EIDadd = function(...) EID:addCard(...) end,

	},
	Pill = {
		EIDadd = function(...) EID:addPill(...) end,

		[mod.Pills.CURSED] = {
			en_us = {
                "Applies a random curse"
            }
		},
	}
}