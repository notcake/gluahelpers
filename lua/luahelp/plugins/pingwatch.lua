LuaHelp.PingWatch = {}
LuaHelp.PingWatch.Thresholds = {
	// {-1, "Lag Watcher Failure", Color (255, 0, 0, 255)},
	{0, "Server is operating normally.", Color (0, 255, 0, 255)},
	{75, "Possible serverside lag.", Color (96, 255, 0, 255)},
	{100, "Server is slightly laggy.", Color (172, 255, 0, 255)},
	{150, "Server is laggy.", Color (216, 255, 0, 255)},
	{200, "Server is very laggy.", Color (255, 255, 0, 255)},
	{300, "Server is seriously laggy.", Color (255, 128, 0, 255)},
	{500, "Server is extremely laggy.", Color (255, 0, 0, 255)}
}

function LuaHelp.PingWatch:GetPingDescription (ping)
	local last = self.Thresholds [1]
	ping = ping or 0
	for k, v in pairs (self.Thresholds) do
		if ping < v [1] then
			return last
		end
		last = v
	end
	return last
end

function LuaHelp.PingWatch:Tick ()
	local NewAveragePing = 0
	local Weight = 1 / #(player.GetHumans ())
	for _, v in pairs (player.GetHumans ()) do
		NewAveragePing = NewAveragePing + Weight * v:Ping ()
	end
	local last = self:GetPingDescription (self.AveragePing)
	local current = self:GetPingDescription (NewAveragePing)
	self.AveragePing = NewAveragePing
	if last [1] != current [1] then
		LuaHelp.LogLine ("Average Ping: " .. string.format ("%.1f", math.Round (self.AveragePing * 10) / 10) .. " (" .. current [2] .. ")", current [3])
	end
end

LuaHelp.AddInitHook (function ()
	LuaHelp.PingWatch.AveragePing = -1
	timer.Create ("LuaHelp.PingWatch", 0.5, 0, function ()
		LuaHelp.PingWatch:Tick ()
	end)
end)

LuaHelp.AddUninitHook (function ()
	timer.Destroy ("LuaHelp.PingWatch")
end)

function LuaHelp.PingWatch:TestMessages ()
	for k, v in pairs (self.Thresholds) do
		LuaHelp.LogLine ("Average Ping: " .. string.format ("%.1f", v [1]) .. " (" .. v [2] .. ")", v [3])
	end
end

concommand.Add ("luahelp_testlagmessages", function ()
	LuaHelp.PingWatch:TestMessages ()
end)