NTLOBO = {} -- Neurotrauma Lobotomy
NTLOBO.Name="Lobotomy"
NTLOBO.Version = "A1.0.1"
NTLOBO.VersionNum = 010000101
NTLOBO.MinNTVersion = "A1.9.5h4"
NTLOBO.MinNTVersionNum = 01090504
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
		dofile(NTLOBO.Path.."/Lua/Scripts/Server/lobotomy_update.lua")
	end
		
		--client side scripts
	if CLIENT then
		dofile(NTLOBO.Path.."/Lua/Scripts/Client/effects.lua")
	end


	--robotrauma comp patch
	for package in ContentPackageManager.EnabledPackages.All do
			if 
				   tostring(package.UgcId) == "2948488019" --Robotrauma
				or tostring(package.UgcId) == "2952546076" --Robo-Trauma-
				or tostring(package.UgcId) == "3227815460" --Robotrauma (Afflictions Override)
			then
				if SERVER or (CLIENT and not Game.IsMultiplayer) then
					dofile(NTLOBO.Path.."/Lua/Scripts/Compatibility/robotrauma_comp.lua")
					print("NT Lobotomy - Robotrauma Integrated Compatibility Patch")
				end	
			break
		end
	end

end,1)


