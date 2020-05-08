require("prototypes.graphics")


local tesseract = 
{
	type = "electric-energy-interface",
	name = "CW-tesseract",
	max_health = 500,
	
	icon = "__CW-tesseract__/graphics/icons/tesseract.png",
	icon_size = 64,
	
	collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
	collision_mask = {},
	drawing_box = {{-1.5, -2}, {1.5, 1.5}},
	selectable_in_game = false,
	flags = {"placeable-player","player-creation","placeable-off-grid"},
	corpse = "medium-remnants",
	
	create_ghost_on_death = false,
	
	order = "ab",
	resistances = {},
	collision_mask = {},
	
	energy_source = 
	{
		type = "electric",
		usage_priority = "tertiary",
		render_no_power_icon = true,
		emissions_per_minute = 0,
		buffer_capacity = "20MJ",
		input_flow_limit = "1MW",
		output_flow_limit = "1MW",
	},
	
	continuous_animation = true,
	animation = graphic.tesseract_animation,
	
}

local ts_box = 
{
	type = "container",
	name = "CW-ts-altar",
	max_health = 500,
	resistances = {},
	icon = "__CW-tesseract__/graphics/icons/leech.png",
	icon_size = 64,
	
	inventory_size = 50,
	enable_inventory_bar = false,
	loot = {{item = "CW-tesseract"}},
	
	corpse = "medium-remnants",
	create_ghost_on_death = false,
	
	collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
	selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
	
	
	minable = {mining_time = 0.5, result = "CW-ts-altar"},
	--circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
	picture = graphic.altar
}

local ts_lab = table.deepcopy(data.raw.lab.lab)
ts_lab.name = "CW-ts-lab"
ts_lab.minable.result = "CW-ts-lab"
ts_lab.next_upgrade = ""
ts_lab.fast_replaceable_group = ""
ts_lab.energy_usage = "200KW"
table.insert(ts_lab.inputs,"CW-ts-fragment")
ts_lab.researching_speed = 3
ts_lab.loot = {{item = "CW-ts-fragment"}}
--ts_lab.off_animation
--ts_lab.on_animation




local power_leech_pole_1 = 
{
	name = "CW-ts-power-leech-pole-1",
	type = "electric-pole",
	icon = "__CW-tesseract__/graphics/icons/leech.png",
	icon_size = 64,
	collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	drawing_box = {{-0.5, -1.5}, {0.5, 0.5}},
	flags = {"placeable-neutral","player-creation",},
	
	supply_area_distance = 10,
	maximum_wire_distance = 22,
	track_coverage_during_build_by_moving = true,
	fast_replaceable_group = "CW-leech-pole",
	next_upgrade = "CW-ts-power-leech-pole-2",
	draw_circuit_wires = false,
	radius_visualisation_picture = 
	{
		filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
		height = 12,
		priority = "extra-high-no-scale",
		width = 12
	},
	corpse = "small-remnants",
	max_health = 100,
	
	loot = {{item = "CW-ts-fragment"}},
	minable = {mining_time = 1, result = "CW-ts-power-leech-pole-1"},
	
	connection_points =
	{
		{
			wire = {copper = {0,-2}},
			shadow = {copper = {2.6,0}},
		}
	},
	resistances = 
	{
		{type = "fire", percent = 60},
		{type = "explosion",percent = 20},
	},
	
	pictures = graphic.leech_pic,
	light = 
	{
		type = "basic",
		intensity = 0.8,
		size = 10,
	}
}

local power_leech_pole_2 = table.deepcopy(power_leech_pole_1)
power_leech_pole_2.name = "CW-ts-power-leech-pole-2"
power_leech_pole_2.max_health = 200
power_leech_pole_2.supply_area_distance = 15
power_leech_pole_2.light.size = 15
power_leech_pole_2.maximum_wire_distance = 33
power_leech_pole_2.next_upgrade = "CW-ts-power-leech-pole-3"
power_leech_pole_2.minable.result = "CW-ts-power-leech-pole-2"
power_leech_pole_2.loot = {{item = "CW-ts-fragment",count_min = 10, count_max = 10}}

local power_leech_pole_3 = table.deepcopy(power_leech_pole_1)
power_leech_pole_3.name = "CW-ts-power-leech-pole-3"
power_leech_pole_3.max_health = 300
power_leech_pole_3.supply_area_distance = 20
power_leech_pole_3.light.size = 20
power_leech_pole_3.maximum_wire_distance = 43
power_leech_pole_3.next_upgrade = "CW-ts-power-leech-pole-4"
power_leech_pole_3.minable.result = "CW-ts-power-leech-pole-3"
power_leech_pole_3.loot = {{item = "CW-ts-fragment",count_min = 100, count_max = 100}}

