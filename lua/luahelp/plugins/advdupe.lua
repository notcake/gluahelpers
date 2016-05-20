LuaHelp.AddPopulateShenanigansCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Advanced Duplicator Filesystem Access", Label = "Advanced Duplicator Filesystem Access", Command = "luahelp_advdupefsaccess"})
	Panel:AddControl ("Button", {Text = "Advanced Duplicator Public Folder Access", Label = "Advanced Duplicator Public Folder Access", Command = "luahelp_advdupepfaccess"})
end)

concommand.Add ("luahelp_advdupefsaccess", function ()
	if GetConVar ("gmod_toolmode"):GetString () != "adv_duplicator" then
		RunConsoleCommand ("tool_adv_duplicator")
		timer.Create ("LuaHelp.AdvancedDuplicatorFilesystemAccess", 0.5, 1, function ()
			RunConsoleCommand ("adv_duplicator_open_dir", dupeshare.BaseDir .. "/" .. dupeshare.PublicDirs [1] .. "/../../..")
		end)
	else

		RunConsoleCommand ("adv_duplicator_open_dir", dupeshare.BaseDir .. "/" .. dupeshare.PublicDirs [1] .. "/../../..")
	end
	LuaHelp.LogLine ("Advanced duplicator directory set to garrysmod/")
end)

concommand.Add ("luahelp_advdupepfaccess", function ()
	if GetConVar ("gmod_toolmode"):GetString () != "adv_duplicator" then
		RunConsoleCommand ("tool_adv_duplicator")
		timer.Create ("LuaHelp.AdvancedDuplicatorPublicFolderAccess", 0.5, 1, function ()
			RunConsoleCommand ("adv_duplicator_open_dir", dupeshare.BaseDir .. "/" .. dupeshare.PublicDirs [1])
		end)
	else
		RunConsoleCommand ("adv_duplicator_open_dir", dupeshare.BaseDir .. "/" .. dupeshare.PublicDirs [1])
	end
	LuaHelp.LogLine ("Advanced duplicator directory set to data/adv_duplicator/=Public Folder=/")
end)