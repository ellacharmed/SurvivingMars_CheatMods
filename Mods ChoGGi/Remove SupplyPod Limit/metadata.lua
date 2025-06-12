return PlaceObj("ModDef", {
	"title", "Remove SupplyPod Limit",
	"id", "ChoGGi_RemoveSupplyPodLimit",
	"steam_id", "2037219360",
	"pops_any_uuid", "b13bcfad-df78-47f5-8834-c991e2d25a86",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Remove limit for Rovers (1) Drones (8) on supply pods (and rockets).


Reload save to update ResupplyItemDefinitions if changing mod option to enable/disable.
]],
})
