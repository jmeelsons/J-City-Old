if SERVER then
    AddCSLuaFile()
end

SWEP.Base = "weapon_tpik_base"
SWEP.PrintName = "Gravity Gun"
SWEP.Instructions = "The Zero-Point Energy Field Manipulator, commonly known as the Gravitational Gun (Gravitational Manipulator), is a tractor beam-type weapon designed for handling hazardous materials."
SWEP.Category = "Weapons - Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Slot = 1
SWEP.Weight = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

if CLIENT then
    SWEP.WepSelectIcon = Material("entities/zcity/gravitygun.png")
    SWEP.IconOverride = "entities/zcity/gravitygun.png"
    SWEP.BounceWeaponIcon = false
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.WorldModel = "models/mmod/weapons/w_physics.mdl"
SWEP.WorldModelReal = "models/mmod/weapons/c_physcannon.mdl"
SWEP.WorldModelExchange = false
SWEP.ViewModel = ""
SWEP.HoldType = "slam"
SWEP.weight = 4

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:CanSecondaryAttack()
    return true
end

SWEP.supportTPIK = true
SWEP.weaponPos = Vector(0, 0, 0)
SWEP.weaponAng = Angle(0, 0, 0)
SWEP.animtime = 0
SWEP.animspeed = 0
SWEP.cycling = false
SWEP.reverseanim = false
SWEP.setlh = true
SWEP.setrh = true
SWEP.sprint_ang = Angle(25, 0, 0)
SWEP.HoldPos = Vector(-10, -3, -3)
SWEP.HoldAng = Angle(-5, 0, 0)
SWEP.basebone = 1
SWEP.WorkWithFake = true
SWEP.modelscale = 1
SWEP.modelscale2 = 0.75
SWEP.DeploySpeed = 1
SWEP.ViewBobCamBase = "ValveBiped.Bip01_R_UpperArm"
SWEP.ViewBobCamBone = "ValveBiped.Bip01_R_Hand"
SWEP.ViewPunchDiv = 70
SWEP.isTPIKBase = true

SWEP.AnimList = {
    ["deploy"] = {"draw", 5, false},
    ["attack"] = {"fire", 1, false},
    ["altfire"] = {"altfire", 1, false},
    ["idle_hold"] = {"hold_idle", 1, true},
    ["holster"] = {"fire", 1, false},
    ["idle"] = {"idle", 5, true},
}

SWEP.PuntForce = 1000000
SWEP.PuntMultiply = 850
SWEP.PullForce = 8000
SWEP.HL2PullForce = 4000
SWEP.HL2PullForceRagdoll = 3500
SWEP.MaxMass = 16500
SWEP.HL2MaxMass = 5500
SWEP.MaxPuntRange = 1650
SWEP.HL2MaxPuntRange = 550
SWEP.MaxPickupRange = 2550
SWEP.HL2MaxPickupRange = 850
SWEP.ConeWidth = 0.88
SWEP.MaxTargetHealth = 1000
SWEP.HL2MaxTargetHealth = 225
SWEP.GrabDistance = 25
SWEP.GrabDistanceRagdoll = 15

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

local holdLoopSound = Sound("weapons/mmod/physcannon/hold_loop.wav")

util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

local IsValid, Vector, Angle, math, game, util, EffectData, ents, pairs, ipairs, table, bit, timer, GetConVar, ConVarExists = 
      IsValid, Vector, Angle, math, game, util, EffectData, ents, pairs, ipairs, table, bit, timer, GetConVar, ConVarExists

local function DissolveEntity(ent)
    local dissolved = nil
    
    for _, dissolver in ipairs(ents.FindByName("scgg_addon_global_dissolver")) do
        if dissolver:GetClass() == "env_entity_dissolver" then
            dissolver:Fire("Dissolve", "", 0, ent)
            dissolved = true
            break
        end
    end
    
    if dissolved != true then
        local newDissolver = ents.Create("env_entity_dissolver")
        newDissolver:SetPos(vector_origin)
        newDissolver:SetKeyValue("target", "!activator")
        newDissolver:SetKeyValue("dissolvetype", 0)
        newDissolver:SetName("scgg_addon_global_dissolver")
        newDissolver:Spawn()
        newDissolver:Activate()
        newDissolver:Fire("Dissolve", "", 0, ent)
    end
end

local function GetEyeTrace(weapon, ply)
    local trace = nil
    
    if ply:IsPlayer() then
        trace = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 32768,
            filter = {weapon, ply},
            mask = MASK_SHOT_HULL
        })
    else
        trace = util.TraceHull({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 32768,
            filter = {weapon, ply},
            mins = Vector(-10, -10, -10),
            maxs = Vector(10, 10, 10),
            mask = MASK_SHOT_HULL
        })
    end
    
    return trace
end

local function IsEntityAlive(ent)
    if ent:IsPlayer() then
        if !ent:Alive() then
            return false
        end
    elseif ent:IsNPC() then
        if ent:GetNPCState() == NPC_STATE_DEAD or ent:Health() <= 0 then
            return false
        end
    end
    
    return true
end

local function SetWeaponHoldType(weapon)
    if !IsValid(weapon.Owner) then
        return
    end
    
    if weapon.Owner:IsNPC() then
        weapon.Weapon:SetHoldType("shotgun")
        
        if SERVER then
            if weapon.Owner:Classify() == CLASS_METROPOLICE then
                weapon.Weapon:SetHoldType("smg")
            end
        end
    else
        weapon.Weapon:SetHoldType(weapon.HoldType)
    end
end

local function PlayHoldLoopSound(weapon, play)
    if play == true then
        local soundEnt = ents.Create("ambient_generic")
        soundEnt:SetPos(weapon:GetPos())
        soundEnt:SetKeyValue("message", holdLoopSound)
        soundEnt:SetKeyValue("health", "4")
        soundEnt:SetKeyValue("spawnflags", "16")
        soundEnt:SetParent(weapon)
        soundEnt:Spawn()
        soundEnt:Activate()
        soundEnt:Fire("PlaySound")
    else
        for _, child in ipairs(weapon:GetChildren()) do
            if IsValid(child) and child:GetClass() == "ambient_generic" and child:GetInternalVariable("message") == holdLoopSound then
                child:Fire("StopSound")
                child:Remove()
                break
            end
        end
    end
end

local function IsValidPhysicsEntity(ent)
    if IsValid(ent) and ent:GetMoveType() == MOVETYPE_VPHYSICS and IsValid(ent:GetPhysicsObject()) then
        if ent:GetPhysicsObject():IsMotionEnabled() or 
           (!ent:GetPhysicsObject():IsMotionEnabled() and (ent:HasSpawnFlags(64) or (ent:GetClass() == "func_physbox" and ent:HasSpawnFlags(131072)))) then
            return true
        end
    end
    
    return false
end

function SWEP:CanBePickedUpByNPCs()
    return true
end

function SWEP:GetCapabilities()
    if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then
        self:GetOwner():SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end
    
    return bit.bor(CAP_WEAPON_RANGE_ATTACK2, CAP_INNATE_RANGE_ATTACK1)
end

local function CheckHookPhysics(entity)
    return false
end

function SWEP:SetupDataTables()
    self:NetworkVar("Entity", 0, "HP")
    self:NetworkVar("Entity", 1, "TP")
    self:NetworkVar("Bool", 0, "Glow")
    
    self:SetHP(nil)
    self:SetTP(nil)
    self:SetGlow(false)
end

local function InitializeWeapon(self)
    self.Fading = false
    self.CoreAllowRemove = true
    self.HPCollideG = COLLISION_GROUP_NONE
    self.HPHealth = -1
    self.HPBone = nil
    self.OnDropOwner = nil
end

if SERVER then
    function SWEP:InitAdd()
        self:SetDeploySpeed(1)
        self:PlayAnim("deploy")
        SetWeaponHoldType(self)
        self:SetSkin(1)
        InitializeWeapon(self)
    end
end

