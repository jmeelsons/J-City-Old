-- error fix
local function SafeGetBoneIndex(ent, boneName)
    if not IsValid(ent) then return nil end
    if not boneName or type(boneName) ~= "string" then return nil end
    
    local boneIndex = ent:LookupBone(boneName)
    if boneIndex and boneIndex > 0 then
        return boneIndex
    end
    return nil
end

local function SafeGetManipulateBoneAngles(ent, boneName)
    local boneIndex = SafeGetBoneIndex(ent, boneName)
    if not boneIndex then return nil end
    
    local success, result = pcall(function()
        return ent:GetManipulateBoneAngles(boneIndex)
    end)
    
    if not success then return nil end
    return result
end

local function SafeGetManipulateBoneAnglesByIndex(ent, boneIndex)
    if not IsValid(ent) then return nil end
    if not boneIndex or type(boneIndex) ~= "number" or boneIndex < 0 then return nil end
    
    local success, result = pcall(function()
        return ent:GetManipulateBoneAngles(boneIndex)
    end)
    
    if not success then return nil end
    return result
end

local originalCanUseLeftHand = hg.CanUseLeftHand
function hg.CanUseLeftHand(ply)
    if not IsValid(ply) then return false end
    
    local ent = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or ply
    
    if ent.organism and ent.organism.larmamputated then
        return false
    end
    
    local wep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon()
    local Car = (ply.GetSimfphys and IsValid(ply:GetSimfphys()) and ply:GetSimfphys()) or 
                (ply.GlideGetVehicle and IsValid(ply:GlideGetVehicle()) and ply:GlideGetVehicle()) or 
                ply:GetVehicle()
    
    local deploying = wep and (wep.deploy and (wep.deploy - CurTime()) > (wep.CooldownDeploy / 2) or 
                              wep.holster and (wep.holster - CurTime()) < (wep.CooldownHolster / 2))
    
    local fingerAngle = 0
    if ent ~= ply and not ply:InVehicle() then
        local fingerAngles = SafeGetManipulateBoneAngles(ent, "ValveBiped.Bip01_L_Finger11")
        if fingerAngles and type(fingerAngles) == "Angle" then
            fingerAngle = math.abs(fingerAngles[2] or 0)
        end
    end
    
    local isInVehicle = ply:InVehicle()
    local driveable = isInVehicle and hg.isdriveablevehicle(ply:GetVehicle())
    
    local condition = not ((((ply:GetTable().ChatGestureWeight or 0) > 0.1 or
        (ply:GetNWBool("TauntLeftHand", false) and ply:GetNWFloat("StartTaunt", 0) + 0.1 < CurTime()) or
        IsValid(ply.flashlight)) and not ply:GetNetVar("handcuffed") and (wep and not wep.reload)) or
        (deploying) or
        (ent ~= ply and fingerAngle > 5 and not ply:InVehicle()) or
        (isInVehicle and wep and not IsValid(wep) and not wep and wep and wep.reload and driveable))
    
    return condition or ply.zmanipstart
end

local originalBoneApplyMatrix = hg.bone_apply_matrix
function hg.bone_apply_matrix(ent, bone, matrix, parentBone)
    if not IsValid(ent) then return end
    
    local boneIndex = bone
    
    if type(bone) == "string" then
        boneIndex = ent:LookupBone(bone)
        if not boneIndex or boneIndex <= 0 then
            return
        end
    elseif type(bone) ~= "number" then
        return
    end
    
    if not matrix then return end
    
    local parentIndex = parentBone
    if parentBone and type(parentBone) == "string" then
        parentIndex = ent:LookupBone(parentBone)
        if not parentIndex or parentIndex <= 0 then
            parentIndex = nil
        end
    elseif parentBone and type(parentBone) ~= "number" then
        parentIndex = nil
    end
    
    local success, err = pcall(function()
        if originalBoneApplyMatrix then
            return originalBoneApplyMatrix(ent, boneIndex, matrix, parentIndex)
        else
            ent:SetBoneMatrix(boneIndex, matrix)
            if parentIndex then
            end
        end
    end)
    
    if not success then
    end
