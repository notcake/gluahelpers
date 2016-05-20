self:CreateCommand ("UnconnectedCrash", "npc_thinknow", function (self)
	LocalPlayer ():ConCommand ("retry; wait 50; npc_thinknow")
end)