function NTLOBO.UpdateLobotomy(targetCharacter)

-------------------------------------------EFFECT AFFLICTIONS-----------------------------------------------------------
	
	if --infinite psychosis
		HF.HasAffliction(targetCharacter, "infinitepsychosis")
	then
		HF.AddAfflictionLimb(targetCharacter, "psychosis", 11, 100)
	end

	if --paralysis
		HF.HasAffliction(targetCharacter, "lobo_paralysis")
	then
		HF.AddAfflictionLimb(targetCharacter, "givein", 11, 1)
	end			
	
	if --nausea
			HF.HasAffliction(targetCharacter, "lobo_nausea")
		and HF.Chance(0.2)
	then
		HF.AddAfflictionLimb(targetCharacter, "nausea", 11, 20)
	end		
	
	if --random respiratory arrest
			HF.HasAffliction(targetCharacter, "lobo_randomarrest")
		and HF.Chance(0.3)
	then
		HF.AddAfflictionLimb(targetCharacter, "respiratoryarrest", 12, 100)
	end		
	
	if --random uncons
			HF.HasAffliction(targetCharacter, "lobo_randomuncon")
		and HF.Chance(0.05)
	then
		HF.AddAfflictionLimb(targetCharacter, "sym_unconsciousness", 11, 100)
	end			
	
	if --always in pain
				HF.HasAffliction(targetCharacter, "lobo_constantpain")
		and not HF.HasAffliction(targetCharacter, "analgesia")
		and not HF.HasAffliction(targetCharacter, "lobo_nopain")
	then
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 11, 100) --head
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 12, 100) --torso
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 4, 100) --right arm
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 3, 100) --left arm
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 8, 100) --right leg
		HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 7, 100) --left leg
	end	

end