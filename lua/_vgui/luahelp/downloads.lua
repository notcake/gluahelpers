require ("cookie")
require ("glon")
require ("timer")

local timers = ({debug.getupvalue (timer.IsTimer, 1)}) [2]
local WriteCookies = nil
local BufferedWrites = nil
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
	
	if not WriteCookies then
		cookie.Set ("Menu_Downloads", "")
		WriteCookies = timers ["Cookie_CommitToSQLite"].Func
		BufferedWrites = ({debug.getupvalue (WriteCookies, 1)}) [2]
	end
	cookie.Set ("Menu_Downloads", downloadableData)
	WriteCookies ()
	BufferedWrites = ({debug.getupvalue (WriteCookies, 1)}) [2]
	
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