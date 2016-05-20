LuaHelp.EnsurePluginLoaded ("urlencode")
local PLAYERLISTPANEL = {}

function PLAYERLISTPANEL:Init ()
	self:SetTitle ("Players")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnReset = vgui.Create ("DButton", self)
	self.btnReset:SetText ("Reset")
	self.btnReset.DoClick = function (button)
		self:ResetData ()
	end

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.lvwPlayers = vgui.Create ("DListView", self)
	self.lvwPlayers:AddColumn ("Name")
	self.lvwPlayers:AddColumn ("Steam ID")
	self.lvwPlayers:AddColumn ("Community Page")
	self.lvwPlayers:AddColumn ("IP Address")
	self.lvwPlayers:AddColumn ("Entity ID")
	self.lvwPlayers:AddColumn ("Health")
	self.lvwPlayers:AddColumn ("Armor")
	self.lvwPlayers:AddColumn ("Weapon")
	self.lvwPlayers:SetMultiSelect (false)

	self.Players = {}

	self:SetVisible (false)
end

function PLAYERLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnReset:SetPos (0 + margins, self:GetTall () - self.btnReset:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.lvwPlayers:SetPos (0 + margins, 24 + margins)
	self.lvwPlayers:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	DFrame.PerformLayout (self)
end

function PLAYERLISTPANEL:ResetData ()
	self.lvwPlayers:Clear ()
	self.Populated = false
	self.Players = {}
	self:Update ()
end

function PLAYERLISTPANEL:CommunityIDFromSteamID (steamID)
	if !steamID then
		return ""
	end
	local parts = string.Explode (":", steamID)
	if !tonumber (parts [2]) or !tonumber (parts [3]) then
		return ""
	end
	local base = 2 * tonumber (parts [3]) + tonumber (parts [2])
	return "7656119" .. string.format ("%.0f", base + 7960265728)
end

function PLAYERLISTPANEL:OnPlayerAuthed (ply, steamID, uniqueID)
	if LuaHelp.PlayerListPanel.Players [steamID] then
	else
		LuaHelp.LogLine (ply:Name () .. " authed (" .. steamID .. ").")
		self.Players [ply:SteamID ()] = {line = self.lvwPlayers:AddLine (ply:Name (), ply:SteamID (), self:CommunityIDFromSteamID (ply:SteamID ()), "<unknown>", ply:EntIndex ()), entity = ply}
	end
end

function PLAYERLISTPANEL:OnPlayerConnect (name, ip)
	LuaHelp.LogLine (name .. " connected (" .. ip .. ").")
end

function PLAYERLISTPANEL:AddPlayer (steamid, name, entity)
	local entindex = ""
	if entity and entity:IsValid () then
		entindex = entity:EntIndex ()
	end
	if self.Players [steamid] then
		self.Players [steamid].entity = entity
		self.Players [steamid].line:SetValue (1, name)
		self.Players [steamid].line:SetValue (5, entindex)
	else
		self.Players [steamid] = {line = self.lvwPlayers:AddLine (name, steamid, self:CommunityIDFromSteamID (steamid), "<unknown>",entindex), entity = entity}
	end
end

function PLAYERLISTPANEL:Update ()
	for _, v in pairs (player.GetAll ()) do
		if string.len (v:SteamID ()) > 0 then
			self:AddPlayer (v:SteamID (), v:Name (), v)
		end
	end
	for _, t in pairs (self.Players) do
		if t.line:GetValue (3) == "" then
			t.line:SetValue (3, self:CommunityIDFromSteamID (t.line:GetValue (2)))
		end
		if t.entity and t.entity:IsValid () then
			t.line:SetValue (5, tostring (t.entity:EntIndex ()))
			t.line:SetValue (6, tostring (t.entity:Health ()))
			t.line:SetValue (7, tostring (t.entity:Armor ()))
			local weapon = t.entity:GetActiveWeapon ()
			if weapon and weapon:IsValid () then
				if weapon:GetClass () == "gmod_tool" and weapon:GetMode () then
					t.line:SetValue (8, t.entity:GetActiveWeapon ():GetMode ())
				else
					t.line:SetValue (8, t.entity:GetActiveWeapon ():GetClass ())
				end
			else
				t.line:SetValue (8, "")
			end
		else
			t.entity = nil
			t.line:SetValue (5, "")
			t.line:SetValue (6, "")
			t.line:SetValue (7, "")
			t.line:SetValue (8, "")
		end
	end
end

function PLAYERLISTPANEL:Load ()
	if !file.Exists ("luahelp/players/players.txt") then
		return
	end
	local tbl = util.KeyValuesToTable (file.Read ("luahelp/players/players.txt"))

	for k, v in pairs (tbl) do
		self:AddPlayer (string.upper (k), LuaHelp.URLDecode (v.name), nil)
	end
end

function PLAYERLISTPANEL:Save ()
	local tbl = {}
	for k, v in pairs (self.Players) do
		tbl [k] = {}
		tbl [k].name = LuaHelp.URLEncode (v.line:GetValue (1))
	end
	file.Write ("luahelp/players/players.txt", util.TableToKeyValues (tbl))
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpPlayerList", PLAYERLISTPANEL, "DFrame")
	LuaHelp.PlayerListPanel = vgui.Create ("LuaHelpPlayerList")
	LuaHelp.PlayerListPanel:Load ()

	hook.Add ("PlayerAuthed", "LuaHelp.PlayerList.PlayerAuthed", function (ply, steamID, uniqueID)
		LuaHelp.PlayerListPanel:OnPlayerAuthed (ply, steamID, uniqueID)
	end)
	hook.Add ("PlayerConnect", "LuaHelp.PlayerList.PlayerConnect", function (name, ip)
		LuaHelp.PlayerListPanel:OnPlayerConnect (name, ip)
	end)

	timer.Create ("LuaHelp.PlayerList.Update", 1, 0, function ()
		if LuaHelp.PlayerListPanel then
			LuaHelp.PlayerListPanel:Update ()
		end
	end)
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.PlayerListPanel then
		LuaHelp.PlayerListPanel:Save ()
		LuaHelp.PlayerListPanel:Remove ()
		LuaHelp.PlayerListPanel = nil
	end

	timer.Destroy ("LuaHelp.PlayerList.Update")
	hook.Remove ("PlayerAuthed", "LuaHelp.PlayerList.PlayerAuthed")
	hook.Remove ("PlayerConnect", "LuaHelp.PlayerList.PlayerConnect")
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Player List", Label = "Open Player List", Command = "luahelp_openplayerlist"})
end)

concommand.Add ("luahelp_openplayerlist", function ()
	LuaHelp.PlayerListPanel:SetVisible (true)
end)