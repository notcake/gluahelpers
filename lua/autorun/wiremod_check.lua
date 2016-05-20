RunConsoleCommand ("wiremod_install_check", "1")

hook.Add ("Think", "WiremodInstallCheck", function ()
	RunConsoleCommand ("wiremod_install_check", "1")
	hook.Remove ("Think", "WiremodInstallCheck")
end)