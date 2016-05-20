LuaHelp.EnsurePluginLoaded ("console")
LuaHelp.EnsurePluginLoaded ("hookusermessage")

function LuaHelp.UnblindCitrus ()
	if citrus and citrus.Overlays then
		local Overlay = citrus.Overlays.Get ("Blind")
		if Overlay then
			Overlay:Remove ()
			LuaHelp.LogLine ("Unblinded you.")
		end
	end
end

function LuaHelp.UnblindGManage ()
	if GManage and GManage.Plugs then
		if GManage.Plugs.GetAll () ["sh_extrapunish"] then
			GManage.Plugs.GetAll () ["sh_extrapunish"].UserMessage = function (tag, um)
				return false
			end
			LuaHelp.LogLine ("Removed GManage blind hook.")

			if GManage.Plugs.GetAll () ["sh_extrapunish"].BLINDER then
				GManage.Plugs.GetAll () ["sh_extrapunish"].BLINDER:Remove ()
				GManage.Plugs.GetAll () ["sh_extrapunish"].BLINDER = nil
				LuaHelp.LogLine ("Unblinded you.")
			end
		end
	end
end

function LuaHelp.UnblindNewAdmin ()
	if LocalPlayer ():GetNetworkedBool ("Blinded") then
		LocalPlayer ():SetNetworkedBool ("Blinded", false)
		LuaHelp.LogLine ("Unblinded you.")
	end
	if hook.GetTable () ["HUDPaint"] ["Blind"] then
		hook.Remove ("HUDPaint", "Blind")
		LuaHelp.LogLine ("Removed NewAdmin blind hook.")
	end
end

function LuaHelp.UnblindULX ()
	if hook.GetTable () ["HUDPaint"] ["ulx_blind"] then
		hook.Remove ("HUDPaint", "ulx_blind")
		LuaHelp.LogLine ("Unblinded you.")
	end
end

LuaHelp.UnblindCitrus ()
LuaHelp.UnblindGManage ()
LuaHelp.UnblindNewAdmin ()
LuaHelp.UnblindULX ()

LuaHelp.AddThinkHook (function ()
	// MOOCOW unblinder
	if GetConVar ("pp_colormod"):GetInt () == 1 and GetConVar ("pp_colormod_brightness"):GetInt () == -2 then
		RunConsoleCommand ("pp_colormod_brightness", "0")
	end
end)

LuaHelp.AddUsermessageHook ("citrus.Overlays.Add", "LuaHelp.AntiBlind", function (Type, Message)
	local Name = Message:ReadString ()
	local Title = Message:ReadString ()
	local Text = Message:ReadString ()
	local Alpha = Message:ReadShort ()
	if Name == "Blind" then
		timer.Create ("LuaHelp.UnblindCitrus", 0.1, 1, function ()
			LuaHelp.UnblindCitrus ()
		end)
	end
end)

LuaHelp.AddUsermessageHook ("ulx_blind", "LuaHelp.AntiBlind", function (Type, Message)
	local Blind = Message:ReadBool ()
	if Blind then
		timer.Create ("LuaHelp.UnblindULX", 0.1, 1, function ()
			LuaHelp.UnblindULX ()
		end)
	end
end)