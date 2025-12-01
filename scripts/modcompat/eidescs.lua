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
                "↑ +0.2 {{Luck}}Luck",
                "↑ +0.2 {{Shotspeed}}Shot Speed"
            },
            ru = { 
                "↑ +0.2 {{Damage}}Урона",
                "↑ +0.2 {{Tears}}Слёз",
                "↑ +0.2 {{Speed}}Скорости",
                "↑ +0.2 {{Range}}Дальности",
                "↑ +0.2 {{Luck}}Удачи",
                "↑ +0.2 {{Shotspeed}}Скорости Слезы"
            },
		},
		[mod.Items.Muse] = {
			en_us = { 
                "On hit has a chance to spawn a pickup from below:",
                "20% {{Card}}Tarot card",
                "10% {{Rune}}Rune",
                "20% random pickup",
                "1% random item from current pool"
            },
            ru = { 
                "При получении урона шанс создать данный ниже подбираемый предмет:",
                "20% {{Card}}Карта Таро",
                "10% {{Rune}}Руна",
                "20% случайный подбираемый предмет",
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
                "Isaac gets 6 fire-wisps",
                "Fire wisps doesn't fire tears but cause {{Burning}}burning and can block shots",
                "Upon clearing a room, add 1 fire wisp",
                "Caps at 8 wisps"
            },
		},
		[mod.Items.MomsDress ] = {
			en_us = {
                "{{RottenHeart}} Spawns 2 Rotten Hearts",
                "{{Collectible313}} {{ColorCyan}}(20 + 10{{ColorYellow}}N{{CR}})%{{CR}} chance to gain Holy Mantle effect in uncleared rooms.",
                "{{Collectible739}} {{ColorYellow}}N{{CR}} is the number of Mom's Dress items the player has."
            },
            ru = {
                "Создаёт 2 {{RottenHeart}}Гнилых Сердца при подборе",
                "30% шанс дать эффект {{Collectible313}}Святой Мантии в незачищенных комнатах",
                "!!! Outdated description."
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
                "Taking damage twice in a room doubles the {{Damage}}damage for the room",
                "Getting damage three times in the same room removes the damage boost and gives a {{BrokenHeart}}broken heart",
                "Getting hit the forth time gains another {{BrokenHeart}}broken heart and doubles the {{Tears}}tear rate",
                "Getting hit 5th time is a skill issue"
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
                "↑ +0.5 {{Tears}}Слёзы"
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
        [mod.Items.Psychosocial] = {
            en_us = { 
                "↑ -0.5 {{Tears}}Tear Delay for each enemy in the room"
            },
            ru = { 
                "↑ -0.5 {{Tears}}Задержки Выстрела за каждого врага в комнате"
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
                "↑ 1.2x {{Damage}}Damage multiplier"
            },
            ru = { 
                "↑ +0.2 {{Damage}}Урона",
                "↑ 1.2x {{Damage}}Множитель Урона"
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
                "Colored tears create matching clouds on impact that apply status effects"
            },
            ru = { 
                "10% шанс выстрелить случайной цветной слезой",
                "Цветные слёзы создают соответствующие облака при попадании, накладывающие эффекты"
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
                "Spawns Fiend Beggar on the first room on every floor",
                "Leaving the room causes the Beggar to leave",
                "Making a deal with the Beggar grants two {{DevilRoom}}devil deal items to choose from on the next floor",
                "{{Warning}} Isaac dies on a single hit on the Beggar deal's floor"
            },
            ru = { 
                "Создаёт Попрошайку-Изверга в первой комнате каждого этажа",
                "При выходе из комнаты Попрошайка исчезнет",
                "Совершая сделку с Попрошайкой, гарантирует 2 {{DevilRoom}}Дьявольских предмета на выбор на следующем этаже",
                "{{Warning}} Исаак умирает от любого удара на этаже, где была совершена сделка"
            },
        },
        [mod.Items.Bloodline] = {
            en_us = { 
                "Every damage inflicted on an enemy, it hurts every enemy type in the room"
            },
            ru = { 
                "Любой урон, нанесённый врагу, распространяется на всех врагов этого же типа в комнате"
            },
        },
        [mod.Items.BetrayalHeart] = {
            en_us = { 
                "+1 {{BrokenHeart}} on pickup",
                "{{Damage}}+1 damage up for every {{BrokenHeart}} broken heart"
            },
            ru = { 
                "+1 {{BrokenHeart}} при подборе",
                "{{Damage}}+1 Урон за каждое {{BrokenHeart}} разбитое сердце"
            },
        },
        [mod.Items.StillStanding] = {
            en_us = { 
                "{{Damage}}Damage up as long as Isaac stand still",
            },
            ru = { 
                "{{Damage}}↑ Урон пока Исаак стоит на месте",
            },
        },
        [mod.Items.BossCompass] = {
            en_us = { 
                "Reveals the {{BossRoom}}Boss and the {{MiniBoss}}Mini-boss rooms on the map",
                "Grant a {{Damage}}damage up for killed bosses and mini bosses"
            },
            ru = { 
                "Показывает комнаты {{BossRoom}}Босса и {{MiniBoss}}Мини-босса на карте",
                "↑ {{Damage}}Урон за каждого убитого босса и мини-босса"
            },
        },
        [mod.Items.DevilsMap] = {
            en_us = { 
                "Reveals the {{SacrificeRoom}}Sacrifice and the {{CursedRoom}}Curse rooms on the map",
                "Grant a {{Tears}}Tears up for entering those rooms and {{DevilRoom}}Devil deal room"
            },
            ru = { 
                "Показывает комнату {{SacrificeRoom}}Жертвоприношения и {{CursedRoom}}Проклятую комнату на карте",
                "↑ {{Tears}}Слёзы за посещение этих комнат и комнаты {{DevilRoom}}Сделки с Дьяволом"
            },
        },
        [mod.Items.BorrowedStrength] = {
            en_us = { 
                "↑ +2 {{Damage}}Damage",
                "{{Warning}} Isaac loses half of his hearts when entering a new floor"
            },
            ru = { 
                "↑ +2 {{Damage}}Урона",
                "{{Warning}} Исаак теряет половину своих сердец при переходе на новый этаж"
            },
        },
        [mod.Items.SymphonyOfDestr] = {
            en_us = { 
                "Every {{Card}}card turns to {{Card17}} The Tower when spawned"
            },
            ru = { 
                "Все {{Card}}карты превращаются в {{Card17}}Башню"
            },
        },
        [mod.Items.SweetCaffeine] = {
            en_us = { 
                "Drop Energy Drink",
                "Higher chance to find Energy Drink"
            },
            ru = { 
                "Создаёт Энергетик",
                "Больше шанс найти Энергетик"
            },
        },
        [mod.Items.PTSD] = {
            en_us = { 
                "{{BossRoom}} Boss room only: {{Tears}} +0.2 tears for each time this boss killed Isaac before"
            },
            ru = { 
                "{{BossRoom}} Только в комнате Босса: {{Tears}} +0.2 слёз за каждую смерть от этого босса"
            },
        },
        [mod.Items.FloweringSkull] = {
            en_us = { 
                "Revives Isaac upon death",
                "{{Heart}} ­ Revives with 2 red heart containers (or 2 {{SoulHeart}} soul hearts)",
                "{{ArrowUp}} ­ Upon revival, deal 40 damage to all enemies in the room",
                "{{Warning}} ­ Also rerolls all of your passive items into random new passives"
            },
            ru = { 
                "Возрождает Исаака при смерти",
                "{{Heart}} ­ Возрождает с 2 контейнерами красных сердец (или 2 {{SoulHeart}} сердцами душ)",
                "{{ArrowUp}} ­ Наносит 40 урона всем врагам в комнате при возрождении",
                "{{Warning}} ­ Также заменяет все пассивные предметы на новые случайные пассивные предметы"
            },
        },
        [mod.Items.RewrappingPaper] = {
            en_us = { 
                "Every {{TreasureRoom}} Treasure room pedestal will become {{Collectible515}} Mystery Gift.",
                "If there're two pedestals, at least one of them will be {{Collectible515}} Mystery Gift."
            },
            ru = { 
                "Все пьедесталы в {{TreasureRoom}} Сокровищнице станут {{Collectible515}} Загадочным Подарком",
                "Если в ней 2 пьедестала, по крайней мере один из них станет {{Collectible515}} Загадочным Подарком"
            },
        },
        [mod.Items.FilthyRich] = {
            en_us = { 
                "The more {{Coin}} coins Isaac have, the higher the chance for {{Poison}} poison tears and {{Poison}} poison clouds to spawn.",
            },
            ru = { 
                "Чем больше {{Coin}} монет есть у Исаака, тем больше шанс на {{Poison}} отравляющие слёзы и создание {{Poison}} отравляющих облаков",
            },
        },
        [mod.Items.CoolStick] = {
            en_us = { 
                "{{Damage}} +0.4 Damage up",
                "{{Luck}} +1 Luck up",
                "{{Chest}} 15% chance for spawned chests to turn into {{WoodenChestRoomIcon}} Wooden Chests",
            },
            ru = { 
                "{{Damage}} +0.4 Урона",
                "{{Luck}} +1 Удача",
                "{{Chest}} 15% шанс заменить сундук на {{WoodenChestRoomIcon}} Деревянный Сундук",
            },
        },
        [mod.Items.Grudge] = {
            en_us = { 
                "When you take damage from an enemy, that enemy type becomes marked",
                "Enemies of that type take double damage for the rest of the run"
            },
            ru = { 
                "При получении урона от врага, этот тип врагов помечается",
                "Враги этого типа получают двойной урон весь забег"
            },
        },
        [mod.Items.BloodBattery] = {
            en_us = { 
                "Taking damage has a chance to drop a {{Battery}} battery"
            },
            ru = { 
                "Шанс создать {{Battery}} батарейку при получении урона"
            },
        },
        [mod.Items.DeliriousMind] = {
            en_us = { 
                "Isaac gets +0.15 {{Damage}} damage up and {{Tears}} +0.15 tears up for every modded item"
            },
            ru = { 
                "+0.15 {{Damage}} Урона и {{Tears}} +0.15 Слёз за каждый предмет из модов"
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
            ru = { 
                "{{ArrowUp}}Защищает от 1 попадания в комнате",
                "{{ArrowUp}}+0.1 {{Speed}}скорости",
                "{{ArrowUp}}+3 {{Luck}}удачи",
                "{{ArrowUp}}x1.5 {{Damage}}множитель урона",
                "При потере щита x1.5 множитель урона пропадёт",
                "{{Warning}}Получение урона после потери щита:",
                "{{ArrowDown}}x0.3 множитель урона",
                "{{ArrowDown}}-5 удачи",
                "{{ArrowDown}} Даёт 2 {{BrokenHeart}}разбитых сердца",
                "Множитель урона будет сброшен до x1.5 при заходе в новую комнату"
            },
        },
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
        [mod.Items.RedBum] = {
			en_us = { 
                "Takes {{Key}}keys and has a chance to spawn red key"
            },
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
                "30% шанс создать предмет {{Quality4}} качества",
                "70% шанс создать {{Collectible36}}Какашку",
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
            ru = {
                "Создаёт случайного попрошайку",
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
        [mod.Trinkets.Gaga] = {
            en_us = {
                "Increased chance to transform regular Bombs, Keys and Coins into their golden variants"
            },
            ru = {
                "Увеличенный шанс превратить обычные Бомбы, Ключи и Монеты в их золотые вариации"
            }
        },
        [mod.Trinkets.WonderOfYou] = {
            en_us = {
                "Taking damage has a 5% chance to instantly kill all non-boss enemies in the room",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}Taking damage has a 10% chance to instantly kill all non-boss enemies in the room"
                    end
                }
            },
            ru = {
                "При получении урона 5% шанс мгновенно убить всех врагов не боссов в комнате",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + (1 << 15)
                    end,
                    function()
                        return "{{ColorGold}}При получении урона 10% шанс мгновенно убить всех врагов не боссов в комнате"
                    end
                }
            }
        },
        [mod.Trinkets.RottenFood] = {
            en_us = {
                "All {{Heart}}heart pickups will be {{RottenHeart}}rotten hearts"
            },
            ru = {
                "Все {{Heart}}сердца будут {{RottenHeart}}гнилыми сердцами"
            },
        },
        [mod.Trinkets.SecondBreakfast] = {
            en_us = {
                "When collecting a food item, spawns a second one"
            },
            ru = {
                "При получении предмета еды создаёт ещё один"
            },
        },
        [mod.Trinkets.Papercut] = {
            en_us = {
                "Using a card causes all enemies to bleed"
            },
            ru = {
                "При использовании карты накладывает кровотечение на врагов"
            },
        },
        [mod.Trinkets.TarotBattery] = {
            en_us = {
                "Using a card adds +1 charge to the active item"
            },
            ru = {
                "При использовании карты даёт +1 заряд к активному предмету"
            },
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
            ru = {
                "{{Heart}}Лечит красные сердца",
                "Если есть {{BrokenHeart}} разбитые сердца, это также излечит их",
                "{{Warning}}Лечение контейнера сердца стоит понижение характеристик",
                "{{Warning}}Лечение {{BrokenHeart}} разбитых сердец стоит предметы"
            },
        },
        [mod.Cards.alpoh] = {
            en_us = {
                "Gives a random {{AngelRoom}} angel room item",
                "Cost 2 {{BrokenHeart}} broken hearts"
            },
            ru = {
                "Даёт случайный {{AngelRoom}} ангельский предмет",
                "Стоит 2 {{BrokenHeart}} разбитых сердца"
            },
        },
        [mod.Cards.StarShard] = {
            en_us = {
                "Change a pedestal into a Planetarium or Planetarium related item",
                "If there's no pedestal in the room it will give one soul heart instead"
            },
            ru = {
                "Меняет предмет на предмет из Планетария",
                "Если предметов нет, даст 1 сердца души"
            },
        },
        [mod.Cards.EnergyDrink] = {
            en_us = {
                "{{ArrowUp}}Gives +0.5 to all the stats for the room",
                "{{Warning}}After 15 seconds Isaac gets {{ArrowDown}}-0.1 stats penalty for the room"
            },
            ru = {
                "{{ArrowUp}}Даёт +0.5 ко всем характеристикам на комнату",
                "{{Warning}}После 15 секунд Исаак получает штрафное {{ArrowDown}}-0.1 к характеристикам на комнату"
            },
        },
        [mod.Cards.DadsLottoTicket] = {
            en_us = {
                "Has a chance to spawn a combination of coins.",
                "Nothing: 25%",
                "{{Blank}}{{Coin}}: 60",
                "{{Coin}}{{Coin}}: 9%",
                "{{Nickel}}: 5%",
                "{{ColorGold}}A prize: 1%",
                {
                    function(_, player)
                        return player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
                    end,
                    function()
                        return "{{Collectible46}}: Increases the chance of {{ColorGold}}the prize{{CR}} to 2%"
                    end
                },
                "Possible Prizes:",
                "{{Dime}}: 0.2%",
                "{{Crafting26}}: 0.2%",
                "{{Crafting11}}: 0.1%",
                "3{{ColorGray}}_{{Nickel}}_{{CR}}: 0.1%",
                "10{{Coin}}{{Coin}}: 0.05%",
                "10{{ColorGray}}_{{Nickel}}_{{CR}}: 0.05%",
                "{{Dime}}, {{Crafting11}}, {{Crafting26}}: 0.05%",
                "2{{Dime}}, 2{{Crafting11}}, 2{{Crafting26}}: 0.05%",
                "6{{Dime}}: 0.04%",
                "4{{Crafting26}}: 0.04%",
                "5{{Crafting11}}: 0.02%",
                "2{{Dime}}, 5{{Crafting26}}: 0.03%",
                "3{{Crafting11}}, {{Coin}}{{Coin}}, {{Nickel}}, {{Dime}}: 0.03%",
                "2{{Crafting26}}, 3{{Crafting11}}: 0.02%",
                "6{{Nickel}}, 6{{ColorGray}}_{{Nickel}}_{{CR}}: 0.02%"
            },
            ru = {
                "Шанс создать Монету, Пятак или Гривенник",
                "Есть шанс не создать ничего",
                "!!! Outdated description.",
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
            },
		},
        [mod.Pills.BLESSED] = {
			en_us = {
                "Removes current curses"
            },
            ru = {
                "Убирает текущие проклятия"
            },
		},
        [mod.Pills.HEARTBREAK] = {
			en_us = {
                "Adds a {{BrokenHeart}}broken heart"
            },
            ru = {
                "Даёт {{BrokenHeart}}разбитое сердце"
            },
		},
        [mod.Pills.POWER_DRAIN] = {
			en_us = {
                "Empties active item charge"
            },
            ru = {
                "Опустошает заряд активного предмета"
            },
		},
        [mod.Pills.VOMIT] = {
			en_us = {
                "Spawn a random {{Trinket}} trinket"
            },
		},
        [mod.Pills.SOMETHING_CHANGED] = {
			en_us = {
                "Change held {{Trinket}} trinket(s)"
            },
		},
        [mod.Pills.EQUAL] = {
			en_us = {
                "Equalizes your coins, bombs and keys"
            },
            ru = {
                "Приравнивает монеты, бомбы и ключи"
            },
		}
	}
}
