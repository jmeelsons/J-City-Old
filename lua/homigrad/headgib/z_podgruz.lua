local ADDON_TAG = "ZCity Gore V2"
local ADDON_TITLE = "porevo"

local HEAD_MODELS = {
    "models/headpartial/headpartial.mdl",
    "models/headpartial/headpartial1.mdl",
    "models/headpartial/headpartial2.mdl",
    "models/headpartial/headpartial3.mdl",
    "models/headpartial/headpartial5.mdl"
}

local HEAD_MODEL_SET = {}
for _, path in ipairs(HEAD_MODELS) do
    HEAD_MODEL_SET[string.lower(path)] = true
end

local TORSO_UPPER_MODEL = "models/torsopartial/torsovar.mdl"
local TORSO_LOWER_MODEL = "models/torsopartial/abdomenvar.mdl"
local ZERO_SCALE = Vector(0, 0, 0)
local FULL_SCALE = Vector(1, 1, 1)
local HIDDEN_POS = Vector(0, 0, 0) / 0

if SERVER then
    AddCSLuaFile()

    local contentFiles = {
        "models/limbspartial/elbowleft.mdl",
        "models/limbspartial/elbowleft.dx80.vtx",
        "models/limbspartial/elbowleft.dx90.vtx",
        "models/limbspartial/elbowleft.vvd",
        "models/limbspartial/elbowright.mdl",
        "models/limbspartial/elbowright.dx80.vtx",
        "models/limbspartial/elbowright.dx90.vtx",
        "models/limbspartial/elbowright.vvd",
        "models/limbspartial/kneeleft.mdl",
        "models/limbspartial/kneeleft.dx80.vtx",
        "models/limbspartial/kneeleft.dx90.vtx",
        "models/limbspartial/kneeleft.vvd",
        "models/limbspartial/kneeright.mdl",
        "models/limbspartial/kneeright.dx80.vtx",
        "models/limbspartial/kneeright.dx90.vtx",
        "models/limbspartial/kneeright.vvd",
        "models/headpartial/headpartial.mdl",
        "models/headpartial/headpartial.dx80.vtx",
        "models/headpartial/headpartial.dx90.vtx",
        "models/headpartial/headpartial.vvd",
        "models/headpartial/headpartial.phy",
        "models/headpartial/headpartial1.mdl",
        "models/headpartial/headpartial1.dx80.vtx",
        "models/headpartial/headpartial1.dx90.vtx",
        "models/headpartial/headpartial1.vvd",
        "models/headpartial/headpartial1.phy",
        "models/headpartial/headpartial2.mdl",
        "models/headpartial/headpartial2.dx80.vtx",
        "models/headpartial/headpartial2.dx90.vtx",
        "models/headpartial/headpartial2.vvd",
        "models/headpartial/headpartial3.mdl",
        "models/headpartial/headpartial3.dx80.vtx",
        "models/headpartial/headpartial3.dx90.vtx",
        "models/headpartial/headpartial3.vvd",
        "models/headpartial/headpartial5.mdl",
        "models/headpartial/headpartial5.dx80.vtx",
        "models/headpartial/headpartial5.dx90.vtx",
        "models/headpartial/headpartial5.vvd",
        "models/torsopartial/torsovar.mdl",
        "models/torsopartial/torsovar.dx80.vtx",
        "models/torsopartial/torsovar.dx90.vtx",
        "models/torsopartial/torsovar.vvd",
        "models/torsopartial/abdomenvar.mdl",
        "models/torsopartial/abdomenvar.dx80.vtx",
        "models/torsopartial/abdomenvar.dx90.vtx",
        "models/torsopartial/abdomenvar.vvd",
        "materials/models/limbspartial/elbowl.vmt",
        "materials/models/limbspartial/elbowl_basecolor.vtf",
        "materials/models/limbspartial/elbowl_bump.vtf",
        "materials/models/limbspartial/elbowl_phongexp.vtf",
        "materials/models/limbspartial/elbowr.vmt",
        "materials/models/limbspartial/elbowr_basecolor.vtf",
        "materials/models/limbspartial/elbowr_bump.vtf",
        "materials/models/limbspartial/elbowr_phongexp.vtf",
        "materials/models/limbspartial/kneevar.vmt",
        "materials/models/limbspartial/kneevar_basecolor.vtf",
        "materials/models/limbspartial/kneevar_bump.vtf",
        "materials/models/limbspartial/kneevar_phongexp.vtf",
        "materials/models/limbspartial/kneevar2.vmt",
        "materials/models/limbspartial/kneevar2_basecolor.vtf",
        "materials/models/limbspartial/kneevar2_bump.vtf",
        "materials/models/limbspartial/kneevar2_phongexp.vtf",
        "sound/gore/kf2_tear1.wav",
        "sound/gore/kf2_tear2.wav",
        "sound/gore/kf2_tear3.wav",
        "sound/gore/kf2_tear4.wav",
        "sound/gore/kf2_tear5.wav",
        "sound/gore/kf2_tear6.wav",
        "sound/gore/kf2_tear7.wav"
    }

    local function AddDirectoryFiles(dir)
        local files = file.Find(dir .. "/*", "GAME")
        for _, name in ipairs(files or {}) do
            contentFiles[#contentFiles + 1] = dir .. "/" .. name
        end
    end

    AddDirectoryFiles("materials/models/headpartial")
    AddDirectoryFiles("materials/models/torsopartial")

    local workshopCVar = CreateConVar("zcity_gore_torso_workshopid", "0", FCVAR_ARCHIVE, "Workshop ID for ZCity Gore torso addon")
    local blastRadiusCVar = CreateConVar("zcity_gore_torso_blast_radius", "110", FCVAR_ARCHIVE, "Maximum blast distance for torso dismemberment", 1, 500)
    local lowerLifetimeCVar = CreateConVar("zcity_gore_torso_lower_lifetime", "180", FCVAR_ARCHIVE, "Lifetime of severed lower torso in seconds", 10, 600)
    local resourcesRegistered = false
    local registeredWorkshopID = nil

    local function ValidWorkshopID(value)
        value = tostring(value or "")
        return value:match("^%d+$") and tonumber(value) and tonumber(value) > 0
    end

    local function DetectOwnWorkshopID()
        if not engine.GetAddons then return nil end
        for _, data in ipairs(engine.GetAddons() or {}) do
            if data and data.mounted and ValidWorkshopID(data.wsid) then
                local title = tostring(data.title or "")
                local fileName = string.lower(tostring(data.file or ""))
                if title == ADDON_TITLE or string.find(fileName, "zcity_gore_torso", 1, true) then
                    return tostring(data.wsid)
                end
            end
        end
        return nil
    end

    local function RegisterContent()
        local configured = workshopCVar:GetString()
        local workshopID = ValidWorkshopID(configured) and configured or DetectOwnWorkshopID()
        if workshopID then
            if registeredWorkshopID ~= workshopID then
                resource.AddWorkshop(workshopID)
                registeredWorkshopID = workshopID
            end
            resourcesRegistered = true
            return
        end
        if resourcesRegistered then return end
        for _, path in ipairs(contentFiles) do
            resource.AddFile(path)
        end
        resourcesRegistered = true
    end

    RegisterContent()
    hook.Add("Initialize", ADDON_TAG .. "_Resources", RegisterContent)
    hook.Add("InitPostEntity", ADDON_TAG .. "_ResourcesLate", RegisterContent)

    cvars.AddChangeCallback("zcity_gore_torso_workshopid", function(_, _, value)
        if not ValidWorkshopID(value) then return end
        resource.AddWorkshop(tostring(value))
        registeredWorkshopID = tostring(value)
        resourcesRegistered = true
    end, ADDON_TAG .. "_WorkshopID")

    local tearSounds = {
        "gore/kf2_tear1.wav",
        "gore/kf2_tear2.wav",
        "gore/kf2_tear3.wav",
        "gore/kf2_tear4.wav",
        "gore/kf2_tear5.wav",
        "gore/kf2_tear6.wav",
        "gore/kf2_tear7.wav"
    }

    for _, snd in ipairs(tearSounds) do
        util.PrecacheSound(snd)
    end
    for _, mdl in ipairs(HEAD_MODELS) do
        util.PrecacheModel(mdl)
    end
    util.PrecacheModel(TORSO_UPPER_MODEL)
    util.PrecacheModel(TORSO_LOWER_MODEL)

    hook.Add("OnEntityCreated", ADDON_TAG .. "_RandomHeadReplacement", function(ent)
        if not IsValid(ent) or ent:GetClass() ~= "prop_dynamic" then return end
        timer.Simple(0, function()
            if not IsValid(ent) then return end
            local model = string.lower(tostring(ent:GetModel() or ""))
            if not HEAD_MODEL_SET[model] then return end
            local parent = ent:GetParent()
            if not IsValid(parent) or not parent:IsRagdoll() then return end
            ent:SetModel(HEAD_MODELS[math.random(#HEAD_MODELS)])
        end)
    end)

    local oldAmputationSounds = {
        ["player/zombie_head_explode_01.wav"] = true,
        ["player/zombie_head_explode_02.wav"] = true,
        ["player/zombie_head_explode_03.wav"] = true,
        ["player/zombie_head_explode_04.wav"] = true,
        ["player/zombie_head_explode_05.wav"] = true,
        ["player/zombie_head_explode_06.wav"] = true
    }

    local function PlayTear(owner, level, volume)
        if not IsValid(owner) then return end
        owner:EmitSound(tearSounds[math.random(#tearSounds)], level or 85, math.random(92, 104), volume or 1)
    end

    hook.Add("EntityEmitSound", ADDON_TAG .. "_ReplaceOldAmpSound", function(data)
        local ent = data and data.Entity
        if not IsValid(ent) or not ent.__zcGoreSuppressOldAmpSound then return end
        local soundName = string.lower(tostring(data.SoundName or ""))
        if oldAmputationSounds[soundName] then return false end
    end)

    local torsoStates = setmetatable({}, {__mode = "k"})
    local splitStates = {}

    local initialPhrases = {
        "FUCK! I'M TORN IN HALF!",
        "OH GOD! MY LOWER BODY IS GONE!",
        "FUCK! I CAN'T FEEL MY LEGS!",
        "JESUS CHRIST! I'M CUT IN HALF!",
        "MY FUCKING TORSO! HELP ME!",
        "HOLY SHIT! WHERE ARE MY LEGS?!",
        "FUCK! I'M IN TWO PIECES!",
        "OH FUCK, MY BODY! MY BODY!",
        "I'M FUCKING SPLIT OPEN!",
        "GOD! I'VE BEEN RIPPED APART!",
        "MY LEGS! FUCK, MY LEGS ARE GONE!",
        "I'M CUT IN FUCKING HALF!",
        "WHAT THE FUCK HAPPENED TO ME?!",
        "FUCKING HELL! I'M TORN APART!",
        "OH GOD! DON'T LOOK AT ME!"
    }

    local painPhrases = {
        "FUCK, IT HURTS!",
        "I'M BLEEDING OUT!",
        "SOMEBODY FUCKING HELP ME!",
        "I CAN'T MOVE MY LEGS!",
        "OH GOD, KEEP ME AWAKE!",
        "FUCK! DON'T LET ME DIE!",
        "I CAN'T FEEL ANYTHING BELOW MY CHEST!",
        "FUCK! THE PAIN WON'T STOP!",
        "SOMEBODY STOP THE BLEEDING!",
        "I'M LOSING TOO MUCH BLOOD!",
        "HELP ME! PLEASE, FUCKING HELP ME!",
        "I CAN'T FUCKING MOVE!",
        "MY BACK IS ON FIRE!",
        "FUCK, I FEEL COLD!",
        "DON'T LET ME PASS OUT!",
        "I'M STILL ALIVE! HELP ME!",
        "OH GOD, I'M BLEEDING EVERYWHERE!",
        "FUCK! I CAN'T BREATHE RIGHT!",
        "KEEP ME AWAKE! KEEP TALKING TO ME!",
        "PLEASE, I DON'T WANT TO DIE!",
        "MY BODY'S FUCKED!",
        "I NEED A MEDIC RIGHT FUCKING NOW!",
        "I CAN FEEL MYSELF GETTING WEAKER!",
        "FUCK! EVERYTHING'S GOING NUMB!"
    }

    local criticalPhrases = {
        "I'M GOING INTO SHOCK!",
        "I CAN'T SEE STRAIGHT!",
        "FUCK, I'M FADING!",
        "I'M SO FUCKING COLD!",
        "DON'T LET ME CLOSE MY EYES!",
        "I CAN'T STAY AWAKE!",
        "THERE'S TOO MUCH BLOOD!",
        "I'M FUCKING DYING HERE!",
        "MY HEART'S POUNDING!",
        "I CAN'T FEEL MY HANDS!",
        "EVERYTHING'S GETTING DARK!",
        "FUCK! I'M LOSING IT!"
    }

    local function PickPhrase(ply, pool, slot)
        local last = ply[slot]
        local index = math.random(#pool)
        if #pool > 1 and index == last then index = index % #pool + 1 end
        ply[slot] = index
        return pool[index]
    end

    local function ResolvePlayer(ent)
        if not IsValid(ent) then return nil end
        if ent:IsPlayer() then return ent end
        local directOwner = ent.ply
        if IsValid(directOwner) and directOwner:IsPlayer() then return directOwner end
        if hg and hg.RagdollOwner then
            local owner = hg.RagdollOwner(ent)
            if IsValid(owner) and owner:IsPlayer() then return owner end
        end
        local nwOwner = ent:GetNWEntity("ply")
        if IsValid(nwOwner) and nwOwner:IsPlayer() then return nwOwner end
        return nil
    end

    local function CopyAppearance(source, target)
        target:SetSkin(source:GetSkin() or 0)
        target:SetColor(source:GetColor())
        target:SetMaterial(source:GetMaterial() or "")
        for _, group in ipairs(source:GetBodyGroups() or {}) do
            if group and group.id then
                target:SetBodygroup(group.id, source:GetBodygroup(group.id))
            end
        end
        local mats = source:GetMaterials() or {}
        for i = 0, #mats - 1 do
            target:SetSubMaterial(i, source:GetSubMaterial(i) or "")
        end
    end

    local function CopyPhysicsPose(source, target)
        local count = math.min(source:GetPhysicsObjectCount(), target:GetPhysicsObjectCount())
        for i = 0, count - 1 do
            local srcPhys = source:GetPhysicsObjectNum(i)
            local dstPhys = target:GetPhysicsObjectNum(i)
            if IsValid(srcPhys) and IsValid(dstPhys) then
                dstPhys:SetPos(srcPhys:GetPos())
                dstPhys:SetAngles(srcPhys:GetAngles())
                dstPhys:SetVelocity(srcPhys:GetVelocity())
            end
        end
    end

    local function CollectDescendants(ent, bone, output)
        output[bone] = true
        for _, child in ipairs(ent:GetChildBones(bone) or {}) do
            if not output[child] then
                CollectDescendants(ent, child, output)
            end
        end
    end

    local function GetBoneTransform(ent, bone)
        if not IsValid(ent) or bone == nil or bone < 0 then return nil end
        local physID = ent:TranslateBoneToPhysBone(bone)
        if physID ~= nil and physID >= 0 then
            local phys = ent:GetPhysicsObjectNum(physID)
            if IsValid(phys) then
                return phys:GetPos(), phys:GetAngles()
            end
        end
        if ent.GetBonePosition then
            local pos, ang = ent:GetBonePosition(bone)
            if isvector(pos) and isangle(ang) then
                return pos, ang
            end
        end
        if ent.GetBoneMatrix then
            local matrix = ent:GetBoneMatrix(bone)
            if matrix then
                local pos = matrix:GetTranslation()
                local ang = matrix:GetAngles()
                if isvector(pos) and isangle(ang) then
                    return pos, ang
                end
            end
        end
        return nil
    end

    local function UpdateCap(cap)
        if not IsValid(cap) then return false end
        local parent = cap.__zcGoreParent
        local bone = cap.__zcGoreBone
        if not IsValid(parent) or not bone then
            cap:Remove()
            return false
        end
        local basePos, baseAng = GetBoneTransform(parent, bone)
        if not basePos or not baseAng then return false end
        local pos, ang = LocalToWorld(cap.__zcGoreLocalPos or vector_origin, cap.__zcGoreLocalAng or angle_zero, basePos, baseAng)
        cap:SetPos(pos)
        cap:SetAngles(ang)
        return true
    end

    local function MakeCap(model, parent, bone, localPos, localAng, scale)
        local cap = ents.Create("prop_dynamic")
        if not IsValid(cap) then return nil end
        cap:SetModel(model)
        cap:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        cap:SetNotSolid(true)
        cap:SetMoveType(MOVETYPE_NONE)
        cap:DrawShadow(false)
        cap:Spawn()
        if scale then cap:ManipulateBoneScale(0, scale) end
        cap.__zcGoreParent = parent
        cap.__zcGoreBone = bone
        cap.__zcGoreLocalPos = localPos
        cap.__zcGoreLocalAng = localAng
        parent:DeleteOnRemove(cap)
        UpdateCap(cap)
        return cap
    end

    local function CollectParents(ent, bone)
        local parents = {}
        local parent = ent:GetBoneParent(bone)
        while parent and parent >= 0 do
            parents[parent] = true
            if parent == 0 then break end
            local nextParent = ent:GetBoneParent(parent)
            if nextParent == parent then break end
            parent = nextParent
        end
        return parents
    end

    local function SetHiddenBone(ent, bone, hardHide)
        ent:ManipulateBoneScale(bone, ZERO_SCALE)
        if hardHide then
            ent:ManipulateBonePosition(bone, HIDDEN_POS)
        end
    end

    local function ConfigureHiddenPhys(ent, physID)
        if not physID or physID < 0 then return end
        local phys = ent:GetPhysicsObjectNum(physID)
        if not IsValid(phys) then return end
        phys:EnableCollisions(false)
        phys:SetMass(0.01)
        phys:EnableMotion(false)
    end

    local function AddPhysParent(map, physID, parentPhysID)
        if not physID or physID < 0 then return end
        if not parentPhysID or parentPhysID < 0 then return end
        if physID == parentPhysID then return end
        map[physID] = parentPhysID
    end

    local function ForceHiddenPhys(ent, map)
        if not IsValid(ent) then return end
        for physID, parentPhysID in pairs(map or {}) do
            local phys = ent:GetPhysicsObjectNum(physID)
            local parentPhys = ent:GetPhysicsObjectNum(parentPhysID)
            if IsValid(phys) and IsValid(parentPhys) then
                phys:SetPos(parentPhys:GetPos())
                phys:SetAngles(parentPhys:GetAngles())
                phys:SetVelocity(parentPhys:GetVelocity())
            end
        end
    end

    local function BuildUpperHalf(rag, spine2, spine2PhysID)
        local visible = {}
        CollectDescendants(rag, spine2, visible)
        local parents = CollectParents(rag, spine2)
        local physParents = {}
        local seenPhys = {}

        for bone = 0, rag:GetBoneCount() - 1 do
            if not visible[bone] then
                SetHiddenBone(rag, bone, not parents[bone])
                local physID = rag:TranslateBoneToPhysBone(bone)
                if physID and physID >= 0 and not seenPhys[physID] then
                    seenPhys[physID] = true
                    ConfigureHiddenPhys(rag, physID)
                    if not parents[bone] then
                        rag:RemoveInternalConstraint(physID)
                    end
                    AddPhysParent(physParents, physID, spine2PhysID)
                end
            end
        end

        for parentBone in pairs(parents) do
            local physID = rag:TranslateBoneToPhysBone(parentBone)
            if physID and physID >= 0 then
                ConfigureHiddenPhys(rag, physID)
                AddPhysParent(physParents, physID, spine2PhysID)
            end
        end

        rag:RemoveInternalConstraint(spine2PhysID)
        return physParents
    end

    local function BuildLowerHalf(lower, spine2)
        local hidden = {}
        CollectDescendants(lower, spine2, hidden)
        local spine2PhysID = lower:TranslateBoneToPhysBone(spine2)
        local pelvis = lower:LookupBone('ValveBiped.Bip01_Pelvis')
        local pelvisPhysID = pelvis and lower:TranslateBoneToPhysBone(pelvis) or 0
        if not pelvisPhysID or pelvisPhysID < 0 then pelvisPhysID = 0 end
        local physParents = {}
        local seenPhys = {}

        for bone in pairs(hidden) do
            SetHiddenBone(lower, bone, bone ~= spine2)
            local physID = lower:TranslateBoneToPhysBone(bone)
            if physID and physID >= 0 and not seenPhys[physID] then
                seenPhys[physID] = true
                ConfigureHiddenPhys(lower, physID)
                if physID ~= pelvisPhysID then
                    lower:RemoveInternalConstraint(physID)
                    AddPhysParent(physParents, physID, pelvisPhysID)
                end
            end
        end

        if spine2PhysID and spine2PhysID >= 0 and spine2PhysID ~= pelvisPhysID then
            lower:RemoveInternalConstraint(spine2PhysID)
            AddPhysParent(physParents, spine2PhysID, pelvisPhysID)
        end

        return physParents
    end

    local function BuildSplitRagdolls(ply, rag, force)
        local spine2 = rag:LookupBone('ValveBiped.Bip01_Spine2')
        if not spine2 then return nil end
        local spine2PhysID = rag:TranslateBoneToPhysBone(spine2)
        if not spine2PhysID or spine2PhysID < 0 then return nil end
        local spine2Phys = rag:GetPhysicsObjectNum(spine2PhysID)
        if not IsValid(spine2Phys) then return nil end

        local lower = ents.Create('prop_ragdoll')
        if not IsValid(lower) then return nil end
        lower:SetModel(rag:GetModel())
        lower:SetPos(rag:GetPos())
        lower:SetAngles(rag:GetAngles())
        lower:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        lower:DrawShadow(false)
        lower:Spawn()
        CopyAppearance(rag, lower)
        CopyPhysicsPose(rag, lower)
        lower:SetNWBool('ZCityTorsoLowerPart', true)

        local lowerSpine2 = lower:LookupBone('ValveBiped.Bip01_Spine2')
        if not lowerSpine2 then
            lower:Remove()
            return nil
        end

        local upperPhysParents = BuildUpperHalf(rag, spine2, spine2PhysID)
        local lowerPhysParents = BuildLowerHalf(lower, lowerSpine2)

        rag:SetNWBool('ZCityTorsoSevered', true)
        ply:SetNWBool('ZCityTorsoSevered', true)

        local upperCap = MakeCap(TORSO_UPPER_MODEL, rag, spine2, Vector(-2, 2, 0), Angle(0, 90, 90), Vector(1, 1, 1))
        local lowerCap = MakeCap(TORSO_LOWER_MODEL, lower, lowerSpine2, Vector(-3, 2, 0), Angle(0, 90, 90), Vector(1.1, 1.1, 1.1))

        ForceHiddenPhys(rag, upperPhysParents)
        ForceHiddenPhys(lower, lowerPhysParents)

        local forceDir = force and force:LengthSqr() > 1 and force:GetNormalized() or VectorRand():GetNormalized()
        local push = math.Clamp(force and force:Length() * 0.012 or 260, 180, 620)
        local upperVelocity = spine2Phys:GetVelocity()
        spine2Phys:EnableMotion(true)
        spine2Phys:Wake()
        spine2Phys:SetVelocity(upperVelocity + forceDir * push + Vector(0, 0, 70))

        local pelvisBone = lower:LookupBone('ValveBiped.Bip01_Pelvis')
        local pelvisPhysID = pelvisBone and lower:TranslateBoneToPhysBone(pelvisBone) or 0
        local lowerRoot = lower:GetPhysicsObjectNum(pelvisPhysID or 0)
        if IsValid(lowerRoot) then
            lowerRoot:EnableMotion(true)
            lowerRoot:Wake()
            lowerRoot:SetVelocity(upperVelocity - forceDir * push * 0.45 + Vector(0, 0, 25))
            lowerRoot:AddAngleVelocity(VectorRand(-120, 120))
        end

        local state = {
            owner = ply,
            rag = rag,
            lower = lower,
            upperCap = upperCap,
            lowerCap = lowerCap,
            upperPhysParents = upperPhysParents,
            lowerPhysParents = lowerPhysParents
        }
        torsoStates[ply] = state
        splitStates[state] = true
        ply.__zcGoreLowerTorso = lower

        local life = lowerLifetimeCVar:GetFloat()
        if life > 0 then SafeRemoveEntityDelayed(lower, life) end
        return state
    end

    local function AddTorsoTrauma(ply, rag, fromExplosion)
        local org = ply.organism
        if not org then return end
        org.torsoamputated = true
        org.llegamputated = true
        org.rlegamputated = true
        org.painadd = math.min((org.painadd or 0) + (fromExplosion and 85 or 70), 150)
        org.shock = math.max(org.shock or 0, fromExplosion and 20 or 16)
        org.adrenaline = math.max(org.adrenaline or 0, fromExplosion and 3.4 or 3.0)
        org.adrenalineAdd = math.max(org.adrenalineAdd or 0, 4.5)
        org.internalBleed = (org.internalBleed or 0) + 24
        org.blood = math.max((org.blood or 5000) - 260, 0)
        org.needfake = true
        org.arterialwounds = org.arterialwounds or {}

        local clean = {}
        for _, wound in pairs(org.arterialwounds) do
            if wound[7] ~= "zcity_torso_artery_a" and wound[7] ~= "zcity_torso_artery_b" then
                clean[#clean + 1] = wound
            end
        end
        clean[#clean + 1] = {18, Vector(0, 0, 0), Angle(), "ValveBiped.Bip01_Spine1", CurTime(), Vector(-150, 0, 0), "zcity_torso_artery_a"}
        clean[#clean + 1] = {16, Vector(0, 0, 0), Angle(), "ValveBiped.Bip01_Spine1", CurTime(), Vector(150, 0, 0), "zcity_torso_artery_b"}
        org.arterialwounds = clean
        ply:SetNetVar("arterialwounds", clean)

        if ply.AddNaturalAdrenaline then ply:AddNaturalAdrenaline(3.5) end

        if hg.organism and hg.organism.AddWoundManual then
            for i = 1, 6 do
                hg.organism.AddWoundManual(ply, 65, VectorRand(-2.5, 2.5), AngleRand(-12, 12), "ValveBiped.Bip01_Spine1", CurTime() + math.Rand(0, 1.2))
            end
        end

        net.Start("organism_send")
        net.WriteTable({owner = ply, llegamputated = true, rlegamputated = true})
        net.WriteBool(true)
        net.WriteBool(false)
        net.WriteBool(false)
        net.WriteBool(true)
        net.Broadcast()

        local splitPos = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Spine2"))
        if splitPos and SpawnMeatGore then
            SpawnMeatGore(rag, splitPos, 10, VectorRand(-350, 350), 1.15)
        end
        if splitPos then
            util.Decal("Blood", splitPos + Vector(0, 0, 10), splitPos - Vector(0, 0, 35), rag)
        end

        PlayTear(ply, 92, 1.15)
        ply:EmitSound("physics/body/body_medium_break3.wav", 88, math.random(82, 94), 1)
        ply:Notify(PickPhrase(ply, initialPhrases, "__zcGoreLastInitialPhrase"), 4, "zcity_torso_initial", 0, nil, Color(255, 80, 70))

        local timerName = ADDON_TAG .. "_PainPhrases_" .. ply:EntIndex()
        timer.Remove(timerName)
        timer.Create(timerName, 6, 7, function()
            if not IsValid(ply) or not ply:Alive() then
                timer.Remove(timerName)
                return
            end
            if not ply:GetNWBool("ZCityTorsoSevered", false) then
                timer.Remove(timerName)
                return
            end
            if ply.organism and not ply.organism.otrub then
                local orgNow = ply.organism
                local phrasePool = ((orgNow.blood or 5000) < 3000 or (orgNow.shock or 0) > 28) and criticalPhrases or painPhrases
                ply:Notify(PickPhrase(ply, phrasePool, "__zcGoreLastPainPhrase"), 2, timerName .. "_" .. tostring(math.random(1000000)), 0, nil, Color(255, 105, 95))
            end
        end)
    end

    local function EnsureFakeAndSplit(ply, force, fromExplosion)
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return false end
        if ply:GetNWBool("ZCityTorsoSevered", false) or (ply.organism and ply.organism.torsoamputated) then return false end
        if ply.__zcGoreTorsoPending then return false end
        ply.__zcGoreTorsoPending = true

        if not IsValid(ply.FakeRagdoll) then
            if not hg or not hg.Fake then
                ply.__zcGoreTorsoPending = nil
                return false
            end
            hg.Fake(ply, nil, nil, true)
        end

        local rag = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or (hg and hg.GetCurrentCharacter and hg.GetCurrentCharacter(ply) or nil)
        if not IsValid(rag) or not rag:IsRagdoll() then
            ply.__zcGoreTorsoPending = nil
            return false
        end
        local state = BuildSplitRagdolls(ply, rag, force or vector_origin)
        if not state then
            ply.__zcGoreTorsoPending = nil
            return false
        end
        AddTorsoTrauma(ply, rag, fromExplosion)
        ply.__zcGoreTorsoPending = nil
        return true
    end

    hg = hg or {}
    hg.ZCityGore_AmputateTorso = function(ent, force, fromExplosion)
        local ply = ResolvePlayer(ent)
        if not IsValid(ply) then return false end
        return EnsureFakeAndSplit(ply, force or VectorRand(-250, 250), fromExplosion == true)
    end

    local blastMask = bit.bor(DMG_BLAST, DMG_BLAST_SURFACE or 0)
    local blastMinDamageCVar = CreateConVar("zcity_gore_torso_blast_min_damage", "35", FCVAR_ARCHIVE, "Minimum blast damage used when explosion origin cannot be resolved", 0, 500)

    local function IsBlastDamage(dmgInfo)
        if not dmgInfo then return false end
        return bit.band(dmgInfo:GetDamageType(), blastMask) ~= 0
    end

    local function GetTorsoPosition(ply, target)
        local character = IsValid(target) and target or nil
        if not IsValid(character) or not character:IsRagdoll() then
            character = hg and hg.GetCurrentCharacter and hg.GetCurrentCharacter(ply) or ply
        end
        local torsoPos = IsValid(character) and character:WorldSpaceCenter() or ply:WorldSpaceCenter()
        if IsValid(character) then
            local bone = character:LookupBone("ValveBiped.Bip01_Spine2")
            if bone then
                local pos = character:GetBonePosition(bone)
                if pos then torsoPos = pos end
            end
        end
        return torsoPos
    end

    local function GetExplosionOrigin(target, dmgInfo)
        local inflictor = dmgInfo:GetInflictor()
        if IsValid(inflictor) and inflictor ~= target and not inflictor:IsPlayer() and not inflictor:IsWeapon() and inflictor:GetClass() ~= "worldspawn" then
            return inflictor:WorldSpaceCenter(), true
        end
        local attacker = dmgInfo:GetAttacker()
        if IsValid(attacker) and attacker ~= target and not attacker:IsPlayer() and not attacker:IsWeapon() and attacker:GetClass() ~= "worldspawn" then
            return attacker:WorldSpaceCenter(), true
        end
        local damagePos = dmgInfo:GetDamagePosition()
        if damagePos and damagePos:LengthSqr() > 1 then return damagePos, false end
        return nil, false
    end

    local function FindDeathRagdoll(ply, target)
        if IsValid(target) and target:IsRagdoll() then return target end
        if IsValid(ply.RagdollDeath) then return ply.RagdollDeath end
        local nwRag = ply:GetNWEntity("RagdollDeath")
        if IsValid(nwRag) then return nwRag end
        if IsValid(ply.FakeRagdoll) then return ply.FakeRagdoll end
        return nil
    end

    local function SplitDeadRagdoll(ply, target, force)
        local rag = FindDeathRagdoll(ply, target)
        if not IsValid(rag) or not rag:IsRagdoll() or rag:GetNWBool("ZCityTorsoSevered", false) then return false end
        local state = BuildSplitRagdolls(ply, rag, force or vector_origin)
        if not state then return false end
        local splitBone = rag:LookupBone("ValveBiped.Bip01_Spine2")
        local splitPos = splitBone and rag:GetBonePosition(splitBone) or rag:WorldSpaceCenter()
        if splitPos and SpawnMeatGore then SpawnMeatGore(rag, splitPos, 10, VectorRand(-350, 350), 1.15) end
        if splitPos then util.Decal("Blood", splitPos + Vector(0, 0, 10), splitPos - Vector(0, 0, 35), rag) end
        PlayTear(rag, 92, 1.15)
        rag:EmitSound("physics/body/body_medium_break3.wav", 88, math.random(82, 94), 1)
        return true
    end

    local function QueueBlastTorso(target, dmgInfo)
        if not IsBlastDamage(dmgInfo) then return end
        local ply = ResolvePlayer(target)
        if not IsValid(ply) then return end
        if ply.__zcGoreTorsoPending or ply.__zcGoreBlastQueued or ply:GetNWBool("ZCityTorsoSevered", false) then return end
        if IsValid(target) and target:GetNWBool("ZCityTorsoSevered", false) then return end
        local attacker = dmgInfo:GetAttacker()
        if IsValid(attacker) and attacker:GetClass() == "npc_zombie" then return end

        local torsoPos = GetTorsoPosition(ply, target)
        local blastPos, reliableOrigin = GetExplosionOrigin(target, dmgInfo)
        local closeEnough = false
        if blastPos and reliableOrigin then
            closeEnough = torsoPos:DistToSqr(blastPos) <= blastRadiusCVar:GetFloat() ^ 2
        elseif blastPos then
            closeEnough = torsoPos:DistToSqr(blastPos) <= math.max(blastRadiusCVar:GetFloat(), 120) ^ 2 or dmgInfo:GetDamage() >= blastMinDamageCVar:GetFloat()
        else
            closeEnough = dmgInfo:GetDamage() >= blastMinDamageCVar:GetFloat()
        end
        if not closeEnough then return end

        local force = dmgInfo:GetDamageForce()
        local targetRef = IsValid(target) and target or nil
        ply.__zcGoreBlastQueued = true
        timer.Simple(0, function()
            if not IsValid(ply) then return end
            ply.__zcGoreBlastQueued = nil
            if ply:GetNWBool("ZCityTorsoSevered", false) then return end
            if IsValid(targetRef) and targetRef:GetNWBool("ZCityTorsoSevered", false) then return end
            if ply:Alive() then
                EnsureFakeAndSplit(ply, force, true)
            else
                SplitDeadRagdoll(ply, targetRef, force)
            end
        end)
    end

    hook.Add("EntityTakeDamage", ADDON_TAG .. "_BlastTorso", QueueBlastTorso)
    hook.Add("PostEntityTakeDamage", ADDON_TAG .. "_BlastTorsoPost", QueueBlastTorso)

    hook.Add("Should Fake Up", ADDON_TAG .. "_NoStand", function(ply)
        if IsValid(ply) and ply:GetNWBool("ZCityTorsoSevered", false) then return false end
    end)

    hook.Add("StartCommand", ADDON_TAG .. "_NoLegDuckControl", function(ply, cmd)
        if IsValid(ply) and ply:GetNWBool("ZCityTorsoSevered", false) then
            cmd:RemoveKey(IN_DUCK)
        end
    end)

    hook.Add("Think", ADDON_TAG .. "_SplitPhysics", function()
        for state in pairs(splitStates) do
            local ragValid = state and IsValid(state.rag)
            local lowerValid = state and IsValid(state.lower)
            if not ragValid and not lowerValid then
                splitStates[state] = nil
            else
                if ragValid then
                    ForceHiddenPhys(state.rag, state.upperPhysParents)
                    if IsValid(state.upperCap) then UpdateCap(state.upperCap) end
                end
                if lowerValid then
                    ForceHiddenPhys(state.lower, state.lowerPhysParents)
                    if IsValid(state.lowerCap) then UpdateCap(state.lowerCap) end
                end
            end
        end
        for ply, state in pairs(torsoStates) do
            if not IsValid(ply) or not ply:Alive() or not ply:GetNWBool("ZCityTorsoSevered", false) or not state then
                torsoStates[ply] = nil
            end
        end
    end)

    hook.Add("PlayerSpawn", ADDON_TAG .. "_ResetTorso", function(ply)
        ply:SetNWBool("ZCityTorsoSevered", false)
        ply.__zcGoreTorsoPending = nil
        ply.__zcGoreBlastQueued = nil
        ply.__zcGoreLowerTorso = nil
        ply.__zcGoreLastInitialPhrase = nil
        ply.__zcGoreLastPainPhrase = nil
        torsoStates[ply] = nil
        timer.Remove(ADDON_TAG .. "_PainPhrases_" .. ply:EntIndex())
    end)

    hook.Add("PlayerDisconnected", ADDON_TAG .. "_CleanupTorso", function(ply)
        ply.__zcGoreBlastQueued = nil
        ply.__zcGoreLowerTorso = nil
        torsoStates[ply] = nil
        timer.Remove(ADDON_TAG .. "_PainPhrases_" .. ply:EntIndex())
    end)

    local function PropertyFilter(self, ent, ply)
        if not IsValid(ply) or not ply.ZCTools_GetAccess or not ply:ZCTools_GetAccess() then return false end
        if not IsValid(ent) then return false end
        if ent:IsPlayer() then return true end
        local owner = hg and hg.RagdollOwner and hg.RagdollOwner(ent) or nil
        if ent:IsRagdoll() and IsValid(owner) and owner:IsPlayer() and owner:Alive() then return true end
        return false
    end

    local function InstallAmputationProperty()
        if not properties or not properties.Add or not hg or not hg.organism then return false end
        properties.Add("amputate_limb", {
            MenuLabel = "Amputate Limb",
            Order = 14,
            MenuIcon = "effects/arc9_eft/evil.png",
            Filter = PropertyFilter,
            MenuOpen = function(self, option, ent)
                local owner = hg.RagdollOwner(ent) or ent
                local submenu = option:AddSubMenu()
                local entries = {
                    {"Head", 0},
                    {"Left Arm", 1},
                    {"Right Arm", 2},
                    {"Left Leg", 3},
                    {"Right Leg", 4},
                    {"Amputate Torso", 5}
                }
                for _, data in ipairs(entries) do
                    local item = submenu:AddOption(data[1])
                    item.OnChecked = function() self:AmputateLimb(owner, data[2]) end
                    item:SetIsCheckable(true)
                end
            end,
            AmputateLimb = function(self, ent, id)
                self:MsgStart()
                net.WriteEntity(ent)
                net.WriteUInt(id, 8)
                self:MsgEnd()
            end,
            Receive = function(self, _, ply)
                local ent = net.ReadEntity()
                local limb = net.ReadUInt(8)
                if not self:Filter(ent, ply) then return end
                ent = hg.RagdollOwner(ent) or ent
                if limb == 0 then
                    if not ent.noHead then hg.ExplodeHead(ent) end
                elseif limb == 1 then
                    hg.organism.AmputateLimb(ent.organism, "larm")
                elseif limb == 2 then
                    hg.organism.AmputateLimb(ent.organism, "rarm")
                elseif limb == 3 then
                    hg.organism.AmputateLimb(ent.organism, "lleg")
                elseif limb == 4 then
                    hg.organism.AmputateLimb(ent.organism, "rleg")
                elseif limb == 5 then
                    hg.ZCityGore_AmputateTorso(ent, VectorRand(-250, 250), false)
                end
            end
        })
        return true
    end

    local function InstallServerCompatibility()
        if not hg or not hg.organism or not isfunction(hg.organism.AmputateLimb) then return false end
        if hg.organism.AmputateLimb ~= hg.ZCityGore_WrappedAmputateLimb then
            local baseAmputate = hg.organism.AmputateLimb
            local wrapped
            wrapped = function(org, limb, ...)
                local owner = org and org.owner
                if IsValid(owner) then owner.__zcGoreSuppressOldAmpSound = true end
                local results = {baseAmputate(org, limb, ...)}
                if IsValid(owner) then
                    owner.__zcGoreSuppressOldAmpSound = nil
                    PlayTear(owner)
                end
                return unpack(results)
            end
            hg.ZCityGore_BaseAmputateLimb = baseAmputate
            hg.ZCityGore_WrappedAmputateLimb = wrapped
            hg.organism.AmputateLimb = wrapped
        end
        InstallAmputationProperty()
        return true
    end

    hook.Add("HomigradRun", ADDON_TAG .. "_ServerInstall", function()
        timer.Simple(0, InstallServerCompatibility)
    end)

    timer.Create(ADDON_TAG .. "_ServerWait", 0.25, 40, function()
        if InstallServerCompatibility() then timer.Remove(ADDON_TAG .. "_ServerWait") end
    end)

    return
end

local stumpData = {
    ["ValveBiped.Bip01_L_Forearm"] = {
        model = Model("models/limbspartial/elbowleft.mdl"),
        ang = Angle(-90, 0, 0),
        offset = Vector(0.5, 0, -0.7),
        expose = 3.25,
        scale = 1
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        model = Model("models/limbspartial/elbowright.mdl"),
        ang = Angle(-90, 0, 0),
        offset = Vector(0.5, 0, 0.7),
        expose = 3.25,
        scale = 1
    },
    ["ValveBiped.Bip01_L_Calf"] = {
        model = Model("models/limbspartial/kneeleft.mdl"),
        ang = Angle(90, 90, -90),
        offset = Vector(0, 0, 0),
        expose = 5.25,
        scale = 0.85
    },
    ["ValveBiped.Bip01_R_Calf"] = {
        model = Model("models/limbspartial/kneeright.mdl"),
        ang = Angle(-90, -90, 90),
        offset = Vector(0, 0, 0),
        expose = 5.25,
        scale = 0.85
    }
}

local limbs = {
    lleg = "ValveBiped.Bip01_L_Calf",
    rleg = "ValveBiped.Bip01_R_Calf",
    larm = "ValveBiped.Bip01_L_Forearm",
    rarm = "ValveBiped.Bip01_R_Forearm",
    head = "ValveBiped.Bip01_Head1"
}

local stumpModels = {}
local vecAlmostZero = Vector(0.01, 0.01, 0.01)

local function DrawStump(modelPath, pos, ang, scale)
    local mdl = stumpModels[modelPath]
    if not IsValid(mdl) then
        mdl = ClientsideModel(modelPath, RENDERGROUP_OPAQUE)
        if not IsValid(mdl) then return end
        mdl:SetNoDraw(true)
        mdl:DrawShadow(false)
        stumpModels[modelPath] = mdl
    end
    mdl:SetRenderOrigin(pos)
    mdl:SetRenderAngles(ang)
    mdl:SetModelScale(scale or 1, 0)
    mdl:SetupBones()
    mdl:DrawModel()
end

local function RemoveClientModels()
    for path, mdl in pairs(stumpModels) do
        if IsValid(mdl) then mdl:Remove() end
        stumpModels[path] = nil
    end
end

hook.Add("ShutDown", ADDON_TAG .. "_Cleanup", RemoveClientModels)

local function NewGoreCalc(ent, ply)
    if not IsValid(ent) then return end
    local org = ent.new_organism or ent.organism
    if not org then return end
    local torsoSevered = ent:GetNWBool("ZCityTorsoSevered", false)

    for limb, boneName in pairs(limbs) do
        if torsoSevered and (limb == "lleg" or limb == "rleg") then
        else
            local bone = ent:LookupBone(boneName)
            if bone then
                if not org[limb .. "amputated"] then
                    local currentScale = ent:GetManipulateBoneScale(bone)
                    if currentScale and not currentScale:IsEqualTol(FULL_SCALE, 0.01) then
                        ent:ManipulateBoneScale(bone, FULL_SCALE)
                    end
                else
                    local parentBone = ent:GetBoneParent(bone)
                    if parentBone and parentBone >= 0 then
                        local boneMatrix = ent:GetBoneMatrix(bone)
                        local parentMatrix = ent:GetBoneMatrix(parentBone)
                        if boneMatrix and parentMatrix then
                            boneMatrix:SetScale(vecAlmostZero)
                            if hg and hg.bone_apply_matrix then
                                hg.bone_apply_matrix(ent, bone, boneMatrix)
                                if IsValid(ply) and IsValid(ply.OldFakeRagdoll) then
                                    hg.bone_apply_matrix(ply, bone, boneMatrix)
                                end
                            else
                                ent:ManipulateBoneScale(bone, vecAlmostZero)
                            end
                            local data = stumpData[boneName]
                            if data then
                                local localPos = WorldToLocal(boneMatrix:GetTranslation(), boneMatrix:GetAngles(), parentMatrix:GetTranslation(), parentMatrix:GetAngles())
                                local outward = localPos:GetNormalized()
                                local pushedLocalPos = localPos + data.offset + outward * (data.expose or 0)
                                local pos, ang = LocalToWorld(pushedLocalPos, data.ang, parentMatrix:GetTranslation(), parentMatrix:GetAngles())
                                DrawStump(data.model, pos, ang, data.scale)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ClientPropertyFilter(self, ent, ply)
    if not IsValid(ply) or not ply.ZCTools_GetAccess or not ply:ZCTools_GetAccess() then return false end
    if not IsValid(ent) then return false end
    if ent:IsPlayer() then return true end
    local owner = hg and hg.RagdollOwner and hg.RagdollOwner(ent) or nil
    return ent:IsRagdoll() and IsValid(owner) and owner:IsPlayer() and owner:Alive() or false
end

local function InstallClientAmputationProperty()
    if not properties or not properties.Add or not hg then return false end
    properties.Add("amputate_limb", {
        MenuLabel = "Amputate Limb",
        Order = 14,
        MenuIcon = "effects/arc9_eft/evil.png",
        Filter = ClientPropertyFilter,
        MenuOpen = function(self, option, ent)
            local owner = hg.RagdollOwner(ent) or ent
            local submenu = option:AddSubMenu()
            local entries = {
                {"Head", 0},
                {"Left Arm", 1},
                {"Right Arm", 2},
                {"Left Leg", 3},
                {"Right Leg", 4},
                {"Amputate Torso", 5}
            }
            for _, data in ipairs(entries) do
                local item = submenu:AddOption(data[1])
                item.OnChecked = function() self:AmputateLimb(owner, data[2]) end
                item:SetIsCheckable(true)
            end
        end,
        AmputateLimb = function(self, ent, id)
            self:MsgStart()
            net.WriteEntity(ent)
            net.WriteUInt(id, 8)
            self:MsgEnd()
        end
    })
    return true
end

local function InstallClientCompatibility()
    if not hg or not isfunction(hg.GoreCalc) or not hg.bone_apply_matrix then return false end
    if hg.GoreCalc ~= NewGoreCalc then
        hg.ZCityGore_BaseGoreCalc = hg.GoreCalc
        hg.GoreCalc = NewGoreCalc
    end
    InstallClientAmputationProperty()
    hg.ZCityGoreInstalled = true
    return true
end

hook.Add("HomigradRun", ADDON_TAG .. "_ClientInstall", function()
    timer.Simple(0, InstallClientCompatibility)
end)

timer.Create(ADDON_TAG .. "_ClientWait", 0.25, 40, function()
    if InstallClientCompatibility() then timer.Remove(ADDON_TAG .. "_ClientWait") end
end)
