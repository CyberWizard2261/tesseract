require("script.runtime_functions")
local gui_location

function recreate_player_GUI(player)
	destroyGUI(player)
	if gui_location == nil then
		gui_location = {1,1}
	end
	player.gui.screen.add({type = "frame", name = "tesseractGUI", direction = "vertical", caption = {"GUIdescription.ts-tesseractGUI"} ,tooltip = {"GUIdescription.ts-hide-window-tip"} })
	player.gui.screen.tesseractGUI.location = gui_location
	player.gui.screen.tesseractGUI.add({type = "label", name = "energy", caption = "0MJ/0MJ", tooltip = {"GUIdescription.ts-energy-tip"}})
	player.gui.screen.tesseractGUI.add({type = "progressbar", name = "energyBar", value = 0, tooltip = {"GUIdescription.ts-energy-tip"}})
	player.gui.screen.tesseractGUI.add({type = "label", name = "inventory", caption = "0/0", tooltip = {"GUIdescription.ts-inventory-tip"}})
	player.gui.screen.tesseractGUI.add({type = "progressbar", name = "inventoryBar", value = 0, tooltip = {"GUIdescription.ts-inventory-tip"}})
	player.gui.screen.tesseractGUI.add({type = "table", name = "table", column_count = 2})
	player.gui.screen.tesseractGUI.table.add({type = "button", name = "CWInventoryDetail",caption = {"GUIdescription.ts-inventory"}})
	player.gui.screen.tesseractGUI.table.add({type = "button", name = "CWPowerDetail",caption = {"GUIdescription.ts-power"}})
end
function create_GUI(force)
	
	if valid(global.tesseract_data[force.index].tesseract.interface) then
		for _ , player in pairs(force.connected_players) do
			recreate_player_GUI(player)
		end
	end
end




function destroyGUI(player)
	if valid(player.gui.screen.tesseractGUI) then
		gui_location = player.gui.screen.tesseractGUI.location
		player.gui.screen.tesseractGUI.destroy()
	end
end


function destroyAllGUIs(force)
	for _ , player in pairs(force.connected_players) do
		destroyGUI(player)
	end
end

local function update_storage_GUI(player)
	player.gui.center.tsStorageGUI.table1.scrollNormal.normal.clear()
	player.gui.center.tsStorageGUI.table1.scrollInfinite.infinite.clear()
	local enabled = force_MD[player.force.index].infinite_storages < global.tesseract_data[player.force.index].max_infinite_storages
	
	for _ , tank in pairs(global.tesseract_data[player.force.index].tanks) do
		local tip = {"GUIdescription.ts-fluid-tip", format_num(tank.temperature), game.fluid_prototypes[tank.name].localised_name}
		if tank.infinite then
			player.gui.center.tsStorageGUI.table1.scrollInfinite.infinite.add({type = "sprite-button", sprite = "fluid/" .. tank.name, name = "CWfluid" .. tank.name , number = tank.fluid_count, tooltip = tip })
		elseif tank.fluid_count > 0 then
			player.gui.center.tsStorageGUI.table1.scrollNormal.normal.add({type = "sprite-button", sprite = "fluid/" .. tank.name,name = "CWfluid" .. tank.name , number = tank.fluid_count, enabled = enabled, tooltip = tip})
		end
	end
	
	for _, storage in pairs(global.tesseract_data[player.force.index].storages) do 
	
		local tip = game.item_prototypes[storage.name].localised_name 
		if storage.infinite then
			player.gui.center.tsStorageGUI.table1.scrollInfinite.infinite.add({type = "sprite-button", sprite = "item/" .. storage.name,name = "CWitem" .. storage.name , number = storage.item_count, tooltip = tip })
		elseif storage.item_count > 0 then
			player.gui.center.tsStorageGUI.table1.scrollNormal.normal.add({type = "sprite-button", sprite = "item/" .. storage.name,name = "CWitem" .. storage.name , number = storage.item_count, enabled = enabled, tooltip = tip})
		end
	end