local power_leech_pole_4 = table.deepcopy(power_leech_pole_1)
power_leech_pole_4.name = "CW-ts-power-leech-pole-4"
power_leech_pole_4.max_health = 400
power_leech_pole_4.supply_area_distance = 30
power_leech_pole_4.light.size = 30
power_leech_pole_4.maximum_wire_distance = 64
power_leech_pole_4.next_upgrade = ""
power_leech_pole_4.minable.result = "CW-ts-power-leech-pole-4"
power_leech_pole_4.loot = {{item = "CW-ts-fragment",count_min = 1000, count_max = 1000}}


local power_source_pole_1 = table.deepcopy(power_leech_pole_1)
power_source_pole_1.icon = "__CW-tesseract__/graphics/icons/source.png"
power_source_pole_1.name = "CW-ts-power-source-pole-1"
power_source_pole_1.fast_replaceable_group = "CW-source-pole"
power_source_pole_1.next_upgrade = "CW-ts-power-source-pole-2"
power_source_pole_1.minable.result = "CW-ts-power-source-pole-1"
power_source_pole_1.pictures = graphic.source_pic

local power_source_pole_2 = table.deepcopy(power_leech_pole_2)
power_source_pole_2.icon = "__CW-tesseract__/graphics/icons/source.png"
power_source_pole_2.name = "CW-ts-power-source-pole-2"
power_source_pole_2.fast_replaceable_group = "CW-source-pole"
power_source_pole_2.next_upgrade = "CW-ts-power-source-pole-3"
power_source_pole_2.minable.result = "CW-ts-power-source-pole-2"
power_source_pole_2.pictures = graphic.source_pic

local power_source_pole_3 = table.deepcopy(power_leech_pole_3)
power_source_pole_3.icon = "__CW-tesseract__/graphics/icons/source.png"
power_source_pole_3.name = "CW-ts-power-source-pole-3"
power_source_pole_3.fast_replaceable_group = "CW-source-pole"
power_source_pole_3.next_upgrade = "CW-ts-power-source-pole-4"
power_source_pole_3.minable.result = "CW-ts-power-source-pole-3"
power_source_pole_3.pictures = graphic.source_pic

local power_source_pole_4 = table.deepcopy(power_leech_pole_4)
power_source_pole_4.icon = "__CW-tesseract__/graphics/icons/source.png"
power_source_pole_4.name = "CW-ts-power-source-pole-4"
power_source_pole_4.fast_replaceable_group = "CW-source-pole"
power_source_pole_4.next_upgrade = ""
power_source_pole_4.minable.result = "CW-ts-power-source-pole-4"
power_source_pole_4.pictures = graphic.source_pic







local power_leech_1 = 
{
	name = "CW-ts-power-leech-1",
	type = "accumulator",
	icon = "__CW-tesseract__/graphics/icons/leech.png",
	icon_size = 64,
	max_health = 200,
	
	charge_cooldown = 5,
	discharge_cooldown = 5,
	
	corpse = "small-remnants",
	collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
	collision_mask = {},
	picture = 
	{
		filename = "__CW-tesseract__/graphics/entity/void.png",
		width = 1,
		height = 1,
	},

	energy_source =
	{
		type = "electric",
		buffer_capacity = "10MJ",
		usage_priority = "tertiary",
		input_flow_limit = "1MW",
		output_flow_limit = "0W"
	},
}

local power_leech_2 = table.deepcopy(power_leech_1)
power_leech_2.name = "CW-ts-power-leech-2"
power_leech_2.energy_source.buffer_capacity = "100MJ"
power_leech_2.energy_source.input_flow_limit = "10MW"

local power_leech_3 = table.deepcopy(power_leech_1)
power_leech_3.name = "CW-ts-power-leech-3"
power_leech_3.energy_source.buffer_capacity = "1000MJ"
power_leech_3.energy_source.input_flow_limit = "100MW"

local power_leech_4 = table.deepcopy(power_leech_1)
power_leech_4.name = "CW-ts-power-leech-4"
power_leech_4.energy_source.buffer_capacity = "10000MJ"
power_leech_4.energy_source.input_flow_limit = "1000MW"





local power_source_1 = table.deepcopy(power_leech_1)
power_source_1.icon = "__CW-tesseract__/graphics/icons/source.png"
power_source_1.name = "CW-ts-power-source-1"
power_source_1.energy_source.buffer_capacity = "10MJ"
power_source_1.energy_source.input_flow_limit = "0W"
power_source_1.energy_source.output_flow_limit = "1MW"

local power_source_2 = table.deepcopy(power_source_1)
power_source_2.name = "CW-ts-power-source-2"
power_source_2.energy_source.buffer_capacity = "100MJ"
power_source_2.energy_source.output_flow_limit = "10MW"

local power_source_3 = table.deepcopy(power_source_1)
power_source_3.name = "CW-ts-power-source-3"
power_source_3.energy_source.buffer_capacity = "1000MJ"
power_source_3.energy_source.output_flow_limit = "100MW"

