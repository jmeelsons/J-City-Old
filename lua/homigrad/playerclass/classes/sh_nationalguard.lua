local CLASS = player.RegClass("nationalguard")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {}
for i = 1, 9 do
    table.insert(models,"models/dejtriyev/enhancednatguard/male_0"..i..".mdl")
end

local ranks = {
    {name = "PVT", chance = 25},
    {name = "PV2", chance = 20},
    {name = "PFC", chance = 18},
    {name = "SPC", chance = 12},
    {name = "CPL", chance = 8},
    {name = "SGT", chance = 7},
    {name = "SSG", chance = 4},
    {name = "SFC", chance = 2.5},
    {name = "MSG", chance = 1.2},
    {name = "1SG", chance = 0.8},
    {name = "SGM", chance = 0.5},
    {name = "CSM", chance = 0.3},
    {name = "SMA", chance = 0.1},
    {name = "2LT", chance = 0.3},
    {name = "1LT", chance = 0.2},
    {name = "CPT", chance = 0.08},
    {name = "MAJ", chance = 0.02},
}

local clr = Color(5, 65, 0):ToVector()
function CLASS.On(self)
    if CLIENT then return end
    ApplyAppearance(self,nil,nil,nil,true)
    local Appearance = self.CurAppearance or hg.Appearance.GetRandomAppearance()
    Appearance.AAttachments = ""
    Appearance.AColthes = ""

    local randomValue = math.random() * 100
    local cumulativeChance = 0
    local rank = "PVT"

    for _, rankInfo in ipairs(ranks) do
        cumulativeChance = cumulativeChance + rankInfo.chance
        if randomValue <= cumulativeChance then
            rank = rankInfo.name
            break
        end
    end

    self:SetNWString("PlayerName", rank .. " " .. Appearance.AName)
    self:SetPlayerColor(clr)
    self:SetModel(models[math.random(#models)])
    self:SetBodygroup(0,14)
    self:SetSubMaterial()
    self.CurAppearance = Appearance
end

local function IsLookingAt(ply, targetVec)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    local diff = targetVec - ply:GetShootPos()
    return ply:GetAimVector():Dot(diff) / diff:Length() >= 0.8 
end

function CLASS.Guilt(self, Victim)
    if CLIENT then return end

    if Victim:GetPlayerClass() == self:GetPlayerClass() then
        --self:ChatPrint("You killed your teammate!")
        return 1
    end

    if CurrentRound().name == "hmcd" then
        return zb.ForcesAttackedInnocent(self, Victim)
    end

    return 1
end

hook.Add("HG_PlayerFootstep", "nationalguard_footsteps", function(ply, pos, foot, sound, volume, rf)
    local chr = hg.GetCurrentCharacter(ply)
    if ply:Alive() and ply.PlayerClassName == "nationalguard" then
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