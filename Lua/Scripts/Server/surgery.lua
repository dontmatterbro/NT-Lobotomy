--Orbitoclast
--Use hammer to insert orbitoclast to skull

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
	
	if --Orbitoclast
		identifier == "orbitoclast"
	then
	
	end
	




end)