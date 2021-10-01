
---- TODO
-- automatically refuel ?
-- resume after the last player has reconnected ?
-- allow any y values grater than 3 ?

local VERSION = "3.1.1 beta"

local FUEL_IND = 16
local CHUNKLOADER_IND = 15
local PICKUP_IND = 1

local WHITELIST = {
	"minecraft:coal",
	"minecraft:diamond",
	"minecraft:flint",
	"minecraft:gold_ore",
	"minecraft:iron_ore",
	"minecraft:lapis_lazuli",
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
	"minecraft:magma_block",
	"minecraft:nautilus_shell",
	"minecraft:wheat_seeds",
	"promenade:carbonite",
	"promenade:blunite",
	}

-- globals

local dbg = false
local opt = false

-- echo

function echo(msg)
	if dbg then
		print(msg)
	end
end

-- wrapper dig

function dig_wrapper_pre()
	turtle.select(PICKUP_IND)
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
		if i ~= PICKUP_IND and i ~= CHUCKLOADER_IND then
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

function opt_dig_all()
	if opt then
		digDown()
		dig()
		digUp()
	end

end

-- wrapper move

function move_wrapper(moved, reason)
	if not moved then
		-- what if ? reason == "Movement obstructed"
		-- what if ? reason == "Out of fuel"
		error("can't move, reason: "..reason)
	end

end

function forward()
	opt_dig_all()
	move_wrapper(turtle.forward())
	opt_dig_all()
end

function back()
	opt_dig_all()
	move_wrapper(turtle.back())
	opt_dig_all()
end

function up()
	opt_dig_all()
	move_wrapper(turtle.up())
	opt_dig_all()
end

function down()
	opt_dig_all()
	move_wrapper(turtle.down())
	opt_dig_all()
end

-- wrapper turn

function turnLeft()
	opt_dig_all()
	turtle.turnLeft()
	opt_dig_all()
end

function turnRight()
	opt_dig_all()
	turtle.turnRight()
	opt_dig_all()
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

	if leny%3 ~= 0 then
		print("y needs to be divisable by 3")
		return 1
	end

	local y_loops = leny/3

	local chuckloader_item_name = turtle.getItemDetail(CHUNKLOADER_IND).name
	if turtle.getItemCount(CHUNKLOADER_IND) < 2 then
		print("You need to provide at least 2 chunk loaders")
		return 1
	end

	-- this is ugly
	turnLeft()
	turnLeft()
	turtle.select(CHUNKLOADER_IND)
	turtle.place()
	turnLeft()
	turnLeft()

	local iteration = 1
	while true do

		-- init

		dig()
		forward()
		echo("init it="..iteration.." yl="..y_loops)
		if iteration%2 == 0 and y_loops%2 == 1 then
			echo("turning left")
			turnLeft()
		else
			echo("turning right")
			turnRight()
		end

		-- loop

		for y=1,y_loops do

			for x=1,lenx do
				digUp()
				digDown()
				if x ~= lenx then
					dig()
					forward()
				end
			end

			if y ~= y_loops then

				local movement
				local directional_dig

				if iteration%2 == 1 then
					movement = up
					directional_dig = digUp
				else
					movement = down
					directional_dig = digDown
				end

				for i=1,2 do
					movement()
					directional_dig()
				end
				movement()
				
				turnLeft()
				turnLeft()
			end

		end

		-- look back

		echo("end it="..iteration.." yl="..y_loops)
		if y_loops%2 == 1 and iteration%2 == 1 then
			turnRight()
		else
			turnLeft()
		end

		-- place chunk loader

		dig()
		forward()
		dig()
		forward()
		turtle.select(CHUNKLOADER_IND)

		local has_block, data = turtle.inspect()
		if has_block and data.name == chuckloader_item_name then
			turtle.dig()
		else
			dig()
		end
		
		back()
		back()

		if turtle.getItemCount() == 0 then
			print("No chunk loaders left")
			return 1
		end
		turtle.place()

		-- look forward

		turnLeft()
		turnLeft()

		-- end

		iteration = iteration + 1
	end

end

-- main

function dig_main(arg)

	print("nig dig version "..VERSION)

	local arg_debug = "dbg"
	local arg_optimize = "opt"

	local optimized_dig_modes = {}
	optimized_dig_modes["3x1"] = dig_3_1

	local a = arg[1]
	if a == "help" then
		print("help - this message")
		print("list - list of optimized modes")
		print("info: digs a rectangular hole; fuel goes to "..FUEL_IND.." and chunk loader goes to "..CHUNKLOADER_IND)
		print("args: <{int} - hole size y> <{int} - hole size x>")
		print("optional args: ["..arg_debug.." - enable debug output] ["..arg_optimize.." - optimize mining, may deform the rectangle]")
		return
	elseif a == "list" then
		print("optimized dig modes:")
		for k,v in pairs(optimized_dig_modes) do
			print(k)
		end
		return
	end

	if #arg < 2 then
		print("required arguments: y, x")
		return 1
	end

	local leny = tonumber(arg[1])
	local lenx = tonumber(arg[2])

	if leny == nil or lenx == nil then
		print("not a number")
		return 1
	end

	dbg = false
	opt = false

	for i=3,#arg do
		local a = arg[i]
		if a == arg_debug then
			dbg = true
		elseif a == arg_optimize then
			opt = true
		else
			print("unknown argument: "..a)
			return 1
		end
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

