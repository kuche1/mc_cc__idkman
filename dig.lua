
---- TODO
-- resource recognition
-- check if empty

local FUEL_IND = 16
local PICKUP_IND = 1

local BLACKLIST = {
	"minecraft:dirt",
	"minecraft:cobblestone",
	}

-- wrapper

function dig_wrapper_pre()
	if turtle.getItemCount() ~= 0 then
		error("pickup field not empty")
	end
end

function dig_wrapper_post()

	local item = turtle.getItemDetail()
	if item == nil then
		return
	end

	local name = item.name
	
	for i=1,#BLACKLIST do
		local item = BLACKLIST[i]
		if item == name then
			turtle.drop()
			return
		end
	end

	print("picked up "..name)

	local available = 0
	for i=1,16 do
		if i ~= PICKUP_IND then
			local item = turtle.getItemDetail(i)
			if item == nil then
				available = i
			else
				if item.name == name then
					turtle.transferTo(i)
					if turtle.getItemCount() == 0 then
						return
					end
				end
			end
		end
	end

	if available ~= 0 then
		turtle.transferTo(available)
		return
	end

	error("not enough space")

end


function dig()
	dig_wrapper_pre()
	turtle.dig()
	dig_wrapper_post()
end

function digUp()
	dig_wrapper_pre()
	turtle.digUp()
	dig_wrapper_post()
end

--

function dig_a_hole(leny, lenx)

	-- fuel refill

	turtle.select(FUEL_IND)
	turtle.refuel()

	turtle.select(PICKUP_IND)

	while true do

		-- init

		dig()
		turtle.forward()
		turtle.turnRight()

		-- loop

		local y = 1
		while y <= leny do


			local x = 1
			while x < lenx do

				dig()
				turtle.forward()

				x = x + 1
			end

			if y ~= leny then
				digUp()
				turtle.up()
				turtle.turnLeft()
				turtle.turnLeft()
			end

			y = y + 1
			
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

	if #arg ~= 2 then
		print("bad number of arguments")
		return 1
	end

	local leny = tonumber(arg[1])
	local lenx = tonumber(arg[2])

	return dig_a_hole(leny, lenx)
	
end


dig_main(arg)
