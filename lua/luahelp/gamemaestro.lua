return

include('shared.lua')



function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	return false
end

local PANEL = {}



function PANEL:Init()

	if Loaded == false || Loaded == nil || Loaded == NULL || Loaded == "" then
		AllTools = spawnmenu.GetTools()
		Msg("|================================|\n")
		Msg("|===Tables loaded successfully===|\n")
		Msg("|================================|\n")
		local Loaded = true
	end
	local tTables = AllTools
	
	MENU = self
	MENU:SetTitle("")
	MENU:ShowCloseButton(false)
	MENU:SetSize(ScrW() - 50, ScrH() - 50)
	MENU:SetPos(25, 25)
	MENU.Paint = function()
		surface.SetDrawColor(0, 0, 0, 0)
		surface.DrawRect(0, 0, MENU:GetWide(), MENU:GetTall())
	end


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	self.PropPanel = vgui.Create("DPropertySheet")												--| Prop tab.
	self.PropPanel:SetParent(MENU)																--|
	self.PropPanel:SetSize(((MENU:GetWide()*.5 - 5)), MENU:GetTall())							--|
	self.PropPanel:SetPos(0, 0)																	--|
																								--|
	self.PropsBackground = vgui.Create("DPanelList")											--| Prop background.
	self.PropsBackground:EnableHorizontal(true)													--|
	self.PropsBackground:EnableVerticalScrollbar(true)											--|
	self.PropsBackground:SetPadding(5)															--|
	self.PropsBackground:SetSpacing(5)															--|
	self.PropsBackground:SetSize((self.PropPanel:GetWide() - 10), self.PropPanel:GetTall())		--|
	self.PropsBackground:SetPos(0, 0)															--|
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	self.ToolPanel = vgui.Create("DPropertySheet")												--| Tool tab.
	self.ToolPanel:SetParent(MENU)																--|
	self.ToolPanel:SetSize(((MENU:GetWide()*.5 - 5)), MENU:GetTall())							--|
	self.ToolPanel:SetPos(((MENU:GetWide()*.5 + 5)), 0)											--|
																								--|
	self.ToolsBackground = vgui.Create("DPanelList")											--| Tool background.
	self.ToolsBackground:EnableHorizontal(true)													--|
	self.ToolsBackground:EnableVerticalScrollbar(false)											--|
	self.ToolsBackground:SetAutoSize(false)														--|
	self.ToolsBackground:SetPadding(0)															--|
	self.ToolsBackground:SetSpacing(5)															--|
	self.ToolsBackground:SetSize(0, 0)															--|
	self.ToolsBackground:SetPos(0, 0)															--|
	self.ToolsBackground.Paint = function()														--|
		surface.SetDrawColor(170, 170, 170, 255)												--|
		surface.DrawRect(0, 0, self.ToolsBackground:GetWide(), self.ToolsBackground:GetTall())	--|
	end																							--|
																								--|
	self.ToolList = vgui.Create("DPanelList")													--| Tool list background.
	self.ToolsBackground:AddItem(self.ToolList)													--|
	self.ToolList:EnableVerticalScrollbar(true)													--|
	self.ToolList:SetSize(self.ToolPanel:GetWide()*.33, self.ToolPanel:GetTall() - 31)			--|
	self.ToolList:SetPos(0, 0)																	--|
	self.ToolList:SetAutoSize( false ) 															--|
	self.ToolList:SetSpacing( 1 ) 																--|
	self.ToolList:SetPadding( 0 ) 																--|
																								--|
	self.Content = vgui.Create("DPanelList")													--| Context background.
	self.ToolsBackground:AddItem(self.Content)													--|
	self.Content:SetSize(self.ToolPanel:GetWide()*.63, self.ToolPanel:GetTall() - 31)			--|
	self.Content:EnableVerticalScrollbar(false)													--|
	self.Content:SetSpacing(0)																	--|
	self.Content:SetPadding(5)																	--|
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	self.WeaponsBackground = vgui.Create("DPanelList")											--| Weapons background.
	self.WeaponsBackground:EnableHorizontal(true)		
	self.WeaponsBackground:EnableVerticalScrollbar(false) 										--|
	self.WeaponsBackground:SetSize((self.ToolPanel:GetWide() - 10), self.ToolPanel:GetTall())	--|
	self.WeaponsBackground:SetPos(0, 0)															--|
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------| Help background.
	self.HelpBackground = vgui.Create("DPanelList")												--|
	self.HelpBackground:EnableVerticalScrollbar(false) 											--|
	self.HelpBackground:SetSize((self.ToolPanel:GetWide() - 10), self.ToolPanel:GetTall())		--|
	self.HelpBackground:SetPos(0, 0)															--|
	self.HelpBackground.Paint = function()
		local Wide = self.HelpBackground:GetWide()
		local Height = self.HelpBackground:GetTall()
		local Title = "Rules:"
		local One = "Do not prop push."
		local Two = "Do not spam mic/chat/props in any way."
		local Three = "Do not try and team up with other players WITHOUT their permission."
		local Four = "If a team survives, boat owner decides who to jump off."
		local Five = "Don't be disrespectful in any way to other players."
		local Six = "Don't exploit any bugs/glitches/errors with the gamemode or maps."
		local Seven = "If any of these rules are broken, you will be kicked/banned on your fault."
		surface.SetDrawColor(50, 50, 50, 255)													--|
		--surface.DrawRect(0, 0, Wide, self.DonateBackground:GetTall())--|
		surface.SetTextColor(255, 255, 255, 255)												--|
		
		surface.SetFont("Trebuchet20")															--|
		local TitleW, TitleH = surface.GetTextSize(Title)
		surface.SetTextPos(((Wide*.5) - (TitleW*.5)), ((Height*.03) - (TitleH*.5)))																--|
		surface.DrawText(Title)						

		surface.SetFont("Default")																--|
		local OneW, OneH = surface.GetTextSize(One)
		surface.SetTextPos(((Wide*.5) - (OneW*.5)), ((Height*.09) - (OneH*.5)))		
		surface.DrawText(One)													--|
		
		surface.SetFont("Default")																--|
		local TwoW, TwoH = surface.GetTextSize(Two)
		surface.SetTextPos(((Wide*.5) - (TwoW*.5)), ((Height*.12) - (TwoH*.5)))		
		surface.DrawText(Two)													--|
		
		surface.SetFont("Default")																--|
		local ThreeW, ThreeH = surface.GetTextSize(Three)
		surface.SetTextPos(((Wide*.5) - (ThreeW*.5)), ((Height*.15) - (ThreeH*.5)))		
		surface.DrawText(Three)													--|
		
		surface.SetFont("Default")																--|
		local FourW, FourH = surface.GetTextSize(Four)
		surface.SetTextPos(((Wide*.5) - (FourW*.5)), ((Height*.18) - (FourH*.5)))		
		surface.DrawText(Four)													--|
		
		surface.SetFont("Default")																--|
		local FiveW, FiveH = surface.GetTextSize(Five)
		surface.SetTextPos(((Wide*.5) - (FiveW*.5)), ((Height*.21) - (FiveH*.5)))		
		surface.DrawText(Five)													--|
		
		surface.SetFont("Default")																--|
		local SixW, SixH = surface.GetTextSize(Six)
		surface.SetTextPos(((Wide*.5) - (SixW*.5)), ((Height*.24) - (SixH*.5)))		
		surface.DrawText(Six)													--|
		
		surface.SetTextColor(200, 25, 25, 255)
		surface.SetFont("Default")																--|
		local SevenW, SevenH = surface.GetTextSize(Seven)
		surface.SetTextPos(((Wide*.5) - (SevenW*.5)), ((Height*.27) - (SevenH*.5)))		
		surface.DrawText(Seven)													--|
		surface.SetTextColor(255, 255, 255, 255)
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|												--|
	
	--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------| Admin background.
	self.AdminBackground = vgui.Create("DPanelList")												--|
	self.AdminBackground:EnableVerticalScrollbar(false) 											--|
	self.AdminBackground:SetSize((self.ToolPanel:GetWide() - 10), self.ToolPanel:GetTall())		--|
	self.AdminBackground:SetPos(0, 0)															--|
	self.AdminBackground.Paint = function()
		surface.SetDrawColor(50, 50, 50, 255)													--|
		surface.DrawRect(0, 0, self.AdminBackground:GetWide(), self.AdminBackground:GetTall())--|
		surface.SetTextColor(255, 255, 255, 255)												--|
		
		local Title = "Admin menu under construction."
		surface.SetFont("Trebuchet20")															--|
		local TitleW, TitleH = surface.GetTextSize(Title)
		surface.SetTextPos(((self.AdminBackground:GetWide()*.5) - (TitleW*.5)), ((self.AdminBackground:GetTall()*.02) - (TitleH*.5)))																--|
		surface.DrawText(Title)	
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	else--]]
	self.AdminBackground = vgui.Create("DPanelList")												--|
	self.AdminBackground:EnableVerticalScrollbar(false) 											--|
	self.AdminBackground:SetSize((self.ToolPanel:GetWide() - 10), self.ToolPanel:GetTall())		--|
	self.AdminBackground:SetPos(0, 0)															--|
	self.AdminBackground.Paint = function()
		surface.SetDrawColor(170, 170, 170, 255)												--|
		surface.DrawRect(0, 0, self.AdminBackground:GetWide(), self.AdminBackground:GetTall())--|
		--[[surface.SetTextColor(255, 255, 255, 255)												--|
		
		local Title = "You must donate and become an admin to view this menu. Click the donations tab on the left."
		surface.SetFont("Trebuchet20")															--|
		local TitleW, TitleH = surface.GetTextSize(Title)
		surface.SetTextPos(((self.AdminBackground:GetWide()*.5) - (TitleW*.5)), ((self.AdminBackground:GetTall()*.02) - (TitleH*.5)))																--|
		surface.DrawText(Title)	--]]
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
   
	for k, v in pairs(WeaponInfo) do
		local Sweps = vgui.Create("SpawnIcon")
		Sweps:SetModel(v.MDL)
		Sweps:SetToolTip(v.Tip)
		Sweps.DoClick = function()
			RunConsoleCommand("Purchase", v.Weapon)
			MENU:SetVisible(false)
			RememberCursorPosition()
			gui.EnableScreenClicker(false)
		end
		self.WeaponsBackground:AddItem(Sweps)
	end
	
	if tTables then
		for k, v in pairs(tTables[1].Items) do 
			if ( type( v ) == "table" ) then 	 
				local Name = v.ItemName 
				local Label = v.Text 
				v.ItemName = nil 
				v.Text = nil 
				self:AddCategory( Name, Label, v ) 
			end
		end
	else
		LocalPlayer():ChatPrint("There has been an error loading your tools section, please rejoin the server or contact an administrator to fix this.")
	end


	if PList then
		for k, v in pairs(PList) do
			local Props = vgui.Create("SpawnIcon")
			Props:SetModel(v)
			Props:SetToolTip(k)
			Props.DoClick = function()
				local MDL = v
				RunConsoleCommand("RemoveIt", MDL)
			end
			self.PropsBackground:AddItem(Props)
		end
	else
		LocalPlayer():ChatPrint("There has been an error loading your props section, please rejoin the server or contact an administrator to fix this.")
	end
	
	self.PropPanel:AddSheet("Props", self.PropsBackground, "gui/silkicons/brick_add", true, false)
	self.PropPanel:AddSheet("Weapons", self.WeaponsBackground, "gui/silkicons/bomb", true, false)
	self.ToolPanel:AddSheet("Tools", self.ToolsBackground, "gui/silkicons/wrench", false, false)
	self.ToolPanel:AddSheet("Help/Rules", self.HelpBackground, "gui/silkicons/exclamation", false, false)
	self.ToolPanel:AddSheet("Admin", self.AdminBackground, "gui/silkicons/shield", true, false)