end

function update_GUIs()
	for k, player in pairs(game.connected_players) do
		if valid(player.gui.screen.tesseractGUI) then
			local maxEnergy = format_num(global.tesseract_data[player.force.index].maxEnergy,"J")
			local energy = format_num(global.tesseract_data[player.force.index].energy,"J")
			local energy_percent = global.tesseract_data[player.force.index].energy / global.tesseract_data[player.force.index].maxEnergy
			local energyDrain = format_num(force_MD[player.force.index].energyDrain,"W")
			local energyProduction = format_num(force_MD[player.force.index].energyProduction,"W")
			
			local maxStorage = format_num(global.tesseract_data[player.force.index].maxStorage)
			local stored = format_num(force_MD[player.force.index].item_count)
			local storage_percent = force_MD[player.force.index].item_count / global.tesseract_data[player.force.index].maxStorage
			
			player.gui.screen.tesseractGUI.energy.caption = (energy .. " / " .. maxEnergy .. "   " .. energyDrain .. " / " .. energyProduction)
			player.gui.screen.tesseractGUI.energyBar.value = energy_percent
			
			player.gui.screen.tesseractGUI.inventory.caption = (stored .. "/" .. maxStorage)
			player.gui.screen.tesseractGUI.inventoryBar.value = storage_percent
		end
		if valid(player.gui.center.tsStorageGUI) then
			update_storage_GUI(player)
		end
	end
end


local function create_inventory_GUI(player)
	if player.gui.center.tsStorageGUI == nil then
		player.gui.center.add({type = "frame", name = "tsStorageGUI", direction = "vertical", caption = {"GUIdescription.ts-storage-GUI"}})
		player.gui.center.tsStorageGUI.style .maximal_height = 500
		--player.gui.center.tsStorageGUI.add({type = "scroll-pane", name = "scroll" , horizontal_scroll_policy = "never", vertical_scroll_policy = "auto-and-reserve-space",})
		player.gui.center.tsStorageGUI.add({type = "table", name = "table1", column_count = 2, draw_vertical_lines = true, draw_horizontal_lines = true})
		player.gui.center.tsStorageGUI.table1.add({type = "label", caption = {"GUIdescription.ts-normal-storage"},tooltip = {"GUIdescription.ts-make-infinite-tip"}})
		player.gui.center.tsStorageGUI.table1.add({type = "label", caption = {"GUIdescription.ts-infinite-storage"},tooltip = {"GUIdescription.ts-make-normal-tip"}})
		player.gui.center.tsStorageGUI.table1.add({type = "scroll-pane", name = "scrollNormal" , horizontal_scroll_policy = "never", vertical_scroll_policy = "auto",})
		player.gui.center.tsStorageGUI.table1.add({type = "scroll-pane", name = "scrollInfinite" , horizontal_scroll_policy = "never", vertical_scroll_policy = "auto",})
		player.gui.center.tsStorageGUI.table1.scrollNormal.add({type = "table", name = "normal", column_count = 10,})
		player.gui.center.tsStorageGUI.table1.scrollInfinite.add({type = "table", name = "infinite", column_count = 5,})
		player.gui.center.tsStorageGUI.add({type = "button", name = "CWInventoryOK",caption = "OK" })
		update_storage_GUI(player)
	end
end

