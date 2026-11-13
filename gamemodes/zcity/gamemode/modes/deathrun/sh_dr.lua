local MODE = MODE or {}
zb.forcemode = zb.forcemode or "random"
MODE.Maps = {
    "dr_",
    "deathrun_"
}

function MODE:GetModeMap(mapName)
    mapName = string.lower(mapName or game.GetMap() or "")

    for _, prefix in ipairs(self.Maps) do
        if string.sub(mapName, 1, #prefix) == prefix then
            return true
        end
    end

    return false
end

zb = zb or {}
zb.Points = zb.Points or {}

zb.Points.HMCD_DR_D = zb.Points.HMCD_DR_D or {}
zb.Points.HMCD_DR_D.Color = Color(237,13,13)
zb.Points.HMCD_DR_D.Name = "HMCD_DR_D"
zb.Points.HMCD_DR_R = zb.Points.HMCD_DR_R or {}
zb.Points.HMCD_DR_R.Color = Color(0,0,150)
zb.Points.HMCD_DR_R.Name = "HMCD_DR_R"
function MODE:HG_MovementCalc_2( mul, ply, cmd, mv )
    if (zb.ROUND_START or 0) + 10 > CurTime() and cmd then
        cmd:RemoveKey(IN_ATTACK)
        cmd:RemoveKey(IN_FORWARD)
        cmd:RemoveKey(IN_BACK)
        cmd:RemoveKey(IN_MOVELEFT)
        cmd:RemoveKey(IN_MOVERIGHT)

        if mv then
            mv:RemoveKey(IN_ATTACK)
            mv:RemoveKey(IN_FORWARD)
            mv:RemoveKey(IN_BACK)
            mv:RemoveKey(IN_MOVELEFT)
            mv:RemoveKey(IN_MOVERIGHT)
        end

        if IsValid(ply) and IsValid(ply:GetWeapon("weapon_hands_sh")) then
            cmd:SelectWeapon(ply:GetWeapon("weapon_hands_sh"))
            if SERVER then ply:SelectWeapon("weapon_hands_sh") end
        end
        
        mul[1] = 0
    end
end
function MODE:PlayerCanLegAttack( ply )
	return false --net idi nahuy
end