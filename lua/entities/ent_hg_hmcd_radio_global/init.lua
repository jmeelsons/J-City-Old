AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	if SERVER then
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:DrawShadow(true)
	self:AddEFlags(EFL_IN_SKYBOX)

	local phys = self:GetPhysicsObject()

	if SERVER and IsValid(phys) then
		phys:SetMass(10)
		phys:Wake()
		phys:EnableMotion(true)
	end
end

util.AddNetworkString("GlobalRadioURLInput")
util.AddNetworkString("PlayGlobalRadioSound")
util.AddNetworkString("GlobalRadioChangeValue")
util.AddNetworkString("GlobalRadioChangeVolume")
util.AddNetworkString("GlobalRadioPause")
util.AddNetworkString("GlobalRadioStop")
util.AddNetworkString("GlobalRadioLooping")

net.Receive("GlobalRadioURLInput", function(len, ply)
	local url = net.ReadString()
	if not isstring(url) or not url then return end
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("PlayGlobalRadioSound")
	net.WriteString(url)
	net.WriteInt(ent:EntIndex(), 32)
	net.Broadcast()
end)

net.Receive("GlobalRadioChangeValue", function(len, ply)
	local val = net.ReadFloat()
	if not val or not isnumber(val) then return end
	local index = net.ReadInt(32)
	if not index then return end
	local ent = Entity(index)
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("GlobalRadioChangeValue")
	net.WriteFloat(val)
	net.WriteInt(index, 32)
	net.Broadcast()
end)

net.Receive("GlobalRadioChangeVolume", function(len, ply)
	local val = net.ReadFloat()
	if not val or not isnumber(val) then return end
	local index = net.ReadInt(32)
	if not index then return end
	local ent = Entity(index)
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("GlobalRadioChangeVolume")
	net.WriteFloat(val)
	net.WriteInt(index, 32)
	net.Broadcast()
end)

net.Receive("GlobalRadioPause", function(len, ply)
	local bool = net.ReadBool()
	if not isbool(bool) then return end
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("GlobalRadioPause")
	net.WriteBool(bool)
	net.WriteInt(ent:EntIndex(), 32)
	net.Broadcast()
end)

net.Receive("GlobalRadioLooping", function(len, ply)
	local bool = net.ReadBool()
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("GlobalRadioLooping")
	net.WriteBool(bool)
	net.WriteInt(ent:EntIndex(), 32)
	net.Broadcast()
end)

net.Receive("GlobalRadioStop", function(len, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	if ent:GetClass() ~= "ent_hg_hmcd_radio_global" or (ent:GetPos():Distance(ply:EyePos()) > 100) then return end

	net.Start("GlobalRadioStop")
	net.WriteInt(ent:EntIndex(), 32)
	net.Broadcast()
end)