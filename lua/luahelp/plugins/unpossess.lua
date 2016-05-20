LuaHelp.EnsurePluginLoaded ("hookusermessage")

local UNPOSSESSORPANEL = {}

function UNPOSSESSORPANEL:Init ()
	self:SetTitle ("Unpossessor")

	self:SetSize (ScrW () * 0.1, ScrH () * 0.1)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2 + 0.2 * ScrH ())

	self:ShowCloseButton (false)
	self:SetDraggable (false)
	self:SetDeleteOnClose (false)
	self:SetSizable (false)
	self:MakePopup ()

	self.btnEscape = vgui.Create ("DButton", self)
	self.btnEscape:SetText ("Escape")
	self.btnEscape.DoClick = function (button)
		self:SetVisible (false)
		RunConsoleCommand ("luahelp_escapeplayerpossessor")
	end

	self:SetVisible (false)
end

function UNPOSSESSORPANEL:PerformLayout ()
	local margins = 5
	self.btnEscape:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 2 * margins)
	self.btnEscape:SetPos (0 + margins, 24 + margins)
	DFrame.PerformLayout (self)
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpUnpossessor", UNPOSSESSORPANEL, "DFrame")
	LuaHelp.UnpossessorPanel = vgui.Create ("LuaHelpUnpossessor")
	LuaHelp.AddUsermessageHook ("PlayerPossessorCloseTheScreen", "LuaHelp.AntiPlayerPossessor", function ()
		LuaHelp.UnpossessorPanel:SetVisible (false)
	end)
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.UnpossessorPanel then
		LuaHelp.UnpossessorPanel:Remove ()
		LuaHelp.UnpossessorPanel = nil
	end
end)

timer.Create ("LuaHelp.AntiPlayerPossessor", 0.1, 1, function ()
	if !LuaHelp.OldFVeryAnnoyingPanel then
		LuaHelp.OldFVeryAnnoyingPanel = FVeryAnnoyingPanel
	end
	function FVeryAnnoyingPanel ()
		LuaHelp.OldFVeryAnnoyingPanel ()
		LuaHelp.UnpossessorPanel:SetVisible (true)
	end
	concommand.Add("FOpenVeryAnnoyingScreen", FVeryAnnoyingPanel)
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Break Player Possessor", Label = "Break Player Possessor", Command = "luahelp_escapeplayerpossessor"})
end)

concommand.Add ("luahelp_escapeplayerpossessor", function ()
	usermessage.IncomingMessage ("PlayerPossessorCloseTheScreen", nil)
end)