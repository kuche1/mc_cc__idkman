
---- TODO
-- check for fuel
-- get back down in case of an error
-- calculate the needed amount of fuel

---- INFO
-- fuel goes to 16
-- all else is building blocks

local FUEL_IND = 16


function place_wrapper()

	while turtle.getItemCount() == 0 do

		local next = turtle.getSelectedSlot() + 1
		if next >= FUEL_IND then
			error("ran out of building blocks")
		else
			turtle.select(next)
		end

	end

end

function place()
	place_wrapper()
	turtle.place()
end

function placeForward()
	place_wrapper()
	turtle.placeDown()
end

function placeDown()
	place_wrapper()
	turtle.placeDown()
end


function get_given_resources()

	local count = 0
	local i = 1
	while i < FUEL_IND do
		turtle.select(i)
		count = count + turtle.getItemCount(i)
	end
	
	return count
end


function putSwas(arg)

	if #arg ~= 1 then
		print("bad number of arguments")
		return 1
	end

	local size = tonumber(arg[1]) -- 5

	if size%2 ~= 1 then
		print("bad size")
		return 1
	end
	
	local half = math.floor(size / 2)

	local required_resorces = (half+1)*4 + (size-2)*2 - 1
	local given_resources = get_given_resources()
	
	if given_resources < required_resources then
		print("not enough resources: needed "..required_resources.." given "..given_resources)
		return 1
	end

	turtle.select(FUEL_IND)
	turtle.refuel()

	turtle.select(1)

	turtle.up()

	-- 0% done

	for i=1,half+1 do
	    turtle.forward()
	    placeDown()
	end

	for i=1,size-1 do
	    turtle.up()
	    placeDown()
	end

	-- 25% +25/2% done

	for i=1,half do
	    turtle.forward()
	    placeDown()
	end

	-- 50% done

	turtle.forward()

	for i=1,half do
		turtle.down()
	end

	for i=1,half do
	    turtle.back()
	    placeDown()
	end

	for i=1,half do
	    turtle.forward()
	end

	turtle.down()

	turtle.turnRight()
	turtle.turnRight()

	for i=1,half do
	    turtle.down()
	    place()
	end

	turtle.turnRight()
	turtle.turnRight()

	-- 75% done

	for i=1,size do
	    turtle.up()
	end

	for i=1,half+2 do
	    turtle.back()
	end

	for i=1,half do
	    turtle.down()
	end

	for i=1,half-1 do
		placeDown()
		turtle.back()
	end

	placeDown()

	for i=1,half do
	    turtle.up()
	    placeDown()
	end

	-- 100% done

	for i=1,size do
	    turtle.forward()
	end

	for i=1,size do
	    turtle.down()
	end

end

putSwas(arg)

