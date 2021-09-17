
---- INVENTORY
-- 4 - fuel (coal)
-- 1 - bloka za stroene (pe4ka)

function putSwas()

	turtle.select(4)
	turtle.refuel()

	turtle.select(1)
	turtle.up()

	for i=1,3 do
	    turtle.forward()
	    turtle.placeDown()
	end

	for i=1,4 do
	    turtle.up()
	    turtle.placeDown()
	end

	for i=1,2 do
	    turtle.forward()
	    turtle.placeDown()
	end

	turtle.forward()
	turtle.down()
	turtle.down()

	for i=1,2 do
	    turtle.back()
	    turtle.placeDown()
	end

	for i=1,2 do
	    turtle.forward()
	end

	for i=1,1 do
	    turtle.down()
	end

	turtle.turnRight()
	turtle.turnRight()

	for i=1,2 do
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
