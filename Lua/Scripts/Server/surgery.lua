--Orbitoclast
--Use hammer to insert orbitoclast to skull
--doesnt require anesthesia only local numbness

Hook.Add("item.applyTreatment", "NT.itemused", function(item, usingCharacter, targetCharacter, limb)
    
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
	
	--frontal lobotomy
	if --Orbitoclast
		identifier == "orbitoclast"
	then
		HF.AddAfflictionLimb(targetCharacter, "orbitoclastready", 11, 3)
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
		
		HF.AddAfflictionLimb(targetCharacter, "orbitoclastinsertion", 11, 3)
	end
	--need a way to shake orbitoclast after insertion. maybe player controls somehow??
	
	--ethanol lobotomy
	if --ethanol insertion
			identifier == "ethanol"
		and HF.HasAffliction(targetCharacter, "drilledbones") --bugtest this
	then
		--lobotomy code here
	end
	

end)