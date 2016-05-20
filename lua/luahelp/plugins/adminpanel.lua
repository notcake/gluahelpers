concommand.Add ("luahelp_unlockadminpanel", function ()
	function PlayerMenu ()
		if MENU.HAHA then
			MENU.HAHA:SetSize (10, 10)
			MENU.HAHA:SetVisible (false)
			MENU.HAHA:SetText ("You are not an admin.")
			MENU.HAHA.DoClick = function ()
				Msg ("Console command blocked.\n")
			end
			MENU.HAHA:Remove ()
		end
	end
	if MENU then
		if MENU.HAHA then
			MENU.HAHA:SetVisible (false)
		end
		if !MENU.PlayerList then
			MENU.PlayerList = vgui.Create ("DComboBox")
			MENU.PlayerList:SetParent (MENU.AdminBackground)
			MENU.PlayerList:SetPos (0, 0)
			MENU.PlayerList:SetSize (MENU.AdminBackground:GetWide () * .333, 225)
			MENU.PlayerList:SetMultiple (false) // Don't use this unless you know extensive knowledge about tables
			ResetPList ()
		end

		if !MENU.Kick then
			MENU.Kick = vgui.Create ("DButton")
			MENU.Kick:SetParent (MENU.AdminBackground) // Set parent to our "DermaPanel"
			MENU.Kick:SetText ("Change to")
			MENU.Kick:SetPos (((MENU.AdminBackground:GetWide () * .333) + 5), 0)
			MENU.Kick:SetSize (((MENU.AdminBackground:GetWide () * .333) - 5), 50)
			MENU.Kick.DoClick = function ()
				local Value = MENU.PlayerList:GetSelectedItems () [1]
				if Value != nil && Value != NULL && Value != "" then
					print (Value:GetValue ())
					--if Value:GetValue () == "fm_fishtank" then
						RunConsoleCommand ("CT_ChgTo", Value:GetValue ()) --LocalPlayer ():GetName ()
					--end
					--RunConsoleCommand ("FM_Kick", Value:GetValue ())
					--local PlayerLeft = Value:GetValue ()
					--ResetPList (PlayerLeft)
				else
					print ("No player selected!")
				end
			end
		end
	else
		Msg ("GameMaestro.net admin panel not detected.\n")
	end
end)