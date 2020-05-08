
function valid(teste)
	if teste ~= nil and teste.valid then
		return true
	else
		return false
	end
end

function distance(possitionA,postionB)
	x = math.abs(possitionA.x - postionB.x)
	y = math.abs(possitionA.y - postionB.y)
	return (x^2+y^2)^0.5
end


function format_num(num , sgn)
	local result = ""
	if sgn == nil then
		sgn = ""
	end
	if math.abs(num / 10^15) >= 1 then
		result = math.floor(num / 10^14 + 0.5) /10 .. "P" .. sgn
	elseif math.abs(num / 10^12) >= 1 then
		result = math.floor(num / 10^11 + 0.5) /10 .. "T" .. sgn
	elseif math.abs(num / 10^9) >= 1 then
		result = math.floor(num / 10^8 + 0.5) /10 .. "G" .. sgn
	elseif math.abs(num / 10^6) >= 1 then
		result = math.floor(num / 10^5 + 0.5) /10 .. "M" .. sgn
	elseif math.abs(num / 10^3) >= 1 then
		result = math.floor(num / 10^2 + 0.5) /10 .. "K" .. sgn
	else
		result = math.floor(num*10 + 0.5)/10 .. sgn
	end
	return result
end






