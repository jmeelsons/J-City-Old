ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Global Radio"
ENT.Author = "Deka and Jmeelson"
ENT.Category = "ZCity Other"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Model = "models/props/cs_office/radio.mdl"
ENT.IconOverride = "vgui/wep_jack_hmcd_walkietalkie.png"

-- playingents[index] = {[1] = startTime, [2] = url, [3] = soundObj, [4] = timeSlider, [5] = volume}
playingents = playingents or {}

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "TextureURL")
	if SERVER then
		self:SetTextureURL("")
	end
end

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		caller:SetNWEntity("GlobalRadio", self)
		net.Start("GlobalRadioURLInput")
		net.WriteEntity(self)
		net.Send(caller)
	end
end

function ENT:PlayURL(url, timespend)
	timespend = timespend or 0
	if IsValid(self.sound) then
		self.sound:Stop()
	end

	sound.PlayURL(url, "3d noblock", function(station)
		if IsValid(station) then
			self.sound = station
			self.sound:SetPos(self:GetPos())
			if station.Set3DFadeDistance then
				station:Set3DFadeDistance(0, 0)
			end
			if station.Set3DEnabled then
				station:Set3DEnabled(false)
			end
			self.sound:Play()
			if not station:IsBlockStreamed() then
				self.sound:SetTime(timespend)
			end
			if playingents[self:EntIndex()] then
				playingents[self:EntIndex()][3] = station
			else
				playingents[self:EntIndex()] = {[1] = CurTime(), [2] = url, [3] = station, [5] = 1}
			end
		else
			print("Unable to play the sound.")
		end
	end)
end

function ENT:OnRemove()
	if CLIENT then
		playingents[self:EntIndex()] = nil
	end
	if self.sound and IsValid(self.sound) then
		self.sound:Stop()
		self.sound = nil
	end
end