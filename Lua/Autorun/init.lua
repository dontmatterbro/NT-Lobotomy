NTLOBO = {} -- Neurotrauma Lobotomy
NTLOBO.Name="Lobotomy"
NTLOBO.Version = "A1.0.0"
NTLOBO.VersionNum = 010000000
NTLOBO.MinNTVersion = "A1.9.4h1"
NTLOBO.MinNTVersionNum = 01090401
NTLOBO.Path = table.pack(...)[1]
Timer.Wait(function() if NTC ~= nil then NTC.RegisterExpansion(NTLOBO) end end,1)


Timer.Wait(function() 
	if SERVER and NTC == nil then --checks if NT is installed
		print("Error loading NT Lobotomy: It seems Neurotrauma isn't loaded!")
		return
	end
	
		--server side scripts
	if SERVER or (CLIENT and not Game.IsMultiplayer) then
		dofile(NTLOBO.Path.."/Lua/Scripts/Server/surgery.lua")
	end
		
		--client side scripts
	if CLIENT then
		dofile(NTLOBO.Path.."/Lua/Scripts/Server/effects.lua")
	end


		--biscripts
		
		


end,1)


