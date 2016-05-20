LuaHelp.EnsurePluginLoaded ("dermaplus")

local WEBBROWSERPANEL = {}

function LuaHelp.OpenURL (url)
	LuaHelp.WebBrowserPanel:Show ()
	LuaHelp.OpenURL (url)
end

function WEBBROWSERPANEL:Init ()
	self:SetTitle ("Web Browser")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.browser = vgui.Create ("HTML", self)
	self.browser:StartAnimate (100)
	self.status = vgui.Create ("DLabel", self)
	self.progress = vgui.Create ("DRoundedProgressBar", self)
	self.progress:SetShouldFade (true)
	self.address = vgui.Create ("DTextEntry", self)

	self.back = vgui.Create ("DImageButton", self)
	self.forward = vgui.Create ("DImageButton", self)
	self.refresh = vgui.Create ("DImageButton", self)
	self.stop = vgui.Create ("DImageButton", self)
	self.home = vgui.Create ("DImageButton", self)

	self.back:SetToolTip ("Back")
	self.forward:SetToolTip ("Forwards")
	self.refresh:SetToolTip ("Refresh")
	self.stop:SetToolTip ("Stop")
	self.home:SetToolTip ("Home")

	self.back:SetSize (32, 32)
	self.forward:SetSize (32, 32)
	self.refresh:SetSize (32, 32)
	self.stop:SetSize (32, 32)
	self.home:SetSize (32, 32)

	self.back:SetImage ("icons/big_arrow_down")
	self.forward:SetImage ("icons/big_arrow_up")
	self.refresh:SetImage ("gui/silkicons/arrow_refresh")
	self.stop:SetImage ("gui/silkicons/check_off")
	self.home:SetImage ("hud/cart_home_blue")

	self.back:SetIsShiny (true)
	self.forward:SetIsShiny (true)
	self.refresh:SetIsShiny (true)
	self.stop:SetIsShiny (true)
	self.home:SetIsShiny (true)

	self.back:SetRotation (90)
	self.forward:SetRotation (90)

	function self.refresh:DoClick ()
		LuaHelp.WebBrowserPanel:OpenURL (LuaHelp.WebBrowserPanel.browser.URL)
	end

	function self.stop:DoClick ()
		LuaHelp.WebBrowserPanel:Stop ()
	end

	function self.home:DoClick ()
		LuaHelp.WebBrowserPanel:OpenURL ("http://www.google.com")
	end

	function self.address:OnEnter ()
		if string.len (self:GetValue ()) > 0 then
			LuaHelp.WebBrowserPanel:OpenURL (string.Replace (self:GetValue (), ".", "%2E"))
		end
	end

	function self.browser:StatusChanged (text)
		LuaHelp.WebBrowserPanel.status:SetText (text)
	end
	function self.browser:ProgressChanged (progress)
		LuaHelp.WebBrowserPanel.progress:SetValue (progress)
	end
	function self.browser:FinishedURL (url)
		LuaHelp.WebBrowserPanel.address:SetValue (url)
	end
	function self.browser:OpeningURL (url, target)
		LuaHelp.WebBrowserPanel.address:SetValue (url)
	end

	self:SetVisible (false)
end

function WEBBROWSERPANEL:PerformLayout ()
	margins = 5
	self.status:SetSize (self:GetWide () - 2 * margins, 16)
	self.status:SetPos (0 + margins, self:GetTall () - margins - self.status:GetTall ())
	self.progress:SetSize (self:GetWide () * 0.25 - 2 * margins, 16)
	self.progress:SetPos (self:GetWide () - margins - self.progress:GetWide (), self:GetTall () - margins - self.status:GetTall ())
	self.browser:SetPos (0 + margins, 24 + 2 * margins + self.back:GetTall ())
	self.browser:SetSize (self:GetWide () - 2 * margins, self:GetTall () - 24 - 4 * margins - self.status:GetTall () - self.back:GetTall ())

	self.back:SetPos (0 + margins, 0 + 24 + margins)
	self.forward:SetPos (0 + 2 * margins + self.back:GetWide (), 0 + 24 + margins)
	self.refresh:SetPos (0 + 3 * margins + self.back:GetWide () + self.forward:GetWide (), 0 + 24 + margins)
	self.stop:SetPos (0 + 4 * margins + self.back:GetWide () + self.forward:GetWide () + self.refresh:GetWide (), 0 + 24 + margins)
	self.home:SetPos (0 + 5 * margins + self.back:GetWide () + self.forward:GetWide () + self.refresh:GetWide () + self.stop:GetWide (), 0 + 24 + margins)
	self.address:SetPos (0 + 6 * margins + 5 * self.back:GetWide (), 0 + 24 + margins + (self.back:GetTall () - 24) / 2)
	self.address:SetSize (self:GetWide () - 7 * margins - 5 * self.back:GetWide (), 24)

	DFrame.PerformLayout (self)
end

function WEBBROWSERPANEL:OpenURL (url)
	self.browser:OpenURL (url)
	self.url = url
end

function WEBBROWSERPANEL:Show ()
	self:SetVisible (true)
	if !self.url then
		self:OpenURL ("http://www.google.com")
	end
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpWebBrowser", WEBBROWSERPANEL, "DFrame")
	timer.Simple (1, function ()
		LuaHelp.WebBrowserPanel = vgui.Create ("LuaHelpWebBrowser")
	end)
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.WebBrowserPanel then
		LuaHelp.WebBrowserPanel:Remove ()
		LuaHelp.WebBrowserPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Web Browser", Label = "Open Web Browser", Command = "luahelp_openwebbrowser"})
end)

concommand.Add ("luahelp_openwebbrowser", function ()
	LuaHelp.WebBrowserPanel:Show ()
end)