SEBootstrap = {}
SEBootstrap.IncludeProxies = {}
SEBootstrap.FindInLuaProxies = {}

if SERVER then
	AddCSLuaFile ("scriptenforcer_bootstrap.lua")
end

local autocomplete = nil
concommand.Add ("lua_run_cl_", function (_, _, args)
	if not autocomplete then
		autocomplete = table.concat (args, " ")
	end
	RunString (autocomplete)
	autocomplete = nil
end, function (_, command)
	autocomplete = command:sub (2)
end)

concommand.Add ("lua_openscript_cl_", function (_, _, args)
	local filename = args [1]
	if not filename then
		print ("SE Bootstrap: No file specified.")
		return
	end
	local addons = file.FindDir ("addons/*", true)
	local path = nil
	for _, folder in ipairs (addons) do
		if file.Exists ("addons/" .. folder .. "/lua/" .. filename, true) then
			path = "addons/" .. folder .. "/lua/"
			break
		end
	end
	if not path then
		if file.Exists ("lua/" .. filename, true) then
			path = "lua/"
		end
	end
	if not path then
		print ("SE Bootstrap: Unable to find file specified in addons/ or lua/.")
		return
	end
	print("SE Bootstrap: Found file at " .. path .. ".")
	local folder = path
	
	local searchpaths = {
		[path] = 1
	}
	local _include = include
	include = function (filename)
		local foundpath = path
		local code = nil
		for k, _ in pairs (searchpaths) do
			code = file.Read (k .. filename, true)
			if code then
				foundpath = k
				break
			end
		end
		if not code then
			ErrorNoHalt ("SE Bootstrap: Failed to find file " .. filename .. ".\n")
			Msg ("Search paths:\n")
			PrintTable (searchpaths)
			return
		else
			print ("including " .. foundpath .. filename)
		end
		
		local searchpath = foundpath .. filename
		searchpath = searchpath:sub (1, -searchpath:reverse ():find ("/"))
		if searchpaths [searchpath] then
			searchpaths [searchpath] = searchpaths [searchpath] + 1
		else
			searchpaths [searchpath] = 1
		end
		code = code:gsub ("include[ ]*%(", "SEBootstrap.IncludeProxies[\"" .. path .. "\"](")
		RunString (code:gsub ("file.FindInLua[ ]*%(", "SEBootstrap.FindInLuaProxies[\"" .. path .. "\"]("))
		searchpaths [searchpath] = searchpaths [searchpath] - 1
		if searchpaths [searchpath] == 0 then
			searchpaths [searchpath] = nil
		end
	end
	SEBootstrap.IncludeProxies [path] = include
	SEBootstrap.FindInLuaProxies [path] = function (path)
		return file.Find (folder .. path, true)
	end
	include (filename)
	include = _include
end)