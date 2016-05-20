local SENTLISTPANEL = {}

function SENTLISTPANEL:Init ()
	self:SetTitle ("Scripted Entities")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.lvwSENTs = vgui.Create ("DListView", self)
	self.lvwSENTs:AddColumn ("Class Name")
	self.lvwSENTs:AddColumn ("Friendly Name")
	self.lvwSENTs:AddColumn ("Base Class")
	self.lvwSENTs:AddColumn ("Spawnable?")
	self.lvwSENTs:SetMultiSelect (false)

	self:SetVisible (false)
	self:Populate ()
end

function SENTLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwSENTs:SetPos (0 + margins, 24 + margins)
	self.lvwSENTs:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function SENTLISTPANEL:Populate ()
	self.lvwSENTs:Clear ()
	for k, v in pairs (scripted_ents.GetList ()) do
		local spawnable = "Yes"
		if !v.t.Spawnable then
			if v.t.AdminSpawnable then
				spawnable = "Admin Only"
			else
				spawnable = "No"
			end
		end
		self.lvwSENTs:AddLine (k, v.t.PrintName, v.Base, spawnable)
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpSENTList", SENTLISTPANEL, "DFrame")
	LuaHelp.SENTListPanel = vgui.Create ("LuaHelpSENTList")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.SENTListPanel then
		LuaHelp.SENTListPanel:Remove ()
		LuaHelp.SENTListPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Scripted Entity List", Label = "Open Scripted Entity List", Command = "luahelp_opensentlist"})
end)

concommand.Add ("luahelp_opensentlist", function ()
	LuaHelp.SENTListPanel:SetVisible (true)
end)