require("script.runtime_functions")
require("script.GUI")



force_MD = {}
player_MD = {}

local game_load = true

local function TS_update(force)
	local interface = global.tesseract_data[force.index].tesseract.interface
	local ts_transfer = (interface.electric_buffer_size / 2) - interface.energy 
	local transfer = 0
	if ts_transfer < 0 then
		transfer = ts_transfer
	else
		transfer = math.min(global.tesseract_data[force.index].energy ,ts_transfer)
	end

	interface.energy = interface.energy + transfer
	global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy - transfer
end


local function leech_power(force)
	if valid(global.tesseract_data[force.index].tesseract.altar) then
		for _ , leecher in pairs(global.tesseract_data[force.index].power_leeches) do
			if valid(leecher.interface) then
				global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy + leecher.interface.energy
				leecher.interface.energy = 0
			end
		end
	end
end

local function provide_power(force)
	if valid(global.tesseract_data[force.index].tesseract.altar) then
		for _ , source in pairs(global.tesseract_data[force.index].power_sources) do
			if valid(source.interface) and global.tesseract_data[force.index].energy > 0 then
				local transfer = math.min(global.tesseract_data[force.index].energy, source.interface.electric_buffer_size - source.interface.energy)
				source.interface.energy = source.interface.energy + transfer
				global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy - transfer
			end
		end
	end
end

local function make_fragments(force)
	if valid(global.tesseract_data[force.index].tesseract.altar) then
		while global.tesseract_data[force.index].energy > global.tesseract_data[force.index].maxEnergy do
			local iserted = global.tesseract_data[force.index].tesseract.altar.insert({name = "CW-ts-fragment"})
			global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy - 10^8 -- 100MJ
			if iserted == 0 then
				local tesseract = global.tesseract_data[force.index].tesseract.altar
				tesseract.surface.spill_item_stack(tesseract.position,{name = "CW-ts-fragment"}, true, tesseract.force,false)
			end
		end
	end
end



local function recharge_equip(force)
	if  valid(global.tesseract_data[force.index].tesseract.altar) then
		for idx , equip in pairs(global.tesseract_data[force.index].equips) do
			if valid(equip) then
				if global.tesseract_data[force.index].energy > 0 then
					local transfer = math.min(global.tesseract_data[force.index].energy, equip.max_energy - equip.energy)
					equip.energy = equip.energy + transfer
					global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy - transfer
				end
			else
				global.tesseract_data[force.index].equips[idx] = nil
				--game.print("remove equip")
			end
		end
	end
end


local function produce_power(force)
	if valid(global.tesseract_data[force.index].tesseract.altar) then
		global.tesseract_data[force.index].energy = global.tesseract_data[force.index].energy + force_MD[force.index].energyProduction - force_MD[force.index].energyDrain
		if global.tesseract_data[force.index].energy < 0 then
			--net production include drain and energy cannot be below 0
			global.tesseract_data[force.index].energy = 0
		end
	end
end


local function materialize_items(force)
	if global.tesseract_data[force.index].energy > 0 and valid(global.tesseract_data[force.index].tesseract.altar) then
		for idx , chest in pairs(global.tesseract_data[force.index].materializer_chests) do
			if valid(chest.chest) then
				if valid(chest.m_connector) then
					local inventory = chest.chest.get_inventory(defines.inventory.chest)
					local requests = chest.m_connector.get_merged_signals()
					if requests ~= nil then
						for _ , request in pairs(requests) do
							if request.signal.type == "item" then
								local insertable = inventory.get_insertable_count(request.signal.name)
								local ts_stored = 0
								if global.tesseract_data[force.index].storages[request.signal.name] ~= nil then
									ts_stored = global.tesseract_data[force.index].storages[request.signal.name].item_count
								end
								local content = inventory.get_contents()
								local chestContent = 0
								if content[request.signal.name] ~= nil then
									chestContent = content[request.signal.name]
								end
								local request_count = 0
								if request.count ~= nil then
									request_count = request.count - chestContent
									
								end
								local transfer = math.min(request_count , ts_stored, insertable)
								if transfer > 0 then
									global.tesseract_data[force.index].storages[request.signal.name].item_count = global.tesseract_data[force.index].storages[request.signal.name].item_count - transfer
									inventory.insert({name = request.signal.name, count = transfer })
									if not global.tesseract_data[force.index].storages[request.signal.name].infinite then
										force_MD[force.index].item_count = force_MD[force.index].item_count - transfer
									end
								end
							end
						end
					end
				end
			else
				global.tesseract_data[force.index].materializer_chests[idx].connector_pole.destroy()
				global.tesseract_data[force.index].materializer_chests[idx].m_connector.destroy()
				global.tesseract_data[force.index].materializer_chests[idx] = nil
				force.print("materializer-chest force nil")
			end
		end
	end
