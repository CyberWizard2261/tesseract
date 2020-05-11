-- Make Lab accept all materials --
--[[
local inputsTable = {}
for k, lab in pairs(data.raw.lab) do
	for k, name in pairs(lab.inputs) do
		inputsTable[name] = name
	end
end
data.raw.lab["CW-ts-lab"].inputs = inputsTable
--]]
require("prototypes.tecnologies")