if CLIENT then
    function SWEP:PlayClawSound(close)
        local soundName = "Weapon_PhysCannon.OpenClaws"
        
        if close == true then
            soundName = "Weapon_PhysCannon.CloseClaws"
        end
        
        self:StopClawSound()
        
        local sound = CreateSound(self, soundName)
        self.ActiveSnd = sound
        sound:Play()
    end
    
    function SWEP:StopClawSound()
        if self.ActiveSnd != nil and self.ActiveSnd:IsPlaying() then
            self.ActiveSnd:Stop()
        end
    end
    
    function SWEP:AdjustClaws()
        local function AdjustValue(current)
            local adjustment = FrameTime()
            local newValue = current + adjustment
            return newValue
        end
        
        if self.PoseParam < 0 then
            self.PoseParam = 0
        elseif self.PoseParam > 1 then
            self.PoseParam = 1
        end
        
        if self.PoseParamDesired < self.PoseParam then
            if self.PoseParam >= 1 then
                self:PlayClawSound(true)
            end
            
            local adjustment = nil
            
            if game.SinglePlayer() then
                adjustment = AdjustValue(0.0025)
            else
                adjustment = AdjustValue(0.02)
            end
            
            self.PoseParam = self.PoseParam - adjustment
        elseif self.PoseParamDesired > self.PoseParam then
            if self.PoseParam <= 0 then
                self:PlayClawSound(false)
            end
            
            local adjustment = nil
            
            if game.SinglePlayer() then
                adjustment = AdjustValue(0.05)
            else
                adjustment = AdjustValue(0.1)
            end
            
            self.PoseParam = self.PoseParam + adjustment
        end
        
        local viewModel = self:GetOwner():GetViewModel()
        local worldModel = self
        local poseParamName = "active"
        
        if (viewModel and IsValid(viewModel)) or (worldModel and IsValid(worldModel)) then
            if !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
                return
            end
            
            if IsValid(viewModel) then
                viewModel:SetPoseParameter(poseParamName, self.PoseParam)
                viewModel:InvalidateBoneCache()
            end
            
            if IsValid(worldModel) then
                worldModel:SetPoseParameter(poseParamName, self.PoseParam)
                worldModel:InvalidateBoneCache()
            end
        end
    end
    
    function SWEP:ThinkAdd()
        if ConVarExists("cl_scgg_viewmodel") then
            local viewModelPath = GetConVar("cl_scgg_viewmodel"):GetString()
            
            if util.IsValidModel(viewModelPath) and self.ViewModel != viewModelPath then
                self.ViewModel = viewModelPath
                local viewModel = self:GetOwner():GetViewModel()
                viewModel:SetWeaponModel(viewModelPath, self)
                viewModel:InvalidateBoneCache()
            end
        end
        
        if !self:GetNWBool("Glow") then
            if !self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand") then
                return
            end
            
            local dynamicLight = DynamicLight(self:EntIndex() + 1000)
            
            if dynamicLight then
                dynamicLight.Pos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
                dynamicLight.r = 255
                dynamicLight.g = 175
                dynamicLight.b = 50
                dynamicLight.Brightness = 0.3
                dynamicLight.Size = 100
                dynamicLight.DieTime = CurTime() + 0.5
            end
        else
            if !self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand") then
                return
            end
            
            local dynamicLight = DynamicLight(self:EntIndex() + 1000)
            
            if dynamicLight then
                dynamicLight.Pos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
                dynamicLight.r = 255
                dynamicLight.g = 175
                dynamicLight.b = 50
                dynamicLight.Brightness = 0.6
                dynamicLight.Size = 160
                dynamicLight.DieTime = CurTime() + 0.5
            end
        end
        
        if self.PoseParam == nil then
            self.PoseParam = 0
        end
        
        if self.PoseParamDesired == nil then
            self.PoseParamDesired = 0
        end
        
        self:AdjustClaws()
        
        local clawMode = 1
        
        if ConVarExists("scgg_claw_mode") then
            clawMode = GetConVar("scgg_claw_mode"):GetInt()
        end
        
        if clawMode <= 0 then
            self:CloseClaws(false)
        elseif clawMode > 0 and clawMode < 2 then
            self:OpenClaws(false)
        elseif clawMode >= 2 then
            local isGlowing = self:GetGlow()
            
            if isGlowing then
                self:StopClawSound()
            end
            
            local trace = self:GetOwner():GetEyeTrace()
            local traceEntity = trace.Entity
            local coneEntity = nil
            
            if (!ConVarExists("scgg_cone") or GetConVar("scgg_cone"):GetBool()) and !self:PickupCheck(traceEntity) and (!IsValid(self:GetTP())) then
                coneEntity = self:GetConeEnt(trace)
            else
                coneEntity = traceEntity
            end
            
            if IsValid(self:GetTP()) then
                timer.Remove("scgg_claw_close_delay" .. self:EntIndex())
                self:OpenClaws(false)
            elseif self:PickupCheck(coneEntity) then
                self:OpenClaws(true)
            else
                if !timer.Exists("scgg_claw_close_delay" .. self:EntIndex()) and IsValid(self) then
                    timer.Create("scgg_claw_close_delay" .. self:EntIndex(), 0.6, 1, function()
                        if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():Alive() then
                            self:CloseClaws(true)
                            self:OpenClaws(false, true)
                        end
                    end)
                end
            end
        end
        
        self:SetNextClientThink(CurTime() + 0.5)
    end
end

local function GetPoseParameterValue(ent, paramName, defaultValue)
    if !IsValid(ent) then
        return defaultValue
    end
    
    local paramIndex = ent:GetPoseParameter(paramName)
    if paramIndex then
        local minValue, maxValue = ent:GetPoseParameterRange(paramIndex)
        return defaultValue
    end
    
    return defaultValue
end

function SWEP:OpenClaws(playSound, reverse)
    if SERVER then
        return
    end
    
    if !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
        return
    end
    
    if reverse == nil then
        reverse = false
    end
    
    local poseParam = "active"
    local viewModel = self:GetOwner():GetViewModel()
    local worldModel = self
    
    timer.Remove("scgg_claw_close_delay" .. self:EntIndex())
    
    local worldModelValue = 0
    local viewModelValue = 0
    
    if IsValid(viewModel) then
        local viewModelPose = viewModel:GetPoseParameter(poseParam)
        viewModelValue = GetPoseParameterValue(viewModel, poseParam, viewModelPose)
    end
    
    if IsValid(worldModel) then
        local worldModelPose = worldModel:GetPoseParameter(poseParam)
        worldModelValue = GetPoseParameterValue(worldModel, poseParam, worldModelPose)
    end
    
    if (worldModel and worldModelValue < 1) or (viewModel and viewModelValue < 1) then
        local worldModelCurrent = worldModelValue
        local viewModelCurrent = viewModelValue
        
        if !timer.Exists("scgg_move_claws_open" .. self:EntIndex()) then
            timer.Remove("scgg_move_claws_close" .. self:EntIndex())
            
            timer.Create("scgg_move_claws_open" .. self:EntIndex(), 0, 20, function()
                if !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
                    timer.Remove("scgg_move_claws_open" .. self:EntIndex())
                    return
                end
                
                local currentViewModel = self:GetOwner():GetViewModel()
                local currentWorldModel = self
                
                if IsValid(currentWorldModel) then
                    if worldModelCurrent > 1 then
                        currentWorldModel:SetPoseParameter(poseParam, 1)
                    end
                    
                    worldModelCurrent = (reverse and worldModelCurrent - 0.1) or worldModelCurrent + 0.1
                    currentWorldModel:SetPoseParameter(poseParam, worldModelCurrent)
                    currentWorldModel:InvalidateBoneCache()
                end
                
                if IsValid(currentViewModel) then
                    if viewModelCurrent > 1 then
                        currentViewModel:SetPoseParameter(poseParam, 1)
                    end
                    
                    viewModelCurrent = (reverse and viewModelCurrent - 0.1) or viewModelCurrent + 0.1
                    currentViewModel:SetPoseParameter(poseParam, viewModelCurrent)
                    currentViewModel:InvalidateBoneCache()
                    
                    if viewModelCurrent >= 0.5 then
                        self.ClawOpenState = true
                    end
                end
            end)
            
            if (worldModelCurrent <= 0 or viewModelCurrent <= 0) and !IsValid(self:GetHP()) and playSound then
                self:StopSound("weapons/mmod/physcannon/physcannon_claws_close.wav")
                self:EmitSound("weapons/mmod/physcannon/physcannon_claws_open.wav")
            end
        end
        
        if (!IsValid(self:GetOwner()) or !self:GetOwner():Alive()) or (!IsValid(worldModel) and !IsValid(viewModel)) or (worldModelCurrent >= 1 and viewModelCurrent >= 1) then
            timer.Remove("scgg_move_claws_open" .. self:EntIndex())
            return
        end
    end
end

function SWEP:CloseClaws(playSound)
    if SERVER then
        return
    end
    
    if !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
        return
    end
    
    local poseParam = "active"
    local viewModel = self:GetOwner():GetViewModel()
    local worldModel = self
    
    timer.Remove("scgg_claw_close_delay" .. self:EntIndex())
    
    local worldModelValue = 0
    local viewModelValue = 0
    
    if IsValid(viewModel) then
        local viewModelPose = viewModel:GetPoseParameter(poseParam)
        viewModelValue = GetPoseParameterValue(viewModel, poseParam, viewModelPose)
    end
    
    if IsValid(worldModel) then
        local worldModelPose = worldModel:GetPoseParameter(poseParam)
        worldModelValue = GetPoseParameterValue(worldModel, poseParam, worldModelPose)
    end
    
    if (worldModel and worldModelValue > 0) or (viewModel and viewModelValue > 0) then
        local worldModelCurrent = worldModelValue
        local viewModelCurrent = viewModelValue
        
        if !timer.Exists("scgg_move_claws_close" .. self:EntIndex()) then
            timer.Remove("scgg_move_claws_open" .. self:EntIndex())
            
            timer.Create("scgg_move_claws_close" .. self:EntIndex(), 0, 20, function()
                if !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
                    timer.Remove("scgg_move_claws_close" .. self:EntIndex())
                    return
                end
                
                local currentViewModel = self:GetOwner():GetViewModel()
                local currentWorldModel = self
                
                if IsValid(currentWorldModel) then
                    if worldModelCurrent < 0 then
                        currentWorldModel:SetPoseParameter(poseParam, 0)
                    end
                    
                    worldModelCurrent = worldModelCurrent - 0.05
                    currentWorldModel:SetPoseParameter(poseParam, worldModelCurrent)
                    currentWorldModel:InvalidateBoneCache()
                end
                
                if IsValid(currentViewModel) then
                    if viewModelCurrent < 0 then
                        currentViewModel:SetPoseParameter(poseParam, 0)
                    end
                    
                    viewModelCurrent = viewModelCurrent - 0.05
                    currentViewModel:SetPoseParameter(poseParam, viewModelCurrent)
                    currentViewModel:InvalidateBoneCache()
                    
                    if viewModelCurrent < 0.5 then
                        self.ClawOpenState = false
                    end
                end
            end)
            
            if (worldModelCurrent >= 1 or viewModelCurrent >= 1) and !IsValid(self:GetHP()) and playSound then
                self:StopSound("weapons/mmod/physcannon/physcannon_claws_open.wav")
                self:EmitSound("weapons/mmod/physcannon/physcannon_claws_close.wav")
            end
        end
        
        if (!IsValid(self:GetOwner()) or !self:GetOwner():Alive()) or (!IsValid(worldModel) and !IsValid(viewModel)) or (worldModelCurrent <= 0 and viewModelCurrent <= 0) then
            timer.Remove("scgg_move_claws_close" .. self:EntIndex())
            return
        end
    end
end

local function CleanupTimers(self)
    timer.Remove("deploy_idle" .. self:EntIndex())
    timer.Remove("attack_idle" .. self:EntIndex())
    timer.Remove("scgg_move_claws_open" .. self:EntIndex())
    timer.Remove("scgg_move_claws_close" .. self:EntIndex())
    timer.Remove("scgg_claw_close_delay" .. self:EntIndex())
end

function SWEP:OwnerChanged()
    if SERVER then
        self:TPrem()
        self:HPrem()
    end
    
    SetWeaponHoldType(self)
end

local function CanPuntEntity(self, entity)
    if IsValid(entity) and self.Fading != true then
        if ((self:AllowedClass(entity) and entity:GetMoveType() == MOVETYPE_VPHYSICS) and 
            (IsValid(entity:GetPhysicsObject()) and entity:GetPhysicsObject():GetMass() < self:GetMaxMass() and IsValidPhysicsEntity(entity) or CLIENT)) or
           (((entity:IsNPC() or entity:IsNextBot()) and 
            ((!ConVarExists("scgg_friendly_fire") or GetConVar("scgg_friendly_fire"):GetBool()) or !self:FriendlyNPC(entity)) and 
            entity:Health() <= self:GetMaxTargetHealth()) or entity:IsPlayer() or entity:IsRagdoll()) and
           !self:NotAllowedClass(entity) then
            return true
        end
    end
    
    return false