end

if hg.MainTPIKFunction then
    local originalMainTPIK = hg.MainTPIKFunction
    
    function hg.MainTPIKFunction(ent, ply, wpn)
        if not IsValid(ent) or not IsValid(ply) then return end
        
        local essentialBones = {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_L_Hand",
            "ValveBiped.Bip01_R_Hand"
        }
        
        for _, boneName in ipairs(essentialBones) do
            if not SafeGetBoneIndex(ent, boneName) then
                return
            end
        end
        
        local success, err = pcall(originalMainTPIK, ent, ply, wpn)
        if not success then
        end
    end
end

if hg.DragHands then
    local originalDragHands = hg.DragHands
    
    function hg.DragHands(ply, self)
        if not IsValid(ply) then return end
        
        local rh = SafeGetBoneIndex(ply, "ValveBiped.Bip01_R_Hand")
        local lh = SafeGetBoneIndex(ply, "ValveBiped.Bip01_L_Hand")
        
        if not rh or not lh then
            return
        end
        
        local success, err = pcall(originalDragHands, ply, self)
        if not success then
        end
    end
end

local function FixWeaponSetHandPos(wep)
    if not wep or not wep.SetHandPos or wep._handpos_fixed then return end
    
    local originalSetHandPos = wep.SetHandPos
    wep.SetHandPos = function(self, noset)
        local ply = self:GetOwner()
        if IsValid(ply) then
            local rh = SafeGetBoneIndex(ply, "ValveBiped.Bip01_R_Hand")
            local lh = SafeGetBoneIndex(ply, "ValveBiped.Bip01_L_Hand")
            
            if not rh or not lh then
                return
            end
        end
        return originalSetHandPos(self, noset)
    end
    wep._handpos_fixed = true
end

hook.Add("Think", "FixWeaponSetHandPos", function()
    for _, wep in ipairs(ents.FindByClass("weapon_hands_sh")) do
        FixWeaponSetHandPos(wep)
    end
end)

hook.Add("OnEntityCreated", "FixNewWeaponSetHandPos", function(ent)
    if ent:GetClass() == "weapon_hands_sh" then
        timer.Simple(0, function()
            if IsValid(ent) then
                FixWeaponSetHandPos(ent)
            end
        end)
    end
end)

function hg.SafeGetManipulateBoneAngles(ent, boneIndex)
    return SafeGetManipulateBoneAnglesByIndex(ent, boneIndex)
end

function hg.SafeLookupBone(ent, boneName)
    return SafeGetBoneIndex(ent, boneName)
end

-- bodygroup
hook.Add("Ragdoll_Create", "FixBodygroupsAfterRagdoll", function(ply, ragdoll)
    if not IsValid(ragdoll) then return end
    if ply:GetModel() then return end

    timer.Simple(0.1, function()
        if not IsValid(ragdoll) or not IsValid(ply) then return end
        local bodygroups = ply:GetBodyGroups()
        for _, bg in ipairs(bodygroups) do
            ragdoll:SetBodygroup(bg.id, ply:GetBodygroup(bg.id))
        end
    end)
end)

hook.Add("NetworkEntityCreated", "FixRagdollBodygroups", function(entity)
    if not IsValid(entity) or entity:GetClass() ~= "prop_ragdoll" then return end
    local ply = entity:GetNWEntity("ply")
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if ply:GetModel() then return end

    timer.Simple(0.1, function()
        if not IsValid(entity) or not IsValid(ply) then return end
        local bodygroups = ply:GetBodyGroups()
        for _, bg in ipairs(bodygroups) do
            entity:SetBodygroup(bg.id, ply:GetBodygroup(bg.id))
        end
    end)
end)