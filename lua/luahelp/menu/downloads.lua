require ("glon")

local function ForwardDownloadables ()
	local numDownloadables = NumDownloadables ()
	local downloadables = GetDownloadables ()
	local translatedDownloadables = {}
	for _, v in pairs (downloadables) do
		translatedDownloadables [v] = TranslateDownloadableName (v)
	end
	
	local downloadableData = glon.encode (
		{
			DownloadCount = numDownloadables,
			Downloads = downloadables,
			TranslatedDownloads = translatedDownloadables
		}
	)
	
	cookie.Set ("Menu_Downloads", downloadableData)
	RunConsoleCommand ("luahelp_receive_downloads")
end

concommand.Add ("menu_dump_downloads", function (_, _, _)
	local downloads = GetDownloadables ()
	if not downloads then
		print ("Download list is empty.")
		return
	end
	for k, v in pairs (downloads) do
		print ("Download: " .. v)
	end
end)

concommand.Add ("menu_forward_downloads", function (_, _, _)
	ForwardDownloadables ()
end)