end

function PANEL:AddCategory( Name, Label, tItems )
	
	self.Category = vgui.Create( "DCollapsibleCategory") 
 	self.ToolList:AddItem( self.Category ) 
 	self.Category:SetLabel( Label ) 
 	self.Category:SetCookieName( "ToolMenu."..tostring(Name) ) 
 	 
 	self.CategoryContent = vgui.Create( "DPanelList" ) 
 	self.CategoryContent:SetAutoSize( true ) 
 	self.CategoryContent:SetDrawBackground( false ) 
 	self.CategoryContent:SetSpacing( 0 ) 
 	self.CategoryContent:SetPadding( 0 ) 
 	self.Category:SetContents( self.CategoryContent ) 
 	 
	local bAlt = true
	 
 	for k, v in pairs( tItems ) do 
 		local Item = vgui.Create( "ToolMenuButton", self ) 
 		Item:SetText( v.Text ) 
 		Item.OnSelect = function( button ) self:EnableControlPanel( button ) end 
 		concommand.Add( Format( "tool_%s", v.ItemName ), function() Item:OnSelect() end ) 
		
 		if ( v.SwitchConVar ) then 
 			Item:AddCheckBox( v.SwitchConVar ) 
 		end 

 		Item.ControlPanelBuildFunction = v.CPanelFunction 
 		Item.Command = v.Command 
 		Item.Name = v.ItemName 
 		Item.Controls = v.Controls 
 		Item.Text = v.Text 

 		Item:SetAlt( bAlt ) 
 		bAlt = !bAlt 

 		self.CategoryContent:AddItem( Item ) 
 	end
