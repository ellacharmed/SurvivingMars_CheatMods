### Msgs

Each OnMsg you declare is added to a list, and fired in that order when the Msg happens.

##### Do something when a Msg() is fired
```lua
local function somefunc(params)
	print("game is loaded", params)
end

-- you can either do it this way
function OnMsg.LoadGame(arg1, arg2)
	somefunc(arg1, arg2)
end
-- or this
OnMsg.LoadGame = somefunc

-- they'll both work the same, but the second one only has to do one function call instead of two.
```

##### Fire your own custom Msg
```lua
Msg("CustomMsgBlahBlah", arg1, arg2, etc)
```

##### Waiting for a msg (game time doesn't run when paused, real always runs
```lua
CreateGameTimeThread(function() -- or RealTime
	while true do
		WaitMsg("OnRender")
		print("scene render update")
	end
end)
```

##### A realtime loop that pauses.
```lua
CreateRealTimeThread(function()
	while true do
		if UISpeedState == "pause" then
			WaitMsg("MarsResume")
		end
		print("not paused")
	end
end)
```

##### Values passed with the Msg() can be edited along the way of each OnMsg
###### In-game example
```
function ConstructionCost:GetConstructionCost(building, resource, modifier_obj)
	-- snipped

	local mod = {
		percent = percent_modifier,
		amount = amount_modifier,
	}
	Msg("ModifyConstructionCost", building_name, resource, mod)

	return MulDivRound(value, mod.percent, 100) + mod.amount
end


function OnMsg.ModifyConstructionCost(building_name, resource, mod)
	if OpenAirBuildings then
		local class_name = (BuildingTemplates[building_name] or empty_table).template_class or building_name
		if IsKindOf(g_Classes[class_name], "OpenAirBuilding") then
			mod.percent = mod.percent - const.Terraforming.OpenDome_CostReduction
		end
	end
end
```


##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs.
###### You need ECM for OpenExamine.
```lua
OpenExamine(GetHandledMsg(true))
```

##### Show a list of functions in the order they will be called when an OnMsg is fired.
###### ECM needs the HelperMod installed to do this.
```lua
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
OpenExamine(v)
```

##### Print Msgs in the console
[OnMsg Print](https://steamcommunity.com/sharedfiles/filedetails/?id=1604230467)
