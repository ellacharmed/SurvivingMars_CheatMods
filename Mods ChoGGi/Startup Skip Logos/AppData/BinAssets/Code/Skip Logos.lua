-- Load mods in mainmenu
local load_mods = true
--~ local load_mods = false

-- Start in Load game dialog
--~ local load_dialog = true
local load_dialog = false

-- Enable disabled DLC
--~ local disabled_DLC = true
local disabled_DLC = false

-- Remove Missing Mods Msg on loading saves (Needs: load_mods = true)
local skip_missing_msg = true
--~ local skip_missing_msg = false

-- Disable gamepads
XInput.IsControllerConnected = empty_func

function OnMsg.DesktopCreated()

	-- Stop intro videos
	PlayInitialMovies = empty_func
	-- Get rid of mod manager warnings (not the reboot one though)
	ParadoxBuildsModManagerWarning = true
	-- Custom cursors in main menu
--~   MountFolder("UI/Cursors","AppData/Mods/Replace Cursors/Cursors/")

	if disabled_DLC then
		DLCConfigPreload = empty_func
	end

  CreateRealTimeThread(function()
		local WaitMsg = WaitMsg
		local Dialogs = Dialogs
		local table = table

		-- Wait for it (otherwise stuff below won't work right)
		while not Dialogs.PGMainMenu do
			WaitMsg("OnRender")
		end
		local Mods = Mods

		-- Library spacer for sort order in manager
		if Mods.ChoGGi_Library then
			Mods.ChoGGi_Library.title = " " .. Mods.ChoGGi_Library.title
		end

		-- Load mods
		if load_mods then
			-- Skip loading mods with assets in main menu to remove delay
			local asset_mods = {}
			local load_mods = AccountStorage.LoadMods or ""
			-- Going backwards to remove from list
			for i = #load_mods, 1, -1 do
				local mod_id = load_mods[i]
				local mod = Mods[mod_id]
				if mod and mod.bin_assets then
					asset_mods[#asset_mods+1] = mod_id
					table.remove(load_mods, i)
				end
			end

			-- Load mods
			ModsReloadItems()
			WaitMsg("OnRender")

			-- stops confirmation dialog about missing mods (still lets you know they're missing)
			if skip_missing_msg then
				function GetMissingMods()
					return "", false
				end
			end

			-- Add mods back to lists (local ModsLoaded here as it's false before)
 			local ModsLoaded = ModsLoaded
			for i = 1, #asset_mods do
				local mod_id = asset_mods[i]
				load_mods[#load_mods+1] = mod_id
				ModsLoaded[#ModsLoaded+1] = Mods[mod_id]
			end
		end

		if table.find(ModsLoaded, "id", "ChoGGi_CheatMenu") then
			-- Update cheat menu toolbar
			XShortcutsTarget:UpdateToolbar()
			-- Show cheat menu
			XShortcutsTarget:SetVisible(true)
		end

		-- Update my list of names
		if rawget(_G, "ChoGGi") and ChoGGi_Funcs.Common.RetName_Update then
			ChoGGi_Funcs.Common.RetName_Update()
		end

		-- Show load game dialog
		if load_dialog then
			Dialogs.PGMainMenu:SetMode("Load")
		end

--~ 		-- Remove the update news
--~ 		UIShowParadoxFeeds = empty_func
  end)

	-- Always random logo on load
	g_FirstLoadingScreen = false
	g_LoadingScreens = {
		"UI/SplashScreen.dds",
		"UI/LoadingScreens/002.tga",
		"UI/LoadingScreens/003.tga",
		"UI/LoadingScreens/004.tga",
		"UI/LoadingScreens/005.tga",
		"UI/LoadingScreens/006.tga",
		"UI/LoadingScreens/007.tga",
		"UI/LoadingScreens/008.tga",
		"UI/LoadingScreens/009.tga",
		"UI/LoadingScreens/010.tga",
		"UI/LoadingScreens/011.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_01_Worlds.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_02_Pillars.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_03_Picnic.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_04_StarLake.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_05_Fireworks.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_06_Rain.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_07_Pines.tga",
		"UI/LoadingScreens/GP_Green_Mars_Loading_Screen_08_Sand.tga",
		-- Doesn't show up, no dlc loaded before main menu?
--~ 		"UI/LoadingScreens/asteroid_01.tga",
--~ 		"UI/LoadingScreens/asteroid_02.tga",
--~ 		"UI/LoadingScreens/asteroid_03.tga",
--~ 		"UI/LoadingScreens/underground_01.tga",
--~ 		"UI/LoadingScreens/underground_02.tga",
--~ 		"UI/LoadingScreens/underground_03.tga",
	}

end
