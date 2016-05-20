local TEAMLISTPANEL = {}

function TEAMLISTPANEL:Init ()
	self:SetTitle ("Teams")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnRefresh = vgui.Create ("DButton", self)
	self.btnRefresh:SetText ("Refresh")
	self.btnRefresh.DoClick = function (button)
		self:Populate ()
	end

	self.btnJoin = vgui.Create ("DButton", self)
	self.btnJoin:SetText ("Join")
	self.btnJoin.DoClick = function (button)
		local line = self.lvwTeams:GetLine (self.lvwTeams:GetSelectedLine ())
		if line then
			RunConsoleCommand ("changeteam", line:GetValue (2))
		end
	end

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.lvwTeams = vgui.Create ("DListView", self)
	self.lvwTeams:AddColumn ("Team Name")
	self.lvwTeams:AddColumn ("Id")
	self.lvwTeams:AddColumn ("Color")
	self.lvwTeams:AddColumn ("Joinable?")
	self.lvwTeams:SetMultiSelect (false)

	self:SetVisible (false)
	self:Populate ()
end

function TEAMLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnRefresh:SetPos (0 + margins, self:GetTall () - self.btnRefresh:GetTall () - margins)
	self.btnJoin:SetPos (0 + 2 * margins + self.btnRefresh:GetWide (), self:GetTall () - self.btnJoin:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwTeams:SetPos (0 + margins, 24 + margins)
	self.lvwTeams:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function TEAMLISTPANEL:Populate ()
	self.lvwTeams:Clear ()
	for k, v in pairs (team.GetAllTeams ()) do
		local color = string.format ("%d %d %d %d", v.Color.r, v.Color.g, v.Color.b, v.Color.a)
		local joinable = "No"
		if v.Joinable then
			joinable = "Yes"
		end
		self.lvwTeams:AddLine (v.Name, k, color, joinable)
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpTeamList", TEAMLISTPANEL, "DFrame")
	LuaHelp.TeamListPanel = vgui.Create ("LuaHelpTeamList")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.TeamListPanel then
		LuaHelp.TeamListPanel:Remove ()
		LuaHelp.TeamListPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Team List", Label = "Open Team List", Command = "luahelp_openteamlist"})
end)

concommand.Add ("luahelp_openteamlist", function ()
	LuaHelp.TeamListPanel:SetVisible (true)
end)