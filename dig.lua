
local FUEL_IND = 16

function dig(leny, lenx)

	turtle.select(FUEL_IND)
	
end

function dig_main(arg)

	if #arg ~= 2
		print("bad number of arguments")
		return 1
	end

	local leny = tonumber(arg[1])
	local lenx = tonumber(arg[2])

	return dig(leny, lenx)
	
end

dig_main(arg)
