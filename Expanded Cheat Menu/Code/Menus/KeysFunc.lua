-- See LICENSE for terms

local ChoGGi_Funcs = ChoGGi_Funcs

function ChoGGi_Funcs.Menus.ConsoleRestart()
	if ChoGGi.testing then
		quit("restart")
	end

	local dlgConsole = dlgConsole
	if ChoGGi_Funcs.Common.IsValidXWin(dlgConsole) then
		if not dlgConsole:GetVisible() then
			ShowConsole(true)
		end
		dlgConsole.idEdit:SetFocus()
		dlgConsole.idEdit:SetText("restart")
	end
end
