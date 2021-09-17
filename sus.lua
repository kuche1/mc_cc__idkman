
local BUILD_IND = 1
local FUEL_IND = 2

function putSwas()

	local size = 5

	if size%2 != 1 then
		print("bad size")
		return 1
	end
	
	local half = math.floor(size / 2)

	turtle.select(FUEL_IND)
	turtle.refuel()

	turtle.select(BUILD_IND)
	turtle.up()

	-- 0% done

	for i=1,half+1 do
	    turtle.forward()
	    turtle.placeDown()
	end

	for i=1,size-1 do
	    turtle.up()
	    turtle.placeDown()
	end

	-- 25% done

	for i=1,half do
	    turtle.forward()
	    turtle.placeDown()
	end

	-- 50% done

	turtle.forward()
	turtle.down()
	turtle.down()

	for i=1,half do
	    turtle.back()
	    turtle.placeDown()
	end

	for i=1,half do
	    turtle.forward()
	end

	turtle.down()

	turtle.turnRight()
	turtle.turnRight()

	for i=1,half do
	    turtle.down()
	    turtle.place()
	end

	turtle.turnRight()
	turtle.turnRight()

	-- 75% done

	for i=1,5 do
	    turtle.up()
	end

	for i=1,4 do
	    turtle.back()
	end

	for i=1,2 do
	    turtle.down()
	end

	turtle.placeDown()
	turtle.back()
	turtle.placeDown()

	for i=1,2 do
	    turtle.up()
	    turtle.placeDown()
	end

	-- 100% done

	for i=1,5 do
	    turtle.forward()
	end

	for i=1,5 do
	    turtle.down()
	end

end

putSwas()

