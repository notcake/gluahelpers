// ulx_gun firing modes

local FireModes = {
	"Kick",
	"Ban",
	"Freeze",
	"Jail",
	"Mute",
	"Blind",
	"Ignite"
}

LuaHelp.EntityInfoPanelHooks.HookPopulateWeaponLines (function (self, entity, entityClass, weapon, weaponClass)
	if entityClass == "player" then
		if weaponClass == "ulx_gun" then
			local Mode = entity:GetNetworkedInt ("FireMode")
			local desc = FireModes [Mode]
			if desc then
				self:AddLine ("ULX Gun Mode: " .. desc)
			end
		end
	end
end)