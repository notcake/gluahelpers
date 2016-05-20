LuaHelp.EnsurePluginLoaded ("hookusermessage")

local AllowedCommands = {}

function LuaHelp.AddAllowedCommand (command)
	AllowedCommands [command] = true
end

LuaHelp.AddAllowedCommand ("citrus achievements")
LuaHelp.AddAllowedCommand ("citrus commands")
LuaHelp.AddAllowedCommand ("citrus entityguard")
LuaHelp.AddAllowedCommand ("citrus sandbox")
LuaHelp.AddAllowedCommand ("citrus spendpoints")

LuaHelp.AddUsermessageHook ("citrus.ConsoleCommand", "LuaHelp.AntiCExec", function (Type, Message)
	local Command = Message:ReadString ()
	local bits = string.Explode (" ", Command)
	local allow = false
	if AllowedCommands [Command] then
		allow = true
	end
	for k, v in pairs (player.GetAll ()) do
		local UniqueID = util.CRC ("gm_" .. v:SteamID () .. "_gm")
		local profile = "citrus profile \"" .. UniqueID .. "\""
		local goto = "citrus goto \"" .. UniqueID .. "\""
		if Command == profile or
		   Command == goto then
			allow = true
		end
	end
	if allow then
		LuaHelp.LogLine ("Ran command: \"" .. Command .. "\".")
		return false
	else
		LuaHelp.BlockedCommandsPanel:AddCommand (Command)
		LuaHelp.LogLine ("Blocked command: \"" .. Command .. "\".")
		return true
	end
end)

local BLOCKEDCOMMANDSPANEL = {}

function BLOCKEDCOMMANDSPANEL:Init ()
	self:SetTitle ("Blocked Console Commands")

	self:SetSize (ScrW () * 0.3, ScrH () * 0.3)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnClear = vgui.Create ("DButton", self)
	self.btnClear:SetText ("Clear")
	self.btnClear.DoClick = function (button)
		self:ClearCommands ()
	end

	self.btnRemove = vgui.Create ("DButton", self)
	self.btnRemove:SetText ("Remove")
	self.btnRemove.DoClick = function (button)
		self:RemoveCommand ()
	end

	self.btnRun = vgui.Create ("DButton", self)
	self.btnRun:SetText ("Run")
	self.btnRun.DoClick = function (button)
		self:RunCommand ()
	end

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.lvwCommands = vgui.Create ("DListView", self)
	self.lvwCommands:AddColumn ("Command")
	self.lvwCommands:AddColumn ("Time")

	self.Commands = {}

	self:SetVisible (false)
end

function BLOCKEDCOMMANDSPANEL:PerformLayout ()
	local margins = 5
	self.btnClear:SetPos (0 + margins, self:GetTall () - self.btnClear:GetTall () - margins)
	self.btnRemove:SetPos (0 + 2 * margins + self.btnClear:GetWide (), self:GetTall () - self.btnRemove:GetTall () - margins)
	self.btnRun:SetPos (0 + 3 * margins + self.btnClear:GetWide () + self.btnRemove:GetWide (), self:GetTall () - self.btnRun:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwCommands:SetPos (0 + margins, 24 + margins)
	self.lvwCommands:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function BLOCKEDCOMMANDSPANEL:ClearData ()
	self.lvwCommands:Clear ()
end

function BLOCKEDCOMMANDSPANEL:AddCommand (command)
	self.lvwCommands:AddLine (command, os.date ())
end

function BLOCKEDCOMMANDSPANEL:RemoveCommand ()
	self.lvwCommands:RemoveLine (self.lvwCommands:GetSelectedLine ())
end

function BLOCKEDCOMMANDSPANEL:RunCommand ()
	LuaHelp.LogLine ("Ran command \"" .. self.lvwCommands:GetLine (self.lvwCommands:GetSelectedLine ()):GetValue (1) .. "\".")
	LocalPlayer ():ConCommand (self.lvwCommands:GetLine (self.lvwCommands:GetSelectedLine ()):GetValue (1))
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpBlockedCommands", BLOCKEDCOMMANDSPANEL, "DFrame")
	LuaHelp.BlockedCommandsPanel = vgui.Create ("LuaHelpBlockedCommands")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.BlockedCommandsPanel then
		LuaHelp.BlockedCommandsPanel:Remove ()
		LuaHelp.BlockedCommandsPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Blocked Commands List", Label = "Open Blocked Commands List", Command = "luahelp_openblockedcommandlist"})
end)

concommand.Add ("luahelp_openblockedcommandlist", function ()
	LuaHelp.BlockedCommandsPanel:SetVisible (true)
end)