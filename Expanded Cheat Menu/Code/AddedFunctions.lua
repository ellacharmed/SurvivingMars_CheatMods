-- See LICENSE for terms

local ChoGGi_Funcs = ChoGGi_Funcs
local what_game = ChoGGi.what_game

-- add some shortened func names
dump = ChoGGi_Funcs.Common.Dump
dumplua = ChoGGi_Funcs.Common.DumpLua
dumptable = ChoGGi_Funcs.Common.DumpTable
MonitorFunc = ChoGGi_Funcs.Common.MonitorFunctionResults
--
function restart()
	quit("restart")
end
function delcls(cls)
	ChoGGi_Funcs.Common.DeleteObject(cls)
end
reboot = restart
exit = quit
mh = GetTerrainCursorObjSel -- returns selected obj under cursor
mhc = GetTerrainCursorObj -- returns obj under cursor
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = GetCursorWorldPos
cs = terminal.GetMousePos -- cursor pos on screen
s = false -- used to store SelectedObj
FlushLog = FlushLogFile -- easier to remember

if what_game == "Mars" or what_game == "MarsR" then
	local menu_id = "idMenuBar"
	local menu_func = "XShortcutsHost"
	if what_game == "MarsR" or what_game == "JA3" then
		menu_id = "idViewport"
		menu_func = "DeveloperInterface"
	end

	local func = _G[menu_func]
	-- add some simple functions to the cheatmenu for moving it/getting pos
	function func:SetPos(pt)
		-- doesn't "stick"
		self:SetBox(pt:x(), pt:y(), self.box:sizex(), self.box:sizey())
	end
	function func:GetPos()
		return ChoGGi_XWindow.GetPos(self, menu_id)
	end
	function func:GetSize()
		local GetSize = ChoGGi_XWindow.GetSize
		return GetSize(self, menu_id) + GetSize(self, "idBottomContainer")
	end

	local function DiscoverTech(tech_id)
		UIColony:SetTechDiscovered(tech_id)
	end
	DiscoverTech_Old = DiscoverTech

	-- for anyone still using it post-gagarin
	if not rawget(_G, "DiscoverTech") then
		_G.DiscoverTech = DiscoverTech
	end
	-- seems like a useful func to have
	if not Colonist.HasTrait then
		function Colonist:HasTrait(trait)
			if self.traits[trait] then
				return true
			end
		end
	end

end
