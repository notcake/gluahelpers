timer.Simple (1, function ()
	for k, v in pairs (weapons.GetList ()) do
		if v.ClassName == "gmod_tool" then
			v.WorldModel = "models/weapons/w_toolgun.mdl"
			v.ViewModel = "models/weapons/v_toolgun.mdl"
		end
		if v.ClassName == "manhack_welder" then
			v.PrintName = "Manhack Welder"
		end
	end
end)