end

 function PANEL:EnableControlPanel( button ) 
   
 	if ( self.LastSelected ) then 
 		self.LastSelected:SetSelected( false ) 
 	end 
 	 
 	button:SetSelected( true ) 
 	self.LastSelected = button 
   
 	local cp = controlpanel.Get( button.Name ) 
 	if ( !cp:GetInitialized() ) then 
 		cp:FillViaTable( button ) 
 	end 
 	 
 	self.Content:Clear() 
 	self.Content:AddItem( cp ) 
 	self.Content:Rebuild() 
   
 	g_ActiveControlPanel = cp 
 	 
 	if ( button.Command ) then 
 		LocalPlayer():ConCommand( button.Command ) 
 	end 
 		 
 end
 
function PANEL:Think()
	
end

function PANEL:Close()
 	MENU:Remove()
end

function PANEL:PerformLayout()

end

vgui.Register("menu", PANEL, "DFrame")


function ResetPList(PL)
	MENU.PlayerList:Clear()
	--for k, v in pairs(player.GetAll()) do
	--	if PL ~= v:Nick() then
	--		MENU.PlayerList:AddItem(v:Nick())
	MENU.PlayerList:AddItem("fm_atlantasv2")
	MENU.PlayerList:AddItem("fm_bigtank_v2")
	MENU.PlayerList:AddItem("fm_cliffs_v1")
	MENU.PlayerList:AddItem("fm_fishtank")
	MENU.PlayerList:AddItem("fm_glacier")
	MENU.PlayerList:AddItem("fm_magmatic_rc3")
	MENU.PlayerList:AddItem("fm_sink")
	MENU.PlayerList:AddItem("fm_wierdholev2")
	--	end
	--end
