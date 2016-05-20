timer.Create ("DImageButtonPlus", 0.01, 1, function ()
	if !DImageButton.OldInit then
		DImageButton.OldInit = DImageButton.Init
	end
	
	function DImageButton:Init ()
		self.IsMouseOver = false
		self.IsShiny = false
		self:OldInit ()
		self.m_Image.Rotation = 0
		function self.m_Image:Paint ()
			self:LoadMaterial ()
			local Mat = self:GetMaterial ()
			if !Mat then
				return true
			end
			surface.SetMaterial (Mat)
			surface.SetDrawColor (self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
			if self:GetKeepAspect () then
				local w = self.ActualWidth
				local h = self.ActualHeight
				// Image is bigger than panel, shrink to suitable size
				if w > self:GetWide () and h > self:GetTall () then
					if w > self:GetWide () then
						local diff = self:GetWide () / w
						w = w * diff
						h = h * diff
       	 	                end
					if h > self:GetTall () then
						local diff = self:GetTall () / h
						w = w * diff
						h = h * diff
					end
				end
				if w < self:GetWide () then
					local diff = self:GetWide () / w
					w = w * diff
					h = h * diff
				end
				if h < self:GetTall () then
					local diff = self:GetTall () / h
					w = w * diff
					h = h * diff
				end
				local OffX = (self:GetWide () - w) * 0.5
				local OffY = (self:GetTall () - h) * 0.5
				surface.DrawTexturedRectRotated (OffX + self:GetWide () * 0.5, OffY + self:GetTall () * 0.5, w, h, -self.Rotation)
				return true
			end
			surface.DrawTexturedRectRotated (0 + self:GetWide () * 0.5, 0 + self:GetTall () * 0.5, self:GetWide (), self:GetTall (), -self.Rotation)
			return true
		end

		if !self.OldThink then
			self.OldThink = DImageButton.Think
			if !self.OldThink then
				function self:OldThink ()
				end
			end
		end
	
		function self:Think ()
			if self.IsShiny then
				if self.IsMouseOver then
					self.m_Image:SetImageColor (Color (255, 255, 255, 255))
				else
					self.m_Image:SetImageColor (Color (228, 228, 228, 255))
				end
				if self:IsDown () then
					self.m_Image:SetImageColor (Color (172, 172, 172, 255))
				end
			end
			self:OldThink ()
		end
	
		if !self.OldOnMousePressed then
			self.OldOnMousePressed = self.OnMousePressed
		end
	
		function self:OnMousePressed (mousecode)
			local x, y = self.m_Image:GetPos ()
			local w, h = self.m_Image:GetSize ()
			self:OldOnMousePressed (mousecode)
			if self.IsShiny then
				self.m_Image:SetPos (x, y)
				self.m_Image:SetSize (w, h)
			end
		end

		if !self.OldOnMouseReleased then
			self.OldOnMouseReleased = DImageButton.OnMouseReleased
		end
	
		function self:OnMouseReleased (mousecode)
			local x, y = self.m_Image:GetPos ()
			local w, h = self.m_Image:GetSize ()
			self:OldOnMouseReleased (mousecode)
			if self.IsShiny then
				self.m_Image:SetPos (x, y)
				self.m_Image:SetSize (w, h)
			end
		end
	end
	
	function DImageButton:IsMouseOver ()
		return self.IsMouseOver
	end
	
	function DImageButton:GetRotation ()
		return self.m_Image.Rotation
	end
	
	function DImageButton:SetRotation (rotation)
		self.m_Image.Rotation = rotation
	end
	
	function DImageButton:GetIsShiny ()
		return self.IsShiny
	end
	
	function DImageButton:SetIsShiny (isShiny)
		self.IsShiny = isShiny
	end
	
	function DImageButton:OnCursorEntered ()
		self.IsMouseOver = true
	end
	
	function DImageButton:OnCursorExited ()
		self.IsMouseOver = false
	end
end)