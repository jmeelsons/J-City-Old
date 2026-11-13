--WARNING! GPT AND BETA CODE!
local MODE = MODE
MODE.name = "flatout"

local bgMat = Material("flatout/backgrnd.png")
local gradientL = Material("vgui/gradient-l")

surface.CreateFont("FO_Huge", {font = "Steadfast", size = ScreenScale(30), weight = 500, antialias = true})
surface.CreateFont("FO_Title", {font = "Steadfast", size = ScreenScale(20), weight = 500, antialias = true})
surface.CreateFont("FO_MenuItem", {font = "Steadfast", size = ScreenScale(16), weight = 500, antialias = true})
surface.CreateFont("FO_Btn", {font = "Steadfast", size = ScreenScale(10), weight = 500, antialias = true})
surface.CreateFont("FO_Med", {font = "Steadfast", size = ScreenScale(8), weight = 400, antialias = true})
surface.CreateFont("FO_Small", {font = "Steadfast", size = ScreenScale(6), weight = 400, antialias = true})
surface.CreateFont("FO_Tiny", {font = "Steadfast", size = ScreenScale(4.5), weight = 400, antialias = true})

local foOrange = Color(255, 140, 0)
local foOrangeDark = Color(180, 80, 0)
local foShadow = Color(120, 60, 0, 180)
local foPanel = Color(18, 10, 2, 215)
local foPanelLight = Color(60, 30, 5, 230)
local foWhite = Color(240, 240, 240)
local foDim = Color(200, 170, 130, 200)
local foRed = Color(220, 50, 50)
local foGreen = Color(0, 255, 100)
local foBlack = Color(0, 0, 0)

local sndClick, sndHover = "flatout2_ui/click.mp3", "flatout2_ui/hover.mp3"

local cv_music = CreateClientConVar("flatout_menumusic", "1", true, false, "Badass menu music", 0, 1)
local cv_musicvol = CreateClientConVar("flatout_menumusic_vol", "60", true, false, "Badass menu music volume", 0, 100)
local cv_vehicle = CreateClientConVar("flatout_vehicle", "1", true, false, "Badass vehicle")

local MUSIC_MENU = {
	"flatout2_ost/Audioslave - Your Time Has Come.mp3",
	"flatout2_ost/Megadeth - Symphony of Destruction.mp3",
	"flatout2_ost/Supergrass - Road To Rouen.mp3",
	"flatout2_ost/Underoath - Reinventing Your Exit.mp3",
	"flatout2_ost/The Chelsea Smiles - Nowhere Ride.mp3",
}

local MUSIC_RACE = {
	"flatout2_ost/Audioslave - Your Time Has Come.mp3",
	"flatout2_ost/Audioslave - Man or Animal.mp3",
	"flatout2_ost/Fall Out Boy - Snitches And Talkers Get Stitches And Walkers.mp3",
	"flatout2_ost/Motley Crue - Dr Feelgood.mp3",
	"flatout2_ost/Rob Zombie - Demon Speeding.mp3",
	"flatout2_ost/Supergrass - Richard III.mp3",
	"flatout2_ost/The Chelsea Smiles - Nowhere Ride.mp3",
	"flatout2_ost/Underoath - Reinventing Your Exit.mp3",
	"flatout2_ost/Wolfmother - Dimension.mp3",
	"flatout2_ost/Wolfmother - Pyramide.mp3",
	"flatout2_ost/Yellowcard - Breathing.mp3",
	"flatout2_ost/Zebrahead - Lobotomy for Dummies.mp3",
}

local menuLastIdx = 0
local raceLastIdx = 0

local menuMusic
local raceMusic
local menuMusicTimer
local raceMusicTimer
local musicTimerCounter = 0

local function StopMenuMusic()
	if menuMusicTimer then
		timer.Remove(menuMusicTimer)
		menuMusicTimer = nil
	end
	if menuMusic then
		if menuMusic.Stop then menuMusic:Stop() end
		menuMusic = nil
	end
end

local function StopRaceMusic()
	if raceMusicTimer then
		timer.Remove(raceMusicTimer)
		raceMusicTimer = nil
	end
	if raceMusic then
		if raceMusic.Stop then raceMusic:Stop() end
		raceMusic = nil
	end
end

