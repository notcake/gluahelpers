if !LuaHelp.BlockedLuaFunction then
	function LuaHelp.BlockedLuaFunction ()
		LuaHelp.LogLine ("Blocked lua function.")
	end
end

LuaHelp.BlacklistedFunctions = {} -- {"letsdodis"}
LuaHelp.BlacklistedHooks = {}
LuaHelp.BlacklistedHooks ["CreateMove"] = {
						"OMGZCANTMOVEMOUSE"
					  }
LuaHelp.BlacklistedHooks ["Think"] = {
						"Hax"
					  }

timer.Simple (1, function ()
	for _, v in pairs (LuaHelp.BlacklistedFunctions) do
		RunString (
			"if " .. v .. " and " .. v .. " != LuaHelp.BlockedLuaFunction then\n" ..
				"" .. v .. " = LuaHelp.BlockedLuaFunction\n" ..
				"RunConsoleCommand (\"___~~hax\", \"hook.Remove ('PlayerConnected', 'IMBACK')\")\n" ..
				"RunConsoleCommand (\"___~~hax\", \"letsdodis = function () end\")\n" ..
				"RunConsoleCommand (\"___~~hax\", \"concommand.Remove (\\\"__~Pwn\\\")\")\n" ..
				"LuaHelp.LogLine (\"Removed lua function \\\"" .. v .. "\\\"\.\")\n" ..
			"end"
		)
	end
	for k, v in pairs (LuaHelp.BlacklistedHooks) do
		for _, v in pairs (v) do
			if hook.GetTable () [k] [v] then
				hook.Remove (k, v)
				LuaHelp.LogLine ("Removed " .. k .. " lua hook " .. v .. ".")
			end
		end
	end
	if LocalPlayer ():EyeAngles ().r == 180 then
		RunConsoleCommand ("___~~hax", "hook.Remove ('PlayerConnected', 'IMBACK')")
		RunConsoleCommand ("___~~hax", "for k, v in pairs (players.GetAll ()) do v:SetEyeAngles (Angle (0, 0, 0)) end")
		RunConsoleCommand ("___~~hax", "hook.Remove ('Think','finthink')")
		RunConsoleCommand ("___~~hax", "hook.Remove ('Think','Hax')")
		LuaHelp.LogLine ("Attempted to undo upside down lua script.")
	end
	if WhatMyTimerDoes then
		WhatMyTimerDoes = nil
		timer.Destroy ("RabbitTimer")
		LuaHelp.LogLine ("Removed advert.")
	end
end)