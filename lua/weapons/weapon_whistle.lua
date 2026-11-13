if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_tpik_base"

if CLIENT then
    SWEP.PrintName = "Trench Whistle"
    SWEP.Slot = 2
    SWEP.SlotPos = 1
end

SWEP.WepSelectIcon = Material("vgui/weapons/trench.png")
SWEP.WepSelectIcon2box = true
SWEP.WepSelectIcon2 = Material("vgui/weapons/trench.png")
SWEP.IconOverride = "vgui/weapons/trench.png"

SWEP.Category = "Weapons - Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Instructions = "The whistle immediately commands all remaining attention-even the negative kind."

SWEP.ViewModel = ""
SWEP.WorldModel = "models/ufn/ww1/weapons/trenchwhistle/w_trenchwhistle.mdl"
SWEP.WorldModelReal = "models/ufn/ww1/weapons/trenchwhistle/c_trenchwhistle.mdl"
SWEP.WorldModelExchange = false

SWEP.HoldType = "slam"
SWEP.supportTPIK = true
SWEP.setrh = true
SWEP.setlh = false

SWEP.HoldPos = Vector(2, 0, 0)
SWEP.HoldAng = Angle(-2.5, 0, 0)
SWEP.weaponPos = Vector(0, 0, 0)
SWEP.weaponAng = Angle(0, 0, 0)

SWEP.sprint_pos = Vector(0, 0, 0)
SWEP.sprint_ang = Angle(20, 0, 0)

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local whistleSound = "/ufn/ww1/weapons/trenchwhistle.wav"

SWEP.AnimList = {
    ["deploy"] = { "draw", 1, false, false },
    ["idle"] = { "idle", 1, false, false },
    ["attack"] = { "use", 3.16, false, false },
    ["attack2"] = { "use", 3.16, false, false },
}

SWEP.lastUsed = 0
SWEP.cooldownTime = 3.16

function SWEP:InitAdd()
end

function SWEP:DeployAdd()
    self.lastUsed = 0
end

function SWEP:PrimaryAttackAdd(ent)
end

function SWEP:SecondaryAttackAdd(ent)
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    
    if self.lastUsed > CurTime() then return end
    
    self.lastUsed = CurTime() + self.cooldownTime
    
    self:PlayAnim("attack", self.cooldownTime, false, nil, false, true)
    
    timer.Simple(0.25, function()
        if not IsValid(self) then return end
        if not IsValid(self:GetOwner()) then return end
        self:EmitSound(whistleSound)
    end)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

function SWEP:Reload()
    return
end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:CanSecondaryAttack()
    return true
end