end

local function IsEntityInPuntRange(self, entity)
    local distanceSquared = 0
    
    if IsValid(entity) then
        distanceSquared = ((entity:GetPos() - self:GetOwner():GetPos()):LengthSqr()) / self:GetMaxPuntRange()
    else
        distanceSquared = self:GetMaxPuntRange() + 10
    end
    
    if CanPuntEntity(self, entity) and distanceSquared < self:GetMaxPuntRange() then
        return true
    end
    
    return false
end

function SWEP:PickupCheck(entity)
    local distanceSquared = 0
    
    if IsValid(entity) then
        distanceSquared = ((entity:GetPos() - self:GetOwner():GetPos()):LengthSqr()) / self:GetMaxPickupRange()
    else
        distanceSquared = self:GetMaxPickupRange() + 10
    end
    
    if CanPuntEntity(self, entity) and distanceSquared < self:GetMaxPickupRange() then
        return true
    end
    
    return false
end

function SWEP:GetConeEnt(trace)
    local function FindBestEntity(entities)
        local entityList = {}
        
        for _, entity in ipairs(entities) do
            if IsValid(entity) and entity != self and entity != self:GetOwner() then
                local entityCenter = entity:WorldSpaceCenter()
                
                if entityCenter:IsZero() then
                    entityCenter = entity:GetPos()
                end
                
                local lineTrace = util.TraceLine({
                    start = self:GetOwner():EyePos(),
                    endpos = entityCenter,
                    filter = {self, self:GetOwner()},
                    mask = MASK_SHOT_HULL
                })
                
                if lineTrace.Entity == entity then
                    local entityData = {{entity, ((entity:GetPos() - self:GetOwner():EyePos()):LengthSqr()) / self:GetMaxPickupRange()}}
                    table.Add(entityList, entityData)
                end
            end
        end
        
        local distanceList = {}
        
        for _, data in ipairs(entityList) do
            local distanceData = {data[#data]}
            table.Add(distanceList, distanceData)
            
            if data == entityList[#entityList] then
                local bestIndex = table.KeyFromValue(table.SortByKey(distanceList, true), 1)
                local bestEntityData = entityList[bestIndex]
                local bestEntity = bestEntityData[1]
                
                if IsValid(bestEntity) then
                    return bestEntity
                end
            end
        end
    end
    
    local combineBalls = {}
    local npcs = {}
    local ragdolls = {}
    local props = {}
    
    local coneEntities = ents.FindInCone(
        self:GetOwner():EyePos(),
        self:GetOwner():GetAimVector(),
        self:GetMaxPickupRange(),
        self.ConeWidth
    )
    
    for _, entity in ipairs(coneEntities) do
        if CanPuntEntity(self, entity) and entity != self and entity != self:GetOwner() then
            if entity:GetClass() == "prop_combine_ball" then
                local entityData = {entity}
                table.Add(combineBalls, entityData)
            elseif ((entity:IsNPC() or entity:IsNextBot()) and 
                   ((!ConVarExists("scgg_friendly_fire") or GetConVar("scgg_friendly_fire"):GetBool()) or !self:FriendlyNPC(entity))) or 
                   (entity:IsPlayer() and entity:Alive()) then
                local entityData = {entity}
                table.Add(npcs, entityData)
            elseif entity:IsRagdoll() then
                local entityData = {entity}
                table.Add(ragdolls, entityData)
            elseif entity:GetMoveType() == MOVETYPE_VPHYSICS or (self:AllowedClass(entity) and !self:NotAllowedClass(entity)) then
                local entityData = {entity}
                table.Add(props, entityData)
            end
        end
    end
    
    if !table.IsEmpty(combineBalls) then
        return FindBestEntity(combineBalls)
    elseif !table.IsEmpty(npcs) then
        return FindBestEntity(npcs)
    elseif !table.IsEmpty(ragdolls) then
        return FindBestEntity(ragdolls)
    elseif !table.IsEmpty(props) then
        return FindBestEntity(props)
    end
    
    return nil
end

local function CreateFadingWeapon(weapon)
    local spawnPos = weapon:GetPos()
    
    if IsValid(weapon.Owner) then
        spawnPos = weapon.Owner:EyePos()
    end
    
    local newWeapon = ents.Create("weapon_physcannon")
    newWeapon:SetPos(spawnPos)
    newWeapon:SetAngles(weapon:GetAngles())
    newWeapon:Spawn()
    newWeapon:Activate()
    
    if IsValid(weapon.FadeCore) then
        weapon.FadeCore:SetParent(newWeapon)
    end
    
    local oldPhysics = weapon:GetPhysicsObject()
    local newPhysics = newWeapon:GetPhysicsObject()
    
    if IsValid(oldPhysics) and IsValid(newPhysics) then
        newPhysics:SetVelocity(oldPhysics:GetVelocity())
        newPhysics:AddAngleVelocity(oldPhysics:GetAngleVelocity())
    end
    
    cleanup.ReplaceEntity(weapon, newWeapon)
    undo.ReplaceEntity(weapon, newWeapon)
    undo.Finish()
    
    return newWeapon
end

if SERVER then
    function SWEP:Discharge()
        if self.Fading == true or IsValid(self.FadeCore) then
            return
        end
        
        self.Fading = true
        
        if IsValid(self:GetHP()) then
            self:Drop()
        end
        
        self:EmitSound("Weapon_Physgun.Off", 75, 100, 0.6)
        self:CloseClaws(false)
        
        local weapon = self
        local attachmentPoint = "core"
        
        if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
            attachmentPoint = "muzzle"
        end
        
        local energyCore = ents.Create("env_citadel_energy_core")
        
        energyCore:SetPos(self:GetPos())
        energyCore:SetAngles(self:GetAngles())
        energyCore:SetParent(self)
        energyCore:Spawn()
        energyCore:Fire("SetParentAttachment", attachmentPoint, 0)
        energyCore:Fire("AddOutput", "scale 1.5", 0)
        energyCore:Fire("StartDischarge", "", 0.1)
        energyCore:Fire("ClearParent", "", 0.89)
        energyCore:Fire("Stop", "", 0.9)
        energyCore:Fire("Kill", "", 1.9)
        
        self.FadeCore = energyCore
        
        timer.Simple(0.20, function()
            if !IsValid(self) or !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():IsPlayer() then
                return
            end
            
            self:PlayAnim("holster")
        end)
        
        timer.Simple(0.90, function()
            if !IsValid(self) then
                return
            end
            
            if IsValid(self.FadeCore) then
                self.FadeCore:Remove()
            end
            
            local newWeapon = CreateFadingWeapon(self)
            
            if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
                if self:GetOwner():HasWeapon("weapon_physcannon") and 
                   IsValid(self:GetOwner():GetActiveWeapon()) and 
                   self:GetOwner():GetActiveWeapon() == self then
                    self:GetOwner():SelectWeapon("weapon_physcannon")
                end
            end
            
            local weaponClass = self:GetClass()
            
            if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and 
               self:GetOwner():HasWeapon(weaponClass) and 
               self:GetOwner():GetWeapon(weaponClass) == self then
                self:GetOwner():StripWeapon(weaponClass)
            else
                if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then
                    self:GetOwner():DropWeapon(self)
                end
                
                self:Remove()
            end
        end)
    end
    
    function SWEP:ThinkAdd()
        local heldEntity = self:GetHP()
        local styleCvar = false
        
        if ConVarExists("scgg_style") then
            styleCvar = GetConVar("scgg_style"):GetBool()
        end
        
        if !styleCvar then
            self.SwayScale = 3
            self.BobScale = 1
        else
            self.SwayScale = 1
            self.BobScale = 1
        end
        
        if SERVER and ConVarExists("scgg_enabled") and GetConVar("scgg_enabled"):GetInt() <= 0 and !self.Fading then
            self:Discharge()
        end
        
        if SERVER then
            if IsValid(self.Core) then
                self.Core:SetPos(self:GetOwner():GetShootPos())
            end
        end
        
        local traceEntity = nil
        
        if CLIENT then
            if self:PickupCheck(traceEntity) then
                self:OpenClaws(true)
            elseif IsValid(heldEntity) and self.Fading != true then
                timer.Remove("scgg_move_claws_close" .. self:EntIndex())
                self:OpenClaws(false)
            else
                if !timer.Exists("scgg_claw_close_delay" .. self:EntIndex()) and IsValid(self) then
                    timer.Create("scgg_claw_close_delay" .. self:EntIndex(), 0.6, 1, function()
                        if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():Alive() and IsValid(self:GetOwner():GetViewModel()) then
                            self:CloseClaws(true)
                            self:OpenClaws(false, true)
                        end
                    end)
                end
            end
        end
        
        if SERVER then
            if IsValid(heldEntity) and !self.Fading then
                self:GlowEffect()
            else
                self:RemoveGlow()
            end
        end
        
        if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
            if !self:GetOwner():KeyDown(IN_ATTACK) then
                if ConVarExists("scgg_primary_extra") and bit.band(GetConVar("scgg_primary_extra"):GetInt(), 1) == 1 then
                    self:SetNextPrimaryFire(CurTime() - 0.55)
                end
            end
            
            if SERVER then
                if self:GetOwner():KeyPressed(IN_ATTACK2) and !self.Fading then
                    if IsValid(traceEntity) and traceEntity:GetMoveType() == MOVETYPE_VPHYSICS then
                        local mass = traceEntity:GetPhysicsObject():GetMass()
                        
                        if mass > self:GetMaxMass() then
                            self:EmitSound("weapons/mmod/physcannon/physcannon_tooheavy.wav")
                            return
                        end
                    else
                        self:EmitSound("weapons/mmod/physcannon/physcannon_tooheavy.wav")
                        return
                    end
                end
            end
        end
        
        if IsValid(self:GetTP()) then
            for _, child in ipairs(self:GetTP():GetChildren()) do
                if child:GetClass() == "env_entity_dissolver" then
                    child:Remove()
                    break
                end
            end
        end
        
        if IsValid(heldEntity) then
            if !IsValid(self:GetOwner()) or !IsEntityAlive(self:GetOwner()) then
                self:Drop()
            end
            
            if SERVER then
                local physicsObject = nil
                
                if heldEntity:IsRagdoll() and self.HPBone != nil and util.IsValidPhysicsObject(heldEntity, self.HPBone) then
                    physicsObject = heldEntity:GetPhysicsObjectNum(self.HPBone)
                end
                
                if !IsValid(physicsObject) then
                    if IsValid(heldEntity:GetPhysicsObject()) then
                        physicsObject = heldEntity:GetPhysicsObject()
                    else
                        physicsObject = heldEntity
                    end
                end
                
                if !IsValid(self:GetOwner()) then
                    return
                end
                
                local boundingRadius = heldEntity:BoundingRadius()
                local grabPosition = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * (self.GrabDistance + boundingRadius)
                local ragdollGrabPosition = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * (self.GrabDistanceRagdoll + boundingRadius)
                
                local function IsEntityNearPosition(entity, position, ownerPos)
                    local nearEntities = ents.FindInSphere(position, 5)
                    local nearOwnerEntities = ents.FindInSphere(ownerPos, 15)
                    
                    for _, nearEntity in ipairs(nearEntities) do
                        if IsValid(nearEntity) and nearEntity == entity then
                            return true
                        end
                    end
                    
                    for _, nearEntity in ipairs(nearOwnerEntities) do
                        if IsValid(nearEntity) and nearEntity == entity then
                            return true
                        end
                    end
                    
                    return false
                end
                
                local pullDirection = self:GetOwner():GetShootPos() - heldEntity:WorldSpaceCenter()
                pullDirection:Normalize()
                pullDirection = pullDirection * self:GetPullForce(heldEntity)
                
                local mass = 50.0
                
                if physicsObject != heldEntity then
                    mass = physicsObject:GetMass()
                end
    
                pullDirection = pullDirection * (mass + 0.5) * (1 / 5.0)
                
                if !IsEntityNearPosition(heldEntity, grabPosition, self:GetOwner():GetShootPos()) and !IsValid(self:GetTP()) or CheckHookPhysics(self, heldEntity) then
                    if physicsObject != heldEntity then
                        physicsObject:SetVelocityInstantaneous(Vector(0, 0, 0))
                        physicsObject:AddAngleVelocity(physicsObject:GetAngleVelocity() * -1)
                        physicsObject:ApplyForceCenter(pullDirection)
                    else
                        physicsObject:SetVelocity(Vector(0, 0, 0))
                    end
                elseif IsValid(self:GetTP()) then
                    if heldEntity:IsRagdoll() then
                        self:GetTP():SetPos(ragdollGrabPosition)
                    else
                        self:GetTP():SetPos(grabPosition)
                    end
                    
                    self:GetTP():PointAtEntity(self:GetOwner())
                else
                    self:CreateTP()
                end
                
                local entityAngles = heldEntity:GetAngles()
                heldEntity:SetAngles(Angle(0, entityAngles.y, entityAngles.r))
                
                if IsValid(physicsObject) then
                    if physicsObject != heldEntity then
                        physicsObject:Wake()
                    else
                        physicsObject:Fire("Wake")
                    end
                end
            end
            
            if self.PropLockTime == nil then
                self.PropLockTime = CurTime() + 1.75
            end
            
            if !styleCvar and CurTime() >= self.PropLockTime then
                if !IsValid(heldEntity) then
                    self:SetHP(nil)
                    return
                end
                
                local boundingRadius = heldEntity:BoundingRadius()
                
                if ((heldEntity:GetPos() - (self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * (self.GrabDistance + boundingRadius))):LengthSqr()) / 80 >= 80 then
                    self:Drop()
                end
            end
        elseif self.HP_PickedUp then
            self:Drop()
            self.HP_PickedUp = nil
        end
    end
end

local nonPickupableEntities = {
    ["npc_strider"] = true,
    ["npc_helicopter"] = true,
    ["npc_combinedropship"] = true,
    ["npc_antliongrub"] = true,
    ["npc_turret_ceiling"] = true,
    ["npc_sniper"] = true,
    ["npc_combine_camera"] = true,
    ["npc_combinegunship"] = true,
    ["npc_bullseye"] = true,
    ["prop_ragdoll"] = true,
    ["npc_alyx"] = true,
    ["npc_barney"] = true,
    ["npc_breen"] = true,
    ["npc_citizen"] = true,
    ["npc_dog"] = true,
    ["npc_eli"] = true,
    ["npc_gman"] = true,
    ["npc_kleiner"] = true,
    ["npc_magnusson"] = true,
    ["npc_mossman"] = true,
    ["npc_odessa"] = true,
    ["npc_vortigaunt"] = true,
    ["npc_monk"] = true,
    ["npc_antlionguard"] = true,
    ["npc_antlionguardian"] = true,
}

function SWEP:NotAllowedClass(entity)
    if !IsValid(entity) then
        return false
    end
    
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and entity:IsPlayer() then
        return true
    end
    
    local entityClass = entity:GetClass()
    
    if nonPickupableEntities[entityClass] then
        return true
    else
        return false
    end
end

function SWEP:AllowedClass(entity)
    if !IsValid(entity) then
        return false
    end
    
    local entityClass = entity:GetClass()
    
    for _, child in ipairs(entity:GetChildren()) do
        if child:GetClass() == "env_entity_dissolver" then
            return false
        end
    end
    
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and entity:IsPlayer() then
        return false
    end
    
    if !entity:IsNPC() and !entity:IsPlayer() and !entity:IsNextBot() and !entity:IsRagdoll() and 
       ConVarExists("scgg_allow_others") and GetConVar("scgg_allow_others"):GetBool() and 
       !self:NotAllowedClass(entity) then
        return true
    end
    
    if entityClass == "npc_manhack" or 
       entityClass == "npc_turret_floor" or 
       entityClass == "npc_sscanner" or 
       entityClass == "npc_cscanner" or 
       entityClass == "npc_clawscanner" or 
       entityClass == "npc_rollermine" or 
       entityClass == "npc_grenade_frag" or 
       entityClass == "item_ammo_357" or 
       entityClass == "item_ammo_ar2_altfire" or 
       entityClass == "item_ammo_crossbow" or 
       entityClass == "item_ammo_pistol" or 
       entityClass == "item_ammo_smg1" or 
       entityClass == "item_ammo_smg1_grenade" or 
       entityClass == "item_battery" or 
       entityClass == "item_box_buckshot" or 
       entityClass == "item_healthvial" or 
       entityClass == "item_healthkit" or 
       entityClass == "item_rpg_round" or 
       entityClass == "item_ammo_ar2" or 
       entityClass == "item_item_crate" or 
       (entity:IsWeapon() and !IsValid(entity:GetOwner())) or 
       entityClass == "megaphyscannon" or 
       entityClass == "weapon_striderbuster" or 
       entityClass == "combine_mine" or 
       entityClass == "bounce_bomb" or 
       entityClass == "combine_bouncemine" or 
       entityClass == "gmod_camera" or 
       entityClass == "gmod_cameraprop" or 
       entityClass == "helicopter_chunk" or 
       entityClass == "func_physbox" or 
       entityClass == "func_pushable" or 
       entityClass == "grenade_helicopter" or 
       entityClass == "prop_combine_ball" or 
       entityClass == "gmod_wheel" or 
       entityClass == "prop_vehicle_prisoner_pod" or 
       entityClass == "prop_physics_respawnable" or 
       entityClass == "prop_physics_multiplayer" or 
       entityClass == "prop_physics_override" or 
       entityClass == "prop_physics" or 
       entityClass == "prop_dynamic" then
        return true
    else
        return false
    end
end

function SWEP:FriendlyNPC(entity)
    if SERVER then
        if !IsValid(entity) then
            return false
        end
        
        if !entity:IsNPC() then
            return false
        end
        
        if entity:Disposition(self:GetOwner()) == (D_LI or D_NU or D_ER) then
            return true
        else
            return false
        end
    else
        return false
    end
end

local function SetupManhackDamage(weapon, manhack)
    if !IsValid(manhack) then
        return
    end
    
    local manhackClass = manhack:GetClass()
    
    if manhackClass != "npc_manhack" then
        return
    end
    
    manhack.SCGG_HurtByHookPhys = nil
    
    local function OnPhysicsCollide(manhackEntity, collisionData)
        local collisionSpeed = collisionData.OurOldVelocity:LengthSqr() / 1550
        
        if !manhackEntity.SCGG_HurtByHookPhys and collisionSpeed > 250 then
            manhackEntity.SCGG_HurtByHookPhys = true
            
            local damageInfo = DamageInfo()
            damageInfo:SetDamage(collisionSpeed / 10)
            damageInfo:SetDamageForce(weapon:GetOwner():GetPos())
            damageInfo:SetReportedPosition(weapon:GetOwner():GetPos())
            damageInfo:SetAttacker(weapon:GetOwner())
            damageInfo:SetInflictor(weapon)
            
            manhackEntity:TakeDamageInfo(damageInfo)
            
            if IsValid(collisionData.HitEntity) and collisionData.HitEntity:Health() > 0 and 
               ((!ConVarExists("scgg_friendly_fire") or GetConVar("scgg_friendly_fire"):GetBool()) or !weapon:FriendlyNPC(collisionData.HitEntity)) then
                collisionData.HitEntity:TakeDamageInfo(damageInfo)
            end
        end
    end
    
    local callbackID = manhack:AddCallback("PhysicsCollide", OnPhysicsCollide)
    
    timer.Simple(1.0, function()
        if IsValid(manhack) then
            manhack:RemoveCallback("PhysicsCollide", callbackID)
        end
    end)
end

local function DealDamageToEntity(weapon, target, damagePosition, fullDamage)
    if !SERVER then
        return
    end
    
    if fullDamage == nil then
        fullDamage = true
    end
    
    local damageInfo = DamageInfo()
    damageInfo:SetDamageForce(weapon:GetOwner():GetShootPos())
    damageInfo:SetDamageType(DMG_PHYSGUN)
    damageInfo:SetAttacker(weapon:GetOwner())
    damageInfo:SetInflictor(weapon)
    damageInfo:SetReportedPosition(weapon:GetOwner():GetShootPos())
    
    if fullDamage then
        damageInfo:SetDamage(weapon:GetMaxTargetHealth())
        damageInfo:SetDamagePosition(damagePosition)
    else
        damageInfo:SetDamage(target:Health())
    end
    
    if target:IsPlayer() then
        target:TakeDamageInfo(damageInfo)
    elseif target:IsNPC() or target:IsNextBot() then
        if target:GetShouldServerRagdoll() != true then
            target:SetShouldServerRagdoll(true)
        end
        
        target:TakeDamageInfo(damageInfo)
    end
end

local function CreateRagdollFromEntity(weapon, entity, applyForce)
    if !SERVER then
        return nil
    end
    
    local existingRagdoll = nil
    
    if applyForce == nil then
        applyForce = true
    end
    
    for _, ragdoll in ipairs(ents.FindInSphere(entity:GetPos(), entity:GetModelRadius())) do
        if ragdoll:IsRagdoll() and ragdoll:GetCreationTime() == CurTime() then
            existingRagdoll = ragdoll
            break
        end
    end
    
    local isNewRagdoll = false
    
    if !IsValid(existingRagdoll) and entity:GetClass() != "npc_antlion_worker" and 
       (entity:GetClass() != "npc_antlion" or entity:GetModel() != "models/antlion_worker.mdl") then
        local newRagdoll = ents.Create("prop_ragdoll")
        newRagdoll:SetPos(entity:GetPos())
        newRagdoll:SetAngles(entity:GetAngles() - Angle(entity:GetAngles().p, 0, 0))
        newRagdoll:SetModel(entity:GetModel())
        
        if entity:GetSkin() then
            newRagdoll:SetSkin(entity:GetSkin())
        end
        
        newRagdoll:SetColor(entity:GetColor())
        
        for _, bodygroup in pairs(entity:GetBodyGroups()) do
            newRagdoll:SetBodygroup(bodygroup.id, entity:GetBodygroup(bodygroup.id))
        end
        
        newRagdoll:SetMaterial(entity:GetMaterial())
        
        if !applyForce then
            newRagdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        end
        
        newRagdoll:SetKeyValue("spawnflags", 8192)
        newRagdoll:Spawn()
        
        existingRagdoll = newRagdoll
        isNewRagdoll = true
    elseif !applyForce and !IsValid(existingRagdoll) then
        for _, ragdoll in ipairs(ents.FindInSphere(entity:GetPos(), entity:GetModelRadius())) do
            if (ragdoll:IsRagdoll() or ragdoll:GetClass() == "prop_physics") and ragdoll:GetCreationTime() == CurTime() then
                existingRagdoll = ragdoll
                break
            end
        end
    end
    
    if (entity:IsNPC() or entity:IsPlayer()) and IsValid(entity:GetActiveWeapon()) then
        local activeWeapon = entity:GetActiveWeapon()
        local weaponClass = activeWeapon:GetClass()
        
        if entity:IsNPC() then
            local shouldVaporize = false
            
            if ConVarExists("scgg_weapon_vaporize") then
                shouldVaporize = GetConVar("scgg_weapon_vaporize"):GetBool()
            end
            
            if !shouldVaporize then
                local weaponModel = ents.Create(weaponClass)
                
                if IsValid(weaponModel) then
                    weaponModel:SetPos(entity:GetShootPos())
                    weaponModel:SetAngles(activeWeapon:GetAngles() - Angle(activeWeapon:GetAngles().p, 0, 0))
                    weaponModel:SetSkin(activeWeapon:GetSkin())
                    weaponModel:SetColor(activeWeapon:GetColor())
                    weaponModel:SetKeyValue("spawnflags", "2")
                    weaponModel:Spawn()
                    weaponModel:Fire("Addoutput", "spawnflags 0", 1)
                end
            elseif shouldVaporize then
                if IsValid(weaponModel) then
                    local weaponModel = ents.Create("prop_physics_override")
                    weaponModel:SetPos(entity:GetShootPos())
                    weaponModel:SetAngles(activeWeapon:GetAngles() - Angle(activeWeapon:GetAngles().p, 0, 0))
                    weaponModel:SetModel(activeWeapon:GetModel())
                    weaponModel:SetSkin(activeWeapon:GetSkin())
                    weaponModel:SetColor(activeWeapon:GetColor())
                    weaponModel:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    weaponModel:Spawn()
                    DissolveEntity(weaponModel)
                end
            end
        end
    end
    
    if self:GetOwner():IsPlayer() and isNewRagdoll == true and IsValid(existingRagdoll) then
        cleanup.Add(self:GetOwner(), "props", existingRagdoll)
        
        undo.Create("Ragdoll")
        undo.AddEntity(existingRagdoll)
        undo.SetPlayer(self:GetOwner())
        undo.Finish()
    end
    
    if entity:IsPlayer() then
        if IsValid(entity:GetRagdollEntity()) and entity:GetRagdollEntity() != existingRagdoll then
            entity:GetRagdollEntity():Remove()
        end
        
        entity:SpectateEntity(existingRagdoll)
        entity:Spectate(OBS_MODE_CHASE)
    elseif entity:IsNPC() or entity:IsNextBot() then
        entity:Fire("Kill", "", 0)
    end
    
    if (applyForce or isNewRagdoll == true) and IsValid(existingRagdoll) then
        for boneIndex = 1, existingRagdoll:GetPhysicsObjectCount() - 1 do
            local physicsObject = existingRagdoll:GetPhysicsObjectNum(boneIndex)
            
            if physicsObject and IsValid(physicsObject) then
                if isNewRagdoll == true then
                    local bonePosition, boneAngles = entity:GetBonePosition(existingRagdoll:TranslatePhysBoneToBone(boneIndex))
                    physicsObject:SetPos(bonePosition)
                    physicsObject:SetAngles(boneAngles)
                end
                
                if applyForce then
                    timer.Simple(0.01, function()
                        if IsValid(self) and IsValid(self:GetOwner()) and IsValid(physicsObject) then
                            if !styleCvar then
                                physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (13000 / 8))
                            else
                                physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply))
                            end
                        end
                    end)
                end
            end
        end
    end
    
    return existingRagdoll
