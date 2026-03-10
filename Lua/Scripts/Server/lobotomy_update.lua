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
