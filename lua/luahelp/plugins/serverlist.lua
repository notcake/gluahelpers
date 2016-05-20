LuaHelp.EnsurePluginLoaded ("urlencode")
local SERVERLISTPANEL = {}

function SERVERLISTPANEL:Init ()
	self:SetTitle ("Servers")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.txtIP = vgui.Create ("DTextEntry", self)
	self.txtIP:SetValue ("")
	self.txtIP.OnTextChanged = function ()
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			line:SetValue (2, self.txtIP:GetValue ())
		end
	end

	self.txtName = vgui.Create ("DTextEntry", self)
	self.txtName:SetValue ("")
	self.txtName.OnTextChanged = function (TextEntry)
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			local entry = self.Servers [line:GetValue (1)]
			self.Servers [line:GetValue (1)] = nil
			self.Servers [self.txtName:GetValue ()] = entry
			line:SetValue (1, self.txtName:GetValue ())
		end
	end

	self.txtRcon = vgui.Create ("DTextEntry", self)
	self.txtRcon:SetValue ("")
	self.txtRcon.OnTextChanged = function (TextEntry)
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			line:SetValue (3, self.txtRcon:GetValue ())
		end
	end

	self.btnRemove = vgui.Create ("DButton", self)
	self.btnRemove:SetText ("Remove")
	self.btnRemove.DoClick = function (Button)
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			self.Servers [line:GetValue (1)] = nil
			self.lvwServers:RemoveLine (line:GetID ())
		end
	end

	self.btnConnect = vgui.Create ("DButton", self)
	self.btnConnect:SetText ("Connect")
	self.btnConnect.DoClick = function (Button)
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			local ip = line:GetValue (2)
			if string.len (ip) > 0 and string.match (ip, "[0-9]{1-3}\\.[0-9]{1-3}\\.[0-9]{1-3}\\.[0-9]{1-3}(:[0-9]{1-5})?") then
				RunConsoleCommand ("connect", ip)
			end
		end
	end

	self.btnLoadRcon = vgui.Create ("DButton", self)
	self.btnLoadRcon:SetText ("Load Rcon")
	self.btnLoadRcon.DoClick = function (Button)
		local line = self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ())
		if line then
			local rcon = line:GetValue (3)
			if string.len (rcon) > 0 then
				SetClipboardText ("rcon_password \"" .. rcon .. "\"")
			end
		end
	end

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (Button)
		self:SetVisible (false)
	end

	self:PrepareTextEntryForHook (self.txtName)
	self:PrepareTextEntryForHook (self.txtIP)
	self:PrepareTextEntryForHook (self.txtRcon)
	self.txtName.OnKeyCodeTyped = function (TextEntry, code)
		TextEntry:OldOnKeyCodeTyped (code)
		if code == KEY_TAB or code == KEY_ENTER then
			TextEntry:FocusNext ()
			TextEntry:KillFocus ()
			self.txtIP:RequestFocus ()
		end
	end
	self.txtIP.OnKeyCodeTyped = function (TextEntry, code)
		TextEntry:OldOnKeyCodeTyped (code)
		if code == KEY_TAB or code == KEY_ENTER then
			TextEntry:FocusNext ()
			TextEntry:KillFocus ()
			self.txtRcon:RequestFocus ()
		end
	end

	self.txtRcon.OnKeyCodeTyped = function (TextEntry, code)
		TextEntry:OldOnKeyCodeTyped (code)
		if code == KEY_ENTER then
			if !self.lvwServers:GetLine (self.lvwServers:GetSelectedLine ()) then
				self:AddServer (self.txtName:GetValue (), self.txtIP:GetValue (), self.txtRcon:GetValue ())
				self.lvwServers:SelectItem (self.Servers [self.txtName:GetValue ()].line)
			end
		end
	end

	self.lvwServers = vgui.Create ("DListView", self)
	self.lvwServers:AddColumn ("Name")
	self.lvwServers:AddColumn ("IP Address")
	self.lvwServers:AddColumn ("Rcon Password")
	self.lvwServers:SetMultiSelect (false)
	self.lvwServers.OnRowSelected = function (ListView, LineID, Line)
		self.txtName:SetValue (Line:GetValue (1))
		self.txtIP:SetValue (Line:GetValue (2))
		self.txtRcon:SetValue (Line:GetValue (3))
		self.txtName:SetCaretPos (string.len (Line:GetValue (1)))
		self.txtIP:SetCaretPos (string.len (Line:GetValue (2)))
		self.txtRcon:SetCaretPos (string.len (Line:GetValue (3)))
	end
	self.lvwServers.OnMousePressed = function (ListView, mcode)
		ListView:ClearSelection ()
	end

	self.Servers = {}

	self:SetVisible (false)