end

function SWEP:PrimaryAttack()
    if self.Fading or PrimaryFired then
        return
    end
    
    local heldEntity = self:GetHP()
    
    self:PlayAnim("attack")
    self:SetNextPrimaryFire(CurTime() + 0.55)
    
    if self:GetOwner():IsPlayer() then
        timer.Create("attack_idle" .. self:EntIndex(), 0.4, 1, function()
            if !IsValid(self) then
                return
            end
            
            if IsValid(self:GetOwner()) and IsValid(self) and 
               self:GetOwner():GetActiveWeapon() == self and self.Fading == false then
                self:PlayAnim("idle")
            end
        end)
    end
    
    if IsValid(heldEntity) then
        local boundingRadius = heldEntity:BoundingRadius()
        
        if ((heldEntity:GetPos() - (self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * (self.GrabDistance + boundingRadius))):LengthSqr()) / 80 >= 80 then
            return
        else
            self:DropAndShoot()
            return
        end
    end
    
    local trace = GetEyeTrace(self, self:GetOwner())
    local traceEntity = trace.Entity
    
    if !IsEntityInPuntRange(self, traceEntity) then
        self:EmitSound("weapons/mmod/physcannon/physcannon_dryfire.wav")
        return
    end
    
    self:Visual(trace)
    
    local styleCvar = false
    
    if ConVarExists("scgg_style") then
        styleCvar = GetConVar("scgg_style"):GetBool()
    end
    
    local shouldZap = true
    
    if ConVarExists("scgg_zap") then
        shouldZap = GetConVar("scgg_zap"):GetBool()
    end
    
    if SERVER then
        if ((traceEntity:IsNPC() or traceEntity:IsNextBot()) and !self:AllowedClass(traceEntity) and !self:NotAllowedClass(traceEntity) or traceEntity:IsPlayer()) then
            DealDamageToEntity(self, traceEntity, trace.HitPos, true)
            
            if traceEntity:Health() > 0 then
                traceEntity:SetVelocity(self:GetOwner():GetAimVector() * Vector(2500, 2500, 0))
                return
            end
            
            local ragdoll = CreateRagdollFromEntity(self, traceEntity, true)
            
            if shouldZap and IsValid(ragdoll) then
                ragdoll:SCGG_RagdollZapper()
            end
            
            if IsValid(ragdoll) then
                ragdoll:SCGG_RagdollCollideTimer()
                ragdoll:SetPhysicsAttacker(self:GetOwner(), 10)
                ragdoll:SetCollisionGroup(self.HPCollideG)
                ragdoll:SetMaterial(traceEntity:GetMaterial())
                ragdoll:Fire("FadeAndRemove", "", 120)
            end
            
            if self:GetOwner():IsPlayer() then
                self:GetOwner():AddFrags(1)
            end
            
            if shouldZap and IsValid(ragdoll) then
                ragdoll:Fire("StartRagdollBoogie", "", 0)
            end
        elseif traceEntity:GetMoveType() != MOVETYPE_VPHYSICS and traceEntity:Health() > 0 then
            local damageInfo = DamageInfo()
            damageInfo:SetDamage(self:GetMaxTargetHealth())
            damageInfo:SetDamageForce(self:GetOwner():GetShootPos())
            damageInfo:SetDamagePosition(trace.HitPos)
            damageInfo:SetDamageType(DMG_PHYSGUN)
            damageInfo:SetAttacker(self:GetOwner())
            damageInfo:SetInflictor(self)
            damageInfo:SetReportedPosition(self:GetOwner():GetShootPos())
            
            traceEntity:TakeDamageInfo(damageInfo)
        end
    end
    
    if IsValidPhysicsEntity(traceEntity) then
        traceEntity:GetPhysicsObject():EnableMotion(true)
    end
    
    if self:AllowedClass(traceEntity) or 
       traceEntity:GetClass() == "prop_vehicle_airboat" or 
       traceEntity:GetClass() == "prop_vehicle_jeep" or 
       (!self:NotAllowedClass() and IsValid(traceEntity:GetPhysicsObject())) then
        if traceEntity:GetClass() == "prop_combine_ball" and IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
            self:GetOwner():SimulateGravGunPickup(traceEntity)
            
            timer.Simple(0.01, function()
                if IsValid(traceEntity) and IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
                    self:GetOwner():SimulateGravGunDrop(traceEntity)
                end
            end)
        end
        
        if SERVER then
            if !IsValid(traceEntity) or !IsValid(traceEntity:GetPhysicsObject()) then
                return
            end
            
            local hitPosition = trace.HitPos
            local physicsObject = traceEntity:GetPhysicsObject()
            
            if !styleCvar then
                if traceEntity:GetClass() == "prop_combine_ball" or traceEntity:GetClass() == "npc_grenade_frag" then
                    physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * 480000)
                    physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * 480000, hitPosition)
                    traceEntity:SetOwner(self:GetOwner())
                else
                    physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply))
                    physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply), hitPosition)
                end
            else
                if traceEntity:GetClass() == "prop_combine_ball" then
                    physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector())
                    physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector(), hitPosition)
                    traceEntity:SetOwner(self:GetOwner())
                else
                    physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply))
                    physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply), hitPosition)
                end
            end
            
            traceEntity:SetPhysicsAttacker(self:GetOwner(), 10)
        end
        
        SetupManhackDamage(self, traceEntity)
        traceEntity:SetSaveValue("m_flEngineStallTime", 2.0)
        traceEntity:SetSaveValue("m_hPhysicsAttacker", self:GetOwner())
    end
    
    if traceEntity:IsRagdoll() then
        if SERVER then
            traceEntity:SetPhysicsAttacker(self:GetOwner(), 10)
            
            if shouldZap then
                traceEntity:Fire("StartRagdollBoogie", "", 0)
            end
        end
        
        traceEntity:SCGG_RagdollZapper()
        traceEntity:SCGG_RagdollCollideTimer()
        
        local owner = self:GetOwner()
        local character = hg.GetCurrentCharacter(owner)
        
        if not character:IsRagdoll() then
            hg.AddForceRag(owner, 2, owner:EyeAngles():Forward() * -10000, 0.5)
            hg.AddForceRag(owner, 0, owner:EyeAngles():Forward() * -10000, 0.5)
            hg.LightStunPlayer(owner, 1)
        end
        
        character:GetPhysicsObjectNum(0):SetVelocity(character:GetVelocity() + owner:EyeAngles():Forward() * -2000)
        
        for boneIndex = 1, traceEntity:GetPhysicsObjectCount() - 1 do
            local physicsObject = traceEntity:GetPhysicsObjectNum(boneIndex)
            
            if physicsObject and physicsObject.IsValid and physicsObject:IsValid() then
                if !styleCvar then
                    physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (10000 / 8))
                else
                    physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (traceEntity:GetPhysicsObject():GetMass() * self.PuntMultiply))
                end
            end
        end
        
        if SERVER then
            traceEntity:SetCollisionGroup(self.HPCollideG)
        end
    end
    
    if self:AllowedClass(traceEntity) and !traceEntity:IsRagdoll() and SERVER then
        local damageInfo = DamageInfo()
        damageInfo:SetDamage(10)
        damageInfo:SetDamageForce(self:GetOwner():GetShootPos())
        damageInfo:SetDamagePosition(traceEntity:GetPos())
        damageInfo:SetDamageType(DMG_PHYSGUN)
        damageInfo:SetAttacker(self:GetOwner())
        damageInfo:SetInflictor(self)
        damageInfo:SetReportedPosition(self:GetOwner():GetShootPos())
        
        traceEntity:TakeDamageInfo(damageInfo)
    end
