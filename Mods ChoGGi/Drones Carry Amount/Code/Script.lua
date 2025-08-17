-- See LICENSE for terms

--[[
	If you assign more than one resource cube to be picked up
	the drones won't pick up any if that number isn't available for pickup
	try that breakthrough where they carry two, and get a depot (at a factory/mine/etc) with one resource left in i
	yes it took awhile to figure it out...
]]
local DronesPickupAmount = ChoGGi_Funcs.Common.DronesPickupAmount
local GetCityLabels = ChoGGi_Funcs.Common.GetCityLabels

local mod_EnableMod
local mod_CarryAmount
local mod_UseCarryAmount

local function StartupCode(tech_id)
	if not mod_EnableMod
		-- Waste of time if it isn't the right tech
		or tech_id and tech_id ~= "ArtificialMuscles"
	then
		return
	end

	-- get default (ArtificialMuscles is the only tech that changes it)
	local default_drone_amount = IsTechResearched("ArtificialMuscles") and 2 or 1

	local amount
	if mod_UseCarryAmount then
		if g_Consts.DroneResourceCarryAmount ~= mod_CarryAmount then
			amount = mod_CarryAmount
		end
	elseif g_Consts.DroneResourceCarryAmount ~= default_drone_amount then
		amount = default_drone_amount
	end

	ChoGGi_Funcs.Common.SetConsts("DroneResourceCarryAmount", amount)
	UpdateDroneResourceUnits()
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- Update amount if tech gets researched
OnMsg.TechResearched = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_CarryAmount = CurrentModOptions:GetProperty("CarryAmount")
	mod_UseCarryAmount = CurrentModOptions:GetProperty("UseCarryAmount")

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

function OnMsg.ClassesPostprocess()

	local ChoOrig_SingleResourceProducer_Produce = SingleResourceProducer.Produce
	function SingleResourceProducer:Produce(...)
		if not mod_EnableMod or ChoGGi.UserSettings.DroneResourceCarryAmountFix then
			return ChoOrig_SingleResourceProducer_Produce(self, ...)
		end

		-- Get them lazy drones working
		if self:GetStoredAmount() >= 1000 then
			DronesPickupAmount(self, "single")
		end

		-- Be on your way
		return ChoOrig_SingleResourceProducer_Produce(self, ...)
	end

end

-- Make them lazy drones stop abusing electricity (we need? to have an hourly update if people are using large prod amounts/low amount of drones)
function OnMsg.NewHour()
	-- If DroneResourceCarryAmountFix is true then ECM is doing the same
	if not mod_EnableMod or ChoGGi.UserSettings.DroneResourceCarryAmountFix then
		return
	end

	-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
	local objs = GetCityLabels("ResourceProducer")
	for i = 1, #objs do
		local prod = objs[i]
		-- most are fine with GetProducerObj, but some like water extractor don't have one
		local obj = prod:GetProducerObj() or prod
		if obj then
			local func = obj.GetStoredAmount and "GetStoredAmount" or obj.GetAmountStored and "GetAmountStored"
			if obj[func](obj) >= 1000 then
				DronesPickupAmount(obj)
			end
		end

		obj = prod.wasterock_producer
		if obj and obj:GetStoredAmount() >= 1000 then
			DronesPickupAmount(obj, "single")
		end
	end

	objs = GetCityLabels("BlackCubeStockpiles")
	for i = 1, #objs do
		local obj = objs[i]
		if obj:GetStoredAmount() >= 1000 then
			DronesPickupAmount(obj)
		end
	end
	--
end
