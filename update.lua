
---- TODO
-- backup the old updater

function update_a_file(arg_fname)

	local fname = "./"..arg_fname

	fs.delete(fname)

	local req = http.get("https://raw.githubusercontent.com/kuche1/mc_cc__idkman/master/"..arg_fname)

	local data = req.readAll()

	local f = fs.open(fname, "w")

	f.write(data)

	f.close()

end

local files_to_update = {"update.lua", "swus.lua"}

local item = files_to_upload
for item do
	update_a_file(item.valie)
	item = item.next
end

