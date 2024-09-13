--timer values
NTLOBO.ClientUpdateCooldown = 0
NTLOBO.ClientUpdateInterval = 120

-- updates client effects every 2 seconds
Hook.Add("think", "NTLOBO.ClientUpdate", function()
    if HF.GameIsPaused() or not Level.Loaded then return end
	
	 --use for deaf
    NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateCooldown-1
    if (NTLOBO.ClientUpdateCooldown <= 0) then
        NTLOBO.ClientUpdateCooldown = NTLOBO.ClientUpdateInterval
        NTLOBO.UpdateClientEffect()
    end
end)


function NTLOBO.UpdateClientEffect()
	if Character.Controlled==nil then return end

	if --different team
		HF.HasAffliction(Character.Controlled, "lobo_differentteam") and Game.IsMultiplayer
	then
		Character.Controlled.TeamID=2 
	else
		Character.Controlled.TeamID=1
	end

end