local function power_details_gui(player)
	if valid(player.gui.center.tsPowerGUI) then
		player.gui.center.tsPowerGUI.destroy()
	end
	local force = player.force
	player.gui.center.add({type = "frame", name = "tsPowerGUI", direction = "vertical", caption = {"GUIdescription.ts-power-GUI"}})
	player.gui.center.tsPowerGUI.add({type = "scroll-pane", name = "scroll" , horizontal_scroll_policy = "never", vertical_scroll_policy = "auto"})
	player.gui.center.tsPowerGUI.scroll.add({type = "table", name = "table1", column_count = 6,})
	
	
	if game.active_mods["CW-orbital-solar-power"] ~= nil then
		local number = global.tesseract_data[force.index].satellites
		player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-solar-satellite",number = number, tooltip = {"GUIdescription.ts-solar-stellite-tip"}})
		local energyProduction = format_num(force_MD[player.force.index].energyProduction,"W")
		local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = energyProduction})
		label.style.font_color = {r = 0, g = 0.5, b = 1, a = 1}
		
	end
	
	
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-tesseract",number = 1, tooltip = {"GUIdescription.ts-tesseract-tip"}})
	local TesseractConsumption = global.tesseract_data[force.index].maxStorage * 2 + 
								global.tesseract_data[force.index].maxEnergy*2 / 10^4 + 
								global.tesseract_data[force.index].max_infinite_storages * 10^6
	
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(TesseractConsumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}
	
	
	local number = 0
	local consumption = 0
	for _ , leech in pairs(global.tesseract_data[force.index].power_leeches) do
		number = number +1
		if leech.pole.name == "CW-ts-power-leech-pole-1" then
			consumption = consumption + 10^5
		elseif leech.pole.name == "CW-ts-power-leech-pole-2" then
			consumption = consumption + 5*10^5
		elseif leech.pole.name == "CW-ts-power-leech-pole-3" then
			consumption = consumption + 25*10^5
		elseif leech.pole.name == "CW-ts-power-leech-pole-4" then
			consumption = consumption + 125*10^5
		end
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-power-leech-pole-1",number = number, tooltip = {"GUIdescription.ts-power-leech-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}




	number = 0
	consumption = 0
	for _ , source in pairs(global.tesseract_data[force.index].power_sources) do
		number = number +1
		if source.pole.name == "CW-ts-power-source-pole-1" then
			consumption = consumption + 10^5
		elseif source.pole.name == "CW-ts-power-source-pole-2" then
			consumption = consumption + 5*10^5
		elseif source.pole.name == "CW-ts-power-source-pole-3" then
			consumption = consumption + 25*10^5
		elseif source.pole.name == "CW-ts-power-source-pole-4" then
			consumption = consumption + 125*10^5
		end
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-power-source-pole-1",number = number, tooltip = {"GUIdescription.ts-power-source-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}




	number = 0
	consumption = 0
	for _ , desmaterializer_chest in pairs(global.tesseract_data[force.index].desmaterializer_chests) do
		number = number +1
		consumption = consumption + 5*10^5
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-desmaterializer-chest",number = number, tooltip = {"GUIdescription.ts-desmaterializer-chest-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}
	
	
	number = 0
	consumption = 0
	for _ , materializer_chest in pairs(global.tesseract_data[force.index].materializer_chests) do
		number = number +1
		consumption = consumption + 5*10^5
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-materializer-chest",number = number, tooltip = {"GUIdescription.ts-materializer-chest-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}

	
	
	number = 0
	consumption = 0
	for _ , desmaterializer_tank in pairs(global.tesseract_data[force.index].desmaterializer_tanks) do
		number = number +1
		consumption = consumption + 5*10^5
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-desmaterializer-tank",number = number, tooltip = {"GUIdescription.ts-desmaterializer-tank-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}


	number = 0
	consumption = 0
	for _ , materializer_tank in pairs(global.tesseract_data[force.index].materializer_tanks) do
		number = number +1
		consumption = consumption + 5*10^5
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-materializer-tank",number = number, tooltip = {"GUIdescription.ts-materializer-tank-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}



	number = 0
	consumption = 0
	for _ , teleporter in pairs(global.tesseract_data[force.index].teleports) do
		number = number +1
		consumption = consumption + 5*10^6
	end
	player.gui.center.tsPowerGUI.scroll.table1.add({type = "sprite-button", sprite = "item/CW-ts-teleporter",number = number, tooltip = {"GUIdescription.ts-teleporter-tip"}})
	local label = player.gui.center.tsPowerGUI.scroll.table1.add({type = "label", caption = format_num(consumption,"W")})
	label.style.font_color = {r = 1, g = 0, b = 0, a = 1}

	









	player.gui.center.tsPowerGUI.add({type = "button", name = "CWPowerOK",caption = "OK" })
