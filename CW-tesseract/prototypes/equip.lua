data:extend
({
	{
		type = "battery-equipment",
		name = "CW-ts-portable-source-1",
		sprite =
		{
			filename = "__CW-tesseract__/graphics/equip/provider.png",
			width = 64,
			height = 128,
			priority = "medium",
		},
		shape =
		{
			width = 2,
			height = 4,
			type = "full"
		},
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-output",
			buffer_capacity = "10MJ",
			input_flow_limit = "0W",
			output_flow_limit = "1MW"
		},
		
		categories = {"armor"},
	},
	{
		type = "battery-equipment",
		name = "CW-ts-portable-source-2",
		sprite =
		{
			filename = "__CW-tesseract__/graphics/equip/provider.png",
			width = 64,
			height = 128,
			priority = "medium",
		},
		shape =
		{
			width = 2,
			height = 4,
			type = "full"
		},
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-output",
			buffer_capacity = "20MJ",
			input_flow_limit = "0W",
			output_flow_limit = "2MW"
		},
		
		categories = {"armor"},
	},
	{
		type = "battery-equipment",
		name = "CW-ts-portable-source-3",
		sprite =
		{
			filename = "__CW-tesseract__/graphics/equip/provider.png",
			width = 64,
			height = 128,
			priority = "medium",
		},
		shape =
		{
			width = 2,
			height = 4,
			type = "full"
		},
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-output",
			buffer_capacity = "40MJ",
			input_flow_limit = "0W",
			output_flow_limit = "4MW"
		},
		
		categories = {"armor"},
	},
	{
		type = "battery-equipment",
		name = "CW-ts-logistic-equip",
		sprite =
		{
			filename = "__CW-tesseract__/graphics/equip/logistic-module.png",
			width = 128,
			height = 128,
			priority = "medium",
		},
		shape =
		{
			width = 4,
			height = 4,
			type = "full"
		},
		energy_source =
		{
			type = "electric",
			usage_priority = "tertiary",
			buffer_capacity = "10J",
			input_flow_limit = "1W",
			output_flow_limit = "1W"
		},
		
		categories = {"CW-ts-logistic"},
	},

})