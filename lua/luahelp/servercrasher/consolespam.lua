self:CreateToggleCommand ("SpamGroundlist", "Start Groundlist Spam", "Stop Groundlist Spam",
function (self)
	timer.Create ("LuaHelp.GroundlistSpam", 0.01, 0, function ()
		RunConsoleCommand ("groundlist")
		RunConsoleCommand ("groundlist")
		RunConsoleCommand ("groundlist")
		RunConsoleCommand ("groundlist")
		RunConsoleCommand ("groundlist")
	end)
end,
function (self)
	timer.Destroy ("LuaHelp.GroundlistSpam")
end)
self:CreateConsoleSpamCommand ("SpamServerTime", "Start Server Time Spam", "Stop Server Time Spam", "server_game_time")
self:CreateConsoleSpamCommand ("SpamSourceModHelp", "Start SourceMod Help Spam", "Stop SourceMod Help Spam", "sm_help")
self:CreateConsoleSpamCommand ("SpamSourceModCookies", "Start SourceMod Cookies Spam", "Stop SourceMod Cookies Spam", "sm_cookies")
self:CreateConsoleSpamCommand ("SpamSourceModSearchCmd", "Start SourceMod SearchCmd Spam", "Stop SourceMod SearchCmd Spam", "sm_searchcmd", "zzzzzzzzzz")
self:CreateConsoleSpamCommand ("SpamExplode", "Start Suicide Spam", "Stop Suicide Spam", "explode")
self:CreateConsoleSpamCommand ("SpamChat", "Start Chat Spam", "Stop Chat Spam", "say", "spam spam spam spam spam spam spam spam spam spam spam spam spam spam")
self:CreateConsoleSpamCommand ("SpamStatus", "Start Status Spam", "Stop Status Spam", "status")

self:CreateToggleCommand ("SpamDatastream", "Start Datastream Spam", "Stop Datastream Spam",
function (self)
	timer.Create ("LuaHelp.DatastreamSpam", 0.01, 0, function ()
		datastream.StreamToServer ("OLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOL", {})
		datastream.StreamToServer ("OLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOL", {})
	end)
end,
function (self)
	timer.Destroy ("LuaHelp.DatastreamSpam")
end)