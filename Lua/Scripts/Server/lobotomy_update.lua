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
	"lobo_genius", 
}	

BadLobotomyAfflictions = {
	"lobo_infinitepsychosis", "lobo_mute", "lobo_blurredvision", "lobo_ungenius", "lobo_alwaysdrunk", "lobo_hearscreams", "lobo_tinnitus",
	"lobo_screenshake", "lobo_deaf", "lobo_blind", "lobo_constantpain"
	
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
		
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("lobotomy", 1000)
		
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
	
	if --always in pain
				HF.HasAffliction(targetCharacter, "lobo_constantpain")
		and not HF.HasAffliction(targetCharacter, "analgesia")
	then
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 11, 100) --head
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 12, 100) --torso
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 4, 100) --right arm
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 3, 100) --left arm
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 8, 100) --right leg
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 7, 100) --left leg
	end
		

end


-- Gets to run once every two seconds
function NTLOBO.Update()
	--print("eyeupdatetest")
		local updateHuman = {}
		local amountHuman = 0
		
		
	--fetch character for update
	for key, character in pairs(Character.CharacterList) do
		if not character.IsDead then
			if character.IsHuman and HF.HasAffliction(character, "lobotomy") then
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