local SERVERCRASHERPANEL = {}
local BUTTONHEIGHT = 20
local margins = 5

function SERVERCRASHERPANEL:Init ()
	self:SetTitle ("Crash Server")

	self:SetSize (ScrW () * 0.2, ScrH () * 0.4)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2 + 0.2 * ScrH ())

	self:ShowCloseButton (true)
	self:SetDraggable (true)
	self:SetDeleteOnClose (false)
	self:SetSizable (false)
	self:MakePopup ()

	self.Commands = self.Commands or {}
	self.CommandMap = self.CommandMap or {}
	self.CommandCount = self.CommandCount or 0

	local luas = file.FindInLua ("luahelp/servercrasher/*.lua")
	_G.self = self
	for _, file in ipairs (luas) do
		include ("luahelp/servercrasher/" .. file)
	end
	_G.self = nil

	self:SetTall (24 + (self.CommandCount + 1) * margins + self.CommandCount * BUTTONHEIGHT)

	self:SetVisible (false)
end

function SERVERCRASHERPANEL:CreateCommand (name, text, func)
	self.Commands = self.Commands or {}
	self.CommandMap = self.CommandMap or {}
	self.CommandCount = self.CommandCount or 0

	text = text or name

	self.Commands [name] = {}
	self.Commands [name].Msg = text
	self.Commands [name].Func = func
	self.CommandCount = self.CommandCount + 1
	table.insert (self.CommandMap, name)
	
	local btn = vgui.Create ("DButton", self)
	self.Commands [name].Button = btn

	btn.CommandName = name
	btn:SetText (text)
	btn.DoClick = function (btn)
		local func = LuaHelp.ServerCrasherPanel.Commands [btn.CommandName].Func
		if func then
			func (btn)
		end
	end
	return self.Commands [name]
end

function SERVERCRASHERPANEL:CreateToggleCommand (name, starttext, stoptext, startfunc, stopfunc)
	self.Commands = self.Commands or {}
	self.CommandMap = self.CommandMap or {}
	self.CommandCount = self.CommandCount or 0

	starttext = starttext or "Start " .. name
	stoptext = stoptext or "Stop " .. name

	self.Commands [name] = {}
	self.Commands [name].StartMsg = starttext
	self.Commands [name].StopMsg = stoptext
	self.Commands [name].StartFunc = startfunc
	self.Commands [name].StopFunc = stopfunc
	self.CommandCount = self.CommandCount + 1
	table.insert (self.CommandMap, name)
	local btn = vgui.Create ("DButton", self)

	self.Commands [name].Button = btn

	btn.CommandName = name
	btn:SetText (starttext)
	function btn:Start ()
		self:SetText (LuaHelp.ServerCrasherPanel.Commands [self.CommandName].StopMsg)
		local startfunc = LuaHelp.ServerCrasherPanel.Commands [self.CommandName].StartFunc
		if startfunc then
			startfunc (self)
		end
		self.DoClick = self.Stop
	end
	function btn:Stop ()
		self:SetText (LuaHelp.ServerCrasherPanel.Commands [self.CommandName].StartMsg)
		local stopfunc = LuaHelp.ServerCrasherPanel.Commands [self.CommandName].StopFunc
		if stopfunc then
			stopfunc (self)
		end
		self.DoClick = self.Start
	end
	btn.DoClick = btn.Start

	return self.Commands [name]
end

function SERVERCRASHERPANEL:CreateConsoleSpamCommand (name, starttext, stoptext, concmd, args)
	local cmd = self:CreateToggleCommand (name, starttext, stoptext,
	function (self)
		timer.Create (self.CommandName, 0.01, 0, function ()
			RunConsoleCommand (self.ConCommand, self.ConCommandArgs)
		end)
	end,
	function (self)
		timer.Destroy (self.CommandName)
	end)
	cmd.Button.ConCommand = concmd
	cmd.Button.ConCommandArgs = args
end

function SERVERCRASHERPANEL:PerformLayout ()
	local y = 24 + margins

	for k, n in pairs (self.CommandMap) do
		local v = self.Commands [n]
		local btn = v.Button
		btn:SetPos (0 + margins, y)
		btn:SetSize (self:GetWide () - 2 * margins, BUTTONHEIGHT)
		y = y + BUTTONHEIGHT + margins
	end

	DFrame.PerformLayout (self)
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpServerCrasher", SERVERCRASHERPANEL, "DFrame")
	LuaHelp.ServerCrasherPanel = vgui.Create ("LuaHelpServerCrasher")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.ServerCrasherPanel then
		for k, v in pairs (LuaHelp.ServerCrasherPanel.Commands) do
			timer.Destroy (k)
		end
		LuaHelp.ServerCrasherPanel:Remove ()
		LuaHelp.ServerCrasherPanel = nil
	end
end)

LuaHelp.AddPopulateShenanigansCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Crash Server", Label = "Server Crasher", Command = "luahelp_openservercrasher"})
end)

concommand.Add ("luahelp_openservercrasher", function ()
	LuaHelp.ServerCrasherPanel:SetVisible (true)
end)