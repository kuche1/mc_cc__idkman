

local fname = "./sus.lua"

fs.delete(fname)

local req = http.get("https://raw.githubusercontent.com/kuche1/mc_cc__idkman/master/sus.lua")

local data = req.readAll()

local f = fs.open(fname, "w")

f.write(data)

f.close()