end

local function AdminMenu()
MENU.PlayerList = vgui.Create( "DComboBox")
MENU.PlayerList:SetParent( MENU.AdminBackground )
MENU.PlayerList:SetPos( 0, 0 )
MENU.PlayerList:SetSize( MENU.AdminBackground:GetWide()*.333, 225 )
MENU.PlayerList:SetMultiple( false ) // Don't use this unless you know extensive knowledge about tables
ResetPList()

MENU.Kick = vgui.Create( "DButton" )
MENU.Kick:SetParent( MENU.AdminBackground ) // Set parent to our "DermaPanel"
MENU.Kick:SetText("Change to")
MENU.Kick:SetPos( ((MENU.AdminBackground:GetWide()*.333) + 5), 0 )
MENU.Kick:SetSize( ((MENU.AdminBackground:GetWide()*.333) - 5), 50 )
	MENU.Kick.DoClick = function ()
		local Value = MENU.PlayerList:GetSelectedItems()[1]
		if Value != nil && Value != NULL && Value != "" then
			print( Value:GetValue() )
			--if Value:GetValue() == "fm_fishtank" then
				RunConsoleCommand("CT_ChgTo", Value:GetValue()) --LocalPlayer():GetName()
			--end
			--RunConsoleCommand("FM_Kick", Value:GetValue())
			--local PlayerLeft = Value:GetValue()
			--ResetPList(PlayerLeft)
		else
			print("No player selected!")
		end
	end 
end


