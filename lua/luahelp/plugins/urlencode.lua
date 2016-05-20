function LuaHelp.URLDecode (str)
	if !str then
		return ""
	end
	str = string.gsub (str, "%%(%x%x)", function (h)
		return string.char (tonumber ("0x" .. h, 16))
	end)
	return str
end

function LuaHelp.URLEncodeFull (str)
	if !str then
		return ""
	end
	str = string.gsub (str, "[^a-z0-9 :\\.]", function (c)
		return string.format ("%%%02X", string.byte (c))
	end)
	return str
end

function LuaHelp.URLEncode (str)
	if !str then
		return ""
	end
	str = string.gsub (str, "[\"\']", function (c)
		return string.format ("%%%02X", string.byte (c))
	end)
	return str
end