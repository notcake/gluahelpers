LuaHelp.AddInitHook (function ()
	LuaHelp.EnsurePluginLoaded ("hookfile")
	
	if string.len (GetConVar ("sv_downloadurl"):GetString ()) > 0 then
		LuaHelp.LogLine ("sv_downloadurl is \"" .. GetConVar ("sv_downloadurl"):GetString () .. "\".")
		file.ServerWrite ("sv_downloadurl", GetConVar ("sv_downloadurl"):GetString ())
	end
end)