end

function SWEP:DropAndShoot()
    if !IsValid(self) then
        return
    end
    
    self:DropGeneral()
    
    local heldEntity = self:GetHP()
    
    if !IsValid(heldEntity) then
        self:HPrem()
        return
    end
    
    if SERVER then
        heldEntity:Fire("EnablePhyscannonPickup", "", 1)
    end
    
    local entityHealth = heldEntity:Health()
    
    if entityHealth != nil and entityHealth > 0 and self.HPHealth != nil and self.HPHealth > 0 then
        heldEntity:SetHealth(self.HPHealth)
        self.HPHealth = -1
    end
    
    if SERVER then
        if heldEntity:IsRagdoll() then
            heldEntity:SetCollisionGroup(COLLISION_GROUP_NONE)
        else
            heldEntity:SetCollisionGroup(self.HPCollideG)
        end
        
        heldEntity:SetPhysicsAttacker(self:GetOwner(), 10)
        self:GetOwner():SimulateGravGunDrop(heldEntity)
    end
    
    if heldEntity:GetClass() == "prop_combine_ball" then
        heldEntity:SetSaveValue("m_bLaunched", true)
    end
    
    SetupManhackDamage(self, heldEntity)
    heldEntity:SetSaveValue("m_flEngineStallTime", 2.0)
    heldEntity:SetSaveValue("m_hPhysicsAttacker", self:GetOwner())
    
    local styleCvar = false
    
    if ConVarExists("scgg_style") then
        styleCvar = GetConVar("scgg_style"):GetBool()
    end
    
    local shouldZap = true
    
    if ConVarExists("scgg_zap") then
        shouldZap = GetConVar("scgg_zap"):GetBool()
    end
    
    self.Secondary.Automatic = true
    
    if styleCvar then
        self:SetNextSecondaryFire(CurTime() + 0.5)
        self:SetNextPrimaryFire(CurTime() + 0.55)
    end
    
    local trace = GetEyeTrace(self, self:GetOwner())
    
    self:Visual(trace)
    
    if IsValid(heldEntity) and heldEntity:IsRagdoll() then
        local damageInfo = DamageInfo()
        damageInfo:SetDamage(500)
        damageInfo:SetAttacker(self:GetOwner())
        damageInfo:SetInflictor(self)
        
        if SERVER and shouldZap then
            heldEntity:Fire("StartRagdollBoogie", "", 0)
        end
        
        for boneIndex = 1, heldEntity:GetPhysicsObjectCount() - 1 do
            local physicsObject = heldEntity:GetPhysicsObjectNum(boneIndex)
            
            if physicsObject and physicsObject.IsValid and physicsObject:IsValid() then
                if shouldZap then
                    heldEntity:SCGG_RagdollZapper()
                end
                
                heldEntity:SCGG_RagdollCollideTimer()
                
                if IsValid(physicsObject) then
                    if !styleCvar then
                        physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (20000 / 8))
                    elseif IsValid(heldEntity:GetPhysicsObject()) then
                        physicsObject:AddVelocity(self:GetOwner():GetAimVector() * (heldEntity:GetPhysicsObject():GetMass() * self.PuntMultiply))
                    end
                end
            end
        end
    elseif IsValid(heldEntity) and IsValid(heldEntity:GetPhysicsObject()) then
        local hitPosition = trace.HitPos
        local entity = heldEntity
        
        timer.Simple(0.01, function()
            if !IsValid(entity) or !IsValid(entity:GetPhysicsObject()) or !IsValid(self) or !IsValid(self:GetOwner()) then
                return
            end
            
            local physicsObject = entity:GetPhysicsObject()
            
            if !styleCvar and entity:GetClass() == "prop_combine_ball" then
                physicsObject:SetVelocity(Vector(0, 0, 0))
                physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * 480000)
                physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * 480000, hitPosition)
                entity:SetOwner(self:GetOwner())
            elseif entity:GetClass() == "prop_combine_ball" then
                physicsObject:SetVelocity(Vector(0, 0, 0))
                physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * self.PuntForce / 0.125)
                physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * self.PuntForce / 0.125, hitPosition)
                entity:SetOwner(self:GetOwner())
            elseif !styleCvar then
                physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply))
                physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * (physicsObject:GetMass() * self.PuntMultiply), hitPosition)
            else
                physicsObject:ApplyForceCenter(self:GetOwner():GetAimVector() * self.PuntForce)
                physicsObject:ApplyForceOffset(self:GetOwner():GetAimVector() * self.PuntForce, hitPosition)
            end
            
            physicsObject:AddAngleVelocity(physicsObject:GetAngleVelocity() * -1)
        end)
    end
    
    if self.HPCollideG then
        self.HPCollideG = COLLISION_GROUP_NONE
    end
    
    if IsValid(self:GetTP()) then
        self:TPrem()
    end
    
    self:HPrem()
