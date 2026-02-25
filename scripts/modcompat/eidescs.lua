--------------------------------------------------------
----Syntax----
---https://github.com/wofsauge/External-Item-Descriptions/wiki/Markup
---
---stat changes are always indicated by ↑ or ↓
---!make sure to know the difference between Tears up and Fire rate up!
---!don't use functions in descriptions (e.g. change the damage number of a familiar if isaac has bff)!
--↑ +[change_amount > 1] [stat(Health/Speed/Tears/Fire rate/Damage/Range/Shot speed/Luck)]
--↓ -[change_amount < 1] [stat]
--↑ x[multiplier_amount > 0] [stat] multiplier
--↓ x[multiplier_amount < 0] [stat] multiplier
--
--{{[pickup]}} [pickup related effect]
--{{HealingRed}} full health
--
---Luck based effects:
--{{[fitting Icon]}} [effect]
--{{Luck}} [change of effect]
--
---stay with often used phrases like "When taking damage, receive..." or "Taking damage has a chance to..."
---don't talk directly to the reader ("holding the fire button" instead of "hold the fire button to")
---try to not use words like "is", "are", "will"
---look at the descriptions found in the folders of the External Item Description mod!
---icons schould be surounded by a space character if in text
---icons are not often needed! only use them if fitting
--------------------------------------------------------

---@class ModReference
local mod = DiesIraeMod

----------------------------------------------------------------------------------------------------------
--Shenanigans Explanation

--Firstly, you don't need to place "#" symbol at the start of each string, eid.lua does that automatically

--You can put in the description table either a string, a function or a table

--String - will be inserted into the in-game description no matter what

--Function(return string) - will be called each frame on description rendering, returned string 
--will be inserted into the in-game description no matter what
--DescObject and ClosestPlayer args are passed to the function

--Table - contains 2 functions with DescObject and ClosestPlayer args passed to them:
--  First(return boolean) - will be called each frame on description rendering, returned bool will
--  determine if the second function will be called

--  Second(return string) - will be called on description rendering if the first function returns true,
--  returned string will be inserted into the in-game description
----------------------------------------------------------------------------------------------------------

