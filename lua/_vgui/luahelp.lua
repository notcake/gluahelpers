Msg (FindMetaTable ("Player"))
concommand.Add ("lua_run_m", function (_, _, arguments)
	RunString (table.concat (arguments, " "))
end)
concommand.Add ("lua_openscript_m", function (_, _, arguments)
	include (table.concat (arguments, " "))
end)
	
if not FindMetaTable ("Player") then

	include ("luahelp/menu/downloads.lua")
end