end

function SWEP:SecondaryAttack()
    if self.Fading == true then
        return
    end
    
    if IsValid(self:GetHP()) and self:GetOwner():IsPlayer() and self:GetOwner():KeyPressed(IN_ATTACK2) then
        self:PlayAnim("attack")
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:Drop()
        return
    end
    
    local trace = GetEyeTrace(self, self:GetOwner())
    local traceEntity = trace.Entity
    local targetEntity = nil
    
    targetEntity = traceEntity
    
    self:CloseClaws(false)
    
    if !IsValid(targetEntity) then
        return
    end
    
    local styleCvar = false
    
    if ConVarExists("scgg_style") then
        styleCvar = GetConVar("scgg_style"):GetBool()
    end
    
    if (!styleCvar) and ((targetEntity:IsNPC() or targetEntity:IsNextBot() or targetEntity:IsPlayer()) and targetEntity:Health() > self:GetMaxTargetHealth()) or 
       (targetEntity:IsNPC() and targetEntity:GetClass() == "npc_bullseye") or 
       ((targetEntity:IsNPC() or targetEntity:IsNextBot() or targetEntity:IsPlayer() or targetEntity:IsRagdoll()) and 
        !util.IsValidRagdoll(targetEntity:GetModel()) and !util.IsValidProp(targetEntity:GetModel())) then
        return
    end
    
    local maxPickupRange = self:GetMaxPickupRange()
    local distanceSquared = ((targetEntity:GetPos() - self:GetOwner():GetPos()):LengthSqr()) / maxPickupRange
    
    local hasPickedUp = false
    
    local function PickupEntity(entity)
        if hasPickedUp == true then
            return
        end
        
        hasPickedUp = true
        
        self:PlayAnim("attack")
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:SetHP(entity)
        self.HP_PickedUp = true
        
        if self:GetOwner():IsPlayer() then
            self:GetOwner():SimulateGravGunPickup(entity)
        end
        
        self.HPCollideG = entity:GetCollisionGroup()
        entity.EmergencyHPCollide = entity:GetCollisionGroup()
        entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        
        self:Pickup()
        self:SetNextSecondaryFire(CurTime() + 0.2)
        
        if styleCvar then
            self:SetNextPrimaryFire(CurTime() + 0.1)
        end
        
        self.Secondary.Automatic = false
        
        if entity:IsRagdoll() then
            if trace.Entity == entity then
                self.HPBone = trace.PhysicsBone
            end
        end
    end
    
    if SERVER and !self:NotAllowedClass(targetEntity) and !self:AllowedClass(targetEntity) and distanceSquared < maxPickupRange then
        if targetEntity:IsPlayer() and targetEntity:HasGodMode() == true then
            return
        end
        
        if targetEntity:IsNPC() or targetEntity:IsNextBot() and 
           ((!ConVarExists("scgg_friendly_fire") or GetConVar("scgg_friendly_fire"):GetBool()) or !self:FriendlyNPC(targetEntity)) or 
           targetEntity:IsPlayer() then
            DealDamageToEntity(self, targetEntity, trace.HitPos, false)
            
            if targetEntity:Health() >= 1 then
                return
            end
            
            local ragdoll = CreateRagdollFromEntity(self, targetEntity, false)
            PickupEntity(ragdoll)
        end
    end
    
    if SERVER and !hasPickedUp and IsValid(targetEntity:GetPhysicsObject()) and targetEntity:GetMoveType() == MOVETYPE_VPHYSICS then
        if IsValidPhysicsEntity(targetEntity) then
            targetEntity:GetPhysicsObject():EnableMotion(true)
        end
        
        local entityMass = targetEntity:GetPhysicsObject():GetMass()
        local pullForce = self:GetPullForce() / (distanceSquared * 0.002)
        local ragdollPullForce = self.HL2PullForceRagdoll / (distanceSquared * 0.001)
        
        if !styleCvar then
            if entityMass >= (self:GetMaxMass() + 1) and targetEntity:GetClass() != "prop_combine_ball" then
                return
            end
        end
        
        if distanceSquared < maxPickupRange then
            PickupEntity(targetEntity)
        else
            targetEntity:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetAimVector() * -pullForce)
        end
    end
