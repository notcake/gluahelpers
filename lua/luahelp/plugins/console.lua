LuaHelp.ConsoleLines = {}

function LuaHelp.LogLine (line, color)
	Msg (line .. "\n")
	if LuaHelp.ConsolePanel then
		LuaHelp.ConsolePanel:AddLine (line, color)
	else
		LuaHelp.DelayLogLine (line, color)
	end
end

function LuaHelp.DelayLogLine (line, color)
	timer.Create (util.CRC (line), 0.1, 1, function (line)
		if LuaHelp.ConsolePanel then
			LuaHelp.ConsolePanel:AddLine (line, color)
		else
			timer.Create (util.CRC (line .. util.CRC (math.random ())), 0.2, 1, LuaHelp.DelayLogLine, line, color)
		end
	end, line)
end

local VCONSOLEPANEL = {}

function VCONSOLEPANEL:Init ()
	self:SetTitle ("Lua Debugging Console")
	self:SetZPos (-1)

	self:SetSize (ScrW () * 0.296, ScrH () * 0.298)
	self:SetPos (0, ScrH () * 0.184)
	self:SetDeleteOnClose (false)
	self:SetDraggable (false)
	self:SetSizable (false)
	self:SetMouseInputEnabled (false)

	self:ShowCloseButton (false)
	self:SetAlpha (0)

	self.FadeTime = 2
	self.StayTime = 10
	self.LastMessageTime = RealTime () - self.StayTime - self.FadeTime

	self.Lines = self.Lines or {}
	self.LineColors = self.LineColors or {}
end

function VCONSOLEPANEL:PerformLayout ()
	DFrame.PerformLayout (self)
end

function VCONSOLEPANEL:Paint ()
	self.LinesDrawn = 0
	local alpha = 255
	if RealTime () - self.LastMessageTime > self.StayTime then
		alpha = 255 - 255 * ((RealTime () - self.LastMessageTime - self.StayTime) / self.FadeTime)
	end
	if alpha < 0 then
		alpha = 0
	end
	if self:GetAlpha () > 0 then
		self:SetAlpha (alpha)
	end
	if self:GetAlpha () == 0 then
		return
	end
	draw.RoundedBox (8, 0, 0, self:GetWide (), self:GetTall (), Color(64, 64, 64, 128))

	local maxLines = math.Round ((self:GetTall () - 25) / 14 - 1)
	while self.LinesDrawn <= maxLines and #self.Lines - self.LinesDrawn > 0 do	
		draw.SimpleText (self.Lines [#self.Lines - self.LinesDrawn], "Default", 8, 25 + (maxLines - self.LinesDrawn) * 14, self.LineColors [#self.LineColors - self.LinesDrawn], 0, 0)
		self.LinesDrawn = self.LinesDrawn + 1
	end
	return true
end

function VCONSOLEPANEL:AddLine (text, color)
	self.LastMessageTime = RealTime ()
	self:SetAlpha (255)
	color = color or Color (255, 255, 0, 255)
	table.insert (self.Lines, text)
	table.insert (self.LineColors, color)
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpConsole", VCONSOLEPANEL, "DFrame")
	LuaHelp.ConsolePanel = vgui.Create ("LuaHelpConsole")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.ConsolePanel then
		LuaHelp.ConsolePanel:Remove ()
		LuaHelp.ConsolePanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Lua Console", Label = "View Lua Console", Command = "luahelp_openconsole"})
end)

concommand.Add ("luahelp_openconsole", function ()
	LuaHelp.ConsolePanel.LastMessageTime = RealTime ()
	LuaHelp.ConsolePanel:SetAlpha (255)
end)

concommand.Add ("luahelp_clearconsole", function ()
	LuaHelp.ConsolePanel.Lines = {}
	LuaHelp.ConsolePanel.LineColors = {}
end)

concommand.Add ("luahelp_logline", function (_, _, args)
	local argstring = ""
	for k, v in pairs (args) do
		if string.len (argstring) > 0 then
			argstring = argstring .. " "
		end
		argstring = argstring .. v
	end
	LuaHelp.LogLine (argstring)
end)