end


local function desmaterialize_items(force)
	if global.tesseract_data[force.index].energy > 0 and valid(global.tesseract_data[force.index].tesseract.altar) then
		for idx , chest in pairs(global.tesseract_data[force.index].desmaterializer_chests) do
			if valid(chest) then
				local inventory = chest.get_inventory(defines.inventory.chest)
				local content = inventory.get_contents()
				for name , number in pairs(content) do
					if global.tesseract_data[force.index].storages[name] == nil then
						local transfer = math.floor(math.min((global.tesseract_data[force.index].maxStorage - force_MD[force.index].item_count),number))
						if transfer > 0 then
							global.tesseract_data[force.index].storages[name] = {name = name , item_count = transfer, infinite = false }
							force_MD[force.index].item_count = force_MD[force.index].item_count + transfer
							inventory.remove({name = name , count = transfer})
						end
					elseif global.tesseract_data[force.index].storages[name].infinite then
						local transfer = number
						if global.tesseract_data[force.index].storages[name].item_count + transfer < 2.1*10^9 then
							global.tesseract_data[force.index].storages[name].item_count = global.tesseract_data[force.index].storages[name].item_count + transfer
							inventory.remove({name = name , count = transfer})
						end
					else
						local transfer = math.floor(math.min((global.tesseract_data[force.index].maxStorage - force_MD[force.index].item_count),number))
						if transfer > 0 then
							force_MD[force.index].item_count = force_MD[force.index].item_count + transfer
							global.tesseract_data[force.index].storages[name].item_count = global.tesseract_data[force.index].storages[name].item_count + transfer
							inventory.remove({name = name , count = transfer})
						end
					end
						
				end
			else
				global.tesseract_data[force.index].desmaterializer_chests[idx] = nil
				force.print("desmaterializer-chest force nil")
			end
			
		end
	end
end

local function desmaterialize_fluids(force)
	if global.tesseract_data[force.index].energy > 0 and valid(global.tesseract_data[force.index].tesseract.altar) then
		for idx , tank in pairs(global.tesseract_data[force.index].desmaterializer_tanks) do
			if valid(tank) then
				for idx = 1, #tank.fluidbox do 
					local fluid = tank.fluidbox[idx]
					if fluid ~= nil then 
						if global.tesseract_data[force.index].tanks[fluid.name] == nil then
							local transfer = math.min(fluid.amount, (global.tesseract_data[force.index].maxStorage - force_MD[force.index].item_count)*50)
							if transfer > 0 then
								global.tesseract_data[force.index].tanks[fluid.name] = {name = fluid.name, fluid_count = transfer, temperature = fluid.temperature, infinite = false}
								force_MD[force.index].item_count = force_MD[force.index].item_count + transfer / 50
								tank.remove_fluid{name = fluid.name, amount = transfer}
							end
						elseif global.tesseract_data[force.index].tanks[fluid.name].infinite then
							if global.tesseract_data[force.index].tanks[fluid.name].fluid_count + fluid.amount < 2.1*10^9 then
								global.tesseract_data[force.index].tanks[fluid.name].temperature = 
								(
									global.tesseract_data[force.index].tanks[fluid.name].fluid_count * global.tesseract_data[force.index].tanks[fluid.name].temperature + 
									fluid.amount * fluid.temperature
								)/ (global.tesseract_data[force.index].tanks[fluid.name].fluid_count + fluid.amount)
								
								global.tesseract_data[force.index].tanks[fluid.name].fluid_count = global.tesseract_data[force.index].tanks[fluid.name].fluid_count + fluid.amount
								tank.remove_fluid{name = fluid.name, amount = fluid.amount}
							end
						else
							local transfer = math.min(fluid.amount, (global.tesseract_data[force.index].maxStorage - force_MD[force.index].item_count)*50)
							if transfer > 0 then
								
								global.tesseract_data[force.index].tanks[fluid.name].temperature = 
								(
									global.tesseract_data[force.index].tanks[fluid.name].fluid_count * global.tesseract_data[force.index].tanks[fluid.name].temperature + 
									transfer * fluid.temperature
								)/ (global.tesseract_data[force.index].tanks[fluid.name].fluid_count + transfer)
								
								global.tesseract_data[force.index].tanks[fluid.name].fluid_count = global.tesseract_data[force.index].tanks[fluid.name].fluid_count + fluid.amount
								tank.remove_fluid{name = fluid.name, amount = transfer}
								force_MD[force.index].item_count = force_MD[force.index].item_count + transfer / 50
							end
						end
					end
				end
			else
				global.tesseract_data[force.index].desmaterializer_tanks[idx] = nil
				force.print("desmaterializer-tank force nil")
			end
			
		end
	end