local power_source_4 = table.deepcopy(power_source_1)
power_source_4.name = "CW-ts-power-source-4"
power_source_4.energy_source.buffer_capacity = "10000MJ"
power_source_4.energy_source.output_flow_limit = "1000MW"


local materializer_chest = table.deepcopy(data.raw.container["steel-chest"])
materializer_chest.name = "CW-ts-materializer-chest"
materializer_chest.loot = {{item = "CW-ts-fragment",count_min = 5, count_max = 5}}
materializer_chest.max_health = 300
materializer_chest.minable.result = "CW-ts-materializer-chest"
materializer_chest.inventory_size = 100
materializer_chest.enable_inventory_bar = false
materializer_chest.next_upgrade = ""
--materializer_chest.fast_replaceable_group = ""
materializer_chest.icon = "__CW-tesseract__/graphics/icons/m-chest.png"
materializer_chest.icon_size = 64
materializer_chest.picture = graphic.materializer_chest_pic


local desmaterializer_chest = table.deepcopy(data.raw.container["steel-chest"])
desmaterializer_chest.name = "CW-ts-desmaterializer-chest"
desmaterializer_chest.loot = {{item = "CW-ts-fragment",count_min = 5, count_max = 5}}
desmaterializer_chest.max_health = 300
desmaterializer_chest.minable.result = "CW-ts-desmaterializer-chest"
desmaterializer_chest.inventory_size = 100
desmaterializer_chest.enable_inventory_bar = false
desmaterializer_chest.next_upgrade = ""
desmaterializer_chest.icon = "__CW-tesseract__/graphics/icons/d-chest.png"
desmaterializer_chest.icon_size = 64
desmaterializer_chest.picture = graphic.desmaterializer_chest_pic


local logistic_desmaterializer_chest = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_desmaterializer_chest.name = "CW-ts-logistic-desmaterializer-chest"
logistic_desmaterializer_chest.loot = {{item = "CW-ts-fragment",count_min = 5, count_max = 5}}
logistic_desmaterializer_chest.max_health = 300
logistic_desmaterializer_chest.minable.result = "CW-ts-logistic-desmaterializer-chest"
logistic_desmaterializer_chest.inventory_size = 100
logistic_desmaterializer_chest.enable_inventory_bar = false
logistic_desmaterializer_chest.next_upgrade = ""
logistic_desmaterializer_chest.icon = "__CW-tesseract__/graphics/icons/ld-chest.png"
logistic_desmaterializer_chest.icon_size = 64
logistic_desmaterializer_chest.picture = graphic.logistic_desmaterializer_chest_pic
logistic_desmaterializer_chest.animation = nil


local logistic_materializer_chest = table.deepcopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
logistic_materializer_chest.name = "CW-ts-logistic-materializer-chest"
logistic_materializer_chest.loot = {{item = "CW-ts-fragment",count_min = 5, count_max = 5}}
logistic_materializer_chest.max_health = 300
logistic_materializer_chest.minable.result = "CW-ts-logistic-materializer-chest"
logistic_materializer_chest.inventory_size = 100
logistic_materializer_chest.enable_inventory_bar = false
logistic_materializer_chest.next_upgrade = ""
logistic_materializer_chest.icon = "__CW-tesseract__/graphics/icons/lm-chest.png"
logistic_materializer_chest.icon_size = 64
logistic_materializer_chest.picture = graphic.logistic_materializer_chest_pic
logistic_materializer_chest.animation = nil


local wreck = table.deepcopy(data.raw.container["big-ship-wreck-1"])
wreck.minable = {mining_time = 1, results = {{type = "item", name = "iron-plate", amount = 5}}}



local desmaterializer_tank = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
desmaterializer_tank.name = "CW-ts-desmaterializer-tank"
desmaterializer_tank.loot = {{item = "CW-ts-fragment",count_min = 5, count_max = 5}}
desmaterializer_tank.max_health = 800
desmaterializer_tank.minable.result = "CW-ts-desmaterializer-tank"
desmaterializer_tank.next_upgrade = ""
desmaterializer_tank.corpse = "medium-remnants"
desmaterializer_tank.two_direction_only = false
desmaterializer_tank.circuit_wire_max_distance = 0
desmaterializer_tank.circuit_wire_connection_points = nil
desmaterializer_tank.circuit_connector_sprites = nil
desmaterializer_tank.pictures = graphic.desmaterializer_tank_pic
desmaterializer_tank.fluid_box = 
{
	base_area = 500,
	pipe_connections = 
	{
		{position= {0,-2}},
		{position= {2,0}},
		{position= {-2,0}},
		{position= {0,2}},
	},
	pipe_covers = graphic.pipe_covers,
}

	
local materializer_tank = table.deepcopy(desmaterializer_tank)
materializer_tank.name = "CW-ts-materializer-tank"
materializer_tank.minable.result = "CW-ts-materializer-tank"
materializer_tank.pictures = graphic.materializer_tank_pic


