local KEYPADCRACKERPANEL = {}

function KEYPADCRACKERPANEL:Init ()
	self:SetTitle ("Keypad Cracker")

	self:SetSize (ScrW () * 0.2, ScrH () * 0.2)
	self:SetPos ((ScrW () - self:GetWide ()) / 2, (ScrH () - self:GetTall ()) / 2 + 0.6 * self:GetTall ())
	self:SetDeleteOnClose (false)
	self:SetSizable (true)
	self:MakePopup ()

	self.lblPassword = vgui.Create ("DLabel", self)
	self.lblPassword:SetTextColor (Color (255, 0, 0, 255))
	self.lblPassword:SetText ("0000")

	self.btnExit = vgui.Create ("DButton", self)
	self.btnExit:SetText ("Close")
	self.btnExit.DoClick = function (button)
		self:SetVisible (false)
	end

	self.btnDoCrack = vgui.Create ("DButton", self)
	self.btnDoCrack:SetText ("Begin Cracking")
	self.btnDoCrack:SetWide (self.btnDoCrack:GetWide () + 16)
	self.btnDoCrack:SetDisabled (true)
	self.btnDoCrack.DoClick = function (button)
		self:BeginCracking ()
	end

	self:SetVisible (false)

	self.RealThink = self.Think
	function self:Think ()
		self:DoThink ()
		self:RealThink ()
	end
end

function KEYPADCRACKERPANEL:PerformLayout ()
	local margins = 5
	self.lblPassword:Center ()
	self.btnDoCrack:SetPos (0 + margins, self:GetTall () - self.btnDoCrack:GetTall () - margins)
	self.btnExit:SetPos (self:GetWide () - self.btnExit:GetWide () - margins, self:GetTall () - self.btnExit:GetTall () - margins)
	DFrame.PerformLayout (self)
end

function KEYPADCRACKERPANEL:BeginCracking ()
	self.Cracking = true
	self.Succeeded = false
	self.CrackState = 0
	self.btnDoCrack:SetText ("End Cracking")
	self.btnDoCrack.DoClick = function (button)
		self:EndCracking()
	end
	self.Password = 0000
end

function KEYPADCRACKERPANEL:EndCracking ()
	self.Cracking = false
	self.CrackState = 0
	self.btnDoCrack:SetText ("Begin Cracking")
	self.btnDoCrack.DoClick = function (button)
		self:BeginCracking()
	end
end

function KEYPADCRACKERPANEL:DoThink ()
	if !self.Cracking then
		if !LocalPlayer () or !LocalPlayer ():IsValid () then
			return
		end
		local tr = util.TraceLine (util.GetPlayerTrace (LocalPlayer ()))
		if tr.HitNonWorld then
			if tr.Entity:IsValid () and !LocalPlayer ():InVehicle () then
				if tr.Entity:GetClass () == "sent_keypad" or
				    tr.Entity:GetClass () == "sent_keypad_wire" then
					self.Entity = tr.Entity
					self.btnDoCrack:SetDisabled (false)
				end
			end
		end
	else
		if !self.Entity or !self.Entity:IsValid () then
			self.btnDoCrack:SetDisabled (true)
			self:EndCracking ()
		end
		if !self.Cracking then
			return
		end
		local basecommand = "gmod_keypad"
		if self.Entity:GetClass () == "sent_keypad_wire" then
			basecommand = "gmod_keypadwire"
		end
		if self.CrackState == 0 then
			if self:NextCode () then
				self.lblPassword:SetText (tostring (self.Password))
				self.lblPassword:SetTextColor (Color (255, 0, 0, 255))
				RunConsoleCommand (basecommand, tostring (self.Entity:EntIndex()), tostring (self.Password))
				self.CrackState = self.CrackState + 1
			end
		elseif self.CrackState == 1 then
			if self.Entity:GetNetworkedInt ("keypad_num") != 0 then
				RunConsoleCommand (basecommand, tostring (self.Entity:EntIndex ()), "accept")
				self.CrackState = self.CrackState + 1
			end
		elseif self.CrackState == 2 then
			if self.Entity:GetNetworkedBool ("keypad_showaccess") then
				if self.Entity:GetNetworkedBool ("keypad_access") then
					LuaHelp.EntityInfoPanel:AddKeypadPassword (tostring (self.Password))
					self.lblPassword:SetTextColor (Color (0, 255, 0, 255))
					self:EndCracking ()
				end
				self.CrackState = self.CrackState + 1
			end
		elseif self.CrackState == 3 then
			RunConsoleCommand (basecommand, tostring (self.Entity:EntIndex ()), "reset")
			self.CrackState = self.CrackState + 1
		elseif self.CrackState == 4 then
			if self.Entity:GetNetworkedInt ("keypad_num") == 0 then
				self.CrackState = 0
			end
		end
	end
end

function KEYPADCRACKERPANEL:NextCode ()
	self.Password = self.Password + 1
	while string.find (tostring (self.Password), "0") do
		self.Password = self.Password + 1
	end
	if self.Password > 9999 then
		self.Cracking = false
		return 0
	end
	return 1
end

LuaHelp.AddInitHook (function ()
	vgui.Register ("LuaHelpKeypadCracker", KEYPADCRACKERPANEL, "DFrame")
	LuaHelp.KeypadCrackerPanel = vgui.Create ("LuaHelpKeypadCracker")
end)

LuaHelp.AddUninitHook (function ()
	if LuaHelp.KeypadCrackerPanel then
		LuaHelp.KeypadCrackerPanel:Remove ()
		LuaHelp.KeypadCrackerPanel = nil
	end
end)

LuaHelp.AddPopulateDebuggingCommandsHook (function (Panel)
	Panel:AddControl ("Button", {Text = "Keypad Cracker", Label = "Open Keypad Cracker", Command = "luahelp_openkeypadcracker"})
end)

concommand.Add ("luahelp_openkeypadcracker", function ()
	LuaHelp.KeypadCrackerPanel:SetVisible (true)
end)