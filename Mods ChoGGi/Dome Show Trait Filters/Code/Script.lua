-- See LICENSE for terms

local next = next
local table = table
local T = T
local _InternalTranslate = _InternalTranslate
local CmpLower = CmpLower

local function SortName(a, b)
	return CmpLower(_InternalTranslate(a[1]), _InternalTranslate(b[1]))
end

local approve_image = T("<image UI/Icons/traits_approve.tga>")
local disapprove_image = T("\n\n<image UI/Icons/traits_disapprove.tga>")
local musthave_image = T("\n\n<image UI/Icons/traits_musthave.tga>")

local function UpdateCount(list, trait)
	if trait then
		list[#list+1] = T(trait.display_name)
	end
	return list
end

function Dome:ChoGGi_GetDomeTraitsRollover()
	if not next(self.traits_filter) then
		return ""
	end

	local approve = {approve_image}
	local disapprove = {disapprove_image}
	local musthave = {musthave_image}

	local TraitPresets = TraitPresets
	for id, filter in pairs(self.traits_filter) do
		-- 1 = up, -1000 = down, 1000000 = !
		if filter == 1 then
			approve = UpdateCount(approve, TraitPresets[id])
		elseif filter == -1000 then
			disapprove = UpdateCount(disapprove, TraitPresets[id])
		elseif filter == 1000000 then
			musthave = UpdateCount(musthave, TraitPresets[id])
		end
	end

	table.sort(approve, SortName)
	table.sort(disapprove, SortName)
	table.sort(musthave, SortName)

	return table.concat{
		T("\n\n"),
		table.concat(approve, ", "),
		table.concat(disapprove, ", "),
		table.concat(musthave, ", "),
	}
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionDome[1]
	if xtemplate.ChoGGi_GetDomeTraitsRollover then
		return
	end
	xtemplate.ChoGGi_GetDomeTraitsRollover = true

	local idx = table.find(xtemplate, "Icon", "UI/Icons/IPButtons/colonists_accept.tga")
	if not idx then
		return
	end

	xtemplate[idx].RolloverText = xtemplate[idx].RolloverText
		.. T("<ChoGGi_GetDomeTraitsRollover>")
end
