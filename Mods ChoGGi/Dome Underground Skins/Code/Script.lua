-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

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

local underground_skins, underground_palettes

function OnMsg.ClassesPostprocess()
	local domebas = GetBuildingSkins("UndergroundDome")
	local domemed = GetBuildingSkins("UndergroundDomeMedium")
	local domemic = GetBuildingSkins("UndergroundDomeMicro")

	underground_skins = {
		DomeBasic = domebas[1],
		DomeMedium = domemed[1],
		DomeMicro = domemic[1],
	}

	underground_palettes = {
		DomeBasic = domebas[2],
		DomeMedium = domemed[2],
		DomeMicro = domemic[2],
	}
end

local domes = {
	DomeBasic = true,
	DomeMicro = true,
	DomeMedium = true,
}

local ChoOrig_Building_GetSkins = Building.GetSkins
function Building:GetSkins(...)
	local name = self.template_name

	if not mod_EnableMod or not domes[name] then
		return ChoOrig_Building_GetSkins(self, ...)
	end

	local skins, palettes = ChoOrig_Building_GetSkins(self, ...)
	skins[#skins+1] = underground_skins[name]
	palettes[#palettes+1] = underground_palettes[name]

	return skins, palettes
end
