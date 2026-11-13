local CLASS = player.RegClass("commanderforces")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {}
for i = 1, 9 do
    table.insert(models,"models/dejtriyev/enhancednatguard/male_0"..i..".mdl")
end


function CLASS.On(self)
    if CLIENT then return end
    ApplyAppearance(self,nil,nil,nil,true)
    local Appearance = self.CurAppearance or hg.Appearance.GetRandomAppearance()
    Appearance.AAttachments = ""
    Appearance.AClothes = ""
    self:SetPlayerColor(Color(100,37,54):ToVector())
    self:SetModel(models[math.random(#models)])
    self:SetBodyGroups("000000000")
    self:SetBodygroup(1,14)
    self:SetBodygroup(3,12)
    self:SetBodygroup(4,12)
    self:SetSubMaterial()
    self.CurAppearance = Appearance
end

-- local function IsLookingAt(ply, targetVec)
--     if not IsValid(ply) or not ply:IsPlayer() then return false end
--     local diff = targetVec - ply:GetShootPos()
--     return ply:GetAimVector():Dot(diff) / diff:Length() >= 0.8 
-- end

function CLASS.Guilt(self, Victim)
    if CLIENT then return end

    if Victim:GetPlayerClass() == self:GetPlayerClass() then
        --self:ChatPrint("You killed your teammate!")
        return 1
    end
end

hook.Add("HG_PlayerFootstep", "commanderforces_footsteps", function(ply, pos, foot, sound, volume, rf)
    local chr = hg.GetCurrentCharacter(ply)
    if ply:Alive() and ply.PlayerClassName == "commanderforces" then
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