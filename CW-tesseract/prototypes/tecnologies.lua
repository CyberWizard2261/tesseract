data:extend
({

	{
		type = "technology",
		name = "CW-tesseract-energy-distribution-2",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"steel-processing","electronics"},
		unit = 
		{
			count = "100",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-source-pole-2",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-leech-pole-2",
			},
		},

	},



	{
		type = "technology",
		name = "CW-tesseract-energy-distribution-3",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"CW-tesseract-energy-distribution-2","advanced-electronics"},
		unit = 
		{
			count = "500",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-source-pole-3",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-leech-pole-3",
			},
		},

	},
	{
		type = "technology",
		name = "CW-tesseract-energy-distribution-4",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"CW-tesseract-energy-distribution-3","advanced-electronics-2"},
		unit = 
		{
			count = "2500",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-source-pole-4",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-power-leech-pole-4",
			},
		},

	},
---------------------------------------------------
	{
		type = "technology",
		name = "CW-tesseract-portable-distribution-1",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"CW-tesseract-energy-distribution-2","modular-armor"},
		unit = 
		{
			count = "100",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-portable-source-1",
			},
		},

	},
	{
		type = "technology",
		name = "CW-tesseract-portable-distribution-2",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"CW-tesseract-energy-distribution-3","CW-tesseract-portable-distribution-1"},
		unit = 
		{
			count = "500",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-portable-source-2",
			},
		},

	},
	{
		type = "technology",
		name = "CW-tesseract-portable-distribution-3",
		icon_size = 128,
		icon = "__CW-tesseract__/graphics/tech/energy-distribution.png",
		prerequisites = {"CW-tesseract-energy-distribution-4","CW-tesseract-portable-distribution-2"},
		unit = 
		{
			count = "2500",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-portable-source-3",
			},
		},

	},








-----------------------------------------------------










	{
		type = "technology",
		name = "CW-tesseract-logistics",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/storage.png",
		prerequisites = {"steel-processing"},
		unit = 
		{
			count = "50",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-materializer-chest",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-desmaterializer-chest",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-materializer-tank",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-desmaterializer-tank",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-connector",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-mini-materializer-tank",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-mini-desmaterializer-tank",
			},
			{
				type = "nothing",
				effect_description = {"effect-description.CW-increase-drain"},
			},
		},

	},


	{
		type = "technology",
		name = "CW-tesseract-logistics-2",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/storage.png",
		prerequisites = {"CW-tesseract-logistics","logistic-system"},
		unit = 
		{
			count = 100,
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-logistic-materializer-chest",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-logistic-desmaterializer-chest",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-logistic-equip",
			},
		},

	},

	{
		type = "technology",
		name = "CW-tesseract-teleporter",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/teleporter.png",
		prerequisites = {"CW-tesseract-logistics"},
		unit = 
		{
			count = 1000,
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "unlock-recipe",
				recipe = "CW-ts-teleporter",
			},
			{
				type = "unlock-recipe",
				recipe = "CW-ts-teleport-beacon",
			},
		},

	},



	
	{
		type = "technology",
		name = "CW-tesseract-energy-capacity",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/energy.png",
		max_level = "infinite",
		unit = 
		{
			count_formula = "10*L",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "nothing",
				effect_description = {"effect-description.CW-tesseract-energy-capacity"},
			},
		},

	},

	{
		type = "technology",
		name = "CW-tesseract-infinite-storage",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/storage.png",
		max_level = "infinite",
		prerequisites = {"CW-tesseract-logistics"},
		unit = 
		{
			count_formula = "1000*L",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "nothing",
				effect_description = {"effect-description.CW-tesseract-infinite-storage"},
			},
		},

	},

	{
		type = "technology",
		name = "CW-tesseract-storage-capacity",
		icon_size = 256,
		icon = "__CW-tesseract__/graphics/tech/storage.png",
		max_level = "infinite",
		prerequisites = {"CW-tesseract-logistics"},
		unit = 
		{
			count_formula = "10*L",
			ingredients =
			{
				{"CW-ts-fragment",1},
			},
			time = 10,
		},

		effects = 
		{
			{
				type = "nothing",
				effect_description = {"effect-description.CW-tesseract-storage-capacity"},
			},
		},

	},


})


if mods["CW-orbital-solar-power"] then
	data:extend
	({
		{
			type = "technology",
			name = "CW-tesseract-solar-satellite",
			icon_size = 128,
			icon = "__CW-orbital-solar-power__/graphics/tech/solar-power.png",
			prerequisites = {"CW-tesseract-energy-distribution-2", "CW-orbital-solar-power"},
			unit = 
			{
				count = 100,
				ingredients =
				{
					{"CW-ts-fragment",1},
				},
				time = 10,
			},

			effects = 
			{
				{
					type = "unlock-recipe",
					recipe = "CW-ts-solar-satellite",
				},
			},

		},
		
	})
end

































