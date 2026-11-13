--\\ JPC (Jumpable Plate Carrier)
-- Модель: models/USOF-V/SFG-Vest-JPC_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "AVS-Black-Backpack"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/BlackOP/Vest_B.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_TORSO] = true,
}

local HitBoxSet = "sof_vest_jpc"
ENT.HitBoxSet = HitBoxSet
local c = Color(255, 200, 0)

-- Front
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, 0),    Angle(0, -4, 0), Vector(3, 1, 3.5), c, true)
hg.organism:CreateHitBox("Front", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(0, 7.5, 0),    Angle(0, -4, 0), Vector(4.1, 1, 5.2), c, true)
hg.organism:CreateHitBox("FrontDown", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, -2.9), Angle(-18, -4, 0), Vector(2.5, 1, 1.5), c, true)
hg.organism:CreateHitBox("FrontRight", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, 2.9),  Angle(18, -4, 0), Vector(2.5, 1, 1.5), c, true)
hg.organism:CreateHitBox("FrontLeft", HB)

-- Back
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, 0), Angle(0, -4, 0), Vector(3, 1, 3.5), c, true)
hg.organism:CreateHitBox("Back", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(0, -2.5, 0), Angle(0, -4, 0), Vector(4.1, 1, 5.2), c, true)
hg.organism:CreateHitBox("BackDown", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, -2.9), Angle(-18, -4, 0), Vector(2.5, 1, 1.5), c, true)
hg.organism:CreateHitBox("BackRight", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, 2.9),  Angle(18, -4, 0), Vector(2.5, 1, 1.5), c, true)
hg.organism:CreateHitBox("BackLeft", HB)

-- Sides (мягкие)
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(-1.7, 2.5, 6),  Angle(0, 0, 90), Vector(2.5, 0.5, 4.5), c, true)
hg.organism:CreateHitBox("LeftSide", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(-1.7, 2.5, -6), Angle(0, 0, 90), Vector(2.5, 0.5, 4.5), c, true)
hg.organism:CreateHitBox("RightSide", HB)

hg.organism:AddArmorInputList(HitBoxSet, ZC_ARMOR_SLOT_TORSO)

local FP, BP, LP, RP = "FrontPlate", "BackPlate", "LeftPlate", "RightPlate"
ENT.PlatesLinks = {
    Front = FP, FrontDown = FP, FrontRight = FP, FrontLeft = FP,
    Back  = BP, BackDown  = BP, BackRight  = BP, BackLeft  = BP,
    LeftSide = LP, RightSide = RP,
}

local function MakePlate(prot, pm, pen, mat, dur, w)
    return {
        Protection = prot,
        ProtectionDamageMul = pm,
        PenetratedDamageMul = pen,
        BalisticMaterial = mat,
        Durability = dur,
        DurabilityMax = dur,
        DurabilityWarranty = w,
        NeedPunch = false,
    }
end

ENT[FP] = MakePlate(ZC_ARMOR_PROTCLASS_IV,   0.4,  0.7,  ZC_ARMOR_MATERIAL_CERAMIC, 160, 60)
ENT[BP] = MakePlate(ZC_ARMOR_PROTCLASS_IV,   0.4,  0.7,  ZC_ARMOR_MATERIAL_CERAMIC, 160, 60)
ENT[LP] = MakePlate(ZC_ARMOR_PROTCLASS_II,   0.6,  0.8,  ZC_ARMOR_MATERIAL_KEVLAR,   25, 20)
ENT[RP] = MakePlate(ZC_ARMOR_PROTCLASS_II,   0.6,  0.8,  ZC_ARMOR_MATERIAL_KEVLAR,   25, 20)

ENT.Male = {
    Model = "models/BlackOP/Vest_B.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Spine2",
    OffsetPos = Vector(-49.6,3.1, 0),
    OffsetAng = Angle(0, 90, 90),
    ModelSize = 1,            
}

ENT.FeMale = {
    Model = "models/BlackOP/Vest_B.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Spine2",
    OffsetPos = Vector(0, 0, 0),
    OffsetAng = Angle(0, 0, 0),
    ModelSize = 0.95,
}

local filename = string.StripExtension(string.GetFileFromFilename(GetCurrentLuaFile()))
scripted_ents.Register(ENT, filename)