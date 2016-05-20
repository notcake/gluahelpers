local CLIENTHOOKSPANEL = {}

function CLIENTHOOKSPANEL:Init ()
	self:SetTitle ("Clientside Lua Hooks")

	self:SetSize (ScrW () * 0.5, ScrH () * 0.5)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.btnUnhook = vgui.Create ("DButton", self)
	self.btnUnhook:SetText ("Nuke")
	self.btnUnhook.DoClick = function (button)
		local selectedLine = self.lvwHooks:GetSelectedLine ()
		hook.Remove (self.lvwHooks:GetLine (selectedLine):GetValue (2), self.lvwHooks:GetLine (selectedLine):GetValue (1))
		self.lvwHooks:RemoveLine (selectedLine)
	end
	self.btnRefresh = vgui.Create ("DButton", self)
	self.btnRefresh:SetText ("Refresh")
	self.btnRefresh.DoClick = function (button)
		self:RefreshData ()
	end
	self.lvwHooks = vgui.Create ("DListView", self)
	self.lvwHooks:AddColumn ("Name")
	self.lvwHooks:AddColumn ("Type")
	self.lvwHooks:SetMultiSelect (false)

	self:SetVisible (false)
end

function CLIENTHOOKSPANEL:PerformLayout ()
	local margins = 5
	self.btnRefresh:SetPos (0 + margins, self:GetTall () - self.btnRefresh:GetTall () - margins)
	self.btnUnhook:SetPos (0 + 2 * margins + self.btnRefresh:GetWide (), self:GetTall () - self.btnRefresh:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwHooks:SetPos (0 + margins, 24 + margins)
	self.lvwHooks:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function CLIENTHOOKSPANEL:RefreshData ()
	self.lvwHooks:Clear ()
	for t, v in pairs (hook.GetTable ()) do
		for k, v in pairs (v) do
			self.lvwHooks:AddLine (k, t)
		end
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpClientHooks", CLIENTHOOKSPANEL, "DFrame")
	LuaHelp.ClientHooksPanel = vgui.Create ("LuaHelpClientHooks")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.ClientHooksPanel then
		LuaHelp.ClientHooksPanel:Remove ()
		LuaHelp.ClientHooksPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "View Clientside Hooks", Label = "View Clientside Hooks", Command = "luahelp_viewclientsidehooks"})
end)

concommand.Add ("luahelp_viewclientsidehooks", function ()
	LuaHelp.ClientHooksPanel:SetVisible (true)
	LuaHelp.ClientHooksPanel:RefreshData ()
end)