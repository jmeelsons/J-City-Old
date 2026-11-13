SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.PrintName = "DSHK"
SWEP.Author = "Tula Arms Plant"
SWEP.Instructions = "Large-caliber machine gun chambered for the 12.7×108 mm cartridge\n\nRate of fire: 600 rounds per minute"
SWEP.Category = "Weapons - Machineguns"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/kord/kord_gun.mdl"
SWEP.WorldModelFake = "models/weapons/fml/hmg/c_dshk.mdl"
SWEP.FakeAttachment = "1"
SWEP.FakeScale = 1
SWEP.FakePos = Vector(-11.5, 3.53, 9.45)
SWEP.FakeAng = Angle(0.19, 0.04, 0)
SWEP.AttachmentPos = Vector(-0, 0.7, 0.2)
SWEP.AttachmentAng = Angle(-90, 0, 0)

SWEP.FakeEjectBrassATT = "2"

SWEP.FakeVPShouldUseHand = true
SWEP.AnimList = {
	["idle"] = "idle",
}

SWEP.FakeViewBobBone = "ValveBiped.Bip01_R_Hand"
SWEP.FakeViewBobBaseBone = "ValveBiped.Bip01_R_UpperArm"
SWEP.ViewPunchDiv = 35

SWEP.NoIdleLoop = true

SWEP.MagModel = "models/weapons/zcity/w_glockmag.mdl"

local function UpdateVisualBullets(mdl, count)
	for i = 1, 16 do
		local boneid = 118 + i
		mdl:ManipulateBoneScale(boneid, i <= count and Vector(1, 1, 1) or Vector(0, 0, 0))
	end
end

SWEP.RestPosition = Vector(10, -1, 4)

function SWEP:PostFireBullet(bullet)
	if CLIENT then
		self:PlayAnim("base_fire_3", 1.5, nil, false)
		UpdateVisualBullets(self:GetWM(), self:Clip1())
	end
	local owner = self:GetOwner()
	if (SERVER or self:IsLocal2()) and owner:OnGround() then
		if IsValid(owner) and owner:IsPlayer() then
			owner:SetVelocity(owner:GetVelocity() - owner:GetVelocity() / 0.45)
		end
	end
	SlipWeapon(self, bullet)
end

SWEP.FakeMagDropBone = "magazine"

SWEP.WepSelectIcon2 = Material("pwb2/vgui/weapons/pkm.png")
SWEP.IconOverride = "pwb2/vgui/weapons/pkm.png"

SWEP.CustomShell = "127x108"
SWEP.CustomSecShell = "m249len"

SWEP.CanSuicide = false

SWEP.ScrappersSlot = "Primary"

SWEP.weight = 35

SWEP.LocalMuzzlePos = Vector(23.632, 0.400, 5.860)
SWEP.LocalMuzzleAng = Angle(0.3, 0.02, 0)
SWEP.WeaponEyeAngles = Angle(0, 0, 0)

SWEP.ShockMultiplier = 8

SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "12.7x108 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 120
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 120
SWEP.Primary.Sound = {"weapons/easternfront/ptrd41/ptrd41_fp.wav", 85, 90, 110}
SWEP.Primary.SoundEmpty = {"zcitysnd/sound/weapons/fnfal/handling/fnfal_empty.wav", 75, 100, 105, CHAN_WEAPON, 2}
SWEP.Primary.Wait = 0.1

SWEP.PPSMuzzleEffect = "pcf_jack_mf_mshotgun"

SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 65, 100, 120}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 65, 100, 120}
SWEP.HoldType = "rpg"
SWEP.ZoomPos = Vector(0, -1.7678, 9.3684)
SWEP.RHandPos = Vector(-5, -2, 0)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.RHPos = Vector(7, -7, 5)
SWEP.RHAng = Angle(0, 0, 90)
SWEP.LHPos = Vector(8.5, -2, -6)
SWEP.LHAng = Angle(-20, 0, -90)

SWEP.Spray = {}
for i = 1, 150 do
	SWEP.Spray[i] = Angle(-0.03 - math.cos(i) * 0.02, math.cos(i * i) * 0.04, 0) * 2
end

SWEP.Ergonomics = 0.35
SWEP.OpenBolt = true
SWEP.Penetration = 45
SWEP.WorldPos = Vector(4, -0.5, 1)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, -1, 0)
SWEP.attAng = Angle(0, -0.2, 0)
SWEP.AimHands = Vector(0, 1.65, -3.65)
SWEP.lengthSub = 15
SWEP.DistSound = "mosin/mosin_dist.wav"

local vector_one = Vector(1, 1, 1)
local vector_zero = Vector(0, 0, 0)

function SWEP:DrawPost()
	local wep = self:GetWeaponEntity()
	if CLIENT and IsValid(wep) then
		self.shooanim = LerpFT(0.4, self.shooanim or 0, (self:Clip1() > 0 or self.reload) and 0 or 3)
	end
end

SWEP.punchmul = 25
SWEP.punchspeed = 0.15
SWEP.podkid = 0.08

SWEP.RecoilMul = 0.3

SWEP.bipodAvailable = true
SWEP.bipodsub = 15

-- Inspect
SWEP.InspectAnimWepAng = {
	Angle(0, 0, 0),
	Angle(4, 4, 15),
	Angle(10, 15, 25),
	Angle(10, 15, 25),
	Angle(10, 15, 25),
	Angle(-6, -15, -15),
	Angle(1, 15, -45),
	Angle(15, 25, -55),
	Angle(15, 25, -55),
	Angle(15, 25, -55),
	Angle(0, 0, 0),
	Angle(0, 0, 0)
}