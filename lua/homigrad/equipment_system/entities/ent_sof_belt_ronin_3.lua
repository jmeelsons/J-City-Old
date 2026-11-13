--\\ JPC (Jumpable Plate Carrier)
-- Модель: models/USOF-V/SFG-Vest-JPC_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "Ronin belt(Mod3)"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/USOF-B/SFG-Belt-Ronin_A.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_PELVIS] = true,
}

ENT.Male = {
    Model = "models/USOF-B/SFG-Belt-Ronin_A.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0512111000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Pelvis",
    OffsetPos = Vector(0, -41.5, -1),
    OffsetAng = Angle(270, 270, 0),
    ModelSize = 1.05,            
}

ENT.FeMale = {
    Model = "models/USOF-B/SFG-Belt-Ronin_A.mdl",
    ModelSubMaterials = {},
    HideSubMaterails = {},
    Skin = 0,
    Bodygroups = "0000000000000",
    BoneMerge = false,
    ParentBone = "ValveBiped.Bip01_Pelvis",
    OffsetPos = Vector(0, 0, 0),
    OffsetAng = Angle(0, 0, 0),
    ModelSize = 0.95,
}

local filename = string.StripExtension(string.GetFileFromFilename(GetCurrentLuaFile()))
scripted_ents.Register(ENT, filename)