local function PickRandomTrack(playlist, lastIdx)
	if not playlist or #playlist == 0 then return nil, 0 end
	if #playlist == 1 then return playlist[1], 1 end

	local idx
	repeat
		idx = math.random(1, #playlist)
	until idx ~= lastIdx

	return playlist[idx], idx
end

local function ChannelIsPlaying(station)
	if not station then return false end
	if not station.GetState then return false end
	return station:GetState() == 1
end

local function PlayTrack(path, volume, onEnded, isMenu)
	local setStation, setTimerName, getStation, clearStation

	if isMenu then
		setStation    = function(s) menuMusic = s end
		setTimerName  = function(t) menuMusicTimer = t end
		getStation    = function() return menuMusic end
		clearStation  = function() menuMusic = nil end
	else
		setStation    = function(s) raceMusic = s end
		setTimerName  = function(t) raceMusicTimer = t end
		getStation    = function() return raceMusic end
		clearStation  = function() raceMusic = nil end
	end

	sound.PlayFile(path, "noblock", function(station, errCode, errStr)
		if not station then
			print("Не удалось загрузить трек: " .. path .. " (" .. tostring(errStr) .. ")")
			timer.Simple(2, function()
				if onEnded then onEnded() end
			end)
			return
		end

		if station.EnableLooping then station:EnableLooping(false) end
		station:SetVolume(volume)
		station:Play()
		setStation(station)

		musicTimerCounter = musicTimerCounter + 1
		local timerName = "flatout_music_check_" .. musicTimerCounter
		setTimerName(timerName)

		local died = false
		local function kill()
			if died then return end
			died = true
			timer.Remove(timerName)
		end

		timer.Create(timerName, 0.5, 0, function()
			if getStation() ~= station then
				kill()
				return
			end

			if station.IsValid and not station:IsValid() then
				kill()
				clearStation()
				setTimerName(nil)
				if onEnded then onEnded() end
				return
			end

			if not ChannelIsPlaying(station) then
				kill()
				clearStation()
				setTimerName(nil)
				if onEnded then onEnded() end
			end
		end)
	end)
end

local function PlayMenuMusic()
	StopMenuMusic()
	StopRaceMusic()
	if not cv_music:GetBool() then return end

	local track, idx = PickRandomTrack(MUSIC_MENU, menuLastIdx)
	if not track then return end
	menuLastIdx = idx

	PlayTrack("sound/" .. track, cv_musicvol:GetInt() / 100, function()
		if IsValid(menuPanel) then
			PlayMenuMusic()
		end
	end, true)
end

local function PlayRaceMusic()
	StopMenuMusic()
	StopRaceMusic()
	if not cv_music:GetBool() then return end

	local track, idx = PickRandomTrack(MUSIC_RACE, raceLastIdx)
	if not track then return end
	raceLastIdx = idx

	PlayTrack("sound/" .. track, cv_musicvol:GetInt() / 100, function()
		if zb.ROUND_STATE == 1 then
			PlayRaceMusic()
		end
	end, false)
end

local function GetVehicleList()
	if MODE and istable(MODE.Vehicles) and #MODE.Vehicles > 0 then
		return MODE.Vehicles
	end
	if zb and zb.modes and zb.modes["flatout"] and istable(zb.modes["flatout"].Vehicles) and #zb.modes["flatout"].Vehicles > 0 then
		return zb.modes["flatout"].Vehicles
	end
	if MODE and MODE.Config and istable(MODE.Config.Vehicles) and #MODE.Config.Vehicles > 0 then
		return MODE.Config.Vehicles
	end
	return {}
end

local function SendVehicleChoice()
	local vehList = GetVehicleList()
	if #vehList == 0 then return end
	local idx = math.Clamp(cv_vehicle:GetInt(), 1, #vehList)
	net.Start("flatout_vehicle")
		net.WriteUInt(idx, 8)
	net.SendToServer()
end

local function BoxButton(parent, text, onClick)
	local b = vgui.Create("DButton", parent)
	b:SetText("")
	b.hover = 0
	b.OnCursorEntered = function() surface.PlaySound(sndHover) end
	b.Paint = function(self, w, h)
		self.hover = Lerp(FrameTime() * 8, self.hover, self:IsHovered() and 1 or 0)
		local hv = self.hover

		surface.SetDrawColor(Lerp(hv, 43, 200), Lerp(hv, 43, 80), Lerp(hv, 43, 10), 215)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 60)
		surface.DrawRect(0, h - 3, w, 3)
		surface.SetDrawColor(foOrange)
		surface.DrawRect(0, 0, 4 + hv * 6, h)

		draw.SimpleText(string.upper(text), "FO_Btn", 22 + hv * 12, h / 2, foWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	b.DoClick = function()
		surface.PlaySound(sndClick)
		onClick()
	end
	return b
end

local function SmallButton(parent, text, onClick)
	local b = vgui.Create("DButton", parent)
	b:SetText("")
	b.hover = 0
	b.OnCursorEntered = function() surface.PlaySound(sndHover) end
	b.Paint = function(self, w, h)
		self.hover = Lerp(FrameTime() * 8, self.hover, self:IsHovered() and 1 or 0)
		local hv = self.hover

		surface.SetDrawColor(Lerp(hv, 43, 200), Lerp(hv, 43, 80), Lerp(hv, 43, 10), 215)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 60)
		surface.DrawRect(0, h - 3, w, 3)

		draw.SimpleText(string.upper(text), "FO_Small", w / 2, h / 2, foWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	b.DoClick = function()
		surface.PlaySound(sndClick)
		onClick()
	end
	return b
end

local function FoRow(parent, label)
	local row = vgui.Create("DPanel", parent)
	row:Dock(TOP)
	row:SetTall(ScreenScale(22))
	row:DockMargin(0, 0, 0, 8)
	row.Paint = function(self, w, h)
		surface.SetDrawColor(60, 35, 10, 180)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(90, 50, 15, 160)
		surface.DrawRect(0, h - 3, w, 3)
		draw.SimpleText(label, "FO_Small", 12, h / 2, foWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	return row
end

local function FoToggle(parent, getState, onClick)
	local toggle = vgui.Create("DButton", parent)
	toggle:SetText("")
	toggle:SetWide(60)
	toggle:Dock(RIGHT)
	toggle:DockMargin(0, 15, 10, 15)
	local anim = getState() and 1 or 0
	toggle.Paint = function(self, w, h)
		anim = Lerp(FrameTime() * 8, anim, getState() and 1 or 0)
		local bgColor = Color(Lerp(anim, 180, 80), Lerp(anim, 30, 120), Lerp(anim, 30, 50))
		draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28))
		draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(0, 0, 0, 30))
		local slsize = h - 10
		local slPos = Lerp(anim, 5, w - slsize - 5)
		draw.RoundedBox(0, slPos, 5, slsize, slsize, bgColor)
		surface.SetDrawColor(0, 0, 0, Lerp(anim, 150, 40))
		surface.DrawRect(slPos, slsize + 3, slsize, 2)
	end
	toggle.OnCursorEntered = function() surface.PlaySound(sndHover) end
	toggle.DoClick = function()
		surface.PlaySound(sndClick)
		onClick()
	end
	return toggle
end

