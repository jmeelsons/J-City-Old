--\\ AVS (Adaptive Vest System) — тяжелее JPC, боковые плиты IIIA
-- Модель: models/USOF-V/SFG-Vest-AVS_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "JPC-Mod1"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/USOF-V/SFG-Vest-AVS_B.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_TORSO] = true,
    [ZC_ARMOR_SLOT_BELLY] = true,
}

local HitBoxSet = "sof_vest_avs"
ENT.HitBoxSet = HitBoxSet
local c = Color(220, 60, 60)

-- Front
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, 0),    Angle(0, -4, 0), Vector(4, 1.2, 5), c, true)
hg.organism:CreateHitBox("Front", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(0, 7.5, 0),    Angle(0, -4, 0), Vector(5, 1.2, 6.5), c, true)
hg.organism:CreateHitBox("FrontDown", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, -3.5), Angle(-18, -4, 0), Vector(3, 1.2, 2), c, true)
hg.organism:CreateHitBox("FrontRight", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, 7, 3.5),  Angle(18, -4, 0), Vector(3, 1.2, 2), c, true)
hg.organism:CreateHitBox("FrontLeft", HB)

-- Back
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, 0), Angle(0, -4, 0), Vector(4, 1.2, 5), c, true)
hg.organism:CreateHitBox("Back", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(0, -2.5, 0), Angle(0, -4, 0), Vector(5, 1.2, 6.5), c, true)
hg.organism:CreateHitBox("BackDown", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, -3.5), Angle(-18, -4, 0), Vector(3, 1.2, 2), c, true)
hg.organism:CreateHitBox("BackRight", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(5.8, -3, 3.5),  Angle(18, -4, 0), Vector(3, 1.2, 2), c, true)
hg.organism:CreateHitBox("BackLeft", HB)

-- Sides — жёсткие плиты
local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(-1.7, 2.5, 6),  Angle(0, 0, 90), Vector(3, 0.8, 5.5), c, true)
hg.organism:CreateHitBox("LeftSide", HB)

local HB = hg.organism:HitBox("ValveBiped.Bip01_Spine2", HitBoxSet, 1, Vector(-1.7, 2.5, -6), Angle(0, 0, 90), Vector(3, 0.8, 5.5), c, true)
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

ENT[FP] = MakePlate(ZC_ARMOR_PROTCLASS_IV,   0.35, 0.65, ZC_ARMOR_MATERIAL_CERAMIC, 190, 80)
ENT[BP] = MakePlate(ZC_ARMOR_PROTCLASS_IV,   0.35, 0.65, ZC_ARMOR_MATERIAL_CERAMIC, 190, 80)
ENT[LP] = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.55, 0.85, ZC_ARMOR_MATERIAL_UHMWPE,   40, 15)
ENT[RP] = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.55, 0.85, ZC_ARMOR_MATERIAL_UHMWPE,   40, 15)

ENT.Male = {
    Model = "models/USOF-V/SFG-Vest-AVS_B.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0214000100000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Spine2",
    OffsetPos = Vector(-49.6,3.1, 0),
    OffsetAng = Angle(0, 90, 90),
    ModelSize = 1,
	nobonemerge = true,
}

ENT.FeMale = {
    Model = "models/USOF-V/SFG-Vest-AVS_B.mdl",
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