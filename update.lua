
---- TODO
-- backup the old updater


local FILES_TO_UPDATE = {"update.lua", "swus.lua"}


function update_a_file(arg_fname)

	local fname = "./"..arg_fname

	fs.delete(fname)

	local req = http.get("https://raw.githubusercontent.com/kuche1/mc_cc__idkman/master/"..arg_fname)

	local data = req.readAll()

	local f = fs.open(fname, "w")

	f.write(data)

	f.close()

end


fs.delete("./update_old.lua")
fs.copy("./update.lua", "./update_old.lua")

local i = 1

while i <= #FILES_TO_UPDATE do
	local item = FILES_TO_UPDATE[i]
	update_a_file(item)
	i = i + 1
end

fs.delete("./update_old.lua")

