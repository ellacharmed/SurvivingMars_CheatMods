-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RemoveQuotes",
		"DisplayName", T(0000, "Remove Quotes"),
		"Help", T(0000, "Remove all quotes/flavour from tech info."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ElonMusk",
		"DisplayName", T(0000, "Elon Musk"),
		"Help", T(0000, "Replaces Elon Musk with Nwabudike Morgan."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "VladimirPutin",
		"DisplayName", T(0000, "Vladimir Putin"),
		"Help", T(0000, "Replaces Vladimir Putin with Sergei Korolev."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RonaldReagan",
		"DisplayName", T(0000, "Ronald Reagan"),
		"Help", T(0000, "Replaces Ronald Reagan with Jimmy Carter."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Vegans",
		"DisplayName", T(0000, "Vegans"),
		"Help", T(0000, "Replaces Vegans description with Wikipedia entry."),
		"DefaultValue", false,
	}),
}
