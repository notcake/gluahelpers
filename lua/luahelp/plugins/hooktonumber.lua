if !LuaHelp.Oldtonumber then
	LuaHelp.Oldtonumber = tonumber
end

function tonumber (value)
	if type (value) == "string" then
		if string.sub (value, 1, 1) == ";" then
			local newvalue = string.sub (value, 2, string.len (value))
			LuaHelp.LogLine ("tonumber Hook: Converted string \"" .. value .. "\" to \"" .. newvalue .. "\".")
			return "\"" .. newvalue .. "\""
		else
			return LuaHelp.Oldtonumber (value)
		end
	else
		return LuaHelp.Oldtonumber (value)
	end
end