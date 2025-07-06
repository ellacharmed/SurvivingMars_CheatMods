-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local rover_ents = {
	RoverBlueSunHarvester = true,
	RoverIndiaConstructor = true,
	RoverTransport = true,
}

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local realm = GetActiveRealm()

	-- Suspending speeds up deleting (among other actions, always good to use it for large operations)
	realm:SuspendPassEdits("ChoGGi.RemoveBlueYellowGridMarks.LoadGame")

	-- Blue/Yellow markers
	local objs = realm:MapGet(true, "GridTile", "GridTileWater", "RangeHexRadius", "RangeHexRadiusContainer", function(o)
		-- SkiRich's Toggle Work Zone
		if not o.ToggleWorkZone then
			return true
		end
	end)

	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	-- Remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	objs = realm:MapGet(true, "WireFramedPrettification", function(rover)
		return rover_ents[rover.entity or ""]
	end)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	realm:ResumePassEdits("ChoGGi.RemoveBlueYellowGridMarks.LoadGame")
end