local mini_desmaterializer_tank = table.deepcopy(desmaterializer_tank)
mini_desmaterializer_tank.name = "CW-ts-mini-desmaterializer-tank"
mini_desmaterializer_tank.max_health = 300
mini_desmaterializer_tank.minable.result = "CW-ts-mini-desmaterializer-tank"
mini_desmaterializer_tank.corpse = "small-remnants"
mini_desmaterializer_tank.collision_box = {{-0.7,-0.7},{0.7,0.7}}
mini_desmaterializer_tank.selection_box = {{-1,-1},{1,1}}
mini_desmaterializer_tank.pictures = graphic.mini_desmaterializer_tank_pic
mini_desmaterializer_tank.fluid_box = 
{	
	base_area = 250,
	pipe_covers = graphic.pipe_covers,
	pipe_connections = 
	{
		{position= {-0.5,-1.5}},
		{position= {0.5,-1.5}},
		{position= {-0.5,1.5}},
		{position= {0.5,1.5}},
		{position= {-1.5,-0.5}},
		{position= {-1.5,0.5}},
		{position= {1.5,-0.5}},
		{position= {1.5,0.5}},
	}
	
}

local mini_materializer_tank = table.deepcopy(mini_desmaterializer_tank)
mini_materializer_tank.name = "CW-ts-mini-materializer-tank"
mini_materializer_tank.minable.result = "CW-ts-mini-materializer-tank"
mini_materializer_tank.pictures = graphic.mini_materializer_tank_pic



local teleport = 
{
	type = "car",
	name = "CW-ts-teleporter",
	max_health = 500,
	icon = "__CW-tesseract__/graphics/icons/teleporter.png",
	icon_size = 64,
	minable = {mining_time = 1 , result = "CW-ts-teleporter"},
	flags = {"not-rotatable","placeable-player","player-creation",},
	energy_source = {type = "void"},
	inventory_size = 0,
	consumption = "1W",
	rotation_speed = 0,
	effectivity = 0,
	map_color = {r=1, g=0, b=0, a=0.5},
	--render_layer = "floor",
	has_belt_immunity = true,
	collision_box = {{-1.3,-1.3},{1.3,1.3}},
	collision_mask = {"object-layer", "water-tile","item-layer"},
	selection_box = {{-1.5,-1.5},{1.5,1.5}},
	loot = {{item = "CW-ts-fragment",count_min = 50, count_max = 50}},
	corpse = "medium-remnants",
	braking_force = 10,
	energy_per_hit_point =0,
	weight = 100,
	friction = 100,
	
	animation = graphic.teleporter_pic,
}


local teleport_beacon = 
{
	type = "lab",
	name = "CW-ts-teleport-beacon",
	max_health = 100,
	icon = "__CW-tesseract__/graphics/icons/beacon.png",
	icon_size = 64,
	minable = {mining_time = 1 , result = "CW-ts-teleport-beacon"},
	flags = {"not-rotatable","placeable-player","player-creation",},
	map_color = {r=1, g=0, b=0, a=0.5},
	render_layer = "floor",
	collision_box = {{-0.8,-0.8},{0.8,0.8}},
	collision_mask = {"object-layer", "water-tile","item-layer"},
	selection_box = {{-1,-1},{1,1}},
	corpse = "small-remnants",
	loot = {{item = "CW-ts-fragment",count_min = 1, count_max = 1}},
	energy_source = {type = "void"},
	energy_usage = "1W",
	
	
	inputs = {},
	module_specification = {module_slots = 0},
	
	on_animation = graphic.teleport_beacon_pic,
	off_animation = graphic.teleport_beacon_pic,
}




local connector = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
connector.name = "CW-ts-connector"
connector.minable.result = "CW-ts-connector"
connector.circuit_wire_max_distance = 20
connector.item_slot_count = 300
connector.sprites = graphic.connector_pic



data:extend({teleport,teleport_beacon})
data:extend({logistic_desmaterializer_chest,logistic_materializer_chest})
data:extend({desmaterializer_tank,materializer_tank,connector, mini_materializer_tank, mini_desmaterializer_tank})
data:extend({tesseract,ts_box,ts_lab,materializer_chest,desmaterializer_chest,wreck})
data:extend({power_leech_pole_1,power_leech_pole_2,power_leech_pole_3,power_leech_pole_4,})
data:extend({power_source_pole_1,power_source_pole_2,power_source_pole_3,power_source_pole_4,})
data:extend({power_leech_1,power_leech_2,power_leech_3,power_leech_4,})
data:extend({power_source_1,power_source_2,power_source_3,power_source_4})






