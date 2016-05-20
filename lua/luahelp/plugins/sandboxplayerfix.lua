timer.Create ("LuaHelp.AddSandboxPlayerFunctions", 0.1, 1, function ()
	local meta = FindMetaTable ("Player")
	if (!meta) then
		return
	end

	if !meta.GetWebsite then
		function meta:GetWebsite ()
			return self:GetNetworkedString ("Website", "N/A")
		end
	
		function meta:GetLocation ()
			return self:GetNetworkedString ("Location", "N/A")
		end
	
		function meta:GetEmail ()
			return self:GetNetworkedString ("Email", "N/A")
		end
	
		function meta:GetMSN ()
			return self:GetNetworkedString ("MSN", "N/A")
		end
	
		function meta:GetAIM ()
			return self:GetNetworkedString ("AIM", "N/A")
		end
	
		function meta:GetGTalk ()
			return self:GetNetworkedString ("GTalk", "N/A")
		end
	
		function meta:GetXFire ()
			return self:GetNetworkedString ("XFire", "N/A")
		end
	
		function meta:GetCount ()
			return 0
		end
	
		LuaHelp.LogLine ("Added sandbox functions to Player metatable.")
	end
end)