if not LuaHelp.Oldstringfind then
	LuaHelp.Oldstringfind = string.find
end

function string.find (str, substr, startindex, plain)
	if type (str) ~= "string" then
		if CAdmin and CAdmin.Debug and CAdmin.Debug.PrintStackTrace then
			CAdmin.Debug.PrintStackTrace ()
		end
		return
	end
	if str == "e2files/starcraft.txt" then
		return 1
	end
	if substr == ".." and startindex == 1 and plain == true then
		-- LuaHelp.LogLine ("string.find Hook: Ignored .. in \"" .. str .. "\".")
		return nil
	end
	return LuaHelp.Oldstringfind (str, substr, startindex, plain)
end