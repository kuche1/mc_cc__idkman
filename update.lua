
---- TODO
-- backup the old updater


local UPDATER = "update.lua"
local UPDATER_BACKUP = "update_old.lua"

local FILES_TO_UPDATE = {"swus.lua", UPDATER}


function update_a_file(arg_fname)

	local fname = "./"..arg_fname

	local req = http.get("https://raw.githubusercontent.com/kuche1/mc_cc__idkman/master/"..arg_fname)

	local resp_code = req.getResponseCode()
	print("file '"..fname.."' response "..resp_code)
	if resp_code ~= 200 then
		req.close()
		error("bad response")
	end

	local data = req.readAll()
	req.close()

	fs.delete(fname)
	local f = fs.open(fname, "w")
	f.write(data)
	f.close()

end


fs.delete("./"..UPDATER_BACKUP)
fs.copy("./"..UPDATER, "./"..UPDATER_BACKUP)

local i = 1

while i <= #FILES_TO_UPDATE do
	local item = FILES_TO_UPDATE[i]
	update_a_file(item)
	i = i + 1
end

fs.delete("./"..UPDATER_BACKUP)


