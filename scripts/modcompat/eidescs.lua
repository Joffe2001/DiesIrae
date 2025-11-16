local mod = DiesIraeMod

mod.EIDescs = {
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
--------------------------------------------------------
--Passive items
--------------------------------------------------------    
		[mod.Items.U2] = {
			en_us = { 
                "↑ +0.2 {{Damage}}Damage",
                "↑ +0.2 {{Tears}}Tears",
                "↑ +0.2 {{Speed}}Speed",
                "↑ +0.2 {{Range}}Range",
                "↑ +0.2 {{Shotspeed}}Shot Speed"
            },
            ru = { 
                "↑ +0.2 {{Damage}}Урона",
                "↑ +0.2 {{Tears}}Слёз",
                "↑ +0.2 {{Speed}}Скорости",
                "↑ +0.2 {{Range}}Дальности",
                "↑ +0.2 {{Shotspeed}}Скорости Слезы"
            },
		},
		[mod.Items.Muse] = {
			en_us = { 
                "On hit has a chance to spawn a pickup from below:",
                "20% {{Card}}Tarot card",
                "10% {{Rune}}Rune",
                "20% non-heart pickup",
                "1% random item from current pool"
            },
            ru = { 
                "При получении урона шанс создать данный ниже подбираемый предмет:",
                "20% {{Card}}Карта Таро",
                "10% {{Rune}}Руна",
                "20% подбираемый предмет за исключением сердец",
                "1% случайный предмет из пула данной комнаты"
            }
		},
		[mod.Items.TheBadTouch] = {
			en_us = { 
                "Instantly kills non-boss enemies on contact",
                "Bosses are poisoned on contact"
            },
            ru = { 
                "При контакте мгновенно убивает врагов-не боссов",
                "Отравляет боссов при контакте"
            }
		},
		[mod.Items.Universal] = {
			en_us = { 
                "{{Chargeable}} Hold and release fire button to absorb projectiles near Isaac",
                "After absorbing {{Collectible160}}Crack the Sky beams will spawn for each projectile"
            },
            ru = { 
                "{{Chargeable}} Зажмите и отпустите кнопку стрельбы чтобы поглотить снаряды вблизи Исаака",
                "После поглощения появятся лучи от {{Collectible160}}Разверзшихся Небес за каждый снаряд"
            }
		},
		[mod.Items.RingOfFire] = {
			en_us = { 
                "Standing in the room center releases a burst of fire outward"
            },
            ru = { 
                "Нахождение в центре комнаты высвобождает круг огня"
            }
		},
		[mod.Items.MomsDress ] = {
			en_us = { 
                "Spawns 2 {{RottenHeart}}Rotten Hearts on pickup",
                "20% chance to gain {{Collectible313}}Holy Mantle effect in uncleared rooms"
            },
            ru = { 
                "Создаёт 2 {{RottenHeart}}Гнилых Сердца при подборе",
                "20% шанс дать эффект {{Collectible313}}Святой Мантии в незачищенных комнатах"
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
            },
            ru = { 
                "За каждую отрицательную {{Luck}}Удачу даёт:",
                "↑ +0.4 {{Damage}}Урона",
                "↑ -0.7 {{Tears}}Задержки Выстрела",
                "↑ +0.1 {{Speed}}Скорости",
                "↑ +0.2 {{Range}}Дальности",
                "↑ +0.05 {{Shotspeed}}Скорости Слезы"
            }
		},
		[mod.Items.EverybodysChanging] = {
			en_us = { 
                "All passive/familiar items are randomized on room clear"
            },
            ru = { 
                "Все пассивные предметы/предметы спутников рандомизируются при зачистке комнаты"
            }
		},
		[mod.Items.Echo] = {
            en_us = { 
                "↑ +25% {{Planetarium}}Planetarium chance, +10% on Womb and onward"
            },
            ru = { 
                "↑ +25% шанс {{Planetarium}}Планетария, +10% в Матке и последующих этажах"
            }
        },
        [mod.Items.Engel] = {
            en_us = { 
                "↑ +5 {{Luck}}Luck",
                "Grants spectral and homing tears",
                "Disables {{Seraphim}}Flight"
            },
            ru = { 
                "↑ +5 {{Luck}}Удачи",
                "Даёт спектральные и самонаводящиеся слёзы",
                "Отключает {{Seraphim}}Полёт"
            }
        },
        [mod.Items.ScaredShoes] = {
            en_us = { 
                "↑ Sets speed to 2 when no enemies are alive",
                "Spawns random small pee creep during combat"
            },
            ru = { 
                "↑ Устанавливает скорость на 2 когда все враги мертвы",
                "Создаёт случайную маленькую лужу мочи во время битвы"
            }
        },
        [mod.Items.DevilsLuck] = {
            en_us = { 
                "↓ -6 {{Luck}}Luck",
                "50% chance for pickups to vanish",
                "↑ +0.05 {{Damage}}Damage per vanished pickup"
            },
            ru = { 
                "↓ -6 {{Luck}}Удачи",
                "50% шанс на исчезновение подбираемого предмета",
                "↑ +0.05 {{Damage}}Урона за каждый исчезнувший предмет"
            }
        },
        [mod.Items.HereToStay] = {
            en_us = {  
                "Standing still spawns creep in growing steps",
                "The puddle gets bigger each frame"
            },
            ru = {  
                "Стоя неподвижно создаёт увеличивающуюся лужу",
                "Лужа растёт каждый кадр"
            }
        },
        [mod.Items.SkullCrasher] = {
            en_us = { 
                "Allows you to damage skull-based enemies (Hosts, Hard Hosts, etc.) when invulnerable"
            },
            ru = { 
                "Позволяет наносить урон врагам с броней из черепа (Наблюдатели, Твёрдые Наблюдатели и т.д.) во время их неуязвимости"
            }
        },
        [mod.Items.ProteinPowder] = {
            en_us = { 
                "↑ +1 {{Damage}}Damage on first pickup, +2 on second, up to +4",
                "Further pickups always grant +1 {{Damage}}Damage"
            },
            ru = { 
                "↑ +1 {{Damage}}Урон при первом подборе, +2 при втором, до +4",
                "Последующие подборы всегда дают +1 {{Damage}}Урон"
            }
        },
        [mod.Items.Hysteria] = {
            en_us = { 
                "Taking damage twice in a room doubles the damage for the room"
            },
            ru = { 
                "Получение урона дважды за комнату удваивает урон на комнату"
            }
        },
        [mod.Items.StabWound] = {
            en_us = { 
                "↑ +1 {{Damage}}Damage",
                "↑ +0.5 {{Tears}}Tears"
            },
            ru = { 
                "↑ +1 {{Damage}}Урон",
                "↑ +0.5 {{Tears}}Слёз"
            }
        },
        [mod.Items.ThoughtContagion] = {
            en_us = { 
                "Enemies mirror damage they take to other nearby enemies",
                "Only pure damage is shared"
            },
            ru = { 
                "Враги отражают получаемый урон на ближайших врагов",
                "Отражается только чистый урон"
            }
        },
        [mod.Items.DadsDumbbell] = {
            en_us = { 
                "Each tear from the lest eye has a 10% chance to deal +2 Damage"
            },
            ru = { 
                "Каждая слеза имеет 10% шанс нанести +2 Урона"
            }
        },
        [mod.Items.GoldenDay] = {
            en_us = { 
                "Spawns a {{GoldenKey}}Random key or {{GoldenBomb}} Golden bomb or {{Coin}}Golden coin",
                "{{SecretRoom}} On each floor has a 50% chance to spawn golden pickup in the Secret Room"
            },
            ru = { 
                "Даёт случайный золотой подбираемый предмет",
                "{{SecretRoom}} На каждом этаже есть 50% шанс создать золотой подбираемый предмет в Секретной Комнате"
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
            },
            ru = { 
                "↑ +0.3 {{Speed}}Скорости",
                "↑ Увеличенный шанс найти предметы {{Mom}}Мамы, Доктора Зародыша и Кесарево",
                "Повышение характеристик за каждый предмет Мамы:",
                "↑ +0.5 {{Damage}}Урона",
                "↑ -0.3 {{Tears}}Задержки Выстрела",
                "↑ +1 {{Luck}}Удачи",
                "↑ +0.05 {{Speed}}Скорости",
            }
        },
        [mod.Items.SolarFlare] = {
            en_us = { 
                "Tears start slow",
                "After 0.2 seconds they dash towards the nearest enemy, leaving a short fire trail",
                "{{Burning}}Tears burn enemies on hit"
            },
            ru = { 
                "Слёзы медленные при выстреле",
                "После 0.2 секунд устремляются к ближайшему врагу, оставляя огненный след",
                "{{Burning}}Слёзы накладывают горение на врагов"
            }
        },
        [mod.Items.EyeSacrifice] = {
            en_us = { 
                "Shoot only from Isaac's right eye",
                "Upon entering the Devil Deal room, receive a free Devil Deal"
            },
            ru = { 
                "Стрельба только из правого глаза",
                "При заходе в Комнату Сделки с Дьяволом даёт бесплатный предмет из сделки"
            }
        },
        [mod.Items.Psychosocial] = {
            en_us = { 
                "↑ -0.5 {{Tears}}Tear Delay for each enemy in the room"
            },
            ru = { 
                "↑ -0.5 {{Tears}}Задержки Выстрела за каждого врага в комнате"
            }
        },
        [mod.Items.TravelerLogbook] = {
            en_us = { 
                "Entering a new room grants +0.1 to a random stat for the floor",
                "Entering an I AM ERROR room resets stat boosts and gives +0.2 to a random stat permanently"
            },
            ru = { 
                "При заходе в новую комнату даёт +0.1 к случайной характеристике на этаж",
                "При заходе в комнату Я ОШИБКА сбрасывает повышение характеристик и даёт +0.2 к случайной характеристике навсегда"
            }
        },
        [mod.Items.UltraSecretMap] = {
            en_us = { 
                "Reveals the {{UltraSecretRoom}}Ultra Secret Room on the map",
                "Drops a {{Card78}}Cracked Key in the {{SecretRoom}}Secret Room"
            },
            ru = { 
                "Показывает {{UltraSecretRoom}}Ультра Секретную Комнату на карте",
                "Создаёт {{Card78}}Треснувший Ключ в {{SecretRoom}}Секретной Комнате"
            }
        },
        [mod.Items.RedCompass] = {
            en_us = { 
                "Has a chance to open a nearby red room on room clear"
            },
            ru = { 
                "Имеет шанс открыть красную комнату рядом при зачистке комнаты"
            }
        },
        [mod.Items.LastResort] = {
            en_us = { 
                "Clearing a hostile room while at half a heart grants a random permanent stat boost from below:",
                "↑ +0.3 {{Damage}}Damage",
                "↑ +0.1 {{Speed}}Speed",
                "↑ -0.3 {{Tears}}Tear Delay"
            },
            ru = { 
                "Зачистка комнаты на половине сердца даёт случайное повышение характеристики ниже:",
                "↑ +0.3 {{Damage}}Урона",
                "↑ +0.1 {{Speed}}Скорости",
                "↑ -0.3 {{Tears}}Задержки Выстрела"
            }
        },
        [mod.Items.CreatineOverdose] = {
            en_us = { 
                "↑ +0.2 {{Damage}}Damage",
                "↑ 1.2x {{Damage}}Damage multiplier."
            },
            ru = { 
                "↑ +0.2 {{Damage}}Урона",
                "↑ Весь бонусный урон увеличен на 20%."
            }
        },
        [mod.Items.FragileEgo] = {
            en_us = { 
                "↑ Clearing a room grants a random minor stat up",
                "↓ Taking damage removes all boosts and may add a {{BrokenHeart}}Broken Heart"
            },
            ru = { 
                "↑ При зачистке комнаты даёт случайное меленькое повышение характеристики",
                "↓ При получении урона убирает все повышения характеристик и может добавить {{BrokenHeart}}Разбитое Сердце"
            }
        },
        [mod.Items.TouristMap] = {
            en_us = { 
                "Adds a {{Shop}}Shop to every floor starting from Chapter 4"
            },
            ru = { 
                "Добавляет {{Shop}}Магазин на каждый этаж начиная с Матки 1"
            }
        },
        [mod.Items.BeggarsTear] = {
            en_us = { 
                "Tears can collect pickups",
                "Consumables are pulled towards Isaac, while other pickups are collected instantly"
            },
            ru = { 
                "Слёзы могут подбирать предметы",
                "Расходники притягиваются к Исааку, в то время как остальные предметы подбираются мгновенно"
            }
        },
        [mod.Items.KoRn] = {
            en_us = { 
                "10% chance to shoot a random colored tear",
                "Colored tears create matching clouds on impact that inflict status effects"
            },
            ru = { 
                "Стрельба сзади",
                "10% шанс выстрелить случайной цветной слезой#Цветные слёзы создают",
                "облака при попадании, которые накладывают эффекты статусов"
            }
        },
        [mod.Items.BackInAnger] = {
            en_us = { 
                "Isaac shoots from behind",
                "↑ +4 {{Damage}}Damage"
            },
            ru = { 
                "Стрельба сзади",
                "↑ +4 {{Damage}}Урона"
            }
        },
        --[[[mod.Items.BuriedTreasureMap] = {
            en_us = { 
                "Crawl space will appear in the next room after defeating a boss"
            },
            ru = { 
                "Ретро-Сокровищница появится в следующей комнате после убийства босса"
            }
        }, ]]
        [mod.Items.BigKahunaBurger] = {
            en_us = { 
                "↑ +1-3 full {{Heart}}Red Heart Containers"
            },
            ru = { 
                "↑ +1-3 полных {{Heart}}Контейнеров Красных Сердец"
            }
        },
        [mod.Items.DadsEmptyWallet] = {
            en_us = { 
                "↑ +1 {{Tears}}Tears if you have no coins",
                "↓ -0.02 {{Tears}}Tears per coin"
            },
            ru = { 
                "↑ +1 {{Tears}}Слёзы если у Исаака нет монет",
                "↓ -0.02 {{Tears}}Слёз за каждую монету"
            },
        },
        [mod.Items.FiendDeal] = {
            en_us = { 
                "Spawns Fiend Beggar on the first room on every floot",
                "Leaving the room causes the Beggar to leave",
                "Making a deal with the Beggar grants two {{DevilRoom}}devil deal items to choose from on the next floor",
                "{{Warning}} Isaac dies on a single hit on the Beggar deal's floor"
            },
        },
        [mod.Items.Bloodline] = {
            en_us = { 
                "Every damage inflicted on an enemy, it hurts every enemy type in the room"
            },
        },
        [mod.Items.BetrayalHeart] = {
            en_us = { 
                "+1 {{BrokenHeart}} on pickup",
                "{{Damage}}+1 damage up for every {{BrokenHeart}} broken heart"
            },
        },
        [mod.Items.StillStanding] = {
            en_us = { 
                "{{Damage}}Damage up as long as Isaac stand still",
            },
        },
        [mod.Items.BossCompass] = {
            en_us = { 
                "Reavels the {{BossRoom}}Boss and the {{MiniBoss}}Mini-boss rooms on the map",
                "Grant a {{Damage}}damage up for killed bosses and mini bosses"
            },
        },
        [mod.Items.DevilsMap] = {
            en_us = { 
                "Reavels the {{SacrificeRoom}}Sacrifice and the {{CursedRoom}}Curse rooms on the map",
                "Grant a {{Tears}}Tears up for entering those rooms and {{DevilRoom}}Devil deal room"
            },
        },
        [mod.Items.BorrowedStrength] = {
            en_us = { 
                "↑ +2 {{Damage}}Damage",
                "{{Warning}} Isaac loses half of his hearts when entering a new floor"
            },
        },
        [mod.Items.SymphonyOfDestr] = {
            en_us = { 
                "Every {{Card}}card turns to {{Card17}} The Tower when spawned"
            },
        },
        [mod.Items.SweetCaffeine] = {
            en_us = { 
                "Drop Energy Drink",
                "Higher chance to find Energy Drink"
            },
        },
        [mod.Items.PTSD] = {
            en_us = { 
                "{{BossRoom}} Boss room only: {{Tears}} +0.2 tears for each time this boss killed Isaac before."
            },
        },
        [mod.Items.FloweringSkull] = {
            en_us = { 
                "Revives Isaac upon death",
                "{{Heart}} ­ Revives with 2 red heart containers (or 2 {{SoulHeart}} soul hearts).",
                "{{ArrowUp}} ­ Upon revival, deal 40 damage to all enemies in the room.",
                "{{Warning}} ­ Also rerolls all of your passive items into random new passives."
            },
        },
        [mod.Items.RewrappingPaper] = {
            en_us = { 
                "Every {{TreasureRoom}}  Treasure room pedestal will become {{Collectible515}} Mystery Gift.",
                "If there're two pedestals, at least one of them will be {{Collectible515}} Mystery Gift."
            },
        },
        [mod.Items.FilthyRich] = {
            en_us = { 
                "The more {{Coin}} coins Isaac have, the higher the chance for {{Poison}} poison tears and {{Poison}} poison clouds to spawn.",
            },
        },
        [mod.Items.CoolStick] = {
            en_us = { 
                "{{Damage}} +0.4 Damage up",
                "{{Luck}} +1 Luck up",
                "{{Chest}} 15% chance for spawned chests to turn into {{WoodenChestRoomIcon}} Wooden Chests",
            },
        },
        [mod.Items.Grudge] = {
            en_us = { 
                "When you take damage from an enemy, that enemy type becomes marked",
                "Enemies of that type take double damage for the rest of the run."
            },
        },
        [mod.Items.BloodBattery] = {
            en_us = { 
                "Taking damage has a chance to drop a {{Battery}} battery."
            },
        },
        [mod.Items.DeliriousMind] = {
            en_us = { 
                "Isaac gets +0.15 {{Damage}} damage up and {{Tears}} +0.15 tears up for every modded item"
            },
        },
        [mod.Items.CorruptedMantle] = {
            en_us = { 
                "{{ArrowUp}}Neglect the first hit in a room",
                "{{ArrowUp}}+0.1 {{Speed}}speed",
                "{{ArrowUp}}+3 {{Luck}}luck",
                "{{ArrowUp}}x1.5 {{Damage}}damage multiplier",
                "Losing the shield, will lose the x1.5 damage multiplier",
                "{{Warning}}Taking damage after losing the shield:",
                "{{ArrowDown}}x0.3 damage multiplier",
                "{{ArrowDown}}-5 luck",
                "{{ArrowDown}} Adds 2 {{BrokenHeart}}broken hearts",
                "The damage multiplier will be reset to x1.5 upon entering a new room"
            },
        },
		--[[[mod.Items.FriendlessChild] = { --NOT DONE
            en_us = { 
                "Removes all familiars",
                "Familiar items give stat boosts instead, based on quality:",
                "{{Quality0}} +0.25 {{Speed}}Speed",
                "{{Quality1}} +0.5 {{Damage}}Damage",
                "{{Quality2}} +1 {{Damage}}Damage, +0.5 {{Tears}}Tears",
                "{{Quality3}} +1.5 {{Damage}}Damage, +1 {{Range}}Range",
                "{{Quality4}} +2 {{Damage}}Damage, +0.7 {{Tears}}Tears"
            },
            ru = { 
                "Убирает всех спутников",
                "Вместо этого предметы спутников дают повышение характеристик в зависимости от качества:",
                "{{Quality0}} +0.25 {{Speed}}Скорости",
                "{{Quality1}} +0.5 {{Damage}}Урона",
                "{{Quality2}} +1 {{Damage}}Урон, +0.5 {{Tears}}Слёз",
                "{{Quality3}} +1.5 {{Damage}}Урона, +1 {{Range}}Дальности",
                "{{Quality4}} +2 {{Damage}}Урона, +0.7 {{Tears}}Слёз"
            }
        },]]
--------------------------------------------------------
--Familiars
--------------------------------------------------------    
		[mod.Items.ParanoidAndroid] = {
            en_us = { 
                "Creates laser ring around itself",
                function(_, player)
                    local dmg = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and "{{ColorGold}}6{{ColorText}}" or 3
                    return "The ring deals " .. dmg .. " damage 6 times per second"
                end
            },
            ru = { 
                "Создаёт лазерное кольцо вокруг себя",
                function(_, player)
                    local dmg = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and "{{ColorGold}}6{{ColorText}}" or 3
                    return "Кольцо наносит " .. dmg .. " урона 6 раз в секунду"
                end
            }
        },
        [mod.Items.KillerQueen] = {
			en_us = { 
                "Shoots rockets at enemies similar to {{Collectible168}}Epic Fetus"
            },
            ru = { 
                "Стреляет ракетами во врагов, похожими на ракеты от {{Collectible168}}Эпичного Зародыша"
            }
		},
--------------------------------------------------------
--Active items
--------------------------------------------------------    
		[mod.Items.AnotherMedium] = { 
			en_us = { 
                "Once per floor randomizes one random passive or familiar item"
            },
            ru = { 
                "Один раз за этаж рандомизирует один случайный пассивный или предмет спутника"
            }
		},
		[mod.Items.ArmyOfLovers] = {
			en_us = {   
                "Spawns 2 Mini Isaacs"
            },
            ru = {   
                "Создаёт 2 Мини-Исааков"
            }
		},
		[mod.Items.BigShot] = {
			en_us = {
                "Fires a massive slow piercing tear that destroys rocks and opens secret room doors",
                "Tear explodes on wall impact",
                "4 second cooldown"
            },
            ru = {
                "Выстреливает огромную медленную пронзающую слезу, уничтожающую камни и открывающую проходы в секретную комнату",
                "Слеза взрывается при столкновении со стеной",
                "4 секунды перезарядка"
            }
		},
        [mod.Items.GuppysSoul] = {
            en_us = {
                "Grants {{Guppy}}Guppy transformation for the room"
            },
            ru = {
                "Даёт превращение {{Guppy}}Гаппи на комнату"
            }
        },
    
        [mod.Items.ShBoom] = {
            en_us = {
                "Triggers {{Collectible483}}Mama Mega! effect",
                "↓ +1 {{BrokenHeart}}Broken Heart",
                "Only once per floor",
            },
            ru = {
                "Вызывает эффект {{Collectible483}}Мама Мега!",
                "↓ +1 {{BrokenHeart}}Разбитое Сердце",
                "Только один раз за этаж",
            }
        },
    
        [mod.Items.HypaHypa] = {
            en_us = {
                "30% chance to spawn a quality {{Quality4}} item",
                "70% chance to spawn {{Collectible36}}The Poop",
                "Single-use"
            },
            ru = {
                "10% шанс создать предмет {{Quality4}} качества",
                "90% шанс создать {{Collectible36}}Какашку",
                "Одноразовый"
            }
        },
    
        [mod.Items.HelterSkelter] = {
            en_us = {
                "25% chance to turn each enemy into a friendly Bony"
            },
            ru = {
                "25% шанс превратить каждого врага в дружественного Костяшку"
            }
        },
    
        [mod.Items.HolyWood] = {
            en_us = {
                "Grants {{Collectible313}}Holy Mantle for the current room"
            },
            ru = {
                "Даёт {{Collectible313}}Святую Мантию на комнату"
            }
        },
    
        [mod.Items.DiaryOfAMadman] = {
            en_us = {
                "Randomizes stats for the current room"
            },
            ru = {
                "Рандомизирует характеристики на комнату"
            }
        },
    
        [mod.Items.ComaWhite] = {
            en_us = {
                "↑ +1 {{EternalHeart}}Eternal Heart",
                "Removes boss item reward on this floor"
            },
            ru = {
                "↑ +1 {{EternalHeart}}Вечное Сердце",
                "Убирает предмет в награду за босса на этом этаже"
            }
        },
    
        [mod.Items.GoodVibes] = {
            en_us = {
                "Transforms all {{Heart}}Red Hearts in the room into {{SoulHeart}}Soul Hearts"
            },
            ru = {
                "Превращает все {{Heart}}Красные Сердца на полу в {{SoulHeart}}Сердца Душ"
            }
        },

        [mod.Items.DevilsHeart] = {
            en_us = {
                "50% chance for a {{Heart}}Red Heart Container",
                "50% chance for a {{BrokenHeart}}Broken Heart ",
                "All items on the floor costs hearts"
            },
            ru = {
                "50% шанс на {{Heart}}Контейнер Красного Сердца",
                "50% шанс на {{BrokenHeart}}Разбитое Сердце",
                "Все предметы на этаже стоят сердца"
            }
        },
    
        [mod.Items.MomsDiary] = {
            en_us = {
                "Spawns a random item",
                "Charges when taking damage"
            },
            ru = {
                "Создаёт случайный предмет",
                "Заряжается от получения урона"
            }
        },
    
        [mod.Items.LittleLies] = {
            en_us = {
                "Shrinks Isaac for the room",
                "↑ +2 {{Tears}}Tears for the room"
            },
            ru = {
                "Уменьшает Исаака на комнату",
                "↑ +2 {{Tears}}Слёз на комнату"
            }
        },
        [mod.Items.KingsHeart] = {
            en_us = {
                "Give Isaac a random {{UnknownHeart}} heart",
                "Costs 10 {{Coin}}pennies"
            },
            ru = {
                "Дает Исааку случайное {{UnknownHeart}} сердце",
                "Стоит 10 {{Coin}} монет"
            }
        },
        [mod.Items.BreakStuff] = {
            en_us = {
                "Deals 100 damage to all enemies in the room",
                "Opens every door",
                "Destroy all rocks"
            },
            ru = {
                "Наносит 100 урона всем врагам в комнате",
                "Открывает все двери",
                "Разрушает все камни в комнате"
            }
        },
        [mod.Items.PersonalBeggar] = {
            en_us = {
                "Spawns a random Beggar",
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
                "All {{Heart}}Red Heart pickups become {{SoulHeart}}Soul Hearts",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}5% chance for {{Heart}}Red Hearts to become {{BlackHeart}}Black Hearts"
                    end
                }
            },
            ru = {
                "Все подбираемые {{Heart}}Красные Сердца становятся {{SoulHeart}}Сердцами Душ",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}5% шанс для {{Heart}}Красных Сердец стать {{BlackHeart}}Чёрными Сердцами"
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
                function(descObj)
                    local golden = descObj.ObjSubType == mod.Trinkets.CatchTheRainbow + (1 << 15)
                    local chance = golden and "{{ColorGold}}5%{{ColorText}}" or "2%"
                    return "Each {{Poop}} poop has a " .. chance .. " chance to be {{RainbowPoop}} Rainbow poop"
                end
            },
            ru = {
                function(descObj)
                    local golden = descObj.ObjSubType == mod.Trinkets.CatchTheRainbow + (1 << 15)
                    local chance = golden and "{{ColorGold}}5%{{ColorText}}" or "2%"
                    return "Каждая {{Poop}} какашка имеет " .. chance .. " шанс стать {{RainbowPoop}} Радужной какашкой"
                end
            }
        },
        [mod.Trinkets.Gaga] = {
            en_us = {
                "Increased chance to transform regular Bombs, Keys, and Coins into their golden variants"
            }
        },
        [mod.Trinkets.FixedMetabolism] = {
            en_us = {
                "Red poops will be replaced with normal poops"
            }
        },
        [mod.Trinkets.ClearVase] = {
            en_us = {
                "Pots no longer spawn spiders or drop hearts/coins",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.ClearVase + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}50% chance to drop hearts/coins as usual"
                    end
                }
            },
            ru = {
                "С горшков больше не падают пауки, сердца или монеты",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.ClearVase + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}50% шанс получить сердца/монеты с горшков как обычно"
                    end
                }
            }
        },
        [mod.Trinkets.WonderOfYou] = {
            en_us = {
                "Taking damage has a 5% chance to instantly kill all non-boss enemies in the room.",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}Taking damage has a 10% chance to instantly kill all non-boss enemies in the room."
                    end
                }
            }
        },
        [mod.Trinkets.RottenFood] = {
            en_us = {
                "All {{Heart}}heart pickups will be {{RottenHeart}}rotten hearts"
            }
        },
        [mod.Trinkets.TrinketCollector] = {
            en_us = {
                "Description for Trinket Collector"
            }
        },
        [mod.Trinkets.SecondBreakfast] = {
            en_us = {
                "When collecting a food item, spawns a second one"
            }
        },
        [mod.Trinkets.Papercut] = {
            en_us = {
                "Using a card causes all enemies to bleed"
            }
        },
        [mod.Trinkets.TarotBattery] = {
            en_us = {
                "Using a card adds +1 charge to the active item"
            }
        },
	},
