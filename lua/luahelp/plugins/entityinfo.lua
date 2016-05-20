local ENTITYINFOPANEL = {}
LuaHelp.EntityInfoPanelHooks = {}
LuaHelp.EntityInfoPanelHooks.Init = {}
LuaHelp.EntityInfoPanelHooks.OnEntityChangedAway = {}
LuaHelp.EntityInfoPanelHooks.OnEntityChangedTo = {}
LuaHelp.EntityInfoPanelHooks.PopulateLines = {}
LuaHelp.EntityInfoPanelHooks.PopulateWeaponLines = {}

function LuaHelp.EntityInfoPanelHooks.HookInit (func)
	table.insert (LuaHelp.EntityInfoPanelHooks.Init, func)
end

function LuaHelp.EntityInfoPanelHooks.HookOnEntityChangedAway (func)
	table.insert (LuaHelp.EntityInfoPanelHooks.OnEntityChangedAway, func)
end

function LuaHelp.EntityInfoPanelHooks.HookOnEntityChangedTo (func)
	table.insert (LuaHelp.EntityInfoPanelHooks.OnEntityChangedTo, func)
end

function LuaHelp.EntityInfoPanelHooks.HookPopulateLines (func)
	table.insert (LuaHelp.EntityInfoPanelHooks.PopulateLines, func)
end

function LuaHelp.EntityInfoPanelHooks.HookPopulateWeaponLines (func)
	table.insert (LuaHelp.EntityInfoPanelHooks.PopulateLines, func)
end

local entityinfohooks = file.FindInLua ("luahelp/entityinfo/*.lua")
for _, file in ipairs (entityinfohooks) do
	include ("luahelp/entityinfo/" .. file)
end

function ENTITYINFOPANEL:Init ()
	self:SetTitle ("Entity Info")
	self:SetZPos (-1)

	self:SetSize (ScrW () * 0.2, ScrH () * 0.3)
	self:SetPos (ScrW () - self:GetWide (), ScrH () * 0.6 / 2)
	self:SetDeleteOnClose (false)
	self:ShowCloseButton (false)
	self:SetAlpha (0)

	for _, f in pairs (LuaHelp.EntityInfoPanelHooks.Init) do
		f (self)
	end
end

function ENTITYINFOPANEL:Paint ()
	self:RefreshData ()
	self.LinesDrawn = 0
	draw.RoundedBox (8, 0, 0, self:GetWide (), self:GetTall (), Color(64, 64, 64, 192))
	if self.Entity and self.Entity:IsValid () and self.InfoLines then
		surface.SetFont("Default")
		draw.SimpleText (self.Entity:GetClass (), "ScoreboardText", self:GetDrawLeft (), 25, Color (192, 255, 192, 255), 0, 0)
		self.LinesDrawn = self.LinesDrawn + 0.5
		for _, v in pairs (self.InfoLines) do
			if type (v) == "function" then
				v (self)
			else
				self:DrawLine (v)
			end
		end
	end
	return true
end

function ENTITYINFOPANEL:FadeOut ()
	if self:GetAlpha () < 0 then
		self:SetAlpha (0)
		return
	end
	if self:GetAlpha () == 0 then
		if self.Entity then
			local oldEntity = self.Entity
			self.Entity = nil
			self:OnEntityChanged (oldEntity, self.EntityClass, nil, nil)
			self.EntityClass = nil
		end
		return
	end
	if self.Entity and self.Entity:IsValid () then
		self:SetAlpha (self:GetAlpha () - 2.5)
	else
		self:SetAlpha (self:GetAlpha () - 10)
	end
end

function ENTITYINFOPANEL:DrawLine (text)
	self.LinesDrawn = self.LinesDrawn + 1
	draw.SimpleText (text, "Default", self:GetDrawLeft (), self:GetDrawTop (), Color (192, 192, 192, 255), 0, 0)
end

function ENTITYINFOPANEL:GetDrawLeft ()
	return 8
end

function ENTITYINFOPANEL:GetDrawTop ()
	return 25 + self.LinesDrawn * 14
end

function ENTITYINFOPANEL:GetLineDrawTop (line)
	return 25 + line * 14
end

