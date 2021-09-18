
---- TODO
-- check if empty ?
-- automatically refuel ?
-- resume after the last player has reconnected ?
-- dig up ?
-- always use the wrapped movement

local VERSION = 1.10

local FUEL_IND = 16
local PICKUP_IND = 1

local WHITELIST = {
	"minecraft:coal",
	"minecraft:gold_ore",
	"minecraft:iron_ore",
	"minecraft:obsidian",
	"minecraft:redstone",
	}

local BLACKLIST = {
	"byg:rocky_stone",
	"minecraft:andesite",
	"minecraft:cobblestone",
	"minecraft:diorite",
	"minecraft:dirt",
	"minecraft:granite",
	"minecraft:gravel",
	"minecraft:wheat_seeds",
	"promenade:blunite",
	}

-- wrapper dig

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

	local in_whitelist = false
	for i=1,#WHITELIST do
		local item = WHITELIST[i]
		if item == name then
			in_whitelist = true
			break
		end
	end

	if not in_whitelist then
		print("picked up "..name)
	end

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
	while turtle.inspect() do
		dig_wrapper_pre()
		local digged, info = turtle.dig()
		if not digged then
			if info == "Nothing to dig here" then
				break
			else
				error("can't dig, reason: "..info)
			end
		end
		dig_wrapper_post()
	end
end

function digUp()
	while turtle.inspectUp() do
		dig_wrapper_pre()
		local digged, info = turtle.digUp()
		if not digged then
			if info == "Nothing to dig here" then
				break
			else
				error("can't dig, reason: "..info)
			end
		end
		dig_wrapper_post()
	end
end

function digDown()
	while turtle.inspectDown() do
		dig_wrapper_pre()
		local digged, info = turtle.digDown()
		if not digged then
			if info == "Nothing to dig here" then
				break
			else
				error("can't dig, reason: "..info)
			end
		end
		dig_wrapper_post()
	end
end

-- wrapper move

function forward()
	local moved, reason = turtle.forward()
	if not moved then
		error("can't move, reason: "..reason)
	end
end

-- dig 3 1

function dig_3_1()

	while true do

		digUp()
		digDown()
		dig()
		forward()

	end

end

-- dig any rect

function dig_any_rectangle(leny, lenx)

	if leny <= 0 or lenx <= 0 then
		print("you can't use negative values or 0")
		return 1
	end

	if leny%2 == 1 then
		print("warning: odd y values are suboptimal")
	end

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


		for i=1,leny-1 do
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

-- main

function dig_main(arg)

	print("nig dig v"..VERSION)

	local optimized_dig_modes = {}
	optimized_dig_modes["3x1"] = dig_3_1

	local a = arg[1]
	if a == "help" then
		print("help - this message")
		print("list - list of optimized modes")
		print("info: digs a rectangular hole")
		print("args: <hole size y> <hole size x>")
		return
	elseif a == "list" then
		print("optimized dig modes:")
		for k,v in pairs(optimized_dig_modes) do
			print(k)
		end
		return
	end

	if #arg ~= 2 then
		print("required arguments: y, x")
		return 1
	end

	local leny = tonumber(arg[1])
	local lenx = tonumber(arg[2])

	if leny == nil or lenx == nil then
		print("not a number")
		return 1
	end

	turtle.select(FUEL_IND)
	turtle.refuel()
	turtle.select(PICKUP_IND)

	local ind = leny.."x"..lenx

	for k,v in pairs(optimized_dig_modes) do
		if k == ind then
			return v()
		end
	end

	print("pre-optimized mode not found, reverting to default digger")
	return dig_any_rectangle(leny, lenx)

end


dig_main(arg)

