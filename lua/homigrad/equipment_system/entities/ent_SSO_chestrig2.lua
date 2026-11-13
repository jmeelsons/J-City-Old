--\\ JPC (Jumpable Plate Carrier)
-- Модель: models/USOF-V/SFG-Vest-JPC_B.mdl / _A

if not load_from_armor_file then return end
DEFINE_BASECLASS("ent_zcity_armor_base")

local ENT = {}
ENT.Type = "anim"
ENT.Base = "ent_zcity_armor_base"
ENT.PrintName = "SSO Chestrig V2"
ENT.Category = "ZCity TestArmor"
ENT.Spawnable = true
ENT.Model = "models/sso_ru_asset_xyi/char/C_A_ChestRig_SSO_V2.mdl"
ENT.ModelMaterial = nil
ENT.IconOverride = "scrappers/armor1.png"

ENT.SlotOccupation = {
    [ZC_ARMOR_SLOT_TORSO] = true,
}

ENT.Male = {
    Model = "models/sso_ru_asset_xyi/char/C_A_ChestRig_SSO_V2.mdl",
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
    Model = "models/sso_ru_asset_xyi/char/C_A_ChestRig_SSO_V2.mdl",
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