
---- TODO
-- check for fuel
-- get back down in case of an error
-- calculate the needed amount of fuel

---- INFO
-- fuel goes to 16
-- all else is building blocks

local FUEL_IND = 16
local LAST_BUILD_IND = 15

local CHAR_EMPTY = ' '
local SHAPE =
	{
		"xxx xxx x   x",
		"x   x    x x ",
		"xxx xxx   x  ",
		"  x x    x x ",
		"xxx xxx x   x",
	}

---- turtle place wrapper

function place_wrapper()

	while turtle.getItemCount() == 0 do

		local next = turtle.getSelectedSlot() + 1
		if next > LAST_BUILD_IND then
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

---- turtle go wrapper

function forward()
	turtle.forward()
end

function back()
	turtle.back()
end

function up()
	turtle.up()
end

---- turtle

function get_given_resources() -- rename to get_available_resources

	local count = 0

	local i = 1
	while i < FUEL_IND do
		count = count + turtle.getItemCount(i)
		i = i + 1
	end

	return count
end

---- else

function count_blocks(multistring)
	local count = 0
	local y = 1
	while y <= #multistring do
		local str = multistring[y]
		local x = 1
		while x <= #str do
			local char = string.sub(str, x,x)
			if char ~= CHAR_EMPTY then
				count = count + 1
			end
			x = x + 1
		end
		y = y + 1
	end
	return count
end

function build_shape(shape)

	local leny = #shape

	if leny == 0 then
		print("empty shape")
		return 1
	end

	local lenx = #shape[1]

	local i = 2
	while i <= leny do
		local test_len = #shape[i]
		if test_len ~= lenx then
			print("the shape needs to be a rectangle")
			return 1
		end
		i = i + 1
	end

	local required_resources = count_blocks(shape)
	local given_resources = get_given_resources()

	print("required resources: "..required_resources.." given resources: "..given_resources)
	if given_resources < required_resources then
		print("not enough resources")
		return 1
	end

	-- refuel

	turtle.select(FUEL_IND)
	turtle.refuel()

	turtle.select(1)

	-- start building

	turtle.turnLeft()
	turtle.turnLeft()

	local y = 0
	while y < leny do

		local x = 0
		while x < lenx do

			back()

			local inx

			if y%2 == 0 then
				indx = x + 1
			else
				indx = lenx-x
			end

			local indy = leny-y

			if string.sub(shape[indy], indx,indx) ~= CHAR_EMPTY then
				place()
			end

			x = x + 1
		end

		up()
		turtle.turnLeft()
		turtle.turnLeft()
		back()
		
		y = y + 1
	end

end

build_shape(SHAPE)