end

local function on_gui_click(evt)
	local player = game.get_player(evt.player_index)
	if evt.element.name == "CWInventoryDetail" then
		create_inventory_GUI(player)
		
	elseif evt.element.name == "CWPowerOK" then
		if valid(player.gui.center.tsPowerGUI) then
			player.gui.center.tsPowerGUI.destroy()
		end
	
	elseif evt.element.name == "CWInventoryOK" then
		if valid(player.gui.center.tsStorageGUI) then
			player.gui.center.tsStorageGUI.destroy()
		end
		if valid(player.gui.center.tsStorage) then
			player.gui.center.tsStorage.destroy()
		end
	elseif evt.element.name == "CWPowerDetail"then
		power_details_gui(player)
		
	elseif evt.element.name == "CWMaterializerTankOK" then
		if valid(player.gui.center.MaterializerTank) then
			local selected_entity = player_MD[player.index].selected_entity
			if valid(selected_entity) then
				global.tesseract_data[player.force.index].materializer_tanks[selected_entity.unit_number].request = player.gui.center.MaterializerTank.requestdfluid.elem_value
			end
			player.gui.center.MaterializerTank.destroy()
		end
		
	elseif evt.element.name == "CWTeleportBeaconOK" then
		local selected_entity = player_MD[player.index].selected_entity
		if valid(player.gui.center.teleportBeacon) then
			if valid(selected_entity) then
				local valid_name = true
				for idx, beacon in pairs(global.tesseract_data[player.force.index].beacons) do
					if player.gui.center.teleportBeacon.table.beaconName.text == beacon.backer_name then
						valid_name = false
						if selected_entity.unit_number ~= idx then
							player.print({"msg.invalid-name"})
						end
					end
				end
				if valid_name then
					global.tesseract_data[player.force.index].beacons[selected_entity.unit_number].backer_name = player.gui.center.teleportBeacon.table.beaconName.text
				end
			end
			player.gui.center.teleportBeacon.destroy()
		end
	elseif evt.element.name == "CWTeleporterOK" then
		if valid(player.gui.center.teleporter) then
			local selected_entity = player_MD[player.index].selected_entity
			if valid(selected_entity) then
				local beacon_idx = 0
				for _ , beacon in pairs(global.tesseract_data[player.force.index].beacons) do
					if beacon.backer_name == player.gui.center.teleporter.table.beacon.items[player.gui.center.teleporter.table.beacon.selected_index] then
						beacon_idx = beacon.unit_number
					end
				end
				--player.print("assing destination")
				global.tesseract_data[player.force.index].teleports[selected_entity.unit_number].destination = global.tesseract_data[player.force.index].beacons[beacon_idx]
			end
			player.gui.center.teleporter.destroy()
		end
		
	elseif string.match(evt.element.name,"CWitem") ~= nil then
		--player.print(string.sub(evt.element.name,7))
		global.tesseract_data[player.force.index].storages[string.sub(evt.element.name,7)].infinite = not global.tesseract_data[player.force.index].storages[string.sub(evt.element.name,7)].infinite 
		force_MD[player.force.index].recountItems = true
	
	elseif string.match(evt.element.name,"CWfluid") ~= nil then
		--player.print(string.sub(evt.element.name,8))
		global.tesseract_data[player.force.index].tanks[string.sub(evt.element.name,8)].infinite = not global.tesseract_data[player.force.index].tanks[string.sub(evt.element.name,8)].infinite 
		force_MD[player.force.index].recountItems = true
	end
end



