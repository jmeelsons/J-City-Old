local Angle, Vector, AngleRand, VectorRand, math, hook, util, game = Angle, Vector, AngleRand, VectorRand, math, hook, util, game
local hook_Run = hook.Run
local hg_gopro = ConVarExists("hg_gopro") and GetConVar("hg_gopro") or CreateClientConVar("hg_gopro", "0", true, false, "Toggle GoPro-like camera view", 0, 1)
local hg_coolcamera = ConVarExists("hg_coolcamera") and GetConVar("hg_coolcamera") or CreateConVar("hg_coolcamera", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Cool camera movement", 0, 1)

--\\ EFT хуйня -- https://steamcommunity.com/sharedfiles/filedetails/?id=2230307188
local registry = include('eft_registry.lua')

local function GetSurfaceType(ply)
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
    
    return surfName, matType
end

local function GetEFTSound(ply, isRunning, isWalking, waterlevel)
    local surfName, matType = GetSurfaceType(ply)
    
    local armorType, armorWeight = nil, 0
    if hg and hg.GetArmorType then
        armorType, armorWeight = hg.GetArmorType(ply)
    end
    
    local useGear = registry.gear and registry.gear[1]
    local footstepReg = nil
    
    if isRunning then
        footstepReg = registry.sprint and (registry.sprint[surfName] or registry.sprint[matType])
    elseif isWalking then
        footstepReg = registry.walk and (registry.walk[surfName] or registry.walk[matType])
    else
        footstepReg = registry.run and (registry.run[surfName] or registry.run[matType])
    end

    if waterlevel >= 1 and waterlevel ~= 3 then
        local splashCategory = registry[isRunning and 'sprint' or (isWalking and 'walk' or 'run')]
        if splashCategory and splashCategory[MAT_SLOSH] then
            local splashReg = splashCategory[MAT_SLOSH]
            if #splashReg > 0 then
                return splashReg[math.random(1, #splashReg)], nil
            end
        end
    end
    
    local footSound = nil
    if footstepReg and #footstepReg > 0 then
        footSound = footstepReg[math.random(1, #footstepReg)]
    end
    
    local gearSound = nil
    if useGear and #useGear > 0 then
        gearSound = useGear[math.random(1, #useGear)]
    end
    
    return footSound, gearSound
end

local lply = nil
if CLIENT then
    lply = LocalPlayer()
end

hook.Add("PlayerStepSoundTime", "hg_eft_footsteps", function(ply, type, walking)
    if not IsValid(ply) then return end
    return 1
end)

hook.Add("PlayerFootstep", "HG_EFTCustomFootstep", function(ply, pos, foot, sound, volume, rf)
    if not IsValid(ply) then return end
    if (ply.lastStepTime or 0) > CurTime() then return true end
    
    local vel = ply:GetVelocity()
    local len = vel:Length()
    local ent = ply
    if hg and hg.GetCurrentCharacter then
        ent = hg.GetCurrentCharacter(ply) or ply
    end
    
    local waterlevel = ply:WaterLevel()
    
    local sprint = false
    if hg and hg.KeyDown then
        sprint = hg.KeyDown(ply, IN_SPEED)
    end
    
    local isRunning = sprint
    local isWalking = false
    if hg and hg.KeyDown then
        isWalking = hg.KeyDown(ply, IN_WALK) or ply:Crouching()
    else
        isWalking = ply:Crouching()
    end

    local stepDelay = 0.7
    if sprint then
        stepDelay = 0.7 * 1.5 * (1 / math.max(len, 200)) * 100
    else
        stepDelay = 0.7 * 1 * (1 / math.max(len, 150)) * 100
    end
    ply.lastStepTime = CurTime() + stepDelay

    if ply.PlayerClassName == "furry" then
        local wep = ply:GetActiveWeapon()
        if sprint and isWalking and IsValid(wep) and wep:GetClass() == "weapon_hands_sh" then
            local furryDelay = 0.4
            if sprint then
                furryDelay = 0.4 * 1.5 * (1 / math.max(len, 200)) * 100
            else
                furryDelay = 0.4 * 1 * (1 / math.max(len, 150)) * 100
            end
            ply.lastStepTime = CurTime() + furryDelay
        end
    end
    
    if hook_Run then
        hook_Run("HG_PlayerFootstep_Notify", ply, pos, foot, sound, volume, rf)
    end

    if CLIENT and lply and ply == lply and ply.move then
        footcl = (footcl == nil and -1 or footcl) + 1
        if footcl > 1 then
            footcl = -1
        elseif footcl == 0 then
            footcl = 1
        end
        local mul = 1 * len / 300 * math.max((350 - ply.move) / 50, 0.4)
        if not ply.organism then return end    
        local legsDamaged = 0
        if ply.organism then
            legsDamaged = (ply.organism.rleg or 0) + (ply.organism.lleg or 0)
        end
        local mul2 = 1
        if ply.organism then
            mul2 = ((ply.organism.lleg or 0) * 3 + 1) * ((ply.organism.rleg or 0) * 3 + 1) * (hg_coolcamera:GetBool() and legsDamaged < 0.2 and 1.5 or 0.5)
        end
        
        local goproVal = 1
        if hg_gopro:GetBool() then
            goproVal = 5
        end
        
        ViewPunch(Angle(goproVal * len / 200 * math.max((350 - ply.move) / 50, 1) * mul2, footcl * mul * mul2, footcl * mul * mul2))
    end

    if SERVER and ply.organism then
        local org = ply.organism
        local legDamage = 0
        if (org.lleg or 0) > 0.75 then
            legDamage = legDamage + (org.lleg - 0.75)
        end
        if (org.rleg or 0) > 0.75 then
            legDamage = legDamage + (org.rleg - 0.75)
        end
        org.painadd = org.painadd + legDamage
        
        if ply.GetNetVar then
            local armor = ply:GetNetVar("Armor", {})
            if armor and armor["torso"] then
                EmitSound("arc9_eft_shared/weapon_generic_rifle_spin"..math.random(9)..".ogg", pos, ply:EntIndex(), CHAN_AUTO, math.min(len / 100, 0.89), 80)
            end
        end
    end
    
    -- мряф >:3
    if SERVER then
        if hook_Run then
            local Hook = hook_Run("HG_PlayerFootstep", ply, pos, foot, sound, volume, rf)
            if Hook then return Hook end
        end

        if ent ~= ply then return true end

        if ply.PlayerClassName == "furry" then
            local snd = "zbattle/footstep/hardbarefoot" .. math.random(1, 5) .. ".ogg"
            if SoundDuration(snd) > 0 then
                EmitSound(snd, pos, ply:EntIndex(), CHAN_AUTO, volume, 75, nil, math.random(95, 105))
            else
                EmitSound(sound, pos, ply:EntIndex(), CHAN_AUTO, volume, 75, nil, math.random(95, 105))
            end
            return true
        elseif ply.PlayerClassName == "Gordon" then
            EmitSound(sound, pos, ply:EntIndex(), CHAN_AUTO, volume, 75, nil, math.random(95, 105))
            return true
        end

        local footSound, gearSound = GetEFTSound(ply, isRunning, isWalking, waterlevel)

        if gearSound then
            EmitSound(gearSound, pos, ply:EntIndex(), CHAN_AUTO, volume * 0.6, math.random(95, 105))
        end
            
        if armorType and armorWeight > 0 then
            local armorMoveSound = hg.GetArmorMovementSound(ply, armorType, isRunning)
            if armorMoveSound then
                timer.Simple(0.05, function()
                    if IsValid(ply) then
                        EmitSound(armorMoveSound, pos, ply:EntIndex(), CHAN_AUTO, volume * 0.3 * armorWeight / 3, math.random(95, 105))
                    end
                end)
             end
         end

        if footSound then
            EmitSound(footSound, pos, ply:EntIndex(), CHAN_BODY, volume, math.random(95, 105))
        end
    end
    
    return true
end)