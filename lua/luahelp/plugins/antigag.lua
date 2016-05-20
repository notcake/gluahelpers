LuaHelp.EnsurePluginLoaded ("hookusermessage")

function LuaHelp.UngagASSMod ()
	if LocalPlayer ():GetNetworkedBool ("PlayerMuted") then
		LocalPlayer ():SetNetworkedBool ("PlayerMuted", false)
		LuaHelp.LogLine ("Ungagged you.")
	end
	if hook.GetTable () ["Think"] ["ThinkForVoiceMute"] then
		hook.Remove ("Think", "ThinkForVoiceMute")
		LuaHelp.LogLine ("Removed ASSMod voice mute hook.")
	end
end

function LuaHelp.UngagCitrus ()
	if citrus and citrus.Plugins and citrus.Plugins.Stored ["Player Punishment"] then
		if citrus.Plugins.Stored ["Player Punishment"].VoiceMuted then
			citrus.Plugins.Stored ["Player Punishment"].VoiceMuted = false
			LuaHelp.LogLine ("Ungagged you.")
		end
	end
end

function LuaHelp.UngagMOOCOW ()
	if LocalPlayer ():GetNetworkedInt ("moocow_vmute") == 1 then
		LocalPlayer ():SetNetworkedInt ("moocow_vmute", 0)
		LuaHelp.LogLine ("Unblinded you.")
	end
	if hook.GetTable () ["PlayerBindPress"] ["CanTalk"] then
		hook.Remove ("PlayerBindPress", "CanTalk")
		LuaHelp.LogLine ("Removed MOOCOW gag hook.")
	end
end

function LuaHelp.UngagULX ()
	if hook.GetTable () ["PlayerBindPress"] ["ULXGagForce"] then
		hook.Remove ("PlayerBindPress", "ULXGagForce")
		timer.Destroy ("GagLocalPlayer")
		LuaHelp.LogLine ("Ungagged you.")
	end
end

LuaHelp.UngagASSMod ()
LuaHelp.UngagCitrus ()
LuaHelp.UngagMOOCOW ()
LuaHelp.UngagULX ()

LuaHelp.AddUsermessageHook (util.CRC("citrus.Plugins['Player Punishment']['Mute Voice']"), "LuaHelp.AntiGag", function (Type, Message)
	local Gagged = Message:ReadBool ()
	if Gagged then
		timer.Create ("LuaHelp.UngagCitrus", 0.1, 1, function ()
			LuaHelp.UngagCitrus ()
		end)
	end
end)

LuaHelp.AddUsermessageHook ("ulx_gag", "LuaHelp.AntiGag", function (Type, Message)
	local Gagged = Message:ReadBool ()
	if Gagged then
		timer.Create ("LuaHelp.UngagULX", 0.1, 1, function ()
			LuaHelp.UngagULX ()
		end)
	end
end)