end

function SWEP:Pickup()
    local heldEntity = self:GetHP()
    
    if !IsValid(heldEntity) then
        self:PlayAnim("attack")
        return
    end
    
    self:StopSound("weapons/mmod/physcannon/physcannon_claws_open.wav")
    self:StopSound("weapons/mmod/physcannon/physcannon_claws_close.wav")
    self:EmitSound("weapons/mmod/physcannon/physcannon_pickup.wav")
    
    PlayHoldLoopSound(self, true)
    
    self:PlayAnim("attack")
    self.PropLockTime = nil
    
    timer.Simple(0.4, function()
        if IsValid(self) and IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetActiveWeapon()) and 
           self:GetOwner():IsPlayer() and IsEntityAlive(self:GetOwner()) and 
           self:GetOwner():GetActiveWeapon() == self and self.Fading == false then
            self:PlayAnim("idle_hold")
        else
            self:PlayAnim("idle")
        end
    end)
    
    local trace = GetEyeTrace(self, self:GetOwner())
    
    heldEntity:Fire("DisablePhyscannonPickup", "", 0)
    
    local entityHealth = heldEntity:Health()
    
    if entityHealth > 0 then
        self.HPHealth = entityHealth
        heldEntity:SetHealth(999999999)
    end
    
    if heldEntity:IsRagdoll() then
        heldEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        
        if !ConVarExists("scgg_zap") or GetConVar("scgg_zap"):GetBool() then
            heldEntity:SCGG_RagdollZapper(true)
        end
    end
    
    if heldEntity:GetClass() == "prop_combine_ball" then
        heldEntity:SetOwner(self:GetOwner())
        
        if IsValid(heldEntity:GetPhysicsObject()) then
            heldEntity:GetPhysicsObject():AddGameFlag(FVPHYSICS_WAS_THROWN)
        end
    end
end

function SWEP:Drop(attacker, silent)
    if !IsValid(self) then
        return
    end
    
    local heldEntity = self:GetHP()
    local dropAttacker = self:GetOwner()
    
    if !IsValid(self:GetOwner()) and IsValid(attacker) then
        dropAttacker = attacker
    end
    
    self:DropGeneral()
    
    if SERVER and IsValid(heldEntity) then
        heldEntity:Fire("EnablePhyscannonPickup", "", 1)
        
        if heldEntity:IsRagdoll() then
            heldEntity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        else
            heldEntity:SetCollisionGroup(self.HPCollideG)
        end
        
        local entity = heldEntity
        
        timer.Simple(0.01, function()
            if !IsValid(entity) or !IsValid(entity:GetPhysicsObject()) then
                return
            end
            
            local physicsObject = entity:GetPhysicsObject()
            
            if entity:GetClass() == "prop_combine_ball" then
                physicsObject:SetVelocity(Vector(0, 0, 0))
                physicsObject:ApplyForceCenter(Vector(math.random(360), math.random(360), math.random(360)) * 3000)
            else
                physicsObject:AddAngleVelocity(physicsObject:GetAngleVelocity() * -1)
            end
        end)
        
        local entityHealth = heldEntity:Health()
        
        if entityHealth > 0 and self.HPHealth > 0 then
            heldEntity:SetHealth(self.HPHealth)
            self.HPHealth = -1
        end
    end
    
    self:PlayAnim("attack")
    
    if SERVER and IsValid(heldEntity) and heldEntity:IsRagdoll() then
        local shouldZap = true
        
        if ConVarExists("scgg_zap") then
            shouldZap = GetConVar("scgg_zap"):GetBool()
        end
        
        if shouldZap then
            heldEntity:SCGG_RagdollZapper()
        end
        
        heldEntity:SCGG_RagdollCollideTimer()
        
        if shouldZap then
            heldEntity:Fire("StartRagdollBoogie", "", 0)
        end
    end
    
    self.Secondary.Automatic = true
    
    if !silent or silent == false then
        self:EmitSound("weapons/mmod/physcannon/physcannon_drop.wav")
    end
    
    self:SetNextSecondaryFire(CurTime() + 0.5)
    
    if SERVER and IsValid(heldEntity) then
        dropAttacker:SimulateGravGunDrop(heldEntity)
    end
    
    timer.Simple(0.4, function()
        if !IsValid(self) or !IsValid(self) then
            return
        end
        
        if IsValid(dropAttacker) and dropAttacker:GetActiveWeapon() == self and self.Fading == false then
            self:PlayAnim("idle")
        end
    end)
    
    self:TPrem()
    self:HPrem()
    
    if self.HPCollideG then
        self.HPCollideG = COLLISION_GROUP_NONE
    end
end

function SWEP:DropGeneral()
    self.PropLockTime = nil
    self.HPBone = nil
    
    PlayHoldLoopSound(self, false)
    
    if SERVER then
        self:RemoveGlow()
    end
    
    local heldEntity = self:GetHP()
    
    if IsValid(heldEntity) then
        local physicsObject = heldEntity:GetPhysicsObject()
        local maxSpeed = 150.0
        local velocity = Vector(0, 0, 0)
        
        if IsValid(physicsObject) then
            velocity = physicsObject:GetVelocity()
        else
            velocity = heldEntity:GetVelocity()
        end
        
        if velocity.x > maxSpeed then
            velocity.x = maxSpeed
        elseif velocity.x < -maxSpeed then
            velocity.x = -maxSpeed
        end
        
        if velocity.y > maxSpeed then
            velocity.y = maxSpeed
        elseif velocity.y < -maxSpeed then
            velocity.y = -maxSpeed
        end
        
        velocity.z = 0
        
        if heldEntity:IsRagdoll() then
            for boneIndex = 1, heldEntity:GetPhysicsObjectCount() - 1 do
                local bonePhysics = heldEntity:GetPhysicsObjectNum(boneIndex)
                
                if bonePhysics and bonePhysics.IsValid and IsValid(bonePhysics) then
                    bonePhysics:SetVelocity(velocity)
                end
            end
        end
        
        if IsValid(physicsObject) then
            physicsObject:SetVelocity(velocity)
        else
            heldEntity:SetVelocity(velocity)
        end
    end
end

local whiteColor = Color(255, 255, 255, 100)

function SWEP:Visual(trace)
    local owner = self:GetOwner()
    
    self:PlayAnim("altfire")
    owner:SetAnimation(PLAYER_ATTACK1)
    
    self:EmitSound("weapons/mmod/physcannon/superphys_launch" .. math.random(4) .. ".wav")
    
    if SERVER and owner.PlayerClassName ~= "Gordon" then
        local character = hg.GetCurrentCharacter(owner)
        
        if not character:IsRagdoll() then
            hg.AddForceRag(owner, 2, owner:EyeAngles():Forward() * -15000, 0.5)
            hg.AddForceRag(owner, 0, owner:EyeAngles():Forward() * -15000, 0.5)
            hg.LightStunPlayer(owner, 1)
        end
        
        character:GetPhysicsObjectNum(0):SetVelocity(character:GetVelocity() + owner:EyeAngles():Forward() * -2000)
    end
    
    if SERVER then
        local dynamicLight = ents.Create("light_dynamic")
        dynamicLight:SetKeyValue("brightness", "5")
        dynamicLight:SetKeyValue("distance", "200")
        dynamicLight:SetLocalPos(owner:GetShootPos())
        dynamicLight:SetLocalAngles(self:GetAngles())
        dynamicLight:Fire("Color", "255 175 50")
        dynamicLight:SetParent(self)
        dynamicLight:Spawn()
        dynamicLight:Activate()
        dynamicLight:Fire("TurnOn", "", 0)
        
        self:DeleteOnRemove(dynamicLight)
        
        timer.Simple(0.15, function()
            if IsValid(dynamicLight) then
                dynamicLight:Remove()
            end
        end)
    end
    
    if IsValid(owner) and owner:IsPlayer() then
        owner:ViewPunch(Angle(-math.random(10, 20), math.random(-1, 1) == 1 and -15 or 15, math.random(-25, 25)) / (owner.PlayerClassName == "Gordon" and 4 or 1))
        owner:ScreenFade(SCREENFADE.IN, whiteColor, 0.25, 0)
    end
    
    local heldEntity = self:GetHP()
    
    local tracerEffect = EffectData()
    
    if !IsValid(heldEntity) or trace.Entity != heldEntity then
        tracerEffect:SetOrigin(trace.HitPos)
    else
        tracerEffect:SetOrigin(heldEntity:GetPos())
    end
    
    tracerEffect:SetStart(owner:GetShootPos())
    tracerEffect:SetAttachment(1)
    tracerEffect:SetEntity(self)
    
    util.Effect("PhyscannonTracer", tracerEffect)
    
    local teslaEffect = EffectData()
    teslaEffect:SetEntity(trace.Entity)
    teslaEffect:SetMagnitude(15)
    teslaEffect:SetScale(15)
    teslaEffect:SetRadius(15)
    teslaEffect:SetColor(255, 150, 50)
    
    util.Effect("TeslaHitBoxes", teslaEffect)
    
    trace.Entity:EmitSound("Weapon_StunStick.Activate")
    
    if SERVER then
        self:MuzzleEffect()
    end
    
    local sparkEffect = EffectData()
    sparkEffect:SetMagnitude(30)
    sparkEffect:SetScale(30)
    sparkEffect:SetRadius(30)
    sparkEffect:SetOrigin(trace.HitPos)
    sparkEffect:SetNormal(trace.HitNormal)
    
    util.Effect("ManhackSparks", sparkEffect)
