
Hook.Add("item.applyTreatment", "NTLOBO.itemused", function(item, usingCharacter, targetCharacter, limb)

    if -- invalid use, dont do anything
        item == nil or
        usingCharacter == nil or
        targetCharacter == nil or
        limb == nil 
    then return end
	
	local identifier = item.Prefab.Identifier
	local limbtype = HF.NormalizeLimbType(limb.type)
	---------------------------------------SURGERY CODE--------------------------
	
	if not limbtype==11 then return end
	if HF.HasAffliction(targetCharacter, "stasis") then return end 
	
	--transorbital lobotomy
	if --Orbitoclast
				identifier == "orbitoclast"
		and not HF.HasAffliction(targetCharacter, "orbitoclastready")
	then
		HF.AddAfflictionLimb(targetCharacter, "orbitoclastready", 11, 3)
		Entity.Spawner.AddItemToRemoveQueue(item) --despawn item as it is inside the patients skull
	end
	
	if --Hammer
			identifier == "surgicalhammer"
		and HF.HasAffliction(targetCharacter, "orbitoclastready")
	
	then
		if --Cause pain if not anesthesia
			not HF.CanPerformSurgeryOn(targetCharacter)
		then
			HF.AddAfflictionLimb(targetCharacter, "severepainlite", 11, 5)
			HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 11, 100)
		end

		NTLOBO.ApplyLobotomy(targetCharacter, prevresult)
		HF.GiveItem(usingCharacter,"orbitoclast") --give back orbitoclast
		targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("orbitoclastready", 1000)
	end
--maybe add a way to remove orbitoclast??


	--ethanol lobotomy
	if --ethanol insertion
			identifier == "ethanol"
		and HF.HasAffliction(targetCharacter, "drilledbones") --test this, may be buggy
	then
		NTLOBO.ApplyLobotomy(targetCharacter, prevresult)
		Entity.Spawner.AddItemToRemoveQueue(item)
	end


	--lobotomy reversal
	if --nerve insertion
			identifier == "nervegenerators"
		and HF.HasAffliction(targetCharacter, "drilledbones") 
		and HF.HasAffliction(targetCharacter, "lobotomyonce")
	then
		HF.AddAfflictionLimb(targetCharacter, "nervegeneration", 11, 1) --this will remove lobotomies upon reaching 100%
		Entity.Spawner.AddItemToRemoveQueue(item)
	end
	
end)