mod.EIDescs = {
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
--------------------------------------------------------
--Passive items
--------------------------------------------------------    
		[mod.Items.U2] = {
			en_us = { 
                "↑ +0.2 Damage",
                "↑ +0.2 Tears",
                "↑ +0.2 Speed",
                "↑ +0.2 Range",
                "↑ +0.2 Luck",
                "↑ +0.2 Shot Speed"
            },
            ru = { 
                "↑ +0.2 Урона",
                "↑ +0.2 Слёзы",
                "↑ +0.2 Скорости",
                "↑ +0.2 Дальности",
                "↑ +0.2 Удачи",
                "↑ +0.2 Скорости Слезы"
            },
		},
		[mod.Items.Muse] = {
			en_us = { 
                "Taking a pickup has a chance to spawn another",
                "Taking a collectible has a chnce to spawn the same one",
            },
		},
		[mod.Items.TheBadTouch] = {
			en_us = { 
                "Kill non-boss enemies on contact",
                "{{Poison}} Poison bosses on contact"
            },
            ru = { 
                "Убийство врагов не-боссов при контакте",
                "{{Poison}} Отравляет боссов при контакте"
            }
		},
		[mod.Items.Universal] = {
			en_us = { 
                "Hold and release fire button to absorb projectiles near Isaac",
                "For each absorbed projectile a beam of light will spawn"
            },
            ru = { 
                "Зажмите и отпустите кнопку стрельбы чтобы поглотить снаряды вблизи Исаака",
                "За каждый поглощённый снаряд появится луч света"
            }
		},
		[mod.Items.RingOfFire] = {
			en_us = { 
                "Spawns 6 Center ring Fire Wisps",
                "{{Burning}} Fire Wisps burn enemies on contact",
				"Fire Wisps are unable to shoot",
                "Upon clearing a room, add 1 fire wisp",
            },
            ru = { 
                "Создаёт кольцо из 6 Огоньков",
                "{{Burning}} Огоньки поджигают врагов при контакте",
                "Огоньки не могут стрелять",
                "Даёт один огонёк после зачистки комнаты",
            },
		},
		[mod.Items.EverybodysChanging] = {
			en_us = { 
                "Randomize all passive items on room clear"
            },
            ru = { 
                "Рандомизирует все пассивные предметы при зачистке комнаты"
            }
		},
		[mod.Items.Echo] = {
            en_us = { 
                "{{Planetarium}} +25% Planetarium chance",
				"+10% after womb" --per floor? gives +25 pre womb and only +10 after?
            },
            ru = { 
                "{{Planetarium}} +25% шанс Планетария",
				"+10% после Матки"
            }
        },
        [mod.Items.ProteinPowder] = {
            en_us = { -- not done
                "↑ +1 Damage",
                "Future copies will grant +1 damage for each collected copy",
				"This effect stops after the fourth copy"
            },
            ru = { -- не готово
                "↑ +1 Урон",
                "Следующие копии дадут +1 урон за каждую",
                "После 4 копии не даёт ничего"
            },
        },
        [mod.Items.GoldenDay] = {
            en_us = { 
                "Spawns a golden pickup",
                "{{SecretRoom}} 50% chance to spawn a golden pickup in the secret room"
            },
            ru = { 
                "Создаёт золотой подбираемый предмет",
                "{{SecretRoom}} 50% шанс создать золотой подбираемый предмет в секретной комнате"
            }
        },
        [mod.Items.CreatineOverdose] = {
            en_us = { 
                "↑ +0.2 Damage",
                "↑ 1.2x Damage multiplier"
            },
            ru = { 
                "↑ +0.2 Урона",
                "↑ 1.2x Множитель Урона"
            }
        },
        [mod.Items.FiendDeal] = {
            en_us = { 
                "Spawns a fiend beggar in the first room on every floor who leaves if the player leaves the room",
				"Interacting with the beggar spawns two devil items on the next floor",
				"{{Warning}} Interacting with the beggar results in Isaac dying in one hit for the floor"
            },
            ru = { 
                "Создаёт Попрошайку-Изверга в первой комнате каждого этажа, который исчезает, если игрок покинет комнату",
                "Взаимодействие с Попрошайкой создаст 2 Дьявольских предмета на следующем этаже",
                "{{Warning}} После взаимодействия с Попрошайкой Исаак умрёт от одного удара на этаже"
            },
        },
        [mod.Items.PTSD] = {
            en_us = { 
				"{{BossRoom}} Entering a boss room grants +0.2 tears for each time the boss killed the player before"
            },
            ru = { 
                "{{BossRoom}} При заходе в комнату босса даёт +0.2 слёзы за каждую смерть от этого босса"
            },
        },
        [mod.Items.FloweringSkull] = {
            en_us = { 
				"Revives Isaac with 2 heart containers in the same room dealing 40 damage to all enemies and rerolling all passive items"
            },
            ru = { 
                "Возрождает Исаака с 2 контейнерами сердец в текущей комнате, нанося 40 урона всем врагам и меняя все пассивные предметы"
            },
        },
        [mod.Items.HarpString] = {
            en_us = { 
				"↑ +1 Item pedestal in the Treasure room"
            },
        },
        [mod.Items.Harp] = {
            en_us = { 
				"↑ +0.15 damage multiplier for every passive item",
                "Not including the Harp or Harp strings"
            },
        },
        [mod.Items.MichelinStar] = {
            en_us = { 
				"Spawn two golden hearts on pickup",
                "Spawn two golden hearts when picking up food item"
            },
        },
--------------------------------------------------------
--Familiars
--------------------------------------------------------    
[mod.Items.ParanoidAndroid] = {
    en_us = { 
        "Shoots a static laser around itself",
    },
    ru = { 
        "Создаёт статический лазер вокруг себя",
    }
},
[mod.Items.KillerQueen] = {
    en_us = { 
        "Fires rockets at enemies"
    },
    ru = { 
        "Стреляет ракетами во врагов"
    }
},
[mod.Items.RedBum] = {
    en_us = { 
        "{{Key}} Picks up nearby Keys",
        "Has a chance to spawn Cracked Key"
    },
},
[mod.Items.ScammerBum] = {
    en_us = { 
        "{{Coin}} Picks up nearby pennies",
        "Has a chance to spawn a purchable item"
    },
},
[mod.Items.RuneBum] = {
    en_us = { 
        "{{Rune}} Picks up nearby runes",
        "Has a chance to spawn a Q 0-2 pedestal"
    },
},
[mod.Items.FairBum] = {
    en_us = { 
        "Picks up the pickup Isaac has the most of",
        "Has a chance to drop the pickup Isaac has the least of"
    },
},
[mod.Items.PastorBum] = {
    en_us = { 
        "{{SoulHeart}} Picks up soul hearts",
        "{{AngelRoom}} Has a chance to drop angel room item",
        "{{DevilRoom}} After droping the item he becomes corrupted with sin",
        "{{BlackHeart}} Might reward with black hearts and devil items"
    },
},
[mod.Items.PillBum] = {
    en_us = { 
        "{{Pill}} Picks up pills",
        "{{ArrowUp}} Positive gives a minor stst boost",
        "{{Poison}} Negative pills makes the bum poison all enemies in the room",
        "Neutral pills gives Isaac a random pill effect"
    },
},
--------------------------------------------------------
--Active items
--------------------------------------------------------    
[mod.Items.ArmyOfLovers] = {
    en_us = {   
        "Spawns 2 Minisaacs",
        "{{Heart}} 12% chance to spawn 5 rewards",
        "{{Luck}} +0.5% chance per Luck: Minimum chance at 8% and maximum chance at 20%",
        "For each reward:",
        "{{Heart}} 50% for full red heart",
        "{{Card}} 50% for Lovers Card",
        "{{Player1}} {{Player22}} 75% for Lovers Card",
        "{{BrokenHeart}} Each Lovers Card has a  1% chance to transform into Reversed Lovers:",
        "{{CurseDarkness}} Curse: +10%",
        "{{Collectible316}} Cursed Eye: +15%",
        "{{CursedRoom}} In Cursed Room: +10%",
        "{{Collectible260}} Black Candle: -100%",
        "{{Collectible584}} Spawn 2 Minisaacs wisps"
    },
    ru = {   
        "Создаёт 2 Мини-Исааков",
        "!!! outdated description"
    }
},
[mod.Items.SlingShot] = {
    en_us = {
        "Shoots a large piercing tear which destroys rocks",
        "Tear explodes on wall impact",
    },
    ru = {
        "Стреляет огромной пронзающей слезой, ломающей камни",
        "Слеза взрывается при столкновении со стеной",
    }
},

[mod.Items.ShBoom] = {
    en_us = {
        "{{Collectible483}} Activates Mama Mega!",
        "{{BrokenHeart}} +1 Broken Heart",
        "Can only be used once per floor"
    },
    ru = {
        "{{Collectible483}} Активирует Мама Мега!",
        "{{BrokenHeart}} +1 Разбитое Сердце",
        "Только раз за этаж",
    }
},

[mod.Items.HelterSkelter] = {
    en_us = {
        "25% chance for each enemy to turn into a friendly Bony"
    },
    ru = {
        "25% шанс превратить каждого врага в дружественного Костяшку"
    }
},
[mod.Items.LittleLies] = {
    en_us = {
        "Size down for the room",
        "↑ +2 Tears for the room"
    },
    ru = {
        "Уменьшает размер на комнату",
        "↑ +2 Слёзы на комнату"
    }
},
[mod.Items.KingsHeart] = {
    en_us = {
        "{{Timer}} Pay 10 {{Coin}} coins to receive a {{UnknownHeart}} random heart"
    },
    ru = {
        "{{Timer}} Заплати 10 {{Coin}} монет за {{UnknownHeart}} случайное сердце"
    }
},
[mod.Items.PersonalBeggar] = {
    en_us = {
        "{{Beggar}} Spawns a random Beggar",
    },
    ru = {
        "{{Beggar}} Создаёт случайного попрошайку",
    },
},
},
--------------------------------------------------------
--Trinkets
--------------------------------------------------------    
Trinket = {
EIDadd = function(...) EID:addTrinket(...) end,

[mod.Trinkets.BabyBlue] = {
    en_us = {
        "{{SoulHeart}} All Red Heart pickups turn into Soul Hearts",
        {
            function(descObj)
                return descObj.ObjSubType == mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG
            end,
            function()
                return "{{BlackHeart}} {{ColorGold}} 5% chance to turn them into Black Hearts"
            end
        }
    },
    ru = {
        "{{SoulHeart}} Все подбираемые Красные Сердца становятся Сердцами Душ",
        {
            function(descObj)
                return descObj.ObjSubType == mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG
            end,
            function()
                return "{{BlackHeart}} {{ColorGold}} 5% шанс превратить их в Чёрные Сердца"
            end
        }
    }
},
[mod.Trinkets.Gaga] = {
    en_us = {
        "Increase spawn-chance for golden pickups"
    },
    ru = {
        "Увеличенный шанс появления золотых подбираемых предметов"
    }
},
[mod.Trinkets.WonderOfYou] = {
    en_us = {
        function(descObj)
            local chance = mod.Utils.IsGoldTrinket(descObj.ObjSubType) and "{{ColorGold}}10%{{ColorReset}}" or "5%"
            return "Taking damage has a " .. chance .. " chance to kill all non-boss enemies"
        end
    },
    ru = {
        function(descObj)
            local chance = mod.Utils.IsGoldTrinket(descObj.ObjSubType) and "{{ColorGold}}10%{{ColorReset}}" or "5%"
            return "При получении урона " .. chance .. " шанс убить всех врагов не-боссов"
        end
    }
},
},
--------------------------------------------------------
--Pills
--------------------------------------------------------    
Pill = {
EIDadd = function(...) EID:addPill(...) end,

[mod.Pills.CURSED] = {
    en_us = {
        "Grants a curse"
    },
    ru = {
        "Даёт проклятие"
    },
},
[mod.Pills.BLESSED] = {
    en_us = {
        "Removes all curses"
    },
    ru = {
        "Убирает все проклятия"
    },
},
[mod.Pills.HEARTBREAK] = {
    en_us = {
        "{{BrokenHeart}} +1 Broken Heart"
    },
    ru = {
        "{{BrokenHeart}} +1 Разбитое Сердце"
    },
},
[mod.Pills.POWER_DRAIN] = {
    en_us = {
        "{{Timer}} Empties held active item"
    },
    ru = {
        "{{Timer}} Разряжает активный предмет"
    },
},
[mod.Pills.VOMIT] = {
    en_us = {
        "{{Trinket}} Spawns a random trinket"
    },
    ru = {
        "{{Trinket}} Создаёт случайный брелок"
    },
},
[mod.Pills.SOMETHING_CHANGED] = {
    en_us = {
        "{{Trinket}} Reroll held trinkets"
    },
    ru = {
        "{{Trinket}} Меняет имеющиеся брелки"
    },
},
[mod.Pills.EQUAL] = {
    en_us = {
        "Equalizes your coins, bombs and keys"
    },
    ru = {
        "Уравнивает монеты, бомбы и ключи"
    },
}
}
}