end

local entityMetaTable = FindMetaTable("Entity")

function entityMetaTable:SCGG_RagdollZapper(removeOnly)
    local timerName = "scgg_zapper_" .. self:EntIndex()
    
    if removeOnly != nil and removeOnly == true then
        timer.Remove(timerName)
        return
    end
    
    local effectInterval = 0.2
    local effectCount = 24
    
    if timer.Exists(timerName) then
        timer.Adjust(timerName, effectInterval, effectCount)
        return
    end
    
    local function CreateTeslaEffect()
        local effectData = EffectData()
        
        if !IsValid(self) then
            timer.Remove(timerName)
            return
        end
        
        effectData:SetOrigin(self:GetPos())
        effectData:SetStart(self:GetPos())
        effectData:SetMagnitude(5)
        effectData:SetEntity(self)
        
        util.Effect("teslaHitBoxes", effectData)
        self:EmitSound("Weapon_StunStick.Activate", 75, math.Rand(99, 101), 0.1, SNDLVL_45dB)
    end
    
    CreateTeslaEffect()
    
    timer.Create(timerName, effectInterval, effectCount, function()
        CreateTeslaEffect()
        
        if !IsValid(self) then
            timer.Remove(timerName)
            return
        end
        
        if timer.RepsLeft(timerName) <= 0 then
            timer.Remove(timerName)
            return
        end
    end)
end

function entityMetaTable:SCGG_RagdollCollideTimer()
    local timerName = "scgg_collidecheck_" .. self:EntIndex()
    
    if timer.Exists(timerName) then
        timer.Adjust(timerName, 2.0, 1)
        return
    end
    
    local function ShouldResetCollision(entity)
        if !IsValid(entity) then
            return false
        end
        
        local collisionGroup = entity:GetCollisionGroup()
        
        if collisionGroup != COLLISION_GROUP_WEAPON or 
           collisionGroup != COLLISION_GROUP_DEBRIS or 
           collisionGroup != COLLISION_GROUP_DEBRIS_TRIGGER or 
           collisionGroup != COLLISION_GROUP_WORLD then
            return true
        else
            return false
        end
    end
    
    timer.Create(timerName, 4.5, 1, function()
        if !IsValid(self) then
            return
        end
        
        local collisionGroup = self:GetCollisionGroup()
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end)
end

function SWEP:Deploy()
    self:SetDeploySpeed(1)
    self:PlayAnim("deploy")
    
    InitializeWeapon(self)
    
    self.OnDropOwner = self:GetOwner()
    self:SetNextSecondaryFire(CurTime() + 5)
    
    CleanupTimers(self)
    
    if IsValid(self:GetOwner()) then
        if self:GetOwner():IsPlayer() then
            local viewModel = self:GetOwner():GetViewModel()
            local deployTime = 0
            
            deployTime = viewModel:SequenceDuration()
            
            timer.Create("deploy_idle" .. self:EntIndex(), deployTime, 1, function()
                if !IsValid(self) then
                    return true
                end
                
                if IsValid(self) and IsValid(self:GetOwner()) and 
                   IsValid(self:GetOwner():GetActiveWeapon()) and 
                   self:GetOwner():GetActiveWeapon() == self and self.Fading == false then
                    self:PlayAnim("idle")
                end
                
                self:SetNextSecondaryFire(CurTime() + 0.01)
            end)
        end
    end
    
    self:EmitSound("weapons/mmod/physcannon/gravgun_deploy.wav", 70, math.random(95, 105))
    
    return true
end

function SWEP:Holster()
    local heldEntity = self:GetHP()
    local viewModelPath = nil
    
    viewModelPath = "models/weapons/shadowysn/c_superphyscannon.mdl"
    
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetInfo("cl_scgg_viewmodel") then
        viewModelPath = self:GetOwner():GetInfo("cl_scgg_viewmodel")
    end
    
    if self.ViewModel != self.WorldModel and util.IsValidModel(viewModelPath) and !IsUselessModel(viewModelPath) then
        self.ViewModel = viewModelPath
    end
    
    self:SetDeploySpeed(1)
    
    if IsValid(heldEntity) and self:GetOwner():Health() > 0 then
        return false
    end
    
    CleanupTimers(self)
    
    if IsValid(heldEntity) then
        self:Drop()
    end
    
    self:SetPoseParameter("active", 0)
    self:SetHP(nil)
    self:TPrem()
    self:HPrem()
    
    return true
end

function SWEP:OnDrop()
    local heldEntity = self:GetHP()
    
    if SERVER then
        self:TPrem()
        self:HPrem()
    end
    
    if IsValid(self.OnDropOwner) then
        self:Drop(self.OnDropOwner, true)
    end
    
    if IsValid(heldEntity) then
        self:SetHP(nil)
    end
end

function SWEP:HPrem()
    self:SetHP(nil)
    self.HP_PickedUp = nil
end

function SWEP:TPrem()
    if SERVER and IsValid(self:GetTP()) then
        self:GetTP():Remove()
    end
    
    if IsValid(self.Const) and (self.Const:IsConstraint() or self.Const:GetClass() == "phys_ragdollconstraint") then
        if SERVER then
            self.Const:Remove()
        end
        
        self.Const = nil
    end
    
    self:SetTP(nil)
end

function SWEP:CreateTP()
    local heldEntity = self:GetHP()
    
    if !IsValid(heldEntity) then
        return
    end
    
    local targetPointer = nil
    
    if heldEntity:GetClass() == "prop_combine_ball" or heldEntity:GetClass() == "npc_manhack" then
        targetPointer = ents.Create("prop_dynamic")
    else
        targetPointer = ents.Create("prop_physics")
    end
    
    self:SetTP(targetPointer)
    
    local physicsObject = nil
    
    if heldEntity:IsRagdoll() and self.HPBone != nil and util.IsValidPhysicsObject(heldEntity, self.HPBone) then
        physicsObject = heldEntity:GetPhysicsObjectNum(self.HPBone)
    end
    
    if !IsValid(physicsObject) then
        if IsValid(heldEntity:GetPhysicsObject()) then
            physicsObject = heldEntity:GetPhysicsObject()
        end
    end
    
    if IsValid(physicsObject) and heldEntity:IsRagdoll() then
        targetPointer:SetPos(physicsObject:GetPos())
    elseif !heldEntity:WorldSpaceCenter():IsZero() then
        targetPointer:SetPos(heldEntity:WorldSpaceCenter())
    else
        targetPointer:SetPos(heldEntity:GetPos())
    end
    
    targetPointer:SetModel("models/props_junk/PopCan01a.mdl")
    targetPointer:Spawn()
    targetPointer:SetCollisionGroup(COLLISION_GROUP_WORLD)
    targetPointer:SetRenderMode(RENDERMODE_TRANSCOLOR)
    targetPointer:SetColor(Color(255, 255, 255, 0))
    targetPointer:PointAtEntity(self:GetOwner())
    
    if targetPointer:GetClass() == "prop_physics" then
        targetPointer:GetPhysicsObject():SetMass(50000)
        targetPointer:GetPhysicsObject():EnableMotion(false)
    end
    
    local trace = GetEyeTrace(self, self:GetOwner())
    local physicsBone = math.Clamp(trace.PhysicsBone, 0, 1)
    
    if heldEntity:IsRagdoll() then
        physicsBone = self.HPBone
    end
    
    if heldEntity:IsRagdoll() and IsValid(targetPointer:GetPhysicsObject()) and IsValid(physicsObject) then
        local ragdollConstraint = ents.Create("phys_ragdollconstraint")
        self.Const = ragdollConstraint
        
        ragdollConstraint:SetPhysConstraintObjects(physicsObject, targetPointer:GetPhysicsObject())
        ragdollConstraint:SetKeyValue("teleportfollowdistance", 1.0)
        
        local constraintRange = 180.0
        ragdollConstraint:SetKeyValue("xmin", -constraintRange)
        ragdollConstraint:SetKeyValue("xmax", constraintRange)
        ragdollConstraint:SetKeyValue("ymin", -constraintRange)
        ragdollConstraint:SetKeyValue("ymax", constraintRange)
        ragdollConstraint:SetKeyValue("zmin", -constraintRange)
        ragdollConstraint:SetKeyValue("zmax", constraintRange)
        
        local friction = 15.0
        ragdollConstraint:SetKeyValue("xfriction", friction)
        ragdollConstraint:SetKeyValue("yfriction", friction)
        ragdollConstraint:SetKeyValue("zfriction", friction)
        
        ragdollConstraint:SetPos(targetPointer:GetPos())
        ragdollConstraint:Spawn()
        ragdollConstraint:Activate()
    else
        self.Const = constraint.Weld(targetPointer, heldEntity, 0, physicsBone, 0, false)
    end
end

function SWEP:GetPullForce(entity)
    if IsValid(entity) and entity:IsRagdoll() then
        return self.HL2PullForceRagdoll
    else
        return self.HL2PullForce
    end
end

function SWEP:GetMaxMass()
    return self.HL2MaxMass
end

function SWEP:GetMaxPuntRange()
    return self.HL2MaxPuntRange
end

function SWEP:GetMaxPickupRange()
    return self.HL2MaxPickupRange
end

function SWEP:GetMaxTargetHealth()
    return self.HL2MaxTargetHealth
end

if SERVER then
    function SWEP:MuzzleEffect()
    end
    
    function SWEP:CoreEffect()
        if !IsValid(self.Core) then
            self.Core = ents.Create("MegaPhyscannonCore")
            self.Core:SetPos(self:GetOwner():GetShootPos())
            self.Core:Spawn()
        end
        
        self.CoreAllowRemove = false
        
        if !IsValid(self.Core) then
            return
        end
        
        self.Core:SetParent(self:GetOwner())
        self.Core:SetOwner(self:GetOwner())
    end
    
    function SWEP:GlowEffect()
        self:SetGlow(true)
    end
    
    function SWEP:RemoveCore()
        if !self.Core then
            return
        end
        
        if !IsValid(self.Core) then
            return
        end
        
        self.CoreAllowRemove = true
        self.Core:Remove()
        self.Core = nil
    end
    
    function SWEP:RemoveGlow()
        self:SetGlow(false)
    end
end