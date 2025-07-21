return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UseCarryAmount",
		"DisplayName", T(302535920011082, "Use Carry Amount"),
		"Help", T(0000, [[Turn on to use the "Carry Amount" instead of game amount.]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "CarryAmount",
		"DisplayName", T(302535920011083, "Carry Amount"),
		"Help", T(0000, "How many items can a drone carry."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