function PlayerMenu()
MENU.HAHA = vgui.Create( "DButton" )
MENU.HAHA:SetParent( MENU.AdminBackground ) // Set parent to our "DermaPanel"
MENU.HAHA:SetText("Big button O' doom says you are not admin and can't view this page!")
MENU.HAHA:SetPos( 0, 0 )
MENU.HAHA:SetSize( MENU.AdminBackground:GetWide(), MENU.AdminBackground:GetTall() )
	MENU.HAHA.DoClick = function ()
		LocalPlayer():ConCommand("say I like penis in my butt :D!")
	end
end

function GM:OnSpawnMenuOpen()
	if MENU == nil or not MENU:IsValid() then
		vgui.Create("menu")
		if LocalPlayer():IsAdmin() then
			AdminMenu()
		else
			PlayerMenu()
		end
	else
		MENU:SetVisible(true)
		if LocalPlayer():IsAdmin() then
			AdminMenu()
		else
			PlayerMenu()
		end
	end
	gui.EnableScreenClicker(true)
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	if MENU and MENU:IsValid() and MENU:IsVisible() then
		MENU:SetVisible(false)
	end
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

function GM:Think()
	for k, v in pairs(player.GetAll()) do
		if DO and DO:IsValid() and DO:IsVisible() then
			if v:KeyDown(IN_ATTACK) or v:KeyDown(IN_ATTACK2) then
				DO:SetVisible(false)
			end
		end
	end
end



PList = {}
PList["Cost: $39\nHealth: 45"] = "models/props_c17/FurnitureTable002a.mdl"
PList["Cost: $30\nHealth: 30"] = "models/props_c17/gravestone_coffinpiece002a.mdl"
PList["Cost: $18\nHealth: 30"] = "models/props_c17/oildrum001.mdl"
PList["Cost: $90\nHealth: 90"] = "models/props_c17/shelfunit01a.mdl"
PList["Cost: $75\nHealth: 75"] = "models/props_c17/concrete_barrier001a.mdl"
PList["Cost: $5\nHealth: 25"] = "models/props_borealis/door_wheel001a.mdl"
PList["Cost: $131\nHealth: 131"] = "models/props_c17/display_cooler01a.mdl"
PList["Cost: $70\nHealth: 90"] = "models/props_c17/canister_propane01a.mdl"
PList["Cost: $17\nHealth: 20"] = "models/props_c17/bench01a.mdl"
PList["Cost: $286\nHealth: 300"] = "models/props_c17/FurnitureCouch001a.mdl"
PList["Cost: $19\nHealth: 35"] = "models/Combine_Helicopter/helicopter_bomb01.mdl"
PList["Cost: $399\nHealth: 399"] = "models/props_c17/FurnitureShelf001a.mdl"
PList["Cost: $17\nHealth: 30"] = "models/props_c17/gravestone003a.mdl"
PList["Cost: $1769\nHealth: 1999"] = "models/props_c17/Lockers001a.mdl"
PList["Cost: $30\nHealth: 37"] = "models/props_debris/metal_panel02a.mdl"
PList["Cost: $150\nHealth: 150"] = "models/props_debris/metal_panel01a.mdl"
PList["Cost: $36\nHealth: 60"] = "models/props_c17/canister01a.mdl"
PList["Cost: $126\nHealth: 126"] = "models/props_doors/door03_slotted_left.mdl"
PList["Cost: $465\nHealth: 465"] = "models/props_docks/dock03_pole01a_256.mdl"
PList["Cost: $304\nHealth: 304"] = "models/props_docks/dock01_pole01a_128.mdl"
PList["Cost: $199\nHealth: 200"] = "models/props_interiors/BathTub01a.mdl"
PList["Cost: $86\nHealth: 100"] = "models/props_interiors/Furniture_Desk01a.mdl"
PList["Cost: $13\nHealth: 20"] = "models/props_borealis/mooring_cleat01.mdl"
PList["Cost: $251\nHealth: 251"] = "models/props_interiors/Furniture_shelf01a.mdl"
PList["Cost: $356\nHealth: 399"] = "models/props_interiors/refrigerator01a.mdl"
PList["Cost: $26\nHealth: 40"] = "models/props_interiors/refrigeratorDoor01a.mdl"
PList["Cost: $600\nHealth: 600"] = "models/props_interiors/VendingMachineSoda01a.mdl"
PList["Cost: $200\nHealth: 200"] = "models/props_interiors/VendingMachineSoda01a_door.mdl"
PList["Cost: $20\nHealth: 20"] = "models/props_building_details/Storefront_Template001a_Bars.mdl"
PList["Cost: $39\nHealth: 59"] = "models/props_borealis/bluebarrel001.mdl"
 
