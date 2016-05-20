local DROUNDEDPROGRESSBAR = {}

function DROUNDEDPROGRESSBAR:Init ()
	self.ProgressValue = 0
	self.ShouldFade = false
	DPanel.Init (self)
end

function DROUNDEDPROGRESSBAR:GetShouldFade ()
	return self.ShouldFade
end

function DROUNDEDPROGRESSBAR:SetShouldFade (fade)
	self.ShouldFade = fade
end

function DROUNDEDPROGRESSBAR:Paint ()
	if self.ShouldFade then
		if self.ProgressValue < 1 then
			if self:GetAlpha () < 255 then
				local alpha = self:GetAlpha () + 50
				if alpha > 255 then
					alpha = 255
				end
				self:SetAlpha (alpha)
			end
		else
			if self:GetAlpha () > 0 then
				local alpha = self:GetAlpha () - 10
				if alpha < 0 then
					alpha = 0
				end
				self:SetAlpha (alpha)
			end
		end
	else
		if self:GetAlpha () < 255 then
			local alpha = self:GetAlpha () + 25
			if alpha > 255 then
				alpha = 255
			end
			self:SetAlpha (alpha)
		end
	end
	draw.RoundedBox (self:GetTall () / 4, 0, 0, self:GetWide (), self:GetTall (), Color (64, 64, 64, 255))
	draw.RoundedBox (self:GetTall () / 4, 1, 1, (self:GetWide () - 2) * self.ProgressValue, self:GetTall () - 2, Color (64, 64, 255, 255))
	return true
end

function DROUNDEDPROGRESSBAR:GetValue ()
	return self.ProgressValue
end

function DROUNDEDPROGRESSBAR:SetValue (value)
	if value > 1 then
		value = 1
	elseif value < 0 then
		value = 0
	end
	self.ProgressValue = value
end

function DROUNDEDPROGRESSBAR:GenerateExample (ClassName, PropertySheet, Width, Height)
	local ctrl = vgui.Create (ClassName)
	ctrl:SetValue (0.5)
	ctrl:SetSize (200, 16)

	PropertySheet:AddSheet (ClassName, ctrl, nil, true, true)
end

derma.DefineControl ("DRoundedProgressBar", "A rounded progress bar", DROUNDEDPROGRESSBAR, "DPanel")