function ENTITYINFOPANEL:GetDrawTall ()
	return 14
end

function ENTITYINFOPANEL:PerformLayout ()
	DFrame.PerformLayout(self)
end

function ENTITYINFOPANEL:AddLine (text)
	table.insert (self.InfoLines, text)
end

function ENTITYINFOPANEL:AddCustomLine (drawfunc)
	table.insert (self.InfoLines, drawfunc)
end

function ENTITYINFOPANEL:OnEntityChanged (oldEntity, oldEntityClass, newEntity, newEntityClass)
	if oldEntityClass and oldEntityClass:len () == 0 then
		oldEntityClass = nil
	end
	if newEntityClass and newEntityClass:len () == 0 then
		newEntityClass = nil
	end
	oldEntityClass = oldEntityClass or "<none>"
	newEntityClass = newEntityClass or "<none>"
	// LuaHelp.LogLine ("Entity changed from " .. oldEntityClass .. " to " .. newEntityClass .. ".")
	if oldEntity then
		for _, f in pairs (LuaHelp.EntityInfoPanelHooks.OnEntityChangedAway) do
			f (self, oldEntity, oldEntityClass, newEntity, newEntityClass)
		end
	end
	if newEntity then
		for _, f in pairs (LuaHelp.EntityInfoPanelHooks.OnEntityChangedTo) do
			f (self, oldEntity, oldEntityClass, newEntity, newEntityClass)
		end
	end
end

function ENTITYINFOPANEL:DoEntityTrace ()
	local trace = util.GetPlayerTrace (LocalPlayer ())
	local delta = (trace.endpos - trace.start)
	trace.endpos = trace.start + (delta:GetNormalized ()) * ((32768 ^ 2 * 3) ^ 0.5)
	local tr = util.TraceLine (trace)
	if tr.HitNonWorld then
		if !LocalPlayer ():InVehicle () then
			return tr.Entity
		end
	end
	return nil
end