WeaponInfo = {}
WeaponInfo[1] = {
	MDL = "models/weapons/w_pist_deagle.mdl",
	Weapon = "weapon_deagle",
	Tip = "Name: Deagle\nCost: $2.000\nDamage: 4\nAmmo: Infinite\nInfo: Spawns with you every round."
}
WeaponInfo[2] = {
	MDL = "models/weapons/W_crossbow.mdl",
	Weapon = "weapon_crossbow",
	Tip = "Name: CrossBow\nCost: $5.000\nDamage: 10\nAmmo: Infinite\nInfo: Spawns with you every round."
}
WeaponInfo[3] = {
	MDL = "models/weapons/w_smg_tmp.mdl",
	Weapon = "weapon_tmp",
	Tip = "Name: Tmp\nCost: $10.000\nDamage: 3\nAmmo: 180\nInfo: Spawns with you every round."
}
WeaponInfo[4] = {
	MDL = "models/weapons/W_357.mdl",
	Weapon = "weapon_357",
	Tip = "Name: Magnum\nCost: $25.000\nDamage: 25\nAmmo: 75\nInfo: Spawns with you every round."
}
WeaponInfo[5] = {
	MDL = "models/weapons/w_shot_xm1014.mdl",
	Weapon = "weapon_shotgun",
	Tip = "Name: Shotgun\nCost: $30.000\nDamage: 40\nAmmo: 50\nInfo: Spawns with you every round."
}
WeaponInfo[6] = {
	MDL = "models/w_rpg.mdl",
	Weapon = "weapon_rpg",
	Tip = "Name: RocketLauncher\nCost: $32.000\nDamage: 0-100 multiple props\nAmmo: 3\nInfo: Spawns with you every round."
}
WeaponInfo[7] = {
	MDL = "models/weapons/w_smg_mp5.mdl",
	Weapon = "weapon_mp5",
	Tip = "Name: MP5\nCost: $85.000\nDamage: 15\nAmmo: 150\nInfo: Spawns with you every round."
}
WeaponInfo[8] = {
	MDL = "models/weapons/w_rif_ak47.mdl",
	Weapon = "weapon_ak47",
	Tip = "Name: AK47\nCost: $125.000\nDamage: 25\nAmmo: 150\nInfo: Spawns with you every round."
}
WeaponInfo[9] = {
	MDL = "models/weapons/w_IRifle.mdl",
	Weapon = "weapon_ar2",
	Tip = "Name: AR2\nCost: $175.000\nDamage: 35\nAmmo: 150\nInfo: Spawns with you every round."
}
WeaponInfo[10] = {
	MDL = "models/weapons/w_mach_m249para.mdl",
	Weapon = "weapon_para",
	Tip = "Name: M249\nCost: $195.000\nDamage: 40\nAmmo: 150\nInfo: Spawns with you every round."
}
WeaponInfo[11] = {
	MDL = "models/weapons/w_snip_awp.mdl",
	Weapon = "cse_awp",
	Tip = "Name: Sniper\nCost: $295.000\nDamage: 300\nAmmo: 20\nInfo: Spawns with you every round.\nWARNING!!: THIS IS BUGGED. DON'T BUY IT YET."
}
WeaponInfo[12] = {
	MDL = "models/weapons/w_grenade.mdl",
	Weapon = "weapon_frag",
	Tip = "Name: Grenade\nCost: $13.750\nDamage: 350\nAmmo: 3\nInfo: Spawns with you every round."
}
WeaponInfo[13] = {
	MDL = "models/weapons/w_crowbar.mdl",
	Weapon = "weapon_crowbar",
	Tip = "Name: Crowbar\nCost: $2.500\nDamage: None\nPurpose: You can use this to move your boat\nInfo: Spawns with you every round."
}
WeaponInfo[14] = {
	MDL = "models/weapons/w_stunbaton.mdl",
	Weapon = "weapon_stunstick",
	Tip = "Name: Repair-Stick\nCost: $8.500\nDamage: None, instead +6hp per hit\nUsage: 8$ per hit\nPurpose: You can use this to heal your props\nInfo: Spawns with you every round."
}