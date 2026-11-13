local MODE = MODE or {}
MODE.name = "dr"
MODE.PrintName = "Deathrun"
MODE.OverideSpawnPos = true
MODE.ROUND_TIME = 480
MODE.LootSpawn = false
MODE.GuiltDisabled = false
function MODE.GuiltCheck(Attacker, Victim, add, harm, amt)
    return 1.5, true
end
MODE.Chance = 1
util.AddNetworkString("dr_start")
function MODE:AssignTeams()
	local players = player.GetAll()
    table.Shuffle(players)

    local numPlayers = #players
    if numPlayers == 0 then return end
    local numDeath = 1
    if numPlayers >= 10 then
        numDeath = 2
    elseif numPlayers >= 20 then
        numDeath = 3
    elseif numPlayers >= 30 then
        numDeath = 4
    end
    local deathCount = 0

    for i = 1, numPlayers do
        local ply = players[i]
        if not IsValid(ply) then continue end

        if deathCount < numDeath then
            deathCount = deathCount + 1
            ply:SetTeam(0)
        else
            ply:SetTeam(1)
        end
    end
    SetGlobalBool("DefaultMove",true) --я хз если оно работает тк я с хомиград реворка спиздел эту линию
end
function MODE:RoundStartPost()
    if self:GetModeMap() then
        NextRound("dr")
    end
end
function MODE:Intermission()
    game.CleanUpMap()
    self:AssignTeams()
	for i, ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end
		ply:SetupTeam(ply:Team())
        ply.ragtime = 0
	end
    for _, ent in ipairs(ents.FindByClass("game_player_equip")) do
        if IsValid(ent) then
            ent:Remove()
        end
    end

    net.Start("dr_start")
    net.Broadcast()
end
function MODE:CheckAlivePlayers()
    return zb:CheckAliveTeams(true)
end
function MODE:GiveEquipment()
    for i, ply in ipairs(player.GetAll()) do
            local hands = ply:Give("weapon_hands_sh")
            local tbl = ply.CurAppearance
		    tbl.AClothes["main"] = "normal"
		    tbl.AClothes["pants"] = "normal"
		    tbl.AClothes["boots"] = "normal"
		    hg.Appearance.ForceApplyAppearance(ply,tbl)
            ply:SelectWeapon(hands)
            if ply.organism then
			    ply.organism.allowholster = true
		    end
            local wepnselected = "weapon_melee"
            ply:Give(wepnselected)
            ply:SelectWeapon(wepnselected)
        if ply:Team() == 0 then
            zb.GiveRole(ply, "Death", Color(190, 0, 0))
            ply:SetPlayerColor(Color(190, 0, 0):ToVector())
        elseif ply:Team() == 1 then
            zb.GiveRole(ply, "Runner", Color(0, 195, 255))
            ply:SetPlayerColor(Color(0, 195, 255):ToVector())
        end
    end
end
function MODE:RoundThink()
    for _,ply in player.Iterator() do
        local org = ply.organism
        if(not ply:Alive())then
			continue
		end
        if org.incapacitated or org.critical then
            ply:Kill()
            --print("fucki")
        end
        local wep = ply:GetWeapon("weapon_knife")
        if IsValid(wep) then
            wep:Remove()
        end
        local rag = ply.FakeRagdoll
        local KillTime = 10
        if(not ply:Alive()) then return end
        local org = ply.organism
        if rag and not org.otrub then
            ply.ragtime = ply.ragtime + 1
        end
        if ply.ragtime > KillTime and ply:Alive() then
            if  (IsValid( ply ) and IsValid( rag ) ) then
                ply:Kill()
                rag:Dissolve( 0, 0, nil, 0.5 )
            end
        end
        if not rag or org.otrub and ply.ragtime > 0 then
            ply.ragtime = 0
        end
    end
end
function MODE:GetTeamSpawn()
	return zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_T" )), zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_CT" ))
end
function MODE:ShouldRoundEnd()
    local endround, winner = zb:CheckWinner(self:CheckAlivePlayers())
    return endround
end
function MODE:RoundStart()
end
util.AddNetworkString("dr_roundend")
function MODE:EndRound()
    timer.Simple(2, function()
        net.Start("dr_roundend")
        net.Broadcast()
        local tbl = zb:CheckAliveTeams(true)
        local winner = 1
        if #tbl[1] == 0 and #tbl[0] == 0 then
            winner = 3
        end
        if #tbl[0] == 0 then
            winner = 0
        end
        local winnerprt = (winner == 1 and "Deaths") or (winner == 0 and "Runners") or "Nobody"
        PrintMessage(HUD_PRINTTALK, winnerprt.." have won the round!")
    end)
end
function MODE:CanLaunch()
    return self:GetModeMap()
end