function ENTITYINFOPANEL:RefreshData ()
	local oldEntity = self.Entity
	local oldEntityClass = self.EntityClass
	local newEntity = nil
	local newEntityClass = nil
	self.TraceEntity = self:DoEntityTrace ()
	if self.LockedEntity and self.LockedEntity:IsValid () then
		newEntity = self.LockedEntity
	else
		if self.TraceEntity and self.TraceEntity:IsValid () then
			newEntity = self.TraceEntity
		else
			newEntity = oldEntity
		end
	end
	if oldEntity and !oldEntity:IsValid () then
		oldEntity = nil
	end
	if newEntity and !newEntity:IsValid () then
		newEntity = nil
	end
	if newEntity and newEntity:IsValid () then
		newEntityClass = newEntity:GetClass ()
	else
		self.EntityClass = nil
	end
	self.Entity = newEntity
	self.EntityClass = newEntityClass
	if (!oldEntity and newEntity) or
	   (oldEntity and !newEntity) or
	   (oldEntity and newEntity and oldEntity:EntIndex () != newEntity:EntIndex ()) or
	   (!oldEntity and !newEntity and oldEntityClass) then
		self:OnEntityChanged (oldEntity, oldEntityClass, newEntity, newEntityClass)
	end
	if self.Entity and self.Entity:IsValid () then
		self:PopulateLines ()
		self:SetTall (self:GetLineDrawTop (#self.InfoLines + 2))
	end
	if (self.TraceEntity and self.TraceEntity:IsValid ()) or
	   (self.LockedEntity and self.LockedEntity:IsValid ()) then
		self:SetAlpha (255)
	else
		self:FadeOut ()
	end
end

function ENTITYINFOPANEL:PopulateLines ()
	self.InfoLines = {}
	if self.Entity:GetClass () == "player" then
		self:AddLine ("Name: " .. self.Entity:Name ())
		self:AddCustomLine (function ()
			self:DrawLine ("Team: ")
			local w = surface.GetTextSize ("Team: ")
			draw.SimpleText (team.GetName (self.Entity:Team ()), "Default", self:GetDrawLeft () + w, self:GetDrawTop (), team.GetColor (self.Entity:Team ()), 0, 0)
		end)
		self:AddLine ("SteamID: " .. self.Entity:SteamID ())
		self:AddLine ("Ping: " .. tostring (self.Entity:Ping ()))
		if self.Entity:GetActiveWeapon ():IsValid () then
			if self.Entity:GetActiveWeapon ():GetClass () == "gmod_tool" and self.Entity:GetActiveWeapon ():GetMode () then
				self:AddLine ("Tool: " .. self.Entity:GetActiveWeapon ():GetMode ())
			else
				self:AddLine ("Weapon: " .. self.Entity:GetActiveWeapon ():GetClass ())
			end
			for _, f in pairs (LuaHelp.EntityInfoPanelHooks.PopulateWeaponLines) do
				f (self, self.Entity, self.Entity:GetClass (), self.Entity:GetActiveWeapon (), self.Entity:GetActiveWeapon ():GetClass ())
			end
		end
		self:AddLine ("")
	end
	self:AddLine ("Index: " .. tostring (self.Entity:EntIndex ()))
	if self.EntityOwnerName and string.len (self.EntityOwnerName) > 0 then
		self:AddLine ("Owner: " .. self.EntityOwnerName)
	end
	self:AddLine ("Model: " .. self.Entity:GetModel ())
	if self.Entity:GetMaterial ():len () > 0 then
		self:AddLine ("Material: " .. self.Entity:GetMaterial ())
	end
	if self.Entity:SkinCount () and self.Entity:SkinCount () > 1 then
		self:AddLine ("Skin: " .. tostring (self.Entity:GetSkin () + 1) .. " (of " .. tostring (self.Entity:SkinCount()) .. ")")
	end
	if self.Entity:Health () > 0 then
		self:AddLine ("Health: " .. tostring (self.Entity:Health ()))
	end
	if self.Entity.Armor and self.Entity:Armor () > 0 then
		self:AddLine ("Armor: " .. tostring (self.Entity:Armor ()))
	end
	local r, g, b, a = self.Entity:GetColor ()
	if r != 255 or g != 255 or b != 255 then
		self:AddCustomLine (function ()
			self:DrawLine ("Color: " .. tostring (r) .. ", " .. tostring (g) .. ", " .. tostring (b))
			local r, g, b, a = self.Entity:GetColor ()
			draw.RoundedBox (4, self:GetWide () - self:GetDrawLeft () - self:GetDrawTall (), self:GetDrawTop (), self:GetDrawTall (), self:GetDrawTall(), Color (0, 0, 0, 255), 0, 0)
			draw.RoundedBox (4, self:GetWide () - self:GetDrawLeft () - self:GetDrawTall () + 1, self:GetDrawTop () + 1, self:GetDrawTall () - 2, self:GetDrawTall () - 2, Color (r, g, b, 255), 0, 0)
		end)
	end
	if a != 255 then
		self:AddLine ("Alpha: " .. tostring (a))
	end
	self:AddLine ("Distance: " .. string.format ("%.2f", (LocalPlayer ():GetPos () - self.Entity:GetPos ()):Length ()))
	local angles = self.Entity:GetAngles ()
	self:AddLine ("Angles: " .. string.format ("%.4f", angles.p) .. ", " ..string.format ("%.4f", angles.y) .. ", " .. string.format ("%.4f", angles.r))

	for _, f in pairs (LuaHelp.EntityInfoPanelHooks.PopulateLines) do
		f (self, self.Entity, self.Entity:GetClass ())
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpEntityInfo", ENTITYINFOPANEL, "DFrame")
	LuaHelp.EntityInfoPanel = vgui.Create ("LuaHelpEntityInfo")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.EntityInfoPanel != nil then
		LuaHelp.EntityInfoPanel:Remove ()
		LuaHelp.EntityInfoPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Checkbox", {Label = "Show crosshair entity info", Command = "luahelp_showentityinfo"})
end)

concommand.Add ("luahelp_showentityinfo", function (_, _, args)
	LuaHelp.EntityInfoPanel:SetVisible (tobool (unpack (args)))
	LuaHelp.EntityInfoPanel:RefreshData ()
end)

concommand.Add ("luahelp_lockentity", function (_, _, args)
	LuaHelp.EntityInfoPanel.LockedEntity = ents.GetByIndex (tonumber (args [1]))
end)