LuaHelp.UsermessageHooks = {}

if !LuaHelp.OldusermessageIncomingMessage then
	LuaHelp.OldusermessageIncomingMessage = usermessage.IncomingMessage
end

function usermessage.IncomingMessage (type, data)
	local denymessage = false
	if LuaHelp.UsermessageHooks [type] then
		for _, f in pairs (LuaHelp.UsermessageHooks [type]) do
			local ret = f (type, data)
			if ret then
				denymessage = ret 
			end
			if data then
				data:Reset ()
				data:ReadString ()
			end
		end
	end
	if denymessage then
		if type != "citrus.ConsoleCommand" then
			LuaHelp.LogLine ("Blocked usermessage: " .. type .. ".")
		end
	else
		LuaHelp.OldusermessageIncomingMessage (type, data)
	end
end

function LuaHelp.AddUsermessageHook (type, name, func)
	if !LuaHelp.UsermessageHooks [type] then
		LuaHelp.UsermessageHooks [type] = {}
	end
	LuaHelp.UsermessageHooks [type] [name] = func
end

function LuaHelp.RemoveUsermessageHook (type, name, func)
	if !LuaHelp.UsermessageHooks [type] then
		return
	end
	LuaHelp.UsermessageHooks [type] [name] = nil
	table.remove (LuaHelp.UsermessageHooks [type], name)
end

LuaHelp.AddUninitHook (function ()
	if LuaHelp.UsermessageHooks then
		LuaHelp.UsermessageHooks = {}
	end
end)