end


local function cont_items(force)
	local storage = global.tesseract_data[force.index].storages
	local tanks = global.tesseract_data[force.index].tanks
	local connectors = global.tesseract_data[force.index].connectors
	local itemCont = 0
	local infiniteCont = 0
	local signalIdx = 5
	for idx , storage in pairs(storage) do

		if storage.infinite then
			infiniteCont = infiniteCont + 1
		else
			itemCont = itemCont + storage.item_count
		end
		for _, connector in pairs(connectors) do
			
			local control = connector.get_or_create_control_behavior()
			if valid(control) then
				control.set_signal(signalIdx,{signal = {type = "item", name = storage.name}, count = storage.item_count})
			else
				game.print("connector error")
			end
		end
		signalIdx = signalIdx + 1
	end
	
	for idx , tank in pairs(tanks) do
		if tank.infinite then
			infiniteCont = infiniteCont + 1
		else
			itemCont = itemCont + tank.fluid_count / 50
		end
		 
		for _, connector in pairs(connectors) do
			local control = connector.get_or_create_control_behavior()
			if valid(control) then
				control.set_signal(signalIdx,{signal = {type = "fluid", name = tank.name}, count = tank.fluid_count})
				else
				game.print("connector error")
			end
		end
		signalIdx = signalIdx + 1
	end
	force_MD[force.index].infinite_storages = infiniteCont
	force_MD[force.index].item_count = itemCont
	for _, connector in pairs(connectors) do
		local control = connector.get_or_create_control_behavior()
		if valid(control) then
			control.set_signal(1,{signal = {type = "virtual", name = "CW-ts-item-count"}, count = itemCont})
			control.set_signal(2,{signal = {type = "virtual", name = "CW-ts-max-items"}, count = global.tesseract_data[force.index].maxStorage})
			control.set_signal(3,{signal = {type = "virtual", name = "CW-ts-power"}, count = global.tesseract_data[force.index].energy/10^6})
			control.set_signal(4,{signal = {type = "virtual", name = "CW-ts-max-power"}, count = global.tesseract_data[force.index].maxEnergy/10^6})
		else
			game.print("connector error")
		end
	end
end

local function materialize_fluids(force)
	if global.tesseract_data[force.index].energy > 0 and valid(global.tesseract_data[force.index].tesseract.altar) then
		for tank_idx , tank in pairs(global.tesseract_data[force.index].materializer_tanks) do
			if valid(tank.tank) then
				
				if tank.tank.fluidbox.get_locked_fluid(1) ~= nil and tank.request == nil then
					tank.request = tank.tank.fluidbox.get_locked_fluid(1)
				end
				
				local amount = 0
				
				if tank.tank.fluidbox[1] ~= nil then
					amount = tank.tank.fluidbox[1].amount
				end
				local remainingCapacity = tank.tank.fluidbox.get_capacity(1) - amount  
				
				
				local fluid_count = 0
				if global.tesseract_data[force.index].tanks[tank.request] ~= nil then
					fluid_count = global.tesseract_data[force.index].tanks[tank.request].fluid_count
				end
				
				
				local transfer = math.min(fluid_count, remainingCapacity)
				
				if transfer > 0 and (tank.request == tank.tank.fluidbox.get_locked_fluid(1) or tank.tank.fluidbox.get_locked_fluid(1) == nil) then
					global.tesseract_data[force.index].tanks[tank.request].fluid_count = global.tesseract_data[force.index].tanks[tank.request].fluid_count - transfer
					tank.tank.insert_fluid({name = tank.request, amount = transfer, temperature = global.tesseract_data[force.index].tanks[tank.request].temperature })
					
				end

			else
				global.tesseract_data[force.index].materializer_tanks[tank_idx] = nil
				game.print("materializer-tank force nil")
			end
		end
	end
