--\\ JPC (Jumpable Plate Carrier)
-- Модель: models/USOF-V/SFG-Vest-JPC_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "Glock(Safari Holster)"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/weapons/arccw/c_ud_glock.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_THIGH_R_ATTACH] = true,
}

ENT.Male = {
    Model = "models/weapons/arccw/c_ud_glock.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0001000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_R_Thigh",
    OffsetPos = Vector(-5,-7,0),
    OffsetAng = Angle(0,5,65),
    ModelSize = 1, 
    nobonemerge = true,
}

ENT.FeMale = {
    Model = "models/weapons/arccw/c_ud_glock.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_R_Thigh",
    OffsetPos = Vector(0, 0, 0),
    OffsetAng = Angle(0, 0, 0),
    ModelSize = 0.95,
}

local filename = string.StripExtension(string.GetFileFromFilename(GetCurrentLuaFile()))
scripted_ents.Register(ENT, filename)