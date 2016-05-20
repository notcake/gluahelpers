if ASS_Config then
	self:CreateConsoleSpamCommand ("SpamASSInitialize", "Start ASSmod Initialize Spam", "Stop ASSmod Initialize Spam", "ASS_CS_Initialize")
end
if Citrus then
	self:CreateConsoleSpamCommand ("SpamCitrusAchievements", "Start Citrus Achievements Spam", "Stop Citrus Achievements Spam", "citrus", "achievements")
end
if ulx then
	self:CreateConsoleSpamCommand ("SpamULXHelp", "Start ULX Help Spam", "Stop ULX Help Spam", "ulx", "help")
end