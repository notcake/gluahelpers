local SWEPLISTPANEL = {}

function SWEPLISTPANEL:Init ()
	self:SetTitle ("Scripted Weapons")

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

	self.lvwSWEPs = vgui.Create ("DListView", self)
	self.lvwSWEPs:AddColumn ("Class Name")
	self.lvwSWEPs:AddColumn ("Friendly Name")
	self.lvwSWEPs:AddColumn ("Base Class")
	self.lvwSWEPs:AddColumn ("Spawnable?")
	self.lvwSWEPs:AddColumn ("World Model")
	self.lvwSWEPs:AddColumn ("View Model")
	self.lvwSWEPs:SetMultiSelect (false)

	self:SetVisible (false)
	self:Populate ()
end

function SWEPLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwSWEPs:SetPos (0 + margins, 24 + margins)
	self.lvwSWEPs:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function SWEPLISTPANEL:Populate ()
	self.lvwSWEPs:Clear ()
	for k, v in pairs (weapons.GetList ()) do
		local spawnable = "Yes"
		if !v.Spawnable then
			if v.AdminSpawnable then
				spawnable = "Admin Only"
			else
				spawnable = "No"
			end
		end
		self.lvwSWEPs:AddLine (v.ClassName, v.PrintName, v.Base, spawnable, v.WorldModel or v.worldModel, v.ViewModel or v.viewModel)
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpSWEPList", SWEPLISTPANEL, "DFrame")
	LuaHelp.SWEPListPanel = vgui.Create ("LuaHelpSWEPList")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.SWEPListPanel then
		LuaHelp.SWEPListPanel:Remove ()
		LuaHelp.SWEPListPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Scripted Weapon List", Label = "Open Scripted Weapon List", Command = "luahelp_opensweplist"})
end)

concommand.Add ("luahelp_opensweplist", function ()
	LuaHelp.SWEPListPanel:SetVisible (true)
end)