local function gui_materizer_tank(player , main_entity)
	if player.force == main_entity.force and player.gui.center.MaterializerTank == nil then 
		player.gui.center.add({type = "frame", name = "MaterializerTank", direction = "vertical", caption = {"GUIdescription.ts-materializer-tank"}})
		player.gui.center.MaterializerTank.add({type = "choose-elem-button", name = "requestdfluid", elem_type = "fluid",})
		player.gui.center.MaterializerTank.requestdfluid.elem_value = global.tesseract_data[player.force.index].materializer_tanks[main_entity.unit_number].request
		player.gui.center.MaterializerTank.add({type = "button", name = "CWMaterializerTankOK",caption = "OK" })
		
	end
end

local function gui_teleporter(player , main_entity)
	if player.force == main_entity.force and player.gui.center.teleporter == nil then 
		player.gui.center.add({type = "frame", name = "teleporter", direction = "vertical", caption = {"GUIdescription.CW-ts-teleporter"}})
		player.gui.center.teleporter.add({type = "table",name = "table", column_count = 2})
		player.gui.center.teleporter.table.add({type = "label", caption = {"GUIdescription.CW-ts-destination"}})
		player.gui.center.teleporter.table.add({type = "drop-down",name = "beacon"})
		player.gui.center.teleporter.add({type = "button", name = "CWTeleporterOK",caption = "OK" })
		
		local list = {}
		for idx , beacon in pairs(global.tesseract_data[player.force.index].beacons) do
			list[idx] = beacon.backer_name
		end
		player.gui.center.teleporter.table.beacon.items = list
		local destination = global.tesseract_data[player.force.index].teleports[main_entity.unit_number].destination
		if valid(destination) then
			local selected_index = 0
			for idx , beacon in pairs(player.gui.center.teleporter.table.beacon.items) do
				if beacon == destination.backer_name then
					selected_index = idx
				end
			end
			player.gui.center.teleporter.table.beacon.selected_index = selected_index
		end
	end
end

local function gui_teleport_beacon(player , main_entity)
	if player.force == main_entity.force and player.gui.center.teleportBeacon == nil then 
		player.gui.center.add({type = "frame", name = "teleportBeacon", direction = "vertical", caption = {"GUIdescription.CW-ts-teleport-beacon"}})
		player.gui.center.teleportBeacon.add({type = "table",name = "table", column_count = 2})
		player.gui.center.teleportBeacon.table.add({type = "label", caption = {"GUIdescription.CW-ts-name"}})
		player.gui.center.teleportBeacon.table.add ({type = "textfield", name = "beaconName",text = global.tesseract_data[player.force.index].beacons[main_entity.unit_number].backer_name ,clear_and_focus_on_right_click  = true })
		player.gui.center.teleportBeacon.add({type = "button", name = "CWTeleportBeaconOK",caption = "OK" })
	end
end



local function configure_input(event)
	local player = game.players[event.player_index]
	local main_entity = player.selected
	if valid(main_entity) and player.force == main_entity.force then
	
		if main_entity.name == "CW-ts-materializer-chest" or main_entity.name == "CW-ts-logistic-materializer-chest" then
			--player_MD[player.index].selected_entity = main_entity
			player.opened = global.tesseract_data[player.force.index].materializer_chests[main_entity.unit_number].m_connector
		elseif main_entity.name == "CW-materializer-connector" then
			player.opened = main_entity
		elseif main_entity.name == "CW-ts-materializer-tank" or main_entity.name == "CW-ts-mini-materializer-tank"  then
			player_MD[player.index].selected_entity = main_entity
			gui_materizer_tank(player , main_entity)
		elseif main_entity.name == "CW-ts-teleporter" then
			player_MD[player.index].selected_entity = main_entity
			gui_teleporter(player , main_entity)
		elseif main_entity.name == "CW-ts-teleport-beacon" then
			player_MD[player.index].selected_entity = main_entity
			gui_teleport_beacon(player , main_entity)
		end
	end
end

local function toggle_window(event)
	local player = game.players[event.player_index]
	if valid(player.gui.screen.tesseractGUI) then
		destroyGUI(player)
	else
		recreate_player_GUI(player)
	end
end
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event("CW-configure-input", configure_input)
script.on_event("CW-toggle-Tesseract-window", toggle_window)















