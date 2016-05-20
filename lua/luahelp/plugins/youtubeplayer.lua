LuaHelp.EnsurePluginLoaded ("hookusermessage")
local margins = 5

function LuaHelp.GenerateYoutubePlayerURL (url)
	return "'//--></script><iframe src=\"" .. url .. "\" style=\"width: 100%; height: 100%; position: absolute; top: 0px; left: 0px\" /><!--"
end

function LuaHelp.GenerateYoutubePlayerMessage (message)
	return "'//--></script><span style=\"width: 100%; height: 100%; position: absolute; top: 0px; left: 0px; color: white; text-align: center; font-size: 32\">" .. message .. "</span><!--"
end

function LuaHelp.GenerateYoutubePlayerSWF (address)
	return "'//--></script><embed src=\"" .. address .. "\" quality=\"high\" width=\"100%\" height=\"100%\" style=\"position: absolute; top: 0px; left: 0px\" type=\"application/x-shockwave-flash\" /><!--"
end

function LuaHelp.SendYoutubeURL (url, mode)
	if mode == 0 then
		datastream.StreamToServer ("youtube_url_message", {["url"] = url})
	else
		RunConsoleCommand ("youtube_player_url", url)
	end
end

local YTPANEL = {}

function YTPANEL:Init ()
	self:SetTitle ("Youtube Player Controls")

	self:SetSize (ScrW () * 0.3, 3 * 20 + 4 * margins + 24)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2 + 0.2 * ScrH ())

	self:ShowCloseButton (true)
	self:SetDraggable (true)
	self:SetDeleteOnClose (false)
	self:SetSizable (false)
	self:MakePopup ()

	self.txtURL = vgui.Create ("DTextEntry", self)
	self.txtURL:SetText ("http://www.")

	self.txtSWF = vgui.Create ("DTextEntry", self)
	self.txtSWF:SetText ("http://www.")

	self.txtMessage = vgui.Create ("DTextEntry", self)
	self.txtMessage:SetText ("")

	self.btnURL = vgui.Create ("DButton", self)
	self.btnURL:SetText ("Set URL")
	self.btnURL.DoClick = function (button)
		LuaHelp.SendYoutubeURL (LuaHelp.GenerateYoutubePlayerURL (self.txtURL:GetValue ()), self.Mode)
	end

	self.btnSWF = vgui.Create ("DButton", self)
	self.btnSWF:SetText ("Set SWF")
	self.btnSWF.DoClick = function (button)
		LuaHelp.SendYoutubeURL (LuaHelp.GenerateYoutubePlayerSWF (self.txtURL:GetValue ()), self.Mode)
	end

	self.btnMessage = vgui.Create ("DButton", self)
	self.btnMessage:SetText ("Set Message")
	self.btnMessage.DoClick = function (button)
		LuaHelp.SendYoutubeURL (LuaHelp.GenerateYoutubePlayerMessage (self.txtMessage:GetValue ()), self.Mode)
	end

	self:SetVisible (false)
	self.Mode = 0
end

function YTPANEL:PerformLayout ()
	self.txtURL:SetPos (0 + margins, 24 + margins)
	self.txtURL:SetSize (self:GetWide () * 0.75, 20)

	self.txtSWF:SetPos (0 + margins, 24 + 2 * margins + self.txtURL:GetTall ())
	self.txtSWF:SetSize (self:GetWide () * 0.75, 20)

	self.txtMessage:SetPos (0 + margins, 24 + 3 * margins + self.txtURL:GetTall () + self.txtSWF:GetTall ())
	self.txtMessage:SetSize (self.txtURL:GetWide (), self.txtURL:GetTall ())

	self.btnURL:SetPos (0 + 2 * margins + self.txtURL:GetWide (), 24 + margins)
	self.btnURL:SetSize (self:GetWide () - 3 * margins - self.txtURL:GetWide (), self.txtURL:GetTall ())

	self.btnSWF:SetPos (0 + 2 * margins + self.txtSWF:GetWide (), 24 + 2 * margins + self.txtURL:GetTall ())
	self.btnSWF:SetSize (self:GetWide () - 3 * margins - self.txtSWF:GetWide (), self.txtSWF:GetTall ())

	self.btnMessage:SetPos (0 + 2 * margins + self.txtMessage:GetWide (), 24 + 3 * margins + self.txtURL:GetTall () + self.txtSWF:GetTall ())
	self.btnMessage:SetSize (self:GetWide () - 3 * margins - self.txtMessage:GetWide (), self.txtMessage:GetTall ())
	DFrame.PerformLayout (self)
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpYT", YTPANEL, "DFrame")
	LuaHelp.YTPanel = vgui.Create ("LuaHelpYT")
	LuaHelp.AddUsermessageHook ("youtube_url_query", "LuaHelp.YoutubePlayerControl", function ()
		LuaHelp.YTPanel.Mode = 0
		LuaHelp.YTPanel:SetVisible (true)
	end)
	LuaHelp.AddUsermessageHook ("youtube_player_use_menu", "LuaHelp.YoutubePlayerControl", function ()
		LuaHelp.YTPanel.Mode = 1
		LuaHelp.YTPanel:SetVisible (true)
	end)
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.YTPanel then
		LuaHelp.YTPanel:Remove ()
		LuaHelp.YTPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Youtube Player", Label = "Youtube Player", Command = "luahelp_openytplayercontrol"})
end)

concommand.Add ("luahelp_openytplayercontrol", function ()
	LuaHelp.YTPanel:SetVisible (true)
end)