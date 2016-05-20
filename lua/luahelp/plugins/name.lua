require ("console")
concommand.Add ("luahelp_setname", function (_, _, args)
	local cvar = GetConVar ("name")
	if not cvar.IsExtended then
		Msg ("Unable to set ConVar \"name\" directly.\n")
		return
	end
	cvar:SetValue (args [1])
end)