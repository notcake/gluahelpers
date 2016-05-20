-- (Wired) Keypads

local X = -50
local Y = -100
local W = 100
local H = 200
local KeypadKeyPos =	{
							{X + 5, Y + 100, 25, 25, -2.2, 3.45, 1.3, -0},
							{X + 37.5, Y + 100, 25, 25, -0.6, 1.85, 1.3, -0},
							{X + 70, Y + 100, 25, 25, 1.0, 0.25, 1.3, -0},
							
							{X + 5, Y + 132.5, 25, 25, -2.2, 3.45, 2.9, -1.6},
							{X + 37.5, Y + 132.5, 25, 25, -0.6, 1.85, 2.9, -1.6},
							{X + 70, Y + 132.5, 25, 25, 1.0, 0.25, 2.9, -1.6},
							
							{X + 5, Y + 165, 25, 25, -2.2, 3.45, 4.55, -3.3},
							{X + 37.5, Y + 165, 25, 25, -0.6, 1.85, 4.55, -3.3},
							{X + 70, Y + 165, 25, 25, 1.0, 0.25, 4.55, -3.3},
							
							{X + 5, Y + 67.5, 40, 25, -2.2, 4.25, -0.3, 1.6},
							{X + 55, Y + 67.5, 40, 25, 0.3, 1.65, -0.3, 1.6}
						}

LuaHelp.EntityInfoPanelHooks.HookInit (function (self)
	if not self.KeypadPasswords then
		self.KeypadPasswords = {}
		self.KeypadPassword = ""
		self.KeypadPasswordLength = 0
	end

	function self:AddCurrentKeypadPassword ()
		self:AddKeypadPassword (self.KeypadPassword)
	end

	function self:AddKeypadPassword (password)
		if password ~= "" and
		   password ~= "0" and
		   password ~= "?" and
		   password ~= "??" and
		   password ~= "???" and 
		   password ~= "????" then
			self.KeypadPasswords [password] = true
		end
	end

end)

LuaHelp.EntityInfoPanelHooks.HookOnEntityChangedAway (function (self, oldEntity, oldEntityClass, newEntity, newEntityClass)
	if oldEntityClass == "sent_keypad" or
	    oldEntityClass == "sent_keypad_wire" then
		self:AddCurrentKeypadPassword ()
		self.KeypadPasswordLength = 0
		self.KeypadPassword = ""
	end
end)

LuaHelp.EntityInfoPanelHooks.HookOnEntityChangedTo (function (self, oldEntity, oldEntityClass, newEntity, newEntityClass)
	if newEntityClass == "sent_keypad" or
	   newEntityClass == "sent_keypad_wire" then
		if newEntity:GetNetworkedBool ("keypad_secure") then
			for i = 0, math.log10 (newEntity:GetNetworkedInt ("keypad_num")) do
				self.KeypadPassword = self.KeypadPassword .. "?"
			end
		else
			self.KeypadPassword = tostring (newEntity:GetNetworkedInt ("keypad_num"))
		end
		if newEntity:GetNetworkedInt ("keypad_num") == 0 then
			self.KeypadPassword = ""
		end
		self.KeypadPasswordLength = string.len (self.KeypadPassword)
	end
end)

LuaHelp.EntityInfoPanelHooks.HookPopulateLines (function (self, entity, entityClass)
	if entityClass == "sent_keypad" or
	   entityClass == "sent_keypad_wire" then
		-- Check if new keys have been entered
		local newlen = math.log10 (entity:GetNetworkedInt ("keypad_num")) + 1
		if entity:GetNetworkedInt ("keypad_num") == 0 then
			newlen = 0
		end
		if newlen > self.KeypadPasswordLength then
			if entity:GetNetworkedBool ("keypad_secure") then
				for i = 1, newlen - self.KeypadPasswordLength - 1 do
					self.KeypadPassword = self.KeypadPassword .. "?"
				end
				self.KeypadPasswordLength = newlen
				local digit = "?"
				local number = 0
				local players = ents.FindByClass ("player")
				for _, v in pairs (players) do
					local skip = false
					if not skip then
						ply = v
						if (ply:GetShootPos () - entity:GetPos ()):Length () > 50 then
							skip = true
						end
					end
					if not skip then
						local t = {}
						t.start = ply:GetShootPos ()
						t.endpos = ply:GetAimVector () * 50 + t.start
						t.filter = ply
						local tr = util.TraceLine (t)
						if tr.Entity ~= entity then
							skip = true
						end
						if not skip then
							local pos = entity:WorldToLocal (tr.HitPos)
							for k,v in pairs (KeypadKeyPos) do
								local text = k
								local textx = v [1] + 9
								local texty = v [2] + 4
								local x = (pos.y - v [5]) / (v [5] + v [6])
								local y = 1 - (pos.z + v [7]) / (v [7] + v [8])
								if x >= 0 and y >= 0 and x <= 1 and y <= 1 then
									if k <= 9 then
										number = k
									end
								end
							end
						end
					end
				end
				if number ~= 0 then
					digit = tostring (number)
				end
				self.KeypadPassword = self.KeypadPassword .. digit
			else
				self.KeypadPassword = tostring (entity:GetNetworkedInt ("keypad_num"))
			end
			self.KeypadPasswordLength = newlen
		elseif newlen < self.KeypadPasswordLength then
			self:AddCurrentKeypadPassword ()
			self.KeypadPasswordLength = newlen
			if entity:GetNetworkedBool ("keypad_secure") then
				self.KeypadPassword = ""
				for i = 1, self.KeypadPasswordLength do
					self.KeypadPassword = self.KeypadPassword .. "?"
				end
			else
				self.KeypadPassword = tostring (entity:GetNetworkedInt ("keypad_num"))
				if newlen == 0 then
					self.KeypadPassword = ""
				end
			end
		end
		self:AddLine ("Keypad Code Entered: " .. self.KeypadPassword)
		if entity:GetNetworkedEntity ("keypad_owner"):IsValid () then
			self:AddLine ("Keypad Owner Current Code: " .. entity:GetNetworkedEntity ("keypad_owner"):GetInfo ("keypad_adv_password"))
		end
		local passwords = ""
		local codecount = 0
		for k, _ in pairs (self.KeypadPasswords) do
			if codecount > 0 then
				passwords = passwords .. ", " .. k
			else
				passwords = k
			end
			codecount = codecount + 1
			if codecount == 5 then
				self:AddLine ("Keypad Codes: " .. passwords)
				passwords = ""
				codecount = 0
			end
		end
		if codecount > 0 then
			self:AddLine ("Keypad Codes: " .. passwords)
		end
	end
end)