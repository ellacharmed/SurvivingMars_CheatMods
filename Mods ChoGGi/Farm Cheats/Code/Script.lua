-- See LICENSE for terms

local ToggleWorking = ChoGGi_Funcs.Common.ToggleWorking

local mod_EnableMod
local mod_CropsNeverFail
local mod_ConstantSoilQuality
local mod_MechFarming
local mod_MechPerformance
local mod_StorageSpace
local mod_Farms
local mod_FungalFarms
local mod_HydroponicFarms

local function UpdateProducer(obj)
	local max_z = (mod_StorageSpace / const.ResourceScale) / 4
	obj.stock_max = mod_StorageSpace
	obj.max_storage = mod_StorageSpace
	-- visual cube bump
	for i = 1, #obj.stockpiles do
		local stock = obj.stockpiles[i]
		stock.max_z = max_z
	end
end

local function UpdateFarm(obj, farm_cls)
	if farm_cls ~= "FungalFarm" and mod_ConstantSoilQuality > 0 and not obj.hydroponic then
		-- 0 because it doesn't matter (see func below)
		obj:SetSoilQuality(0)
	end

	if mod_MechFarming then
		obj.max_workers = 0
		obj.automation = 1
		obj.auto_performance = mod_MechPerformance or 100
		ToggleWorking(obj)
	else
		obj.max_workers = nil
		obj.automation = nil
		obj.auto_performance = nil
	end

	if mod_StorageSpace > 0 then
		obj.max_storage = mod_StorageSpace
		UpdateProducer(obj:GetProducerObj())
	end

	ToggleWorking(obj)
end

local function UpdateFarmsLoop(farm_cls)
	local objs = ChoGGi_Funcs.Common.GetCityLabels(farm_cls)
	for i = 1, #objs do
		UpdateFarm(objs[i], farm_cls)
	end
end

local function UpdateFarms()
	if not mod_EnableMod then
		return
	end

	if mod_Farms then
		UpdateFarmsLoop("Farm")
	end
	if mod_HydroponicFarms then
		UpdateFarmsLoop("FarmHydroponic")
	end
	if mod_FungalFarms then
		UpdateFarmsLoop("FungalFarm")
	end
end
OnMsg.CityStart = UpdateFarms
OnMsg.LoadGame = UpdateFarms

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_CropsNeverFail = options:GetProperty("CropsNeverFail")
	mod_ConstantSoilQuality = options:GetProperty("ConstantSoilQuality") * const.SoilQualityScale
	mod_MechFarming = options:GetProperty("MechFarming")
	mod_MechPerformance = options:GetProperty("MechPerformance")
	mod_StorageSpace = options:GetProperty("StorageSpace") * const.ResourceScale
	mod_Farms = options:GetProperty("Farms")
	mod_FungalFarms = options:GetProperty("FungalFarms")
	mod_HydroponicFarms = options:GetProperty("HydroponicFarms")

	if mod_StorageSpace > 0 then
		if mod_Farms then
			ChoGGi_Funcs.Common.SetBuildingTemplates("Farm", "max_storage1", mod_StorageSpace)
		end
		if mod_FungalFarms then
			ChoGGi_Funcs.Common.SetBuildingTemplates("FungalFarm", "max_storage1", mod_StorageSpace)
		end
		if mod_HydroponicFarms then
			ChoGGi_Funcs.Common.SetBuildingTemplates("FarmHydroponic", "max_storage1", mod_StorageSpace)
		end
	end

	-- make sure we're in-game
	if not GameMaps then
		return
	end

	UpdateFarms()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function FarmCheck(obj)
	if mod_Farms and obj:IsKindOf("Farm")
		or mod_FungalFarms and obj:IsKindOf("FungalFarm")
		or mod_HydroponicFarms and obj:IsKindOf("FarmHydroponic")
	then
		return true
	end
end

local ChoOrig_Farm_CalcExpectedProduction = Farm.CalcExpectedProduction
function Farm:CalcExpectedProduction(idx, ...)
	if not mod_EnableMod or not FarmCheck(self) then
		return ChoOrig_Farm_CalcExpectedProduction(self, idx, ...)
	end

	local amount = ChoOrig_Farm_CalcExpectedProduction(self, idx, ...)

	if mod_CropsNeverFail and amount == 0 then
		-- check if there's a crop and abort if not
		idx = idx or self.current_crop
		local crop = self.selected_crop[idx]
		crop = crop and CropPresets[crop]
		if not crop then
			return 0
		end
		-- there's a crop so ignore the fail and give 'em something
		local output = (self.city or UICity):Random(crop.FoodOutput)
		if output < 1001 then
			output = 1000
		end

		return output
	end

	return amount
end

local ChoOrig_Farm_SetSoilQuality = Farm.SetSoilQuality
function Farm:SetSoilQuality(value, ...)
	if not mod_EnableMod or not FarmCheck(self) then
		return ChoOrig_Farm_SetSoilQuality(self, value, ...)
	end

	if mod_ConstantSoilQuality > 0 then
		value = mod_ConstantSoilQuality
	end

	return ChoOrig_Farm_SetSoilQuality(self, value, ...)
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_Farm_InstantHarvest", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_Farm_InstantHarvest",
		"ChoGGi_Template_Farm_InstantHarvest", true,
		"__context_of_kind", "Farm",
		-- main button
		"__template", "InfopanelButton",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and FarmCheck(context)
		end,

		"Title", T(302535920011849, "Quick Harvest"),
		"RolloverTitle", T(302535920011849, "Quick Harvest"),
		"RolloverText", T(302535920011850, "Quickly harvest current crop."),
		"Icon", "UI/Icons/IPButtons/unload.tga",

		"OnPress", function (self)
			local context = self.context
			-- change growth time to now
			context.harvest_planted_time = -max_int

			-- force an update instead of waiting
			context:BuildingUpdate()

			ObjModified(context)
		end,
	})

end

function OnMsg.BuildingInit(obj)
	if not mod_EnableMod or not FarmCheck(obj) then
		return
	end

	UpdateFarm(obj)
end
