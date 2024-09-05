--lobotomy tables
GoodLobotomyAfflictions = {
	"lobo_genius", "lobo_veryfast", "lobo_notrauma", "lobo_nopsychosis", "lobo_nostun", "lobo_nopain", "lobo_noneurotrauma",
	"lobo_nodrunk"
}	

BadLobotomyAfflictions = {
	"lobo_infinitepsychosis", "lobo_mute", "lobo_blurredvision", "lobo_ungenius", "lobo_alwaysdrunk", "lobo_hearscreams", "lobo_tinnitus",
	"lobo_screenshake", "lobo_deaf", "lobo_blind", "lobo_constantpain", "lobo_paralysis", "lobo_invertcontrols", "lobo_nausea", "lobo_alwaysvigorous",
	"lobo_alwaysjolly", "lobo_differentteam", "lobo_veryslow", "lobo_alwaysrun", "lobo_randomarrest", "lobo_makescreams", "lobo_fart", "lobo_randomuncon",
	"lobo_noanalgesia", "lobo_durden"
	
}

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
		HF.AddAfflictionLimb(targetCharacter, "orbitoclastready", 11, 1+HF.GetSurgerySkill(usingCharacter)/2,usingCharacter)
		Entity.Spawner.AddItemToRemoveQueue(item) --despawn item as it is inside the patients skull
	end
	
	if --Hammer
				identifier == "surgicalhammer"
			and HF.HasAffliction(targetCharacter, "orbitoclastready", 100)
		--and not HF.HasAffliction(targetCharacter, "orbitoclastspin")
	
	then
		if --Cause pain if not anesthesia
			not HF.CanPerformSurgeryOn(targetCharacter)
		then
			HF.AddAfflictionLimb(targetCharacter, "severepainlite", 11, 5)
			HF.AddAfflictionLimb(targetCharacter, "pain_extremity", 11, 100)
		end
		
			HF.AddAfflictionLimb(targetCharacter, "orbitoclastspin", 11, 1+HF.GetSurgerySkill(usingCharacter)/2,usingCharacter)
			HF.GiveItem(usingCharacter,"orbitoclast") --give back orbitoclast
			--a statuseffect hook completes the surgery
	end

	--ethanol lobotomy
	if --ethanol insertion
			identifier == "ethanol"
		and HF.HasAffliction(targetCharacter, "drilledbones") --test this, may be buggy
	then
		HF.AddAfflictionLimb(targetCharacter, "ethanollobotomy", 11, 1+HF.GetSurgerySkill(usingCharacter)/2,usingCharacter) 
		Entity.Spawner.AddItemToRemoveQueue(item)
	end


	--lobotomy reversal
	if --nerve insertion
			identifier == "nervegenerators"
		and HF.HasAffliction(targetCharacter, "drilledbones") 
		and HF.HasAffliction(targetCharacter, "lobotomy")
	then
		HF.AddAfflictionLimb(targetCharacter, "nervegeneration", 11, 1) --this will remove lobotomies upon reaching 100%
		Entity.Spawner.AddItemToRemoveQueue(item)
	end
	
end)

--lobotomy
Hook.Add("lobotomize", function(effect, deltaTime, item, targets, worldPosition, element)

	for k, targetCharacter in pairs(targets) do
		if 
			   HF.HasAffliction(targetCharacter, "orbitoclastspin", 90)
			or HF.HasAffliction(targetCharacter, "ethanollobotomy", 90)
		then
			NTLOBO.ApplyLobotomy(targetCharacter, nil)
				
			targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("orbitoclastspin", 1000)
			targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("orbitoclastready", 1000)
			
			targetCharacter.CharacterHealth.ReduceAfflictionOnAllLimbs("ethanollobotomy", 1000)
		end
	end

end)

--nerve regen
Hook.Add("nerveregen", function(effect, deltaTime, item, targets, worldPosition, element)

	for k, targetCharacter in pairs(targets) do
		if --remove lobotomy
			HF.HasAffliction(targetCharacter, "nervegeneration", 90)
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
	end

end)


--lobotomize
function NTLOBO.ApplyLobotomy(targetCharacter, prevresult, prevchance)
	local result=prevresult --in case result want to be determined beforehand
	local chance=prevchance
	
	if chance==nil then chance=0.15 end
	
	if --determine result if not already determined
		result==nil 
	then
		if 
			HF.Chance(chance)
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
		
		
	HF.AddAfflictionLimb(targetCharacter, "lobotomy", 11, 1) --add progress after lobotomy
	
	if --chance of death from lobotomy
		HF.GetAfflictionStrength(targetCharacter, "lobotomy") <= 5
	then
		if
			HF.Chance( HF.GetAfflictionStrength(targetCharacter, "lobotomy")*0.07 )
		then
			HF.AddAfflictionLimb(targetCharacter, "lobotomydeath", 11, 3)
		end
	else
		if --scales up after 5 lobotomies
			HF.Chance( HF.GetAfflictionStrength(targetCharacter, "lobotomy")*0.12 )
		then
			HF.AddAfflictionLimb(targetCharacter, "lobotomydeath", 11, 3)
		end
	end
	
	
end