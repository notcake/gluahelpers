LuaHelp.EntityInfoPanelHooks.HookPopulateWeaponLines (function (self, entity, entityClass, weapon, weaponClass)
	if entityClass == "gmod_wire_textscreen" then
		self:AddLine ("Text: " .. entity.text)
	end
end)