--------------------------------------------------------
--Cards/Runes
--------------------------------------------------------    
	Card = {
		EIDadd = function(...) EID:addCard(...) end,

        [mod.Cards.Locacaca] = {
            en_us = {
                "{{Heart}}Heal Isaac red hearts",
                "If there's a {{BrokenHeart}} broken heart(s) it will heal them also",
                "{{Warning}}Healing a heart container cost stats decrease",
                "{{Warning}}Healing a {{BrokenHeart}} broken heart(s) will costs collectibles"
            },
        },
        [mod.Cards.alpoh] = {
            en_us = {
                "Gives a random {{AngelRoom}} angel room item",
                "Cost 2 {{BrokenHeart}} broken hearts"
            },
        },
        [mod.Cards.StarShard] = {
            en_us = {
                "Change a pedestal into a Planetarium item",
                "If there's no pedestal in the room it will give two soul hearts instead"
            },
        },
        [mod.Cards.EnergyDrink] = {
            en_us = {
                "{{ArrowUp}}Gives +0.5 to all the stats for the room",
                "{{Warning}}After 15 seconds Isaac gets {{ArrowDown}}-0.1 stats penalty for the room"
            },
        },
        [mod.Cards.DadsLottoTicket] = {
            en_us = {
                "Has a chance to spawn a Penny, a nickel or a dime",
                "There's a chance for nothing to spawn"
            },
        }
	},
--------------------------------------------------------
--Pills
--------------------------------------------------------    
	Pill = {
		EIDadd = function(...) EID:addPill(...) end,

		[mod.Pills.CURSED] = {
			en_us = {
                "Applies a random curse"
            },
            ru = {
                "Даёт случайное проклятие"
            }
		},
        [mod.Pills.BLESSED] = {
			en_us = {
                "Removes current curses"
            }
		},
        [mod.Pills.HEARTBREAK] = {
			en_us = {
                "Adds a {{BrokenHeart}}broken heart"
            }
		},
        [mod.Pills.POWER_DRAIN] = {
			en_us = {
                "Empties active item charge"
            }
		},
        [mod.Pills.GULPING] = {
			en_us = {
                "Gulps your current trinket"
            }
		},
        [mod.Pills.EQUAL] = {
			en_us = {
                "Equalizes your coins, bombs, and keys"
            }
		}
	}
}
