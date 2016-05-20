local downloadCount = 0
local downloads = {}
local translatedDownloads = {}
local luaToDownload = {}

function NumDownloadables ()
	return downloadCount
end

function GetDownloadables ()
	return downloads
end

function GetTranslatedDownloadables ()
	return translatedDownloads
end

function GetTranslatedScriptNames ()
	return luaToDownload
end

function TranslateDownloadableName (fileName)
	return translatedDownloads [fileName]
end

function TranslateScriptName (scriptName)
	return luaToDownload [scriptName]
end

concommand.Add ("luahelp_receive_downloads", function (_, _, _)
	DownloadData = cookie.GetString ("Menu_Downloads")
	local downloadData = glon.decode (cookie.GetString ("Menu_Downloads"))
	if not downloadData then
		Msg ("luahelp_receive_downloads: Failed to decode download list. (\"" .. tostring (cookie.GetString ("Menu_Downloads")) .. "\")\n")
		return
	end
	downloadCount = downloadData.DownloadCount
	downloads = downloadData.Downloads
	translatedDownloads = downloadData.TranslatedDownloads
	
	for k, v in pairs (translatedDownloads) do
		luaToDownload [v] = k
	end
	
	local outputFile = ""
	for _, v in pairs (downloads) do
		if translatedDownloads [v] then
			outputFile = outputFile .. translatedDownloads [v] .. " (" .. v .. ")\n"
		else
			outputFile = outputFile .. v .. "\n"
		end
	end
	
	file.ServerWrite ("downloads", outputFile)
	
	cookie.Set ("Menu_Downloads", nil)
end)

timer.Simple (0.1, RunConsoleCommand, "menu_forward_downloads")