local CLASS = player.RegClass("swat")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {
    "models/css_seb_swat/css_swat.mdl",
}

function CLASS.On(self)
    if CLIENT then return end
    ApplyAppearance(self,nil,nil,nil,true)
    self:SetPlayerColor(Color(10,10,100):ToVector())
    self:SetModel(models[math.random(#models)])
    self:SetSubMaterial()
    timer.Simple(0,function()
        self:SetBodyGroups("00000000000")
    end)
    local Appearance = self.CurAppearance or hg.Appearance.GetRandomAppearance()
    Appearance.AAttachments = ""
    Appearance.AColthes = ""
    self:SetNetVar("Accessories", "")
    self.CurAppearance = Appearance
    local inv = self:GetNetVar("Inventory", {})
    inv["Weapons"] = inv["Weapons"] or {}
    inv["Weapons"]["hg_sling"] = true
    self:SetNetVar("Inventory", inv)

    self:SetNWString("PlayerName","SWAT "..Appearance.AName)
    
    timer.Simple(0.5, function()
        if IsValid(self) then
            local armor = ents.Create("ent_armor_axon_body")
            if IsValid(armor) then
                armor:SetPos(self:GetPos() + Vector(0, 0, 50))
                armor:Spawn()
                armor:Activate()
                armor:SetOwner(self)
                    
                armor:Use(self)
            end
        end
    end)
end

function CLASS.Guilt(self, Victim)
    if CLIENT then return end

    if Victim:GetPlayerClass() == self:GetPlayerClass() then
        return 1
    end

    if CurrentRound().name == "hmcd" then
        return zb.ForcesAttackedInnocent(self, Victim)
    end

    if Victim == zb.hostage then
        return 1
    end

    return 1
end

hook.Add("HG_PlayerFootstep", "swat_footsteps", function(ply, pos, foot, sound, volume, rf)
    local chr = hg.GetCurrentCharacter(ply)
    if ply:Alive() and ply.PlayerClassName == "swat" then
        local ent = hg.GetCurrentCharacter(ply)
        
        if not (ply:IsWalking() or ply:Crouching()) and ent == ply then
            local mins, maxs = ply:OBBMins(), ply:OBBMaxs()
            local tr = util.TraceHull({
                start = ply:GetPos(),
                endpos = ply:GetPos() - Vector(0, 0, 5),
                mins = mins,
                maxs = maxs,
                filter = ply
            })
            
            local matType = tr.MatType == 0 and MAT_DEFAULT or tr.MatType
            local surfName = tr.SurfaceProps == 0 and 'default' or util.GetSurfacePropName(tr.SurfaceProps)

            local vel = ply:GetVelocity()
            local len = vel:Length()
            local sprint = hg.KeyDown(ply, IN_SPEED)
            local isRunning = sprint
            local isWalking = hg.KeyDown(ply, IN_WALK) or ply:Crouching()
            local waterlevel = ply:WaterLevel()

            local registry = include('eft_registry.lua')
            local footSound = nil
            local gearSound = nil

            if isRunning then
                local sprintReg = registry.sprint and (registry.sprint[surfName] or registry.sprint[matType])
                if sprintReg and #sprintReg > 0 then
                    footSound = sprintReg[math.random(1, #sprintReg)]
                end
            elseif isWalking then
                local walkReg = registry.walk and (registry.walk[surfName] or registry.walk[matType])
                if walkReg and #walkReg > 0 then
                    footSound = walkReg[math.random(1, #walkReg)]
                end
            else
                local runReg = registry.run and (registry.run[surfName] or registry.run[matType])
                if runReg and #runReg > 0 then
                    footSound = runReg[math.random(1, #runReg)]
                end
            end
  
            local gearReg = registry.gear and registry.gear[1]
            if gearReg and #gearReg > 0 then
                gearSound = gearReg[math.random(1, #gearReg)]
            end

            if footSound then
                if gearSound then
                    EmitSound(gearSound, pos, ply:EntIndex(), CHAN_AUTO, volume * 0.6, math.random(95, 105))
                end
                
                EmitSound(footSound, pos, ply:EntIndex(), CHAN_BODY, volume, math.random(95, 105))
            else
                local snd = "zcitysnd/" .. string.Replace(sound, "player/footsteps", "player/footsteps_military/")
                if SoundDuration(snd) <= 0 then
                    snd = sound
                end
                EmitSound(snd, pos, ply:EntIndex(), CHAN_AUTO, volume, 75, nil, math.random(95,105))
            end
            
            return true
        end
    end
end)