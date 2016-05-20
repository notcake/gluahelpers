function LuaHelp.IsMouseInCitrusPanel (Panel)
	// LuaHelp.LogLine (string.format ("%s (%d, %d) : (%d, %d) to (%d, %d)", Panel.Text, gui.MouseX (), gui.MouseY (), Panel.X, Panel.Y, Panel.X + Panel.Width, Panel.Y + Panel.Height))
	if gui.MouseX () >= Panel.X and gui.MouseX () < Panel.X + Panel.Width and
	   gui.MouseY () >= Panel.Y and gui.MouseY () < Panel.Y + Panel.Height then
		return true
	end
	return false
end

timer.Create ("LuaHelp.CitrusLog", 0.1, 1, function ()
	if citrus then
		if citrus.Menus then
			if !LuaHelp.OldcitrusMenusTextEntry then
				LuaHelp.OldcitrusMenusTextEntry = citrus.Menus.TextEntry
			end
			
			function citrus.Menus.TextEntry (Title, Command, Discontinue)
				local strcommand = tostring (Command)
				if type (Command) == "string" then
					LuaHelp.LogLine ("Citrus text entry: \"" .. Title .. "\": \"" .. strcommand .. "\".")
				else
					// LuaHelp.LogLine ("Citrus text entry: \"" .. Title .. "\": " .. strcommand .. ".")
				end
				return LuaHelp.OldcitrusMenusTextEntry (Title, Command, Discontinue)
			end
		end
		
		if citrus.Controls then
			if !LuaHelp.OldcitrusSliderOnMouseReleased then
				LuaHelp.OldcitrusSliderOnMouseReleased = citrus.Controls.Stored ["Slider"].OnMouseReleased
			end
	
			citrus.Controls.Stored ["Slider"].OnMouseReleased = function (self, Button)
				LuaHelp.OldcitrusSliderOnMouseReleased (self, Button)
				if LuaHelp.IsMouseInCitrusPanel (self) then
					LuaHelp.LogLine ("Citrus slider command: " .. self.Text .. ": \"" .. self.Command .. "\".")
				end
			end
		end
	end
end)

LuaHelp.AddUninitHook (function ()
	timer.Destroy ("LuaHelp.CitrusLog")
end)