LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Fix Movement", Label = "Fix Movement", Command = "luahelp_fixmovement"})
end)

concommand.Add ("luahelp_fixmovement", function ()
	RunConsoleCommand ("-alt1")
	RunConsoleCommand ("-alt2")
	RunConsoleCommand ("-attack")
	RunConsoleCommand ("-attack2")
	RunConsoleCommand ("-back")
	RunConsoleCommand ("-break")
	RunConsoleCommand ("-camdistance")
	RunConsoleCommand ("-camin")
	RunConsoleCommand ("-cammousemove")
	RunConsoleCommand ("-camout")
	RunConsoleCommand ("-campitchdown")
	RunConsoleCommand ("-campitchup")
	RunConsoleCommand ("-camyawleft")
	RunConsoleCommand ("-camyawright")
	RunConsoleCommand ("-commandermousemove")
	RunConsoleCommand ("-demoui2")
	RunConsoleCommand ("-duck")
	RunConsoleCommand ("-forward")
	RunConsoleCommand ("-graph")
	RunConsoleCommand ("-grenade1")
	RunConsoleCommand ("-grenade2")
	RunConsoleCommand ("-jlook")
	RunConsoleCommand ("-jump")
	RunConsoleCommand ("-klook")
	RunConsoleCommand ("-left")
	RunConsoleCommand ("-lookdown")
	RunConsoleCommand ("-lookup")
	RunConsoleCommand ("-mat_texture_list")
	RunConsoleCommand ("-menu")
	RunConsoleCommand ("-menu_context")
	RunConsoleCommand ("-movedown")
	RunConsoleCommand ("-moveleft")
	RunConsoleCommand ("-moveright")
	RunConsoleCommand ("-moveup")
	RunConsoleCommand ("-posedebug")
	RunConsoleCommand ("-reload")
	RunConsoleCommand ("-right")
	RunConsoleCommand ("-score")
	RunConsoleCommand ("-showbudget")
	RunConsoleCommand ("-showbudget_texture")
	RunConsoleCommand ("-showbudget_texture_global")
	RunConsoleCommand ("-showscores")
	RunConsoleCommand ("-showvprof")
	RunConsoleCommand ("-snap")
	RunConsoleCommand ("-speed")
	RunConsoleCommand ("-strafe")
	RunConsoleCommand ("-vgui_drawtree")
	RunConsoleCommand ("-voicerecord")
	RunConsoleCommand ("-walk")
	RunConsoleCommand ("-zoom")
end)