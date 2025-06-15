return PlaceObj("ModDef", {
	"title", "Camera Change Settings",
	"id", "ChoGGi_CameraChangeSettings",
	"steam_id", "2219393389",
	"pops_any_uuid", "f3ac3900-6dce-4db1-8bb4-3d1abdea4b8e",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"description", [[
Adjust camera settings: Rotation/move speed, zoom level, border scroll size.


Mod options:
Rotate Speed/Up Down Speed/Move Speed: How fast the camera moves when holding down middle mouse and pressing Up/Down/Left/Right.
Max Zoom: How far you can zoom out (in thousands).
Max Height: How far you can move the camera above buildings (bird's-eye).
Scroll Border: Size of camera scroll border (when mouse is near edge).


Known Issues:
Games will be saved zoomed in from max zoom.


Partially requested by Arthurdubya.
]],
})
