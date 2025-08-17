NTLOBO = {} -- Neurotrauma Lobotomy
NTLOBO.Name = "Lobotomy"
NTLOBO.Version = "A1.1.0"
NTLOBO.VersionNum = 010100000
NTLOBO.MinNTVersion = "A1.9.5h4"
NTLOBO.MinNTVersionNum = 01090504
NTLOBO.Path = table.pack(...)[1]
Timer.Wait(function()
	if NTC ~= nil then
		NTC.RegisterExpansion(NTLOBO)
	end
end, 1)

Timer.Wait(function()
	if SERVER and NTC == nil then --checks if NT is installed
		print("Error loading NT Lobotomy: It seems Neurotrauma isn't loaded!")
		return
	end

	--server side scripts
	if SERVER or (CLIENT and not Game.IsMultiplayer) then
		dofile(NTLOBO.Path .. "/Lua/Scripts/Server/surgery.lua")
		dofile(NTLOBO.Path .. "/Lua/Scripts/Compatibility/robotrauma_comp.lua") --robotrauma compatibility patch
	end
end, 1)
