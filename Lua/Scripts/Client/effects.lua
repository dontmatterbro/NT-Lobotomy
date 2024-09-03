--timer values
NTLOBO.ClientUpdateCooldown = 0
NTLOBO.ClientUpdateInterval = 120

-- updates client effects every 2 seconds
Hook.Add("think", "NTLOBO.ClientEffectUpdate", function()
    if HF.GameIsPaused() or not Level.Loaded then return end
	
	 --use for deaf
    NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateCooldown-1
    if (NTLOBO.ClientUpdateCooldown <= 0) then
        NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateInterval
        NTLOBO.UpdateClientEffect()
    end
end)


function NTLOBO.UpdateClientEffect()
	
	print(Character.Controlled.LowPassMultiplier)

end

--tick effects (sorry potato pc users, idk if there is simpler way to do this, there probably is tho)
Hook.Add("think", "NTLOBO.ClientEffectUpdate", function()
	if HF.GameIsPaused() or not Level.Loaded then return end
	
	if HF.HasAffliction(Character.Controlled, "lobo_deaf") then
	Character.Controlled.LowPassMultiplier=0 end --deaf	
	
	if HF.HasAffliction(Character.Controlled, "lobo_blind") then
	Character.Controlled.ObstructVisionAmount=0.7 end --blind

end) 