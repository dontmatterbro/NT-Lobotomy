NTLOBO.UpdateCooldown = 0
NTLOBO.UpdateInterval = 120
NTLOBO.Deltatime = NTLOBO.UpdateInterval/60 -- Time in seconds that transpires between updates

-- This Hook triggers NTLOBO.Update function.
Hook.Add("think", "NTLOBO.Update", function()
    if HF.GameIsPaused() or (not Level.Loaded) then return end

    NTLOBO.UpdateCooldown = NTLOBO.UpdateCooldown-1
    if (NTLOBO.UpdateCooldown <= 0) then
        NTLOBO.UpdateCooldown = NTLOBO.UpdateInterval
        NTLOBO.Update() 
    end
end)


--lobotomy tables
GoodLobotomyAfflictions = {
	
}	
	
BadLobotomyAfflictions = {
	"infinitepsychosis", "mute"
}


function NTLOBO.UpdateLobotomy(targetCharacter)

---------------------------------------------------------INITAL AFFLICTIONS-------------------------------------------------------
	if --nerve generation tick, (idk if there is a cooler way to do this)
		HF.HasAffliction(targetCharacter, "nervegeneration")
	then
		HF.AddAfflictionLimb(targetCharacter, "nervegeneration", 11, 5)
	end
	
	if --remove lobotomy
		HF.HasAffliction(targetCharacter, "nervegeneration", 100)
	then
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("nervegeneration", 1000)
		
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("lobotomyonce", 1000)
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("lobotomytwice", 1000)
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("lobotomythrice", 1000)
		
		for RemoveGoodLobotomy in GoodLobotomyAfflictions do
			targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs(RemoveGoodLobotomy, 1000)
		end
		
		for RemoveBadLobotomy in BadLobotomyAfflictions do
			targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs(RemoveBadLobotomy, 1000)
		end
	end

-------------------------------------------EFFECT AFFLICTIONS-----------------------------------------------------------
	
	if --infinite psychosis
		HF.HasAffliction(targetCharacter, "infinitepsychosis")
	then
		HF.AddAfflictionLimb(targetCharacter, "psychosis", 11, 100)
	end

	if --mute
		HF.HasAffliction(targetCharacter, "mute")
	then
		targetCharacter.CanSpeak=false
	end	
		

end


--lobotomize
function NTLOBO.ApplyLobotomy(targetCharacter, prevresult)
	local result=prevresult

	if --determine result if not already determined
		result==nil 
	then
		if 
			HF.Chance(0.07)
		then
			result="good"
		else
			result="bad"
		end
	end
	


	local BadLobotomy = BadLobotomyAfflictions[ math.random( #BadLobotomyAfflictions ) ]
	local GoodLobotomy = GoodLobotomyAfflictions[ math.random( #GoodLobotomyAfflictions ) ]


	if --give lobotomy
		result=="bad"
	then
		HF.AddAfflictionLimb(targetCharacter, BadLobotomy, 11, 3)
		print(BadLobotomy)
	else
		HF.AddAfflictionLimb(targetCharacter, GoodLobotomy, 11, 3)
		print(GoodLobotomy)
	end
		
	if --kill at 4th lobotomy
		HF.HasAffliction(targetCharacter, "lobotomythrice")
	then
		HF.AddAfflictionLimb(targetCharacter, "cerebralhypoxia", 11, 300)
	return end
		
	if --give third lobotomy affliction
		HF.HasAffliction(targetCharacter, "lobotomytwice")
	then
		HF.AddAfflictionLimb(targetCharacter, "lobotomythrice", 11, 3)
		
		if 
			HF.Chance(0.33)
		then
			HF.AddAfflictionLimb(targetCharacter, "cerebralhypoxia", 11, 300)
		end
	return end	
	
	if --give second lobotomy affliction
		HF.HasAffliction(targetCharacter, "lobotomyonce")
	then
		HF.AddAfflictionLimb(targetCharacter, "lobotomytwice", 11, 3)
		
		if 
			HF.Chance(0.14)
		then
			HF.AddAfflictionLimb(targetCharacter, "cerebralhypoxia", 11, 300)
		end
	return end	

	if --give first lobotomy affliction
		not HF.HasAffliction(targetCharacter, "lobotomyonce")
	then
		HF.AddAfflictionLimb(targetCharacter, "lobotomyonce", 11, 3)
		
		if 
			HF.Chance(0.07)
		then
			HF.AddAfflictionLimb(targetCharacter, "cerebralhypoxia", 11, 300)
		end
	return end

end


-- Gets to run once every two seconds
function NTLOBO.Update()
	--print("eyeupdatetest")
		local updateHuman = {}
		local amountHuman = 0
		
		
	--fetch character for update
	for key, character in pairs(Character.CharacterList) do
		if not character.IsDead then
			if character.IsHuman and HF.HasAffliction(character, "lobotomyonce") then
				table.insert(updateHuman, character)
				amountHuman = amountHuman + 1
			end
		end
	end
	
	--spread the characters out over the duration of an update so that the load isnt done all at once
    for key, value in pairs(updateHuman) do
        -- make sure theyre still alive and human
        if (value ~= nil and not value.Removed and value.IsHuman and not value.IsDead) then
            Timer.Wait(function ()
                if (value ~= nil and not value.Removed and value.IsHuman and not value.IsDead) then
                NTLOBO.UpdateLobotomy(value) end
            end, ((key + 1) / amountHuman) * NTLOBO.Deltatime * 1000)
        end
    end
end