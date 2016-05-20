CreateClientConVar ("luahelp_cvar_string", "", false, true)
CreateClientConVar ("luahelp_cvar_float", 0, false, true)
CreateClientConVar ("luahelp_cvar_vec1", 0, false, true)
CreateClientConVar ("luahelp_cvar_vec2", 0, false, true)
CreateClientConVar ("luahelp_cvar_vec3", 0, false, true)

concommand.Add ("luahelp_createconvar", function (_, _, args)
	if !args [1] or type (args [1]) != "string" then
		return
	end
	CreateClientConVar ("luahelp_cvar_" .. args [1], "", false, true)
end)