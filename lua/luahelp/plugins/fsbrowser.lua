LuaHelp.FileHandlers = {}
LuaHelp.FileHandlers.Extensions = {}

local FILESYSTEMBROWSERPANEL = {}

local filehandlers = file.FindInLua ("luahelp\\fsbrowser\\*.lua")
for _, file in ipairs (filehandlers) do
	include ("luahelp\\fsbrowser\\" .. file)
end

function FILESYSTEMBROWSERPANEL:Init ()
	self:SetTitle ("Filesystem Browser")

	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2)
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end
	self.tvwFiles = vgui.Create ("DTree", self)
	self.txtView = vgui.Create ("DTextEntry", self)
	self.txtView:SetEditable (false)
	self.txtView:SetMultiline (true)
	self.txtView:SetVerticalScrollbarEnabled (true)
	self.txtView:SetMouseInputEnabled (true)
	self.txtView:SetKeyboardInputEnabled (true)
	self.imgView = vgui.Create ("DImage", self)
	self.imgView:SetSize (0, 0)
	
	self.RootNode = self.tvwFiles:AddNode ("root")
	self.RootNode.Path = "..\\.."
	self.RootNode.Populated = false

	self:SetVisible (false)
end

function FILESYSTEMBROWSERPANEL:PerformLayout ()
	margins = 5
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	self.tvwFiles:SetPos (0 + margins, 24 + margins)
	self.tvwFiles:SetSize (self:GetWide () * 0.3 - 1.5 * margins, self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())
	self.txtView:SetPos (0 + 2 * margins + self.tvwFiles:GetWide (), 24 + margins)
	self.txtView:SetSize (self:GetWide () - 3 * margins - self.tvwFiles:GetWide (), self:GetTall () - 24 - 3 * margins - self.btnExit:GetTall ())

	self.imgView:SetPos (0 + 2 * margins + self.tvwFiles:GetWide () + (self:GetWide () - 3 * margins - self.tvwFiles:GetWide () - self.imgView:GetWide ()) / 2, 24 + margins)
	DFrame.PerformLayout (self)
end

function FILESYSTEMBROWSERPANEL:DisplayFile (path)
	path = string.Replace (path, "..\\..\\garrysmod\\", "..\\")
	
	local luaPath = string.match (path, "%.%.\\lua_temp\\(.*)")
	if luaPath then
		local translatedName = TranslateScriptName (luaPath)
		if translatedName then
			path = "..\\" .. translatedName
		end
	end
	
	local extension = string.GetExtensionFromFilename (path)
	if extension == "vmt" then
		self.imgView:SetVisible (true)
		self.txtView:SetVisible (false)
		self.imgView:SetImage (path)
		self.imgView:SizeToContents ()
		self.imgView:SetPos ((margins + self.tvwFiles:GetWide () + self:GetWide () - self.imgView:GetWide ()) / 2, 24 + (self:GetTall () - 24 - margins - self.btnExit:GetTall () - self.imgView:GetTall ()) / 2)
	else
		self.imgView:SetVisible (false)
		self.txtView:SetVisible (true)
		self.imgView:SetSize (0, 0)
		self.txtView:SetValue (file.Read (path) or "<Read Error>")
	end
end

function FILESYSTEMBROWSERPANEL:PopulateNode (pnode)
	local path = pnode.Path
	if pnode.Populated then
		return
	end
	if pnode.TempChild then
		pnode.TempChild:Remove ()
		pnode.TempChild = nil
	end
	local files = file.Find (path .. "\\*")
	local delay = 0.01
	for _, v in pairs (files) do
		local cnode = pnode:AddNode (v)
		cnode.Path = path .. "\\" .. v
		timer.Create (util.CRC (path .. "\\" .. v), delay, 1, function (cnode)
			if file.IsDir (path .. "\\" .. v) then
				cnode.TempChild = cnode:AddNode ("<Populating ...>")
				function cnode:SetExpanded (bExpanded)
					if bExpanded then
						LuaHelp.FilesystemBrowserPanel:PopulateNode (self)
					else
						self.ChildNodes:Clear ()
						self.TempChild = cnode:AddNode ("<Populating ...>")
						self.Populated = false
					end
					DTree_Node.SetExpanded (self, bExpanded)
				end
			else
				cnode.Icon:SetImage ("vgui\\spawnmenu\\file")
				function cnode:DoClick ()
					LuaHelp.FilesystemBrowserPanel:DisplayFile (self.Path)
					DTree_Node.DoClick (self)
				end
			end
		end, cnode)
		delay = delay + 0.01
	end
	pnode.Populated = true
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpFilesystemBrowser", FILESYSTEMBROWSERPANEL, "DFrame")
	LuaHelp.FilesystemBrowserPanel = vgui.Create ("LuaHelpFilesystemBrowser")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.FilesystemBrowserPanel then
		LuaHelp.FilesystemBrowserPanel:Remove ()
		LuaHelp.FilesystemBrowserPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Filesystem Browser", Label = "Open Filesystem Browser", Command = "luahelp_openfilesystembrowser"})
end)

concommand.Add ("luahelp_openfilesystembrowser", function ()
	LuaHelp.FilesystemBrowserPanel:SetVisible (true)
	if !LuaHelp.FilesystemBrowserPanel.RootNode.Populated then
		LuaHelp.FilesystemBrowserPanel:PopulateNode (LuaHelp.FilesystemBrowserPanel.RootNode)
		LuaHelp.FilesystemBrowserPanel.RootNode:SetExpanded (true)
	end
end)