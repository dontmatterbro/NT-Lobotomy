--timer values
NTLOBO.ClientUpdateCooldown = 0
NTLOBO.ClientUpdateInterval = 120

-- updates client effects every 2 seconds
Hook.Add("think", "NTLOBO.ClientEffectUpdate", function()
    if HF.GameIsPaused() or not Level.Loaded then return end
	
    NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateCooldown-1
    if (NTLOBO.ClientUpdateCooldown <= 0) then
        NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateInterval
        NTLOBO.UpdateClientEffect()
    end
end)

function NTLOBO.UpdateClientEffect()
	

end