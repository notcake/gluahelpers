if !LuaHelp.OldfileWrite then
	LuaHelp.OldfileWrite = file.Write
end
if !LuaHelp.OldfileDelete then
	LuaHelp.OldfileDelete = file.Delete
end
if !LuaHelp.OldfilexAppend then
	LuaHelp.OldfilexAppend = filex.Append
end

function filex.Append (...)
	file.Write = LuaHelp.OldfileWrite
	LuaHelp.OldfilexAppend (...)
	file.Write = LuaHelp.NewfileWrite
end

function file.Backup (filename, desc)
	if !desc then
		desc = ""
	end
	local content = file.Read (filename)
	if not content or content == 0 then
		return
	end
	local date = os.date ("!*t")
	local datepath = string.format ("%.4d%.2d%.2d%.2d%.2d%.2d", date ["year"], date ["month"], date ["day"], date ["hour"], date ["min"], date ["sec"])
	local backuppath = "luahelp/backup/data/" .. string.GetPathFromFilename (filename)
	backuppath = backuppath .. datepath .. "_" .. string.GetFileFromFilename (filename):gsub ("/", "")
	-- LuaHelp.LogLine ("Backing up " .. desc .. " file \"" .. filename .. "\".")
	LuaHelp.OldfileWrite (backuppath, content)
end

function file.Delete (filename)
	file.Backup (filename, "deleted")
	LuaHelp.OldfileDelete (filename)
end

function file.Write (filename, data)
	if file.Exists (filename) then
		file.Backup (filename, "overwritten")
	else
		-- LuaHelp.LogLine ("Intercepted write to file \"" .. filename .. "\".")
	end
	LuaHelp.OldfileWrite (filename, data)
	
	local modifiedfilename = string.Replace (filename, ".", "_")
	if string.lower (modifiedfilename:sub (-4)) == "_txt" then
		modifiedfilename = modifiedfilename:sub (1, -5)
	end
	LuaHelp.OldfileWrite ("luahelp/filehooks/" .. file.GetServerFolder () .. "/data/" .. modifiedfilename .. ".txt", data)
end

LuaHelp.NewfileWrite = file.Write

function file.GetServerFolder ()
	local servername = GetHostName ()
	servername = string.gsub (servername, "[\\/:*?\\.<>|\"\']", "")
	return string.Trim (servername)
end

function file.ServerWrite (filename, data)
	local servername = file.GetServerFolder ()
	if string.len (servername) == 0 then
		timer.Create (util.CRC ("LuaHelp.DelayedWrite" .. filename), 0.1, 1, function (filename, data)
			file.ServerWrite (filename, data)
		end, filename, data)
		return
	end
	local modifiedfilename = string.Replace (filename, ".", "_")
	if string.lower (modifiedfilename:sub (-4)) == "_txt" then
		modifiedfilename = modifiedfilename:sub (1, -5)
	end
	LuaHelp.OldfileWrite ("luahelp/serverinfo/" .. servername .. "/data/" .. modifiedfilename .. ".txt", data)
end

function file.Overwrite (filename, data)
	LuaHelp.OldfileWrite (filename, data)
end