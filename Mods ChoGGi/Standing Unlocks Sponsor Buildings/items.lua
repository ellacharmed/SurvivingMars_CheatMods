-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowNotification",
		"DisplayName", T(302535920011558, "Show Notification"),
		"Help", T(302535920011559, "Show a notification when unlocked buildings have changed."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinStanding",
		"DisplayName", T(302535920011752, "Minimum Standing"),
		"Help", T(302535920011753, "Your standing needs to be at or above this to unlock buildings."),
		"DefaultValue", 61,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SingleUnits",
		"DisplayName", T(0000, "Single Units"),
		"Help", T(0000, "Instead of unlocking a building this will give a prefab when you reach it, and another one each 10 sols."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SingleUnitsSols",
		"DisplayName", T(0000, "Single Units Sols"),
		"Help", T(0000, "How many Sols to give a new building prefab."),
		"DefaultValue", 10,
		"MinValue", 1,
		"MaxValue", 100,
	}),
}