local function FoArrows(row, getMax, getVal, setVal, getLabel)
	local function arrow(txt, dir)
		local b = vgui.Create("DButton", row)
		b:SetText("")
		b:SetWide(ScreenScale(14))
		b:Dock(RIGHT)
		b:DockMargin(3, 6, txt == ">" and 10 or 3, 6)
		b.Paint = function(self, w, h)
			surface.SetDrawColor(self:IsHovered() and 90 or 15, self:IsHovered() and 20 or 2, self:IsHovered() and 20 or 2, 245)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText(txt, "FO_Small", w / 2, h / 2, foWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		b.OnCursorEntered = function() surface.PlaySound(sndHover) end
		b.DoClick = function()
			surface.PlaySound(sndClick)
			setVal((getVal() + dir + getMax()) % getMax())
		end
		return b
	end

	arrow(">", 1)

	local val = vgui.Create("DPanel", row)
	val:SetWide(ScreenScale(52))
	val:Dock(RIGHT)
	val:DockMargin(3, 6, 0, 6)
	val.Paint = function(self, w, h)
		surface.SetDrawColor(15, 2, 2, 245)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(getLabel(), "FO_Small", w / 2, h / 2, foWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	arrow("<", -1)
end

local menuPanel
local readyN, readyT = 0, 0
local cpProgress = {}
local positionData = {}
local countdownEnd = 0
local raceCountdownFinish = 0
local raceCountdownPending = false

local outsideSince = 0
local raceStartedLocal = false

local clientCheckpoints = {}
local pickupEffects = {}

local function CloseMenu()
	if IsValid(menuPanel) then
		local pnl = menuPanel
		menuPanel = nil
		pnl:AlphaTo(0, 1.2, 0.4, function()
			if IsValid(pnl) then pnl:Remove() end
		end)
	end
end

local function OpenMenu()
	if IsValid(menuPanel) then menuPanel:Remove() end

	local scrw, scrh = ScrW(), ScrH()
	local headerH = scrh * 0.15

	local pnl = vgui.Create("EditablePanel")
	pnl:SetSize(scrw, scrh)
	pnl:MakePopup()
	pnl:SetKeyboardInputEnabled(false)
	pnl.state = "main"
	pnl.px, pnl.py = 0, 0
	pnl:SetAlpha(0)
	pnl:AlphaTo(255, 0.7, 0)
	menuPanel = pnl

	PlayMenuMusic()

	pnl.Paint = function(self, w, h)
		local mx, my = input.GetCursorPos()
		self.px = Lerp(FrameTime() * 3, self.px, ((mx / w) - 0.5) * -22)
		self.py = Lerp(FrameTime() * 3, self.py, ((my / h) - 0.5) * -14)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(bgMat)
		surface.DrawTexturedRect(-28 + self.px, -28 + self.py, w + 56, h + 56)

		surface.SetDrawColor(0, 0, 0, 120)
		surface.DrawRect(0, 0, w, h)

		surface.SetMaterial(gradientL)
		surface.SetDrawColor(20, 8, 0, 235)
		surface.DrawTexturedRect(0, 0, w * 0.8, h)
		surface.SetDrawColor(255, 140, 0, 55)
		surface.DrawTexturedRect(0, 0, w * 0.45, h)

		surface.SetDrawColor(15, 5, 0, 165)
		surface.DrawRect(0, 0, w, headerH)
		surface.SetDrawColor(foOrange)
		surface.DrawRect(0, headerH - 3, w, 3)

		draw.SimpleText("BADASS RACE", "FO_Huge", w * 0.5 + 4, headerH * 0.5 + 4, foShadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("BADASS RACE", "FO_Huge", w * 0.5, headerH * 0.5, foOrange, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if self.state == "waiting" then
			local wa = math.ease.OutCubic(math.Clamp((CurTime() - (self.waitingAt or 0) - 0.3) / 0.7, 0, 1))
			local yoff = (1 - wa) * h * 0.03

			draw.SimpleText("WAITING FOR RACERS", "FO_Title", w / 2, h * 0.42 + yoff, ColorAlpha(foWhite, 255 * wa), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(readyN .. " / " .. readyT, "FO_Huge", w / 2, h * 0.54 + yoff, ColorAlpha(foOrange, 255 * wa), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local left = math.max(0, (zb.ROUND_BEGIN or 0) - CurTime())
			draw.SimpleText("RACE STARTS IN " .. string.FormattedTime(left, "%02i:%02i"), "FO_Med", w / 2, h * 0.66 + yoff, ColorAlpha(foDim, 200 * wa), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local builders = {}
	local current, currentName

	local function Switch(name)
		if currentName == name then return end
		local old = current
		if IsValid(old) then
			old:AlphaTo(0, 0.2, 0, function() if IsValid(old) then old:Remove() end end)
		end

		currentName = name
		pnl.state = name
		current = nil

		if name == "waiting" then
			pnl.waitingAt = CurTime()
		end

		if not builders[name] then return end
		current = builders[name]()
		current:SetAlpha(0)
		current:AlphaTo(255, 0.25, 0.1)
	end

	local function ScreenBase()
		local scr = vgui.Create("DPanel", pnl)
		scr:SetPos(scrw * 0.03, headerH + scrh * 0.03)
		scr:SetSize(scrw * 0.94, scrh * 0.93 - headerH)
		scr.Paint = nil
		return scr
	end

	local function TopBar(scr, title)
		local top = vgui.Create("DPanel", scr)
		top:Dock(TOP)
		top:SetTall(ScreenScale(16))
		top:DockMargin(0, 0, 0, 10)
		top.Paint = function(self, w, h)
			draw.SimpleText(string.upper(title), "FO_Med", w / 2, h / 2, foWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		local back = SmallButton(top, "< Back", function() Switch("main") end)
		back:SetWide(ScreenScale(50))
		back:Dock(LEFT)
		return top
	end

	builders.main = function()
		local scr = vgui.Create("DPanel", pnl)
		scr:SetSize(scrw, scrh)
		scr:SetPos(0, 0)
		scr.Paint = nil

		local titlePanel = vgui.Create("DPanel", scr)
		titlePanel:SetPos(0, headerH + scrh * 0.05)
		titlePanel:SetSize(scrw, scrh * 0.2)
		titlePanel.Paint = function(self, w, h)
			draw.SimpleText("FUCKING BADASS RACING!", "FO_Med", w * 0.5, 0, ColorAlpha(foOrangeDark, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local btnBar = vgui.Create("DPanel", scr)
		btnBar:SetSize(scrw, scrh * 0.18)
		btnBar:SetPos(0, scrh - scrh * 0.18)
		btnBar.Paint = function(self, w, h)
			surface.SetDrawColor(10, 5, 0, 200)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(foOrange)
			surface.DrawRect(0, 0, w, 3)
		end

		local numBtns = 4
		local pad = ScreenScale(20)
		local gap = ScreenScale(10)
		local totalW = scrw - pad * 2 - gap * (numBtns - 1)
		local btnW = totalW / numBtns
		local btnH = scrh * 0.12
		local btnY = (scrh * 0.18 - btnH) / 2

		local flyingOut = false
		local btns = {}

		local firstIntro = not pnl.introPlayed
		pnl.introPlayed = true

		local function StartRace()
			if flyingOut then return end
			flyingOut = true

			SendVehicleChoice()
			net.Start("flatout_ready")
			net.SendToServer()

			for i, b in ipairs(btns) do
				b.outStart = CurTime() + (i - 1) * 0.09
			end

			timer.Simple(0.75, function()
				if IsValid(scr) and currentName == "main" then Switch("waiting") end
			end)
		end

		local menuData = {
			{"Start Race", StartRace, foOrange},
			{"Garage", function() Switch("garage") end, foWhite},
			{"Settings", function() Switch("settings") end, foWhite},
			{"How to Play", function() Switch("howto") end, foWhite},
		}

		for i, data in ipairs(menuData) do
			local b = vgui.Create("DButton", btnBar)
			b:SetText("")
			b:SetSize(btnW, btnH)
			b:SetPos(pad + (i - 1) * (btnW + gap), btnY)
			b.hover = 0
			b.accent = data[3]
			b.introStart = firstIntro and (CurTime() + 0.3 + i * 0.12) or 0
			b.OnCursorEntered = function()
				if flyingOut then return end
				surface.PlaySound(sndHover)
			end
			b.Paint = function(self, w, h)
				self.hover = Lerp(FrameTime() * 8, self.hover, self:IsHovered() and not flyingOut and 1 or 0)
				local hv = self.hover
				local accent = self.accent or foWhite

				local ip = math.Clamp((CurTime() - self.introStart) / 0.4, 0, 1)
				ip = math.ease.OutCubic(ip)

				local yoff = (1 - ip) * h * 1.5
				local alpha = 255 * ip

				if self.outStart then
					local op = math.Clamp((CurTime() - self.outStart) / 0.35, 0, 1)
					op = math.ease.InCubic(op)
					yoff = yoff + op * h * 1.5
					alpha = alpha * (1 - op)
				end

				local bgCol = Color(Lerp(hv, 20, 60), Lerp(hv, 8, 20), Lerp(hv, 2, 5), alpha * 0.9)
				surface.SetDrawColor(bgCol)
				surface.DrawRect(0, yoff, w, h)

				surface.SetDrawColor(accent.r, accent.g, accent.b, alpha * (0.5 + hv * 0.5))
				surface.DrawOutlinedRect(0, yoff, w, h, 2 + hv * 2)

				local lineW = w * (0.3 + hv * 0.7)
				surface.SetDrawColor(accent.r, accent.g, accent.b, alpha)
				surface.DrawRect(w / 2 - lineW / 2, yoff + h - 3, lineW, 3)

				local col = Color(Lerp(hv, 225, accent.r), Lerp(hv, 225, accent.g), Lerp(hv, 225, accent.b), alpha)
				draw.SimpleText(string.upper(data[1]), "FO_Btn", w / 2, yoff + h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			b.DoClick = function()
				if flyingOut then return end
				surface.PlaySound(sndClick)
				data[2]()
			end
			table.insert(btns, b)
		end

		return scr
	end

	builders.settings = function()
		local scr = ScreenBase()
		TopBar(scr, "Settings")

		local box = vgui.Create("DPanel", scr)
		box:Dock(FILL)
		box:DockPadding(scr:GetWide() * 0.28, 20, scr:GetWide() * 0.28, 20)
		box.Paint = function(self, w, h)
			local bw = w * 0.48
			draw.RoundedBox(8, w / 2 - bw / 2 - 16, 0, bw + 32, h, foPanel)
		end

		local musicRow = FoRow(box, "MUSIC")
		FoToggle(musicRow, function() return cv_music:GetBool() end, function()
			RunConsoleCommand("flatout_menumusic", cv_music:GetBool() and "0" or "1")
			timer.Simple(0, function()
				if cv_music:GetBool() then PlayMenuMusic() else StopMenuMusic() StopRaceMusic() end
			end)
		end)

		local volRow = FoRow(box, "MUSIC VOLUME")
		FoArrows(volRow,
			function() return 11 end,
			function() return math.Round(cv_musicvol:GetInt() / 10) end,
			function(v)
				RunConsoleCommand("flatout_menumusic_vol", v * 10)
				timer.Simple(0, function()
					local vol = cv_musicvol:GetInt() / 100
					if menuMusic and menuMusic.SetVolume then menuMusic:SetVolume(vol) end
					if raceMusic and raceMusic.SetVolume then raceMusic:SetVolume(vol) end
				end)
			end,
			function() return cv_musicvol:GetInt() .. "%" end)

		return scr
	end

	builders.garage = function()
		local scr = ScreenBase()
		TopBar(scr, "Garage")

		local vehList = GetVehicleList()
		local vehCount = #vehList

		local selIdx = 1
		if vehCount > 0 then
			selIdx = math.Clamp(cv_vehicle:GetInt() or 1, 1, vehCount)
		end

		local body = vgui.Create("DPanel", scr)
		body:Dock(FILL)
		body.Paint = nil

		local previewPanel = vgui.Create("DPanel", body)
		previewPanel:Dock(LEFT)
		previewPanel:SetWide(scr:GetWide() * 0.68)
		previewPanel:DockMargin(0, 0, 10, 0)
		previewPanel.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(8, 4, 1, 230))
			surface.SetDrawColor(foOrangeDark)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
		end

		local vehPanel = vgui.Create("DModelPanel", previewPanel)
		vehPanel:Dock(FILL)
		vehPanel:DockMargin(4, 4, 4, 4)

		vehPanel:SetFOV(60)
		vehPanel:SetCamPos(Vector(280, 0, 80))
		vehPanel:SetLookAt(Vector(0, 0, 15))

		vehPanel:SetDirectionalLight(BOX_TOP, Color(255, 240, 220))
		vehPanel:SetDirectionalLight(BOX_FRONT, Color(200, 180, 160))
		vehPanel:SetAmbientLight(Color(60, 55, 50))
		vehPanel:SetAnimated(true)

		vehPanel.AngleY = 0
		vehPanel.AngleX = 15
		vehPanel.RotSpeed = 0.7

		vehPanel.LayoutEntity = function(pv, ent)
			if not IsValid(ent) then return end
			ent:SetAngles(Angle(0, pv.AngleY, 0))
			ent:SetPos(Vector(0, 0, 0))
			pv:RunAnimation()
		end

		vehPanel.OnMousePressed = function(pv, code)
			if code == MOUSE_LEFT then
				pv.Dragging = true
				pv.LastX = gui.MouseX()
				pv.LastY = gui.MouseY()
				pv:MouseCapture(true)
			end
		end

		vehPanel.OnMouseReleased = function(pv, code)
			if code == MOUSE_LEFT then
				pv.Dragging = false
				pv:MouseCapture(false)
			end
		end

		vehPanel.Think = function(pv)
			if pv.Dragging then
				local mx = gui.MouseX()
				local my = gui.MouseY()
				local dx = mx - (pv.LastX or mx)
				local dy = my - (pv.LastY or my)

				pv.AngleY = pv.AngleY - dx * pv.RotSpeed
				pv.LastX = mx
				pv.LastY = my
			else
				pv.AngleY = pv.AngleY + FrameTime() * 6
			end
		end

		vehPanel.PaintOver = function(self, w, h)
			draw.SimpleText("HOLD LMB TO ROTATE", "FO_Small", w / 2, h - ScreenScale(8), foDim, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

		local rightPanel = vgui.Create("DPanel", body)
		rightPanel:Dock(FILL)
		rightPanel.Paint = nil

		local listScroll = vgui.Create("DScrollPanel", rightPanel)
		listScroll:Dock(FILL)
		listScroll:DockMargin(0, 0, 0, 10)

		do
			local vbar = listScroll:GetVBar()
			if vbar then
				vbar:SetWide(6)
				vbar.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(20, 10, 2, 180))

					local canvasSize = nil

					if self.GetCanvasSize then
						local ok, val = pcall(self.GetCanvasSize, self)
						if ok then canvasSize = val end
					end

					if not canvasSize or canvasSize <= 0 then
						if self.GetCanvas then
							local canvas = self:GetCanvas()
							if IsValid(canvas) then
								canvasSize = canvas:GetTall()
							end
						end
					end

					if not canvasSize or canvasSize <= 0 then canvasSize = h end

					local scroll = 0
					if self.GetScroll then
						local ok, val = pcall(self.GetScroll, self)
						if ok and val then scroll = val end
					end

					local size = h
					if self.GetSize then
						local ok, val = pcall(self.GetSize, self)
						if ok and val then size = val end
					end

					local barH = math.max(10, (size / canvasSize) * h)
					local barY = (scroll / canvasSize) * h

					draw.RoundedBox(0, 0, barY, w, barH, foOrangeDark)
				end
			end
		end

		local vehicleButtons = {}

		local function UpdateSelection(idx)
			if vehCount == 0 then
				selIdx = 1
				if IsValid(vehPanel) then
					vehPanel:SetModel("models/props_c17/oildrum001.mdl")
				end
				return
			end

			idx = math.Clamp(tonumber(idx) or 1, 1, vehCount)
			selIdx = idx

			for _, btn in ipairs(vehicleButtons) do
				btn.Selected = (btn.vehIdx == idx)
			end

			if not IsValid(vehPanel) then return end

			local entry = vehList[idx]
			local m = entry and entry.model
			vehPanel:SetModel(m or "models/props_c17/oildrum001.mdl")
			vehPanel.AngleY = -30
		end

		for i, veh in ipairs(vehList) do
			local b = vgui.Create("DButton", listScroll)
			b:SetText("")
			b:Dock(TOP)
			b:SetTall(ScreenScale(28))
			b:DockMargin(0, 0, 0, 6)
			b.hover = 0
			b.Selected = false
			b.vehIdx = i
			b.OnCursorEntered = function() surface.PlaySound(sndHover) end
			b.Paint = function(self, w, h)
				self.hover = Lerp(FrameTime() * 8, self.hover, self:IsHovered() and 1 or 0)
				local hv = self.hover

				local bgCol = self.Selected and Color(60, 30, 5, 230) or Color(Lerp(hv, 15, 40), Lerp(hv, 8, 20), Lerp(hv, 2, 5), 200)
				draw.RoundedBox(4, 0, 0, w, h, bgCol)

				surface.SetDrawColor(self.Selected and foOrange or Color(foOrangeDark.r, foOrangeDark.g, foOrangeDark.b, 100 + hv * 100))
				surface.DrawOutlinedRect(0, 0, w, h, self.Selected and 2 or 1)

				draw.SimpleText(string.upper(veh.name or ("CAR " .. i)), "FO_Btn", w / 2, h / 2, self.Selected and foOrange or foWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			b.DoClick = function()
				surface.PlaySound(sndClick)
				UpdateSelection(b.vehIdx or 1)
			end
			table.insert(vehicleButtons, b)
		end

		local applyBtn = BoxButton(rightPanel, "Apply", function()
			if vehCount == 0 then return end
			cv_vehicle:SetInt(selIdx)
			SendVehicleChoice()
		end)
		applyBtn:Dock(BOTTOM)
		applyBtn:SetTall(ScreenScale(20))

		UpdateSelection(selIdx)

		return scr
	end

	builders.howto = function()
		local scr = vgui.Create("DPanel", pnl)
		scr:SetPos(scrw * 0.05, headerH + scrh * 0.04)
		scr:SetSize(scrw * 0.34, scrh * 0.68)
		scr.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, foPanel)
			surface.SetDrawColor(foOrange)
			surface.DrawRect(0, 0, w, 3)
		end

		local top = vgui.Create("DPanel", scr)
		top:Dock(TOP)
		top:SetTall(ScreenScale(16))
		top:DockMargin(10, 10, 10, 6)
		top.Paint = function(self, w, h)
			draw.SimpleText("HOW TO PLAY", "FO_Med", 0, h / 2, foOrange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local back = SmallButton(top, "< Back", function() Switch("main") end)
		back:SetWide(ScreenScale(44))
		back:Dock(RIGHT)

		local scroll = vgui.Create("DScrollPanel", scr)
		scroll:Dock(FILL)
		scroll:DockMargin(10, 0, 10, 10)

		do
			local vbar = scroll:GetVBar()
			if vbar then vbar:SetWide(4) end
		end

		local white = "<colour=240,240,240,255>"
		local orange = "<colour=255,140,0,255>"
		local dim = "<colour=200,170,130,255>"

		local text = "<font=FO_Med>" .. white .. "BADASS RACE RULES</colour></font>\n\n"
			.. "<font=FO_Small>" .. white .. "1. TARGET</colour>\n\n"
			.. "Reach the finish line first. Placed: " .. orange .. "checkpoints</colour>. "
			.. "The next checkpoint is highlighted. " .. orange .. "green</colour> and have text: NEXT.\n\n"
			.. "2. CONTROLS\n\n"
			.. "Use your own car. You must not get into other people's cars...\n\n"
			.. "3. DO NOT GET OUT OF THE CAR\n\n"
			.. "If you get out of the car for more than 3 seconds, you are out of the race.\n\n"
			.. "4. DEADLY\n\n"
			.. "If you DEADLY-crash, you're out of the race.\n\n"
			.. "5. FINISH\n\n"
			.. "The final checkpoint is the finish line. Once you cross it, you get your ranking and time.\n\n"
			.. dim .. "Tip: Don't be afraid to ram your opponents — in BADASS, it's part of the race. :P</colour></font>"

		local body = vgui.Create("DPanel", scroll)
		body:Dock(TOP)
		body.Paint = function(self, w, h)
			if not self.m1 or self.mw ~= w then
				self.mw = w
				self.m1 = markup.Parse(text, w - 12)
				self:SetTall(self.m1:GetHeight() + 24)
			end
			self.m1:Draw(4, 4)
		end

		return scr
	end

	Switch("main")

	pnl.OnRemove = function()
		StopMenuMusic()
	end
end

net.Receive("flatout_start", function()
	readyN, readyT = 0, 0
	table.Empty(cpProgress)
	table.Empty(positionData)
	table.Empty(pickupEffects)
	table.Empty(clientCheckpoints)
	countdownEnd = 0
	raceCountdownFinish = 0
	raceCountdownPending = false
	outsideSince = 0
	raceStartedLocal = false

	StopRaceMusic()

	OpenMenu()
end)

net.Receive("flatout_checkpoints", function()
	table.Empty(clientCheckpoints)
	local count = net.ReadUInt(16)
	for i = 1, count do
		clientCheckpoints[i] = net.ReadVector()
	end

	if count == 0 then
		raceStartedLocal = false
		raceCountdownPending = false
		raceCountdownFinish = 0
		countdownEnd = 0
	end

	print("[FLATOUT] Client received checkpoints:", count)
end)

net.Receive("flatout_readycount", function()
	readyN = net.ReadUInt(8)
	readyT = net.ReadUInt(8)
end)

net.Receive("flatout_countdown", function()
	local duration = net.ReadFloat()
	countdownEnd = CurTime() + duration
	raceCountdownFinish = countdownEnd
	raceCountdownPending = true
	raceStartedLocal = false

	CloseMenu()

	StopMenuMusic()
end)

net.Receive("flatout_begin", function()
	CloseMenu()
end)

net.Receive("flatout_music_start", function()
	PlayRaceMusic()
end)

net.Receive("flatout_music_stop", function()
	StopRaceMusic()
	StopMenuMusic()
end)

net.Receive("flatout_checkpoint", function()
	local ply = net.ReadEntity()
	local idx = net.ReadUInt(8)
	local total = net.ReadUInt(8)
	if not IsValid(ply) then return end
	cpProgress[ply] = {idx = idx, total = total}
end)

net.Receive("flatout_cp_effect", function()
	local pos = net.ReadVector()
	local idx = net.ReadUInt(8)

	table.insert(pickupEffects, {
		pos = pos,
		start = CurTime(),
		duration = 1.5,
		idx = idx,
	})

	surface.PlaySound("flatout2_ui/click.mp3")
end)

net.Receive("flatout_finish", function()
	local ply = net.ReadEntity()
	local time = net.ReadFloat()
	local pos = net.ReadUInt(8)
	if not IsValid(ply) then return end
	positionData[ply] = {finished = true, time = time, pos = pos}

	if ply == LocalPlayer() then
		surface.PlaySound("snb/rounds/round_is_over.wav")
	end
end)

net.Receive("flatout_positions", function()
	local ply = net.ReadEntity()
	local pos = net.ReadUInt(8)
	if IsValid(ply) then
		positionData[ply] = positionData[ply] or {}
		positionData[ply].pos = pos
	end
end)

local endStats

net.Receive("flatout_roundend", function()
	local winner = net.ReadEntity()
	local count = net.ReadUInt(8)
	local results = {}
	for i = 1, count do
		local ply = net.ReadEntity()
		local pos = net.ReadUInt(8)
		local time = net.ReadFloat()
		local finished = net.ReadBool()
		if IsValid(ply) then
			table.insert(results, {ply = ply, pos = pos, time = time, finished = finished})
		end
	end

	local isDraw = net.ReadBool()

	endStats = {
		start = CurTime(),
		winner = winner,
		results = results,
		isDraw = isDraw,
	}

	table.Empty(pickupEffects)
	table.Empty(clientCheckpoints)

	CloseMenu()
	StopMenuMusic()
	StopRaceMusic()

	surface.PlaySound("snb/rounds/round_is_over.wav")
end)

function MODE:RenderScreenspaceEffects()
	if countdownEnd > 0 and CurTime() > countdownEnd - 3 then
		zb.RemoveFade()
	end
end

local function SafeEyePos()
	local ply = LocalPlayer()
	if not IsValid(ply) then return Vector(0, 0, 0) end

	local eye = EyePos()
	if eye and eye.DistTo then return eye end

	local p = ply:GetPos()
	if p and p.DistTo then return p end

	return Vector(0, 0, 0)
end

local function GetLocalNextCP()
	local prog = cpProgress[LocalPlayer()]
	if not prog then return 1 end
	return prog.idx + 1
end

local function IsValidPos(p)
	return p and p.DistTo and p.x and p.y and p.z
end

local cpBeamMaterial = Material("sprites/light_glow02_add")
local cpRingMaterial = Material("cable/redlaser")
local cpGlowMaterial = Material("sprites/glow04_noz")

local function DrawCPBeam(startPos, endPos, width, col, material)
	render.SetMaterial(material or cpBeamMaterial)
	render.DrawBeam(startPos, endPos, width, 0, 1, col)
end

local function DrawCheckpointWorldMarker(cpPos, idx, dist, isNext, isDone, pulse, eyeAngles)
	local baseRadius = MODE.CheckpointRadius or 520
	local ringRadius = baseRadius * (isNext and 0.95 or 0.78)
	local beamHeight = MODE.CheckpointBeamHeight or 500
	local baseColor = isNext and (MODE.CheckpointNextColor or foGreen)
		or (isDone and (MODE.CheckpointDoneColor or foDim) or (MODE.CheckpointColor or foOrange))
	local alpha = math.floor(math.Clamp(1 - dist / 30000, 0.2, 1) * (isDone and 90 or 235))
	local col = Color(baseColor.r, baseColor.g, baseColor.b, alpha)
	local beamWidth = isNext and (10 + pulse * 5) or 5

	-- Vertical beacon: rendered in 3D world space, not projected into HUD coordinates.
	local bottom = cpPos + Vector(0, 0, 12)
	local top = cpPos + Vector(0, 0, beamHeight)
	DrawCPBeam(bottom, top, beamWidth * 2.5, Color(col.r, col.g, col.b, alpha * 0.18), cpGlowMaterial)
	DrawCPBeam(bottom, top, beamWidth, col, cpBeamMaterial)

	-- Ground ring, with short radial ticks to make the checkpoint readable at a distance.
	local segments = 48
	for seg = 0, segments - 1 do
		local a1 = (seg / segments) * math.pi * 2
		local a2 = ((seg + 1) / segments) * math.pi * 2
		local p1 = cpPos + Vector(math.cos(a1) * ringRadius, math.sin(a1) * ringRadius, 8)
		local p2 = cpPos + Vector(math.cos(a2) * ringRadius, math.sin(a2) * ringRadius, 8)
		DrawCPBeam(p1, p2, isNext and (5 + pulse * 2) or 3, col, cpRingMaterial)

		if isNext and seg % 4 == 0 then
			local outer = cpPos + Vector(math.cos(a1) * ringRadius * 1.12, math.sin(a1) * ringRadius * 1.12, 8)
			DrawCPBeam(p1, outer, 4, Color(255, 255, 255, alpha * 0.8), cpRingMaterial)
		end
	end

	-- Bright beacon cap and a world-space label above it.
	local capPos = top + Vector(0, 0, 18)
	render.SetMaterial(cpGlowMaterial)
	render.DrawSprite(capPos, isNext and 42 or 26, isNext and 42 or 26, col)

	local lp = LocalPlayer()
	if IsValid(lp) and eyeAngles then
		local labelPos = top + Vector(0, 0, 55)
		local labelAng = Angle(0, eyeAngles.y - 90, 90)
		local labelScale = 0.18
		cam.Start3D2D(labelPos, labelAng, labelScale)
			local title = isNext and ("NEXT CHECKPOINT  " .. idx) or ("CHECKPOINT  " .. idx)
			if isDone then title = "PASSED  " .. idx end
			draw.SimpleTextOutlined(title, "FO_Title", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 240))
			if isNext then
				local metres = math.Round(dist * 0.0254)
				draw.SimpleTextOutlined(metres .. " m", "FO_Med", 0, ScreenScale(11), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 240))
			end
		cam.End3D2D()
	end
end

hook.Add("PostDrawTranslucentRenderables", "flatout_cp_world_display", function(depth, skybox, is3DSkybox)
	if skybox or is3DSkybox then return end
	if not raceStartedLocal then return end
	if #clientCheckpoints == 0 then return end

	local lp = LocalPlayer()
	if not IsValid(lp) then return end

	local eyePos = EyePos()
	local eyeAngles = lp:EyeAngles()
	local nextCP = GetLocalNextCP()
	local pulse = (math.sin(CurTime() * 4) + 1) * 0.5
	local maxDist = 30000

	for idx, cpPos in ipairs(clientCheckpoints) do
		if not IsValidPos(cpPos) then continue end
		local dist = eyePos:DistTo(cpPos)
		if dist > maxDist then continue end

		local isNext = idx == nextCP
		local isDone = idx < nextCP
		DrawCheckpointWorldMarker(cpPos, idx, dist, isNext, isDone, pulse, eyeAngles)
	end
end)

local function DrawCheckpointCompass(sw, sh)
	local lply = LocalPlayer()
	if not IsValid(lply) then return end
	if not raceStartedLocal then return end
	if countdownEnd > 0 then return end

	local data = positionData[lply]
	if data and data.finished then return end

	local nextIdx = GetLocalNextCP()
	local cpPos = clientCheckpoints[nextIdx]
	if not IsValidPos(cpPos) then return end

	local barW = sw * 0.5
	local barH = ScreenScale(16)
	local barX = sw * 0.5 - barW / 2
	local barY = ScreenScale(10)

	draw.RoundedBox(2, barX - 4, barY - 4, barW + 8, barH + 8, Color(0, 0, 0, 150))

	draw.RoundedBox(0, barX, barY, barW, barH, Color(15, 8, 2, 210))

	surface.SetDrawColor(foOrange)
	surface.DrawRect(barX, barY, barW, 2)
	surface.DrawRect(barX, barY + barH - 2, barW, 2)

	surface.SetDrawColor(255, 140, 0, 70)
	for s = 1, 23 do
		local x = barX + (s / 24) * barW
		local hh = (s % 6 == 0) and barH * 0.6 or barH * 0.3
		surface.DrawRect(x, barY + (barH - hh) / 2, 1, hh)
	end

	local centerX = barX + barW / 2
	surface.SetDrawColor(255, 255, 255, 220)
	surface.DrawRect(centerX - 1, barY - 2, 2, barH + 4)

	local eyePos = SafeEyePos()
	local eyeAng = lply:EyeAngles()

	local toCP = cpPos - eyePos
	toCP.z = 0
	local dist = toCP:Length()
	toCP:Normalize()

	local fwd = eyeAng:Forward()
	fwd.z = 0
	if fwd:LengthSqr() > 0.001 then fwd:Normalize() end

	local right = eyeAng:Right()
	right.z = 0
	if right:LengthSqr() > 0.001 then right:Normalize() end

	local dotF = fwd:Dot(toCP)
	local dotR = right:Dot(toCP)
	local angleToCP = math.deg(math.atan2(dotR, dotF))

	local fovRange = 180
	local clampedAngle = math.Clamp(angleToCP, -fovRange, fovRange)

	local markerX = centerX + (clampedAngle / fovRange) * (barW / 2)

	local isOffScreen = math.abs(angleToCP) > fovRange * 0.95

	local col = MODE.CheckpointNextColor or foGreen
	local mSize = ScreenScale(7)

	if isOffScreen then
		local dir = angleToCP > 0 and 1 or -1
		local ax = markerX + dir * mSize * 0.6
		local ay = barY + barH / 2

		local p1 = {ax, ay - mSize}
		local p2 = {ax, ay + mSize}
		local p3 = {ax + dir * mSize * 1.2, ay}

		surface.SetDrawColor(col.r, col.g, col.b, 255)
		draw.NoTexture()
		surface.DrawPoly({p1, p2, p3})

		local p = (math.sin(CurTime() * 6) + 1) * 0.5
		surface.SetDrawColor(255, 255, 255, 150 * p)
		surface.DrawPoly({p1, p2, p3})
	else
		local mx = markerX
		local my = barY + barH / 2

		local pts = {
			{mx, my - mSize},
			{mx + mSize * 0.7, my},
			{mx, my + mSize},
			{mx - mSize * 0.7, my},
		}

		surface.SetDrawColor(col.r, col.g, col.b, 100)
		draw.NoTexture()
		surface.DrawPoly(pts)

		surface.SetDrawColor(col.r, col.g, col.b, 255)
		surface.DrawPoly(pts)

		surface.SetDrawColor(255, 255, 255, 220)
		for k = 1, 4 do
			local pp1 = pts[k]
			local pp2 = pts[(k % 4) + 1]
			surface.DrawLine(pp1[1], pp1[2], pp2[1], pp2[2])
		end
	end

	local distM = math.Round(dist * 0.0254)
	local label = "CP " .. nextIdx .. "  " .. distM .. "m"

	surface.SetFont("FO_Small")
	local tw, th = surface.GetTextSize(label)
	local tx = barX + barW / 2 - tw / 2
	local ty = barY + barH + 6

	draw.RoundedBox(2, tx - 6, ty - 2, tw + 12, th + 4, Color(0, 0, 0, 170))
	draw.SimpleText(label, "FO_Small", barX + barW / 2, ty + th / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if isOffScreen then
		local dirText = angleToCP > 0 and "TURN RIGHT" or "TURN LEFT"
		draw.SimpleText(dirText, "FO_Small", barX + barW / 2, ty + th + 12, ColorAlpha(col, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local heightDiff = cpPos.z - eyePos.z
	if math.abs(heightDiff) > 200 then
		local arrow = heightDiff > 0 and "▲" or "▼"
		local ay = barY + barH / 2
		draw.SimpleText(arrow, "FO_Med", barX + barW + ScreenScale(14), ay, ColorAlpha(col, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function MODE:HUDPaint()
	if countdownEnd > 0 then
		local left = countdownEnd - CurTime()

		if left > 0 then
			local num = math.ceil(left)
			if num >= 1 and num <= 3 then
				local frac = left - math.floor(left)
				local alpha = 255 * math.min(1, (1 - frac) * 4)
				draw.SimpleText(tostring(num), "FO_Huge", sw / 2, sh / 2, ColorAlpha(foOrange, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif left > -0.5 then
			local a = 255 * (1 + left * 2)
			draw.SimpleText("GO!", "FO_Huge", sw / 2, sh / 2, ColorAlpha(Color(100, 255, 100), a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			countdownEnd = 0
		end
	end

	local lply = LocalPlayer()
	if not IsValid(lply) then return end

	if raceStartedLocal and lply:Alive() then
		local data = positionData[lply]
		local finished = data and data.finished
		if not finished then
			if lply:InVehicle() then
				outsideSince = 0
			else
				if outsideSince == 0 then
					outsideSince = CurTime()
				end

				local outside = CurTime() - outsideSince
				local left = math.max(0, 3 - outside)

				if outside > 0.2 then
					local col = outside > 2 and foRed or foOrange

					draw.SimpleText("GET BACK TO CAR!", "FO_Med", sw / 2, sh * 0.35, ColorAlpha(col, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText(string.format("%.1f", left), "FO_Title", sw / 2, sh * 0.42, ColorAlpha(col, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
	end

	local prog = cpProgress[lply]
	if prog then
		draw.SimpleText("CHECKPOINT " .. prog.idx .. " / " .. prog.total, "FO_Med", sw / 2, ScreenScale(30), foOrange, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local y = ScreenScale(60)
	draw.SimpleText("POSITIONS", "FO_Small", ScreenScale(20), y, foOrange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	y = y + ScreenScale(12)

	local sorted = {}
	for ply, data in pairs(positionData) do
		if IsValid(ply) then
			table.insert(sorted, {ply = ply, data = data})
		end
	end
	table.sort(sorted, function(a, b)
		local ad, bd = a.data, b.data
		local aReal = ad.finished and (ad.time or 0) > 0
		local bReal = bd.finished and (bd.time or 0) > 0

		if aReal and bReal then return (ad.time or 0) < (bd.time or 0) end
		if aReal then return true end
		if bReal then return false end
		return (ad.pos or 99) < (bd.pos or 99)
	end)

	for i, entry in ipairs(sorted) do
		local col = entry.ply == lply and foOrange or foWhite
		local timeStr = ""
		if entry.data.finished then
			if (entry.data.time or 0) > 0 then
				timeStr = string.format(" %.2f", entry.data.time)
			else
				timeStr = " DNF"
				col = foDim
			end
		end
		draw.SimpleText((entry.data.pos or "?") .. ". " .. entry.ply:Nick() .. timeStr, "FO_Small", ScreenScale(20), y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		y = y + ScreenScale(8)
	end

	DrawCheckpointCompass(sw, sh)

	for i = #pickupEffects, 1, -1 do
		local eff = pickupEffects[i]
		local t = CurTime() - eff.start

		if t > eff.duration or not IsValidPos(eff.pos) then
			table.remove(pickupEffects, i)
			continue
		end

		local frac = t / eff.duration
		local tscr = eff.pos:ToScreen()

		if tscr and tscr.visible then
			local baseSize = ScreenScale(40)
			local growSize = baseSize * (1 + frac * 3)
			local alpha = 255 * (1 - frac)

			surface.SetDrawColor(255, 200, 50, alpha * 0.8)
			surface.DrawOutlinedRect(tscr.x - growSize / 2, tscr.y - growSize / 2, growSize, growSize, 3)

			surface.SetDrawColor(255, 255, 100, alpha * 0.4)
			surface.DrawOutlinedRect(tscr.x - growSize * 0.7 / 2, tscr.y - growSize * 0.7 / 2, growSize * 0.7, growSize * 0.7, 2)

			local textAlpha = 255 * (1 - frac)
			local textPos = eff.pos + Vector(0, 0, 100 + frac * 150)
			local txtScr = textPos:ToScreen()
			if txtScr and txtScr.visible then
				draw.SimpleText("+CHECKPOINT " .. eff.idx, "FO_Title", txtScr.x, txtScr.y, ColorAlpha(Color(255, 220, 100), textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	if endStats then
		local t = CurTime() - endStats.start
		if t < 16 then
			local alpha = 255 * math.Clamp(t / 2, 0, 1)
			surface.SetDrawColor(0, 0, 0, alpha)
			surface.DrawRect(-1, -1, sw + 2, sh + 2)

			if t > 2 then
				local textAlpha = math.min(alpha, 255 * math.Clamp((t - 2) / 0.7, 0, 1))
				if t > 12 then
					textAlpha = textAlpha * math.Clamp(1 - (t - 12) / 3, 0, 1)
				end

				draw.SimpleText("BADASS RACE", "FO_Med", sw * 0.5, sh * 0.1, ColorAlpha(foOrangeDark, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if endStats.isDraw then
					draw.SimpleText("DRAW", "FO_Title", sw * 0.5, sh * 0.3, ColorAlpha(foDim, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("NOBODY REACHED THE FINISH", "FO_Med", sw * 0.5, sh * 0.45, ColorAlpha(foWhite, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					local y2 = sh * 0.58
					for i, entry in ipairs(endStats.results) do
						if i > 10 then break end
						draw.SimpleText(entry.pos .. ". " .. entry.ply:Nick(), "FO_Small", sw * 0.5, y2, ColorAlpha(foDim, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						y2 = y2 + sh * 0.035
					end
				else
					draw.SimpleText("RACE FINISHED", "FO_Title", sw * 0.5, sh * 0.2, ColorAlpha(foOrange, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					local y2 = sh * 0.35
					for i, entry in ipairs(endStats.results) do
						if i > 10 then break end
						local col = entry.ply == LocalPlayer() and foOrange or foWhite
						local timeStr
						if entry.finished then
							timeStr = string.format("%.2f", entry.time or 0)
						else
							timeStr = "DNF"
							col = foDim
						end
						draw.SimpleText(entry.pos .. ". " .. entry.ply:Nick() .. "  " .. timeStr, "FO_Med", sw * 0.5, y2, ColorAlpha(col, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						y2 = y2 + sh * 0.045
					end
				end
			end
		else
			endStats = nil
		end
	end
end

hook.Add("Think", "flatout_localracestate", function()
	if raceCountdownPending and raceCountdownFinish > 0 and CurTime() >= raceCountdownFinish then
		raceStartedLocal = true
		raceCountdownPending = false
	end
end)

local function EndLockActive()
	if not endStats then return false end
	if CurTime() - endStats.start > 14 then
		endStats = nil
		return false
	end
	return true
end

hook.Add("StartCommand", "flatout_endlock", function(ply, mv)
	if not EndLockActive() then return end
	mv:RemoveKey(IN_ATTACK)
	mv:RemoveKey(IN_ATTACK2)
	mv:RemoveKey(IN_FORWARD)
	mv:RemoveKey(IN_BACK)
	mv:RemoveKey(IN_MOVELEFT)
	mv:RemoveKey(IN_MOVERIGHT)
	mv:RemoveKey(IN_JUMP)
	mv:RemoveKey(IN_DUCK)
	mv:RemoveKey(IN_USE)
	mv:RemoveKey(IN_RELOAD)
end)

hook.Add("PlayerBindPress", "flatout_endlock_binds", function(ply, bind, pressed)
	if not EndLockActive() then return end
	if string.find(bind, "+menu") or string.find(bind, "+use") or string.find(bind, "+attack") then
		return true
	end
end)