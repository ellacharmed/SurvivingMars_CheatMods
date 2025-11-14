-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return
end

local GetStandingText = GetStandingText
local Max = Max
local T = T
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate

local mod_ShowNotification
local mod_MinStanding
local mod_SingleUnits
local mod_SingleUnitsSols

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowNotification = CurrentModOptions:GetProperty("ShowNotification")
	mod_MinStanding = CurrentModOptions:GetProperty("MinStanding")
	mod_SingleUnits = CurrentModOptions:GetProperty("SingleUnits")
	mod_SingleUnitsSols = CurrentModOptions:GetProperty("SingleUnitsSols")
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local buildings = {}
local standings_prev = {}

function OnMsg.ModsReloaded()
--~ ex(buildings)
--~ ex(standings_prev)

	ModOptions() --?

-- build a list of locked buildings (we do it in ModsReloaded for any changed by mods)
	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates

	for id, bld in pairs(BuildingTemplates) do
		for i = 1, 3 do
			local name = "sponsor_name" .. i
			local spons = bld[name]
			if spons ~= "" then
				-- add a table for each sponsor
				if not buildings[spons] then
					buildings[spons] = {}
				end
				-- and add the building id
				if not buildings[spons][id] then
					-- paradox spon disables regular shuttlehub
					buildings[spons][id] = {
						bld.sponsor_status1 ~= "disabled" and bld.sponsor_status1 or false,
						bld.sponsor_status2 ~= "disabled" and bld.sponsor_status2 or false,
						bld.sponsor_status3 ~= "disabled" and bld.sponsor_status3 or false,
					}
				end
			end
		end

		local name = id
		if name:find("RC") and name:find("Building") then
			name = name:gsub("Building", "")
		end
		local reqs = BuildingTechRequirements[id]
		local idx = table.find(reqs, "check_supply", name)
		if idx then
			table.remove(reqs, idx)
		end

	end
end

--~ -- Set what shows up in resupply dialog (rockets)
--~ local function UpdateCargoDef(bld_id)
--~ 	-- Strip off "Building" from id
--~ 	if bld_id:sub(1, 2) == "RC" then
--~ 		bld_id = bld_id:sub(1 , -9)
--~ 	end

--~ 	local defs = ResupplyItemDefinitions
--~ 	local idx = table.find(defs, "id", bld_id)
--~ 	if idx then
--~ 		defs[idx].locked = false
--~ 	end

--~ end


GlobalVar("ChoGGi_StandingUnlocksSponsorBuildings_Sols", 0)

-- Mr. Burns
local excel = 61

local function UpdateStanding(is_newsol)
	local add_prefab
	if is_newsol then
		local sols = ChoGGi_StandingUnlocksSponsorBuildings_Sols + 1
		if sols >= mod_SingleUnitsSols then
			add_prefab = true
			-- reset for next count
			ChoGGi_StandingUnlocksSponsorBuildings_Sols = 0
		else
			ChoGGi_StandingUnlocksSponsorBuildings_Sols = sols
		end
	end

	-- show standings msg
	local show_standings = false
	local show_prefab = false

	local RivalAIs = RivalAIs
	local BuildingTemplates = BuildingTemplates
	for id, rival in pairs(RivalAIs) do
		-- there's none locked to it, then nothing to do
		local rival_bld = buildings[id]
		if not rival_bld then
			goto continue
		end

		-- are we showing standing msg?
		local standing_curr = rival.resources.standing
		-- check if old and new standing are diff
		if mod_ShowNotification then
			local standing_prev = standings_prev[id]
			if standing_prev
				and (standing_prev >= excel and standing_curr < excel
				or standing_prev < excel and standing_curr >= excel)
			then
				show_standings = true
			end
			-- update old standing
			standings_prev[id] = standing_curr
		end

		--  61 for excellent
		local standing_excel = standing_curr >= mod_MinStanding

		for bld_id, list in pairs(rival_bld) do
			if mod_SingleUnits then
				if standing_excel then
					if show_prefab then
						show_prefab[#show_prefab+1] = bld_id
					else
						show_prefab = {bld_id}
					end
					MainCity:AddPrefabs(bld_id, 1)
				end
			else
				-- not sure why they added three sponsors (when they only use one) so we'll just be lazy
				for i = 1, 3 do
					if standing_excel then
						-- Set what shows up in resupply dialog (rockets)
--~ 						UpdateCargoDef(bld_id)
						-- Strip off "Building" from id
						if bld_id:sub(1, 2) == "RC" then
							bld_id = bld_id:sub(1 , -9)
						end

						local defs = ResupplyItemDefinitions
						local idx = table.find(defs, "id", bld_id)
						if idx then
							defs[idx].locked = false
						end

						BuildingTemplates[bld_id]["sponsor_status" .. i] = false
					else
						BuildingTemplates[bld_id]["sponsor_status" .. i] = list[i]
					end
				end -- for i=1

			end -- if mod_SingleUnits

		end -- for bld_id
		--
		::continue::
	end

	if not mod_ShowNotification then
		return
	end

	if show_prefab then
		ChoGGi_Funcs.Common.MsgPopup(
			table.concat(show_prefab, ", "),
			T(0000, "Added Prefab")
		)
	end

	if not show_standings then
		return
	end

	-- build list of changed standings and display msg
	local standing_msg = {}
	local c = 0
	for _, rival in pairs(RivalAIs) do
		local standing = rival.resources.standing
		c = c + 1
		standing_msg[c] = T{302535920011562, "<name>: <stand_text>",
			name = rival.display_name,
			stand_text = T{11538, "<standing> (<clamped_number>)",
				standing = GetStandingText(standing),
				clamped_number = Max(standing, -100),
			},
		}
	end

	-- sort by rival name
	table.sort(standing_msg, function(a, b)
		return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
	end)

	ChoGGi_Funcs.Common.MsgPopup(
		table.concat(standing_msg, ", "),
		T(302535920011561, "Colony Standing"),
		{size = true}
	)
end

OnMsg.CityStart = UpdateStanding
OnMsg.LoadGame = UpdateStanding
--~ OnMsg.NewDay = UpdateStanding
function OnMsg.NewDay()
	UpdateStanding("new_sol")
end
