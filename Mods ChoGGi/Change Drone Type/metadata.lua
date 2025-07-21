return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 8,
		}),
	},
	"title", "Change Drone Type",
	"id", "ChoGGi_ChangeDroneType",
	"steam_id", "1592984375",
	"pops_any_uuid", "0d35f043-f2eb-4f38-ac2c-12459370a41c",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds a button to hubs and rovers that lets you switch between wasp (flying) and regular drones (global setting, not per building). You will need to repack/unpack to change them on current hubs.

This mod requires Space Race DLC.

Mod Options:
Martian Aerodynamics: Only show button when Martian Aerodynamics has been researched.
Always Wasp Drones: Forces drones to always be wasp drones (hides button).
]],
})
