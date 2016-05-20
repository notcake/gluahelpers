if CLIENT then
	include ("luahelp/luahelp.lua")
	
	concommand.Add ("luahelp_reload", function (_, _, _)
		include ("luahelp/luahelp.lua")
	end)
end