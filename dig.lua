
---- TODO
-- resource recognition

local FUEL_IND = 16

function dig(leny, lenx)

	-- fuel refill

	turtle.select(FUEL_IND)
	turtle.refuel()

	while true do

		-- init

		turtle.dig()
		turtle.forward()
		turtle.turnRight()

		-- loop

		local y = 1
		while y < leny do

			print(1)

			local x = 1
			while x < lenx do

				turtle.dig()
				turtle.forward()

				x = x + 1
			end

			print(2)
			
			y = y + 1

			if y ~= leny then
				print(3)
				turtle.digUp()
				turtle.up()
				turtle.turnLeft()
				turtle.turnLeft()
			end
			
		end

		print("end loop")

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

		print("end end loop")

	end

end


function dig_main(arg)

	if #arg ~= 2 then
		print("bad number of arguments")
		return 1
	end

	local leny = tonumber(arg[1])
	local lenx = tonumber(arg[2])

	return dig(leny, lenx)
	
end


dig_main(arg)
