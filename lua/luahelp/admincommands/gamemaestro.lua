LuaHelp.AddPopulateAdminCommandsHook (function (Panel)
	local servername = GetGlobalString ("ServerName")
	if string.find (servername, "GameMaestro.net") then
		Panel:AddControl ("Label", {Text = "GameMaestro.net Flood"})
		Panel:AddControl ("Label", {Text = "FM_kick is the command to kick players."})
		Panel:AddControl ("Label", {Text = "Change Map"})
	
		local maplist = {
			"fm_atlantasv2",
			"fm_bigtank_v2",
			"fm_cliffs_v1",
			"fm_fishtank",
			"fm_glacier",
			"fm_magmatic_rc3",
			"fm_sink",
			"fm_wierdholev2"
		}
		for _, v in pairs (maplist) do
			Panel:AddControl ("Button", {Text = v, Label = "Change map to " .. v .. ".", Command = "CT_ChgTo " .. v})
		end
	end
end)