
---- TODO
-- resume after the last player has reconnected ?
-- allow any y values grater than 3 ?
-- check if no chunkloader ?
-- put the chunkloader in the middle !
-- create a wrapper for place !
-- add more fuel items
-- remove the initial fuel requirement ?

local VERSION = "3.5.0 beta 2"

local IND_LAST = 16
local IND_CHUNKLOADER = 16
local PICKUP_IND = 1 -- rename

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
	"minecraft:stone",
	"minecraft:wheat_seeds",
	"pixelmon:amethyst",
	"pixelmon:crystal",
	"pixelmon:fire_stone_shard",
	"pixelmon:ruby",
	"pixelmon:sapphire",
	"pixelmon:silicon_ore",
	"promenade:carbonite",
	"promenade:blunite",
	}

local ITEM_FUEL = "minecraft:coal"

-- globals

local dbg = false
local opt = false

-- echo, error

function echo(msg)
	if dbg then
		print(msg)
	end
end

function error_msg(msg)
	local status, data = pcall(function() error(msg, 4) end)

	print(data)

	local f = fs.open("error_log", "w")
	f.write(os.date())
	f.write("\n")
	f.write(data)
	f.write("\n")
	f.close()

	error(msg, 2)
end

-- backpack

function backpack_contains(item_name)

	for i=1,IND_LAST do
		local item = turtle.getItemDetail(i)
		if item ~= nil then
			if item.name == item_name then
				return true, i
			end
		end
	end
	return false, -1
end

-- wrapper dig

function dig_wrapper_pre()
	turtle.select(PICKUP_IND)
	if turtle.getItemCount() ~= 0 then
		error_msg("pickup field not empty")
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
	for i=1,IND_LAST do
		if i ~= PICKUP_IND and i ~= IND_CHUNKLOADER then
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

	error_msg("not enough space")

end


function dig()
	while turtle.inspect() do
		dig_wrapper_pre()
		local digged, info = turtle.dig()
		if not digged then
			if info == "Nothing to dig here" then
				break
			else
				error_msg("can't dig, reason: "..info)
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
				error_msg("can't dig, reason: "..info)
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
				error_msg("can't dig, reason: "..info)
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

-- wrapper place

function place()
	local could_be_placed = turtle.place()
	if not could_be_placed then
		error_msg("could not place block")
	end
end

-- wrapper move

function move_wrapper(move_fnc)
	local moved, reason = move_fnc()
	if not moved then
		-- what if ? reason == "Movement obstructed"
		if reason == "Out of fuel" then
			local contains, idx = backpack_contains(ITEM_FUEL)
			if contains then
				local old_slot = turtle.getSelectedSlot()
				turtle.select(idx)
				turtle.refuel()
				turtle.select(old_slot)
				return move_wrapper(move_fnc)
			else
				error_msg("out of fuel, no fuel in backpack found")
			end
		else
			error_msg("can't move, reason: "..reason)
		end
	end
end

function forward()
	opt_dig_all()
	move_wrapper(turtle.forward)
	opt_dig_all()
end

function back()
	opt_dig_all()
	move_wrapper(turtle.back)
	opt_dig_all()
end

function up()
	opt_dig_all()
	move_wrapper(turtle.up)
	opt_dig_all()
end

function down()
	opt_dig_all()
	move_wrapper(turtle.down)
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

	local item_chunkloader = turtle.getItemDetail(IND_CHUNKLOADER)
	if item_chunkloader == nil then
		print("You need to put a chunkloader in slot "..IND_CHUNKLOADER)
		return 1
	end
	local chuckloader_item_name = item_chunkloader.name
	if turtle.getItemCount(IND_CHUNKLOADER) < 2 then
		print("You need to provide at least 2 chunk loaders")
		return 1
	end

	-- this is ugly
	turnLeft()
	turnLeft()
	turtle.select(IND_CHUNKLOADER)
	place()
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

		local has_block, data = turtle.inspect()
		if has_block and data.name == chuckloader_item_name then -- todo move to dig() function
			turtle.select(IND_CHUNKLOADER)
			turtle.dig()
		else
			dig()
		end
		
		back()
		back()

		if turtle.getItemCount(IND_CHUNKLOADER) == 0 then
			print("No chunk loaders left")
			return 1
		end
		turtle.select(IND_CHUNKLOADER)
		place()

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

	local arg_help = "--help"
	local arg_list = "--list"
	local arg_version = "--version"

	local optimized_dig_modes = {}
	optimized_dig_modes["3x1"] = dig_3_1

	local a = arg[1]
	if a == arg_help then
		print(arg_help.." - this message")
		print(arg_list.." - list of optimized modes")
		print("info: digs a rectangular hole; chunk loader goes to "..IND_CHUNKLOADER.."; fuel automatically consumed if any in backpack while out of fuel")
		print("args: <{int} - hole size y> <{int} - hole size x>")
		print("optional args: ["..arg_debug.." - enable debug output] ["..arg_optimize.." - optimize mining, may deform the rectangle]")
		return
	elseif a == arg_list then
		print("optimized dig modes:")
		for k,v in pairs(optimized_dig_modes) do
			print(k)
		end
		return
	elseif a == arg_version then
		return -- we're already printing this
	end

	if #arg < 2 then
		print("required arguments: y, x")
		dig_main({arg_help})
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

	local exists, idx = backpack_contains(ITEM_FUEL)
	if exists then
		local last_idx = turtle.getSelectedSlot()
		turtle.select(idx)
		turtle.refuel()
		turtle.select(last_idx)
	end

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

