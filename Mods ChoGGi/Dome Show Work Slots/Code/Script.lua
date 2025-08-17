-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
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

local ChoOrig_Dome_GetUISectionCitizensRollover = Dome.GetUISectionCitizensRollover
function Dome:GetUISectionCitizensRollover(...)
	if not mod_EnableMod then
		return ChoOrig_Dome_GetUISectionCitizensRollover(self, ...)
	end

	-- Get all work slots
	local work_slots = 0
	local objs = self.labels.Workplace or ""
	for i = 1, #objs do
		work_slots = work_slots + objs[i].max_workers
	end

	-- insert into rollover
	local ret = ChoOrig_Dome_GetUISectionCitizensRollover(self, ...)
	local list = ret[1]
	list.j = list.j + 1
	table.insert(list.table, 3, T{0000, "Total work slots<right><number>/<work(total)>",
		number = work_slots,
		total = work_slots * 3,
	})

	return ret
end
