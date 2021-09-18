
---- TODO
-- resource recognition

local FUEL_IND = 16

function dig(leny, lenx)

	-- fuel refill

	turtle.select(FUEL_IND)
	turtle.refill()

	while true do

		-- init

		turtle.dig()
		turtle.forward()
		-- turtle.turnLeft()
		turtle.turnRight()

		-- loop

		local y = 1
		while y < leny

			--turtle.turnRight()
			--turtle.turnRight()

			local x = 1
			while x < lenx

				turtle.dig()
				turtle.forward()

				x = x + 1
			end
			
			y = y + 1

			if y ~= leny then
				turtle.digUp()
				turtle.up()
				turtle.turnLeft()
				turtle.turnLeft()
			end
			
		end

		for i=1,leny do
			turtle.down()
		end

		if leny%2 == 1 then
			for i=1,lenx do
				turtle.back()
			end
			turtle.turnLeft()
		else
			turtle.turnRight()
		end

	end

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
