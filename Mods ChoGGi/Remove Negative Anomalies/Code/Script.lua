-- See LICENSE for terms

local mod_EnableMod

local scenarios = {
	["Dust Devil"] = true,
	["Crust Fault"] = true,
}

local function RemoveAnomalies(label)
	for i = #(label or ""), 1, -1 do
		local obj = label[i]
		if scenarios[obj.sequence] then
			obj:delete()
		end
	end
end

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	local labels = MainCity.labels
	RemoveAnomalies(labels.Anomaly)
	RemoveAnomalies(labels.SubsurfaceAnomalyMarker)
end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not GameMaps then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
