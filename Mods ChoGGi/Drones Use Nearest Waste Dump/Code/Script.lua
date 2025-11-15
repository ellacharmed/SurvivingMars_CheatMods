-- See LICENSE for terms

local IsValid = IsValid
local FindNearestObject = FindNearestObject

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

local ChoOrig_TaskRequestHub_FindDemandRequest = TaskRequestHub.FindDemandRequest
function TaskRequestHub:FindDemandRequest(obj, resource, amount, ...)
	if not mod_EnableMod
		-- We only care about WasteRock
		or not obj or resource ~= "WasteRock"
	then
		return ChoOrig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	-- If it isn't a dumpsite abort
	local dropoff = obj.d_request and obj.d_request:GetBuilding()
	if IsValid(dropoff) and not dropoff:IsKindOf("WasteRockDumpSite") then
		return ChoOrig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	-- Ignore picked up from same obj
	local pickup_obj_bld = obj.picked_up_from_req and obj.picked_up_from_req:GetBuilding()
	if not IsValid(pickup_obj_bld) then
		pickup_obj_bld = nil
	end

	-- Filter hub list of connected buildings for dumpsite with free slots and storage space remaining
	local sites = GetRealm(self):MapFilter(self.connected_task_requesters, function(obj)
		return obj ~= pickup_obj_bld and obj.has_free_landing_slots
			and IsValid(obj) and obj:IsKindOf("WasteRockDumpSite")
			and (obj.max_amount_WasteRock - obj:GetStored_WasteRock()) >= amount
	end)

	-- not sure what happens when two drones go to the same site and one of them takes the last spot/fills it up?
	-- hopefully whatever happens happens lower then this :)

	-- no site means abort
	if #sites == 0 then
		return ChoOrig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	local nearest_obj = FindNearestObject(sites, obj)
	-- Doesn't hurt to check
	if not IsValid(nearest_obj) then
		return ChoOrig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	return nearest_obj.demand.WasteRock
end