end

function SERVERLISTPANEL:PrepareTextEntryForHook (TextEntry)
	TextEntry.OldOnKeyCodeTyped = TextEntry.OnKeyCodeTyped
end

function SERVERLISTPANEL:PerformLayout ()
	local margins = 5
	self.btnRemove:SetPos (0 + margins, self:GetTall () - self.btnRemove:GetTall () - margins)
	self.btnConnect:SetPos (0 + 2 * margins + self.btnRemove:GetWide (), self:GetTall () - self.btnConnect:GetTall () - margins)
	self.btnLoadRcon:SetPos (0 + 3 * margins + self.btnRemove:GetWide () + self.btnConnect:GetWide (), self:GetTall () - self.btnLoadRcon:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)

	self.txtName:SetSize (self:GetWide () * 0.4, 16)
	self.txtName:SetPos (0 + margins, self:GetTall () - self.btnExit:GetTall () - self.txtName:GetTall () - 2 * margins)
	self.txtRcon:SetSize (self:GetWide () * 0.3, self.txtName:GetTall ())
	self.txtRcon:SetPos (self:GetWide () - margins - self.txtRcon:GetWide (), self:GetTall () - self.btnExit:GetTall () - self.txtName:GetTall () - 2 * margins)
	self.txtIP:SetSize (self:GetWide () - self.txtName:GetWide () - self.txtRcon:GetWide () - 4 * margins, self.txtName:GetTall ())
	self.txtIP:SetPos (0 + self.txtName:GetWide () + 2 * margins, self:GetTall () - self.btnExit:GetTall () - self.txtName:GetTall () - 2 * margins)

	self.lvwServers:SetPos (0 + margins, 24 + margins)
	self.lvwServers:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 4 * margins - self.btnExit:GetTall () - self.txtIP:GetTall ())
	DFrame.PerformLayout (self)
end

function SERVERLISTPANEL:AddServer (name, ip, rcon)
	if self.Servers [name] then
		self.Servers [name].line:SetValue (1, name)
		self.Servers [name].line:SetValue (2, ip or self.Servers [name].line:GetValue (2))
		self.Servers [name].line:SetValue (3, rcon or self.Servers [name].line:GetValue (3))
	else
		self.Servers [name] = {line = self.lvwServers:AddLine (name, ip or "", rcon or "")}
	end
end

function SERVERLISTPANEL:Load ()
	if !file.Exists ("luahelp/serverinfo/servers.txt") then
		return
	end
	local tbl = util.KeyValuesToTable (file.Read ("luahelp/serverinfo/servers.txt"))

	for k, v in pairs (tbl) do
		self:AddServer (LuaHelp.URLDecode (k), LuaHelp.URLDecode (v.ip), LuaHelp.URLDecode (v.rcon))
	end
end

function SERVERLISTPANEL:Save ()
	local tbl = {}
	for k, v in pairs (self.Servers) do
		tbl [LuaHelp.URLEncodeFull (k)] = {}
		tbl [LuaHelp.URLEncodeFull (k)].ip = LuaHelp.URLEncodeFull (v.line:GetValue (2))
		tbl [LuaHelp.URLEncodeFull (k)].rcon = LuaHelp.URLEncodeFull (v.line:GetValue (3))
	end
	file.Write ("luahelp/serverinfo/servers.txt", util.TableToKeyValues (tbl))
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpServerList", SERVERLISTPANEL, "DFrame")
	LuaHelp.ServerListPanel = vgui.Create ("LuaHelpServerList")
	LuaHelp.ServerListPanel:Load ()

	timer.Create ("LuaHelp.ServerListInit", 0.1, 1, function ()
		LuaHelp.ServerListPanel:AddServer (GetHostName ())
		LuaHelp.ServerListPanel.lvwServers:SelectItem (LuaHelp.ServerListPanel.Servers [GetHostName ()].line)
	end)
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.ServerListPanel then
		LuaHelp.ServerListPanel:Save ()
		LuaHelp.ServerListPanel:Remove ()
		LuaHelp.ServerListPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Server List", Label = "Open Server List", Command = "luahelp_openserverlist"})
end)

concommand.Add ("luahelp_openserverlist", function ()
	LuaHelp.ServerListPanel:SetVisible (true)
end)