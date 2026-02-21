if Encyclopedia then
    local save = require("scripts.dependencies.save_manager")
    local Enums = require("scripts.core.enums")

    local Wiki = {
        David = {
			{ -- Start Data
                {str = "Start Data", fsize = 2, clr = 3, halign = 0},
                {str = "Active Item: Slingshot"},
                {str = "Smelted Trinket: Gaga"},
                {str = "Stats", clr = 3, halign = 0},
				{str = "HP: 1 red hear, 1 gold heart"},
				{str = "Speed: 1.20"},
				{str = "Tears: 2.50"},
				{str = "Damage: 6.00"},
				{str = "Range: 6.50"},
				{str = "Shotspeed: 1.00"},
				{str = "Luck: 1"},
			},
            { -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "David knows a secret chord, he loves music and always feels the Muse."},
				{str = "He loves gold."},
			},
			{ -- Birthright
			{str = "Birthright", fsize = 2, clr = 3, halign = 0},
			{str = "Does double damage to bosses."},
			},
			{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "Just like the original David, ours also have a red hair."},
			{str = "David theme is revovled around music and gold."},
		},

		},
			{ -- Transformation
				{str = "Dad's Old Playlist", fsize = 2, clr = 3, halign = 0},
				{str = "Collecting 3 Old music references items give you the Dad's old playlist transformation."},
				{str = "Gives you +2 tears up"},
				{str = "When shooting it can create a small shockwave that knockback and can charm enemies."},
			},
		}
    end
