local function bAnd (a, b)
	return a & b
end

local function bXor (a, b)
	return (a | b) & (-1-(a & b))
end

function LuaHelp.SendAchievement (id)
	// (x xor y) xor y == x
	local crc = tonumber (util.CRC (game.GetMap () .. ".bsp"))

	local mask = bAnd (crc, 0xFFFF)
	local userid = LocalPlayer ():UserID ()

	local achievement = bXor (id, mask)
	local check = bXor (userid, bXor (achievement, mask))

	local arg1 = achievement
	local arg2 = check

	// Now double check
	local iAchievement = bXor (arg1, mask)
	local code = bXor (bXor (userid, iAchievement), mask)
	if code ~= arg2 then
		Msg ("FAIL.\n")
		Msg ("mask: " .. string.format ("0x%.8x", mask) .. "\n")
		Msg ("iAchievement: " .. string.format ("0x%.8x", iAchievement) .. "\n")
		Msg ("Code: " .. string.format ("0x%.8x", code) .. "\n")
		Msg ("Arg2: " .. string.format ("0x%.8x", arg2) .. "\n")
	else
		local name = achievements.GetName (id) or tostring (id)
		Msg ("Sent achievement message: " .. name .. "\n")
	end

	RunConsoleCommand ("achievement_earned", tostring (achievement), tostring (check))
	LocalPlayer ():ConCommand ("achievement_earned " .. tostring (achievement) .. " " .. tostring (check))
end

concommand.Add ("luahelp_achievement", function (_, _, args)
	if not args [1] then
		args [1] = math.random (1, 15)
	end
	LuaHelp.SendAchievement (tonumber (args [1]))
end)