end

local function updateTesseracts()
	for _ , force in pairs(game.forces) do
		if valid(force) and force.name ~= "enemy" and force.name ~= "neutral" then
			if global.tesseract_data[force.index].tesseract ~= nil and valid(global.tesseract_data[force.index].tesseract.interface) then
				TS_update(force)
				leech_power(force)
				produce_power(force)
				recharge_equip(force)
				provide_power(force)
				make_fragments(force)
				materialize_fluids(force)
				materialize_items(force)
				desmaterialize_fluids(force)
				desmaterialize_items(force)
				cont_items(force)
			end
		end
	end
end

local function calc_energy_production(force)
	local production = global.tesseract_data[force.index].satellites * 11*10^6
	force_MD[force.index].energyProduction = production
end

local function calc_energy_consumption(force)
	
	if global.tesseract_data[force.index].tesseract ~= nil and valid(global.tesseract_data[force.index].tesseract.interface) then
		local drain = 	global.tesseract_data[force.index].maxStorage * 2 + 
						global.tesseract_data[force.index].maxEnergy*2 / 10^4 + 
						global.tesseract_data[force.index].max_infinite_storages * 10^6
		
		for idx, leech in pairs(global.tesseract_data[force.index].power_leeches) do
			if valid(leech.pole) then
				--force.print(leech.pole.name)
				if leech.pole.name == "CW-ts-power-leech-pole-1" then
					drain = drain + 10^5
				elseif leech.pole.name == "CW-ts-power-leech-pole-2" then
					drain = drain + 5*10^5
				elseif leech.pole.name == "CW-ts-power-leech-pole-3" then
					drain = drain + 25*10^5
				elseif leech.pole.name == "CW-ts-power-leech-pole-4" then
					drain = drain + 125*10^5
				end
			else
				force.print("force remove power leech ".. idx)
				if valid(leech.interface) then
					leech.interface.destroy()
					global.tesseract_data[force.index].power_leeches[idx] = nil
				end	
			end
		end

		for idx , source in pairs(global.tesseract_data[force.index].power_sources) do
			if valid(source.pole) then
				--force.print(source.pole.name)
				if source.pole.name == "CW-ts-power-source-pole-1" then
					drain = drain + 10^5
				elseif source.pole.name == "CW-ts-power-source-pole-2" then
					drain = drain + 5*10^5
				elseif source.pole.name == "CW-ts-power-source-pole-3" then
					drain = drain + 25*10^5
				elseif source.pole.name == "CW-ts-power-source-pole-4" then
					drain = drain + 125*10^5
				end
			else
				force.print("force remove power source ".. idx)
				if valid(source.interface) then
					source.interface.destroy()
					global.tesseract_data[force.index].power_sources[idx] = nil
				end	
			end
		end
		
		for idx , desmaterializer_tank in pairs(global.tesseract_data[force.index].desmaterializer_tanks) do
			if valid(desmaterializer_tank) then
				drain = drain + 5*10^5
			else
				force.print("force remove desmaterializer tank ".. idx)
				global.tesseract_data[force.index].desmaterializer_tanks[idx] = nil
			end
		end
		for idx , materializer_tank in pairs(global.tesseract_data[force.index].materializer_tanks) do
			if valid(materializer_tank.tank) then
				drain = drain + 5*10^5
			else
				force.print("force remove materializer tank ".. idx)
				global.tesseract_data[force.index].materializer_tanks[idx] = nil
			end
		end
		for idx , desmaterializer_chest in pairs(global.tesseract_data[force.index].desmaterializer_chests) do
			if valid(desmaterializer_chest) then
				drain = drain + 5*10^5
			else
				force.print("force remove desmaterializer chest ".. idx)
				global.tesseract_data[force.index].desmaterializer_chests[idx] = nil
			end
		end
		for idx , materializer_chest in pairs(global.tesseract_data[force.index].materializer_chests) do
			if valid(materializer_chest.chest) then
				drain = drain + 5*10^5
			else
				force.print("force remove materializer chest ".. idx)
				if valid(global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].m_connector) then
					global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].m_connector.destroy()
				end
				if valid(global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].connector_pole)then
					global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].connector_pole.destroy()
				end
				global.tesseract_data[force.index].materializer_chests[idx] = nil
			end
		end
		
		for idx , teleporter in pairs(global.tesseract_data[force.index].teleports) do
			if valid(teleporter.teleporter) then
				drain = drain + 5*10^6
			else
				force.print("force remove teleporter ".. idx)
				global.tesseract_data[force.index].teleports[idx] = nil
			end
		end
		force_MD[force.index].energyDrain = drain
	end
	
end


local function create_connector(main_entity)
	if valid(main_entity) then
		local position = main_entity.position
		local surface = main_entity.surface
		local force = main_entity.force
		local player = main_entity.last_user
		local connector = nil
		local conn_position = {x = position.x, y = position.y + 0.01}
		local ghosts = surface.find_entities_filtered{position = position, radius = 0.1 , ghost_name = "CW-materializer-connector"} 
		if ghosts ~= nil then	
			for _ , ghost in pairs(ghosts) do
				ghost.revive()
				--game.print("revive")
			end
			local results = surface.find_entities_filtered{position = position, radius = 0.1 , name = "CW-materializer-connector"} 
			for _ , result in pairs(results) do
				if valid(result) then
					connector = result
				end
			end
		end
		
		if connector == nil then
			--game.print("create")
			connector = surface.create_entity
			({
				name = "CW-materializer-connector", 
				position = conn_position, 
				force = force, 
				fast_replace = true, 
				player = player,
				raise_built = true,
			})
		end
		
		return connector
	end
end

local function on_built(evt)
	if evt.created_entity == nil and evt.entity ~= nil then
		evt.created_entity = evt.entity
	end
	if valid(evt.created_entity) then
		local player = evt.created_entity.last_user
		local surface = evt.created_entity.surface
		local position = evt.created_entity.position
		local force = evt.created_entity.force

		if evt.created_entity.name == "CW-ts-altar" then
			if global.tesseract_data[force.index].tesseract == nil then
				local interface = surface.create_entity{name = "CW-tesseract", position = {position.x,position.y+0.01}, force = force, player = player}
				global.tesseract_data[force.index].tesseract = {altar = evt.created_entity, interface = interface}
				create_GUI(force)
				calc_energy_consumption(force)
			else 
				evt.created_entity.destroy()
				player.print("you cant place more than 1 tesseract")
			end
		elseif evt.created_entity.name == "CW-ts-power-leech-pole-1" then
			local interface = surface.create_entity{name = "CW-ts-power-leech-1", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_leeches[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-leech-pole-2" then
			local interface = surface.create_entity{name = "CW-ts-power-leech-2", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_leeches[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-leech-pole-3" then
			local interface = surface.create_entity{name = "CW-ts-power-leech-3", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_leeches[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-leech-pole-4" then
			local interface = surface.create_entity{name = "CW-ts-power-leech-4", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_leeches[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-source-pole-1" then
			local interface = surface.create_entity{name = "CW-ts-power-source-1", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_sources[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-source-pole-2" then
			local interface = surface.create_entity{name = "CW-ts-power-source-2", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_sources[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)

		elseif evt.created_entity.name == "CW-ts-power-source-pole-3" then
			local interface = surface.create_entity{name = "CW-ts-power-source-3", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_sources[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-power-source-pole-4" then
			local interface = surface.create_entity{name = "CW-ts-power-source-4", position = position, force = force, player = player}
			global.tesseract_data[force.index].power_sources[evt.created_entity.unit_number] = {pole = evt.created_entity, interface = interface}
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-desmaterializer-chest" or evt.created_entity.name == "CW-ts-logistic-desmaterializer-chest" then
			global.tesseract_data[force.index].desmaterializer_chests[evt.created_entity.unit_number] = evt.created_entity
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-materializer-chest" or evt.created_entity.name == "CW-ts-logistic-materializer-chest" then
			
			local connector = create_connector(evt.created_entity)
			local connector_pole = surface.create_entity({name = "CW-materializer-pole", position = position, force = force, player = player})
			
			connector.connect_neighbour({target_entity = connector_pole, wire = defines.wire_type.green})
			
			global.tesseract_data[force.index].materializer_chests[evt.created_entity.unit_number] = {chest = evt.created_entity, m_connector = connector, connector_pole = connector_pole}
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-desmaterializer-tank" or evt.created_entity.name == "CW-ts-mini-desmaterializer-tank" then
			global.tesseract_data[force.index].desmaterializer_tanks[evt.created_entity.unit_number] = evt.created_entity
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-materializer-tank" or evt.created_entity.name == "CW-ts-mini-materializer-tank" then
			global.tesseract_data[force.index].materializer_tanks[evt.created_entity.unit_number] = {tank = evt.created_entity, request = nil}
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-connector" then
			global.tesseract_data[force.index].connectors[evt.created_entity.unit_number] = evt.created_entity
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-teleporter" then
			evt.created_entity.operable = false
			global.tesseract_data[force.index].teleports[evt.created_entity.unit_number] = {teleporter = evt.created_entity, destination = nil}
			calc_energy_consumption(force)
		elseif evt.created_entity.name == "CW-ts-teleport-beacon" then
			evt.created_entity.operable = false
			global.tesseract_data[force.index].beacons[evt.created_entity.unit_number] = evt.created_entity
			calc_energy_consumption(force)
		end
		
	end
end

local function on_remove(evt)
	if valid(evt.entity) and valid (evt.entity.last_user) then
		local force = evt.entity.last_user.force
		--force.print("tt")
		if evt.entity.name == "CW-ts-altar" then
			global.tesseract_data[force.index].tesseract.interface.destroy()
			global.tesseract_data[force.index].tesseract = nil
			destroyAllGUIs(force)
			
		elseif	evt.entity.name == "CW-ts-power-leech-pole-1" or
				evt.entity.name == "CW-ts-power-leech-pole-2" or  
				evt.entity.name == "CW-ts-power-leech-pole-3" or  
				evt.entity.name == "CW-ts-power-leech-pole-4" then
			global.tesseract_data[force.index].power_leeches[evt.entity.unit_number].interface.destroy()
			global.tesseract_data[force.index].power_leeches[evt.entity.unit_number] = nil

		elseif	evt.entity.name == "CW-ts-power-source-pole-1" or
				evt.entity.name == "CW-ts-power-source-pole-2" or  
				evt.entity.name == "CW-ts-power-source-pole-3" or  
				evt.entity.name == "CW-ts-power-source-pole-4" then
			global.tesseract_data[force.index].power_sources[evt.entity.unit_number].interface.destroy()
			global.tesseract_data[force.index].power_sources[evt.entity.unit_number] = nil
		
		elseif	evt.entity.name == "CW-ts-desmaterializer-chest" or evt.entity.name == "CW-ts-logistic-desmaterializer-chest"    then
			global.tesseract_data[force.index].desmaterializer_chests[evt.entity.unit_number] = nil

		elseif	evt.entity.name == "CW-ts-materializer-chest" or evt.entity.name == "CW-ts-logistic-materializer-chest" then
			global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].m_connector.destroy()
			global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number].connector_pole.destroy()
			global.tesseract_data[force.index].materializer_chests[evt.entity.unit_number] = nil

		elseif	evt.entity.name == "CW-ts-desmaterializer-tank" or evt.entity.name == "CW-ts-mini-desmaterializer-tank" then
			global.tesseract_data[force.index].desmaterializer_tanks[evt.entity.unit_number] = nil

		elseif	evt.entity.name == "CW-ts-materializer-tank" or evt.entity.name == "CW-ts-mini-materializer-tank" then
			global.tesseract_data[force.index].materializer_tanks[evt.entity.unit_number] = nil
		
		elseif	evt.entity.name == "CW-ts-connector" then
			global.tesseract_data[force.index].connectors[evt.entity.unit_number] = nil

		elseif	evt.entity.name == "CW-ts-teleporter" then
			global.tesseract_data[force.index].teleports[evt.entity.unit_number] = nil
		elseif	evt.entity.name == "CW-ts-teleport-beacon" then
			global.tesseract_data[force.index].beacons[evt.entity.unit_number] = nil


		end
		calc_energy_consumption(force)
	end
end


local function on_research(evt)
	local tech = evt.research 
	local force = tech.force
	if tech.name == "CW-tesseract-energy-capacity" then
		global.tesseract_data[force.index].maxEnergy = 10^9 + (tech.level -1) * 10^8
		calc_energy_consumption(force)
	elseif tech.name == "CW-tesseract-infinite-storage" then
		global.tesseract_data[force.index].max_infinite_storages = (tech.level -1)
		calc_energy_consumption(force)
		
	elseif tech.name == "CW-tesseract-storage-capacity" then
		global.tesseract_data[force.index].maxStorage = 10^5 + (tech.level -1) * 10^4
		calc_energy_consumption(force)
		if 10^5 + (tech.level) * 10^4 > 2.1*10^9 then
			force.print("max storage max level")
			force.technologies["CW-tesseract-storage-capacity"].enabled = false
			force.research_queue = nil
		end
	elseif tech.name == "CW-tesseract-logistics" then
		global.tesseract_data[force.index].maxStorage = 10^5
		calc_energy_consumption(force)
	end
	
end




local function fill_MD(force)
	force_MD[force.index] = {item_count = 0, energyProduction = 0, energyDrain = 0, infinite_storages = 0}
	for _ , player in pairs(force.players) do
		player_MD[player.index] = {selected_entity = nil}
	end
	calc_energy_consumption(force)
	calc_energy_production(force)
end

local function init_force(force)
	if valid(force) and force.name ~= "enemy" and force.name ~= "neutral" then
		
		global.tesseract_data[force.index] = {tesseract = nil, maxEnergy = 10^9, energy = 0, maxStorage = 0.01, storages = {},tanks = {}, satellites = 0,
		materializer_chests = {},desmaterializer_chests = {},materializer_tanks = {},desmaterializer_tanks = {}, power_sources = {}, power_leeches = {},
		max_infinite_storages = 0, equips = {}, teleports = {},beacons = {}, connectors = {} }
		
		-- insert tesseract in big-ship-wreck-1
		surface = game.get_surface("nauvis")
		position = {force.get_spawn_position(surface).x, force.get_spawn_position(surface).y +3}
		
		local wreck = surface.create_entity{name = "big-ship-wreck-1", position = position, force = force, create_build_effect_smoke = false}
		
		wreck.insert({name = "CW-tesseract"})

		fill_MD(force)
	end
	
end
local function on_init()
	global.tesseract_data = {}
	for _ , force in pairs(game.forces) do
		init_force(force)
	end
end
 

local function force_created(evt)
	init_force(evt.force)
end







local function on_load()
	for _ , force in pairs(game.forces) do
		if valid(force) and force.name ~= "enemy" and force.name ~= "neutral" then
			fill_MD(force)
			for _ , player in pairs(force.players) do
				if valid(player.gui.screen.tesseractGUI) then
					recreate_player_GUI(player)
				end
			end
		end
	end
end

local function on_tick(evt)
	if game_load then
		on_load()
		
		game_load = false
	end
	if (evt.tick % 60) == 10 then
		updateTesseracts()
		update_GUIs()
	end
end

local function on_change()
	--game.print("on change")
	for _ , force in pairs(game.forces) do
		if valid(force) and force.name ~= "enemy" and force.name ~= "neutral" then
			for idx , item in pairs(global.tesseract_data[force.index].storages) do
				if game.item_prototypes[item.name] == nil then 
					--remove data of any item removed from the game 
					global.tesseract_data[force.index].storages[idx] = nil
				end
			end
			for idx , fluid in pairs(global.tesseract_data[force.index].tanks) do
				if game.fluid_prototypes[fluid.name] == nil then
					--remove data of any fluid removed from the game 
					global.tesseract_data[force.index].tanks[idx] = nil
				end
			end
			for _, connector in pairs(global.tesseract_data[force.index].connectors) do
				connector.get_or_create_control_behavior().parameters = nil
			end
			
			if game.active_mods["CW-orbital-solar-power"] == nil then
				global.tesseract_data[force.index].satellites = 0
				--calc_energy_production(force)
				--game.print("removed solar")
			end
			for idx , materializer_chest in pairs(global.tesseract_data[force.index].materializer_chests) do
				if valid(materializer_chest.chest) then
					if not valid(materializer_chest.m_connector) then
						local connector =  create_connector(materializer_chest.chest)
						global.tesseract_data[force.index].materializer_chests[idx].m_connector = connector
					end
					if not valid(materializer_chest.connector_pole) then
						local surface = materializer_chest.chest.surface
						local player = materializer_chest.chest.last_user
						local position = materializer_chest.chest.position
						local pole = surface.create_entity{name = "CW-materializer-pole", player = player, position = position, force = force, create_build_effect_smoke = false}
						global.tesseract_data[force.index].materializer_chests[idx].connector_pole = pole
						pole.connect_neighbour({wire = defines.wire_type.green, target_entity = global.tesseract_data[force.index].materializer_chests[idx].m_connector})
					end
					if global.tesseract_data[force.index].materializer_chests[idx].request ~= nil then
						local connector = global.tesseract_data[force.index].materializer_chests[idx].m_connector
						local request = global.tesseract_data[force.index].materializer_chests[idx].request
						local count = global.tesseract_data[force.index].materializer_chests[idx].requestCount
						local control = connector.get_or_create_control_behavior()
						control.set_signal(1,{signal= {type = "item", name = request}, count = count})
						global.tesseract_data[force.index].materializer_chests[idx].request = nil
						global.tesseract_data[force.index].materializer_chests[idx].requestCount = nil
					end
				end
			end
		end
	end
	
end


local function place_equip(evt)
	if evt.equipment.name == "CW-ts-portable-source-1" or evt.equipment.name == "CW-ts-portable-source-2" or evt.equipment.name == "CW-ts-portable-source-3" then
		local force = game.get_player(evt.player_index)
		table.insert(global.tesseract_data[force.index].equips,evt.equipment)
	end
end

local function teleport(evt)
	if valid(evt.entity) and evt.entity.name == "CW-ts-teleporter" then
		local player = game.get_player(evt.player_index)
		local teleporter = evt.entity
		if valid(teleporter) then
			local destination = global.tesseract_data[player.force.index].teleports[teleporter.unit_number].destination
			teleporter.set_driver(nil)
			if valid(destination) and global.tesseract_data[evt.entity.force.index].tesseract ~= nil and valid(global.tesseract_data[evt.entity.force.index].tesseract.altar)  then
				player.teleport(destination.position,destination.surface)
			end
		end
		
	end
end

local function join(evt)
	local player = game.get_player(evt.player_index)
	if global.tesseract_data[player.force.index].tesseract ~= nil and valid(global.tesseract_data[player.force.index].tesseract.altar) then
		recreate_player_GUI(player)
	end
end


local function rocket_launch(evt)
	local cargo = evt.rocket.get_inventory(defines.inventory.rocket)
	local force = evt.rocket.force
	if cargo.get_item_count("CW-ts-solar-satellite") > 0 then
		--game.print("solar-satellite")
		global.tesseract_data[force.index].satellites = global.tesseract_data[force.index].satellites + 1
		calc_energy_production(force)
	end
end


local build_events = {defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}
script.on_event(build_events, on_built)

local remove_events = {defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity,defines.events.on_entity_died, defines.events.script_raised_destroy }
script.on_event(remove_events, on_remove)

script.on_event(defines.events.on_research_finished, on_research)

script.on_event(defines.events.on_tick, on_tick)

script.on_init(on_init)

script.on_configuration_changed(on_change)
script.on_event(defines.events.on_force_created,force_created)


script.on_event(defines.events.on_player_placed_equipment, place_equip)

script.on_event(defines.events.on_player_driving_changed_state, teleport)

script.on_event(defines.events.on_player_joined_game,join)

script.on_event(defines.events.on_rocket_launched,  rocket_launch )











