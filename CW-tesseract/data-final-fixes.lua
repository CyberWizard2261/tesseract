
require("prototypes.tecnologies")
for _, armor in pairs(data.raw.armor) do
	if armor.equipment_grid ~= nil then
		local grid = table.deepcopy(data.raw["equipment-grid"][armor.equipment_grid])
		grid.name = "CW-ts-"..grid.name
		table.insert(grid.equipment_categories, "CW-ts-logistic")
		armor.equipment_grid = grid.name
	
		data:extend({grid})
	end
end