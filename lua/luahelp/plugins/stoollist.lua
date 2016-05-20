local STOOLLISTPANEL = {}

function STOOLLISTPANEL:Init ()
	self:SetTitle ("Scripted Tools")

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

	self.lvwSTOOLs = vgui.Create ("DListView", self)
	self.lvwSTOOLs:AddColumn ("Name")
	self.lvwSTOOLs:AddColumn ("Mode")
	self.lvwSTOOLs:AddColumn ("Category")
	self.lvwSTOOLs:SetMultiSelect (false)

	self:SetVisible (false)
	self:Populate ()
end

function STOOLLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwSTOOLs:SetPos (0 + margins, 24 + margins)
	self.lvwSTOOLs:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function STOOLLISTPANEL:Populate ()
	self.lvwSTOOLs:Clear ()
	for k, v in pairs (weapons.GetList ()) do
		if v.ClassName == "gmod_tool" then
			for k, v in pairs (v.Tool) do
				self.lvwSTOOLs:AddLine (v.Name, v.Mode, v.Category)
			end
		end
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpSTOOLList", STOOLLISTPANEL, "DFrame")
	LuaHelp.STOOLListPanel = vgui.Create ("LuaHelpSTOOLList")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.STOOLListPanel then
		LuaHelp.STOOLListPanel:Remove ()
		LuaHelp.STOOLListPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Scripted Tool List", Label = "Open Scripted Tool List", Command = "luahelp_openstoollist"})
end)

concommand.Add ("luahelp_openstoollist", function ()
	LuaHelp.STOOLListPanel:SetVisible (true)
end)