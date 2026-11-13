--\\ JPC (Jumpable Plate Carrier)
-- Модель: models/USOF-V/SFG-Vest-JPC_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "Борода"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/props_c17/SuitCase001a.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"
ENT.norender = true 

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_FACE] = true,
}

ENT.Male = {
    Model = "models/eft_modular/gear/facecover/beard.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Head1",
    OffsetPos = Vector(-65,-1.5,0),
    OffsetAng = Angle(180,90,90),
    ModelSize = 1, 
}

ENT.FeMale = {
    Model = "models/eft_modular/gear/facecover/beard.mdl",
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