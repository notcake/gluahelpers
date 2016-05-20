-- Made by !cake
if not CLIENT then
	return
end

if not LuaHelp then
	LuaHelp = {
		PopulateAdminCommandsHooks = nil,
		PopulateDebuggingCommandsHooks = nil,
		PopulateShenanigansCommandsHooks = nil,
		InitHooks = nil,
		UninitHooks = nil,
		ThinkHooks = nil
	}
end

-- Some functions to allow pseudo-plugins
function LuaHelp.AddPopulateAdminCommandsHook (func)
	if not LuaHelp.PopulateAdminCommandsHooks then
		LuaHelp.PopulateAdminCommandsHooks = {}
	end
	table.insert (LuaHelp.PopulateAdminCommandsHooks, func)
end

function LuaHelp.AddPopulateDebuggingCommandsHook (func)
	if not LuaHelp.PopulateDebuggingCommandsHooks then
		LuaHelp.PopulateDebuggingCommandsHooks = {}
	end
	table.insert (LuaHelp.PopulateDebuggingCommandsHooks, func)
end

function LuaHelp.AddPopulateShenanigansCommandsHook (func)
	if not LuaHelp.PopulateShenanigansCommandsHooks then
		LuaHelp.PopulateShenanigansCommandsHooks = {}
	end
	table.insert (LuaHelp.PopulateShenanigansCommandsHooks, func)
end

function LuaHelp.AddInitHook (func)
	if not LuaHelp.InitHooks then
		LuaHelp.InitHooks = {}
	end
	table.insert (LuaHelp.InitHooks, func)
end

function LuaHelp.AddUninitHook (func)
	if not LuaHelp.UninitHooks then
		LuaHelp.UninitHooks = {}
	end
	table.insert (LuaHelp.UninitHooks, func)
end

function LuaHelp.AddThinkHook (func)
	if not LuaHelp.ThinkHooks then
		LuaHelp.ThinkHooks = {}
	end
	table.insert (LuaHelp.ThinkHooks, func)
end

-- Before plugins are registered, unload previous copies.
if LuaHelp.Initialized then
	LuaHelp.Uninit ()
end

local plugins = file.FindInLua( "luahelp/plugins/*.lua" )
local loaded = {}
function LuaHelp.EnsurePluginLoaded (name)
	if not loaded [name .. ".lua"] then
		loaded [name .. ".lua"] = true
		include ("luahelp/plugins/" .. name .. ".lua")
	end
end
for _, file in ipairs (plugins) do
	if not loaded [file] then
		   loaded [file] = true
		include ("luahelp/plugins/" .. file)
	end
end

local populateadmincommandshooks = file.FindInLua( "luahelp/admincommands/*.lua" )
for _, fileName in ipairs (populateadmincommandshooks) do
	include ("luahelp/admincommands/" .. fileName)
end

-- Initialize
function LuaHelp.Init ()
	if LuaHelp.Initialized then
		Msg ("Lua Helper already loaded.\n")
		return
	end
	for _, initFunc in pairs (LuaHelp.InitHooks) do
		initFunc ()
	end

	hook.Add ("Think", "LuaHelp.RunThinkHooks", function ()
		for _, thinkFunc in pairs (LuaHelp.ThinkHooks) do
			thinkFunc ()
		end
	end)

	LuaHelp.InitHooks = {}
	Msg("Lua Helper loaded.\n")
	LuaHelp.Initialized = true
end

function LuaHelp.Uninit ()
	if not LuaHelp.Initialized then
		Msg ("Lua Helper already unloaded.\n")
		return
	end
	for _, uninitFunc in pairs (LuaHelp.UninitHooks) do
		uninitFunc ()
	end
	LuaHelp.UninitHooks = {}
	LuaHelp.ThinkHooks = {}
	LuaHelp.PopulateAdminCommandsHooks = {}
	LuaHelp.PopulateDebuggingCommandsHooks = {}
	LuaHelp.PopulateShenanigansCommandsHooks = {}

	hook.Remove ("Think", "LuaHelp.RunThinkHooks")

	Msg("Lua Helper unloaded.\n")
	LuaHelp.Initialized = false
end

hook.Add ("ShutDown", "LuaHelp.ShutDownHook", function ()
	LuaHelp.Uninit ()
end)

timer.Create ("LuaHelpInitTimer", 0.1, 1, function ()
	LuaHelp.Init ()
end)

-- Populate Q menu
function LuaHelp.LuaDebuggingPanel (Panel)
	Panel:ClearControls ()
	Panel:AddControl ("Label", {Text = "Lua Helper - !cake"})
	for _, f in pairs (LuaHelp.PopulateDebuggingCommandsHooks) do
		f (Panel)
	end
end

function LuaHelp.LuaShenanigansPanel (Panel)
	Panel:ClearControls ()
	Panel:AddControl ("Label", {Text = "Lua Shenanigans - !cake"})
	Panel:AddControl ("Button", {Text = "Unlock Admin Panel", Label = "Unlock Admin Panel", Command = "luahelp_unlockadminpanel"})
	for _, f in pairs (LuaHelp.PopulateShenanigansCommandsHooks) do
		f (Panel)
	end
end

function LuaHelp.AdminCommandsPanel (Panel)
	Panel:ClearControls ()
	Panel:AddControl ("Label", {Text = "Admin Commands - !cake"})
	for _, f in pairs (LuaHelp.PopulateAdminCommandsHooks) do
		f (Panel)
	end
end

function LuaHelp.SpawnMenuOpen ()
	LuaHelp.LuaDebuggingPanel (GetControlPanel ("LuaHelpDebugging"))
	LuaHelp.LuaShenanigansPanel (GetControlPanel ("LuaHelpShenanigans"))
	LuaHelp.AdminCommandsPanel (GetControlPanel ("LuaHelpAdminCommands"))
end
hook.Add ("SpawnMenuOpen", "LuaHelp.SpawnMenuOpen", LuaHelp.SpawnMenuOpen)

function LuaHelp.PopulateToolMenu ()
	spawnmenu.AddToolMenuOption ("Utilities", "Lua Help", "Lua Debugging", "Lua Debugging", "", "", LuaHelp.LuaDebuggingPanel)
	spawnmenu.AddToolMenuOption ("Utilities", "Lua Help", "Lua Shenanigans", "Lua Shenanigans", "", "", LuaHelp.LuaShenanigansPanel)
	spawnmenu.AddToolMenuOption ("Utilities", "Lua Help", "Admin Commands", "Admin Commands", "", "", LuaHelp.AdminCommandsPanel)
end
hook.Add ("PopulateToolMenu", "LuaHelp.PopulateToolMenu", LuaHelp.PopulateToolMenu)
