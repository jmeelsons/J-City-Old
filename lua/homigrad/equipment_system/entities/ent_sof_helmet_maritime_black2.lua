--\\ Ops-Core Maritime (без чехла) + ПНВ + шумодав
-- Модель: models/USOF-H/SFG-Helmet-Maritime_B.mdl (основной) / _A (альт. камо)

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "Ops-Core Maritime Helmet"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/USOF-H/SFG-Helmet-Maritime_C.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "vgui/icons/helmet"

--\\ Занимаем HEAD + EARS -> наушники надеть нельзя
ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_HEAD] = true,
    [ZC_ARMOR_SLOT_EARS] = true,
}

--\\ Фичи шлема
ENT.HasNVG = true
ENT.HasSoundSuppression = true

--\\ Оверлей в первом лице
ENT.ShouldRenderLocaly = false
ENT.Overlay = {}
ENT.Overlay.Model = "models/USOF-H/SFG-Helmet-Maritime_C.mdl"
ENT.Overlay.ModelMaterial = nil
ENT.Overlay.PosAdjust = Vector(-2.2, 0, -0.6)
ENT.Overlay.Fov = -55

ENT.DrawOverlay = hg.DrawFirstPersonHelmet

--\\ HitBoxSets
local HitBoxSet = "sof_helmet_maritime"
ENT.HitBoxSet = HitBoxSet
local c = Color(0, 200, 100)

-- Front
local HB  = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(6.5, -6, 0), Angle(0, 0, 0), Vector(2, 1, 3.5), c, true)
local HBF = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(5.5, -4.5, 0), Angle(0, 0, 0), Vector(2, 1, 3.5), c, true)
hg.organism:CreateHitBox("Front", HB, HBF)

-- Back
local HB  = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(4.5, 3, 0), Angle(0, 0, 0), Vector(4, 1, 3.5), c, true)
local HBF = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(3.5, 4.5, 0), Angle(0, 0, 0), Vector(4, 1, 3.5), c, true)
hg.organism:CreateHitBox("Back", HB, HBF)

-- Top
local HB  = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(7.8, -1.5, 0), Angle(0, 0, 0), Vector(1, 3.5, 3.5), c, true)
local HBF = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(6.8, 0, 0), Angle(0, 0, 0), Vector(1, 3.5, 3.5), c, true)
hg.organism:CreateHitBox("Top", HB, HBF)

-- Sides
local HB  = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(5.9, -2, 3.5), Angle(0, 3, 0), Vector(1.8, 4, 1), c, true)
local HBF = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(4.8, -2, 3.5), Angle(0, 15, 0), Vector(1.8, 2, 1), c, true)
hg.organism:CreateHitBox("SideR", HB, HBF)

local HB  = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(5.9, -2, -3.5), Angle(0, 3, 0), Vector(1.8, 4, 1), c, true)
local HBF = hg.organism:HitBox("ValveBiped.Bip01_Head1", HitBoxSet, 1, Vector(4.8, -2, -3.5), Angle(0, 15, 0), Vector(1.8, 2, 1), c, true)
hg.organism:CreateHitBox("SideL", HB, HBF)

hg.organism:AddArmorInputList(HitBoxSet, ZC_ARMOR_SLOT_HEAD)

--\\ Плиты
local FP, BP, SLP, SRP, TP = "FrontPlate", "BackPlate", "SideLPlate", "SideRPlate", "TopPlate"

ENT.PlatesLinks = {
    Front = FP, Back = BP,
    SideR = SRP, SideL = SLP,
    Top   = TP,
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
        NeedPunch = true,
    }
end

ENT[FP]  = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.55, 0.85, ZC_ARMOR_MATERIAL_UHMWPE_CERAMIC, 55, 15)
ENT[BP]  = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.55, 0.85, ZC_ARMOR_MATERIAL_UHMWPE_CERAMIC, 55, 15)
ENT[TP]  = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.6,  0.9,  ZC_ARMOR_MATERIAL_UHMWPE,         45, 10)
ENT[SLP] = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.6,  0.9,  ZC_ARMOR_MATERIAL_UHMWPE,         25, 10)
ENT[SRP] = MakePlate(ZC_ARMOR_PROTCLASS_IIIA, 0.6,  0.9,  ZC_ARMOR_MATERIAL_UHMWPE,         25, 10)

--\\ Рендер на модели игрока
ENT.Male = {
    Model = "models/USOF-H/SFG-Helmet-Maritime_C.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 1,
    Bodygroups = "110016300000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Head1",
    OffsetPos = Vector(-63.2, -12.5, 0),
    OffsetAng = Angle(180, 100, 90),
    ModelSize = 1,
	nobonemerge = true,
}

ENT.FeMale = {
    Model = "models/USOF-H/SFG-Helmet-Maritime_C.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Head1",
    OffsetPos = Vector(0, 0, 0),
    OffsetAng = Angle(0, 0, 0),
    ModelSize = 0.95,
}

local filename = string.StripExtension(string.GetFileFromFilename(GetCurrentLuaFile()))
scripted_ents.Register(ENT, filename)