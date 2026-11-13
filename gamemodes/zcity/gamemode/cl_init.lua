zb = zb or {}
include("shared.lua")
include("loader.lua")

if not ConVarExists("hg_newspectate") then
    CreateClientConVar("hg_newspectate", "1", true, false, "Enables smooth spectator camera transitions", 0, 1)
end

function CurrentRound()
	return zb.modes[zb.CROUND]
end

zb.ROUND_STATE = 0
--0 = players can join, 1 = round is active, 2 = endround
local vecZero = Vector(0.2, 0.2, 0.2)
local vecFull = Vector(1, 1, 1)
spect,prevspect,viewmode = nil,nil,1
local hullscale = Vector(0,0,0)
net.Receive("ZB_SpectatePlayer", function(len)
	spect = net.ReadEntity()
	prevspect = net.ReadEntity()
	viewmode = net.ReadInt(4)

	timer.Simple(0.1,function()
		-- LocalPlayer():BoneScaleChange()
		LocalPlayer():SetHull(-hullscale,hullscale)
		LocalPlayer():SetHullDuck(-hullscale,hullscale)

		if viewmode == 3 then
			LocalPlayer():SetMoveType(MOVETYPE_NOCLIP)
		end
	end)
end)

zb.ROUND_TIME = zb.ROUND_TIME or 400
zb.ROUND_START = zb.ROUND_START or CurTime()
zb.ROUND_BEGIN = zb.ROUND_BEGIN or CurTime() + 5

net.Receive("updtime",function()
	local time = net.ReadFloat()
	local time2 = net.ReadFloat()
	local time3 = net.ReadFloat()

	zb.ROUND_TIME = time
	zb.ROUND_START = time2
	zb.ROUND_BEGIN = time3
end)

local blur = Material("pp/blurscreen")
local blur2 = Material("effects/shaders/zb_blur" )
local blursettings = {}
local hg_potatopc
hg = hg or {}
function hg.DrawBlur(panel, amount, passes, alpha)
	if is3d2d then return end
	amount = amount or 5
	hg_potatopc = hg_potatopc or hg.ConVars.potatopc

	// old blur
	if(hg_potatopc:GetBool())then
		surface.SetDrawColor(0, 0, 0, alpha or (amount * 20))
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(0, 0, 0, alpha or 125)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
		local x, y = panel:LocalToScreen(0, 0)
		if blursettings and blursettings[1] == amount and blursettings[2] == passes then
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
			return
		end
		blursettings = {amount, passes}
		for i = -(passes or 0.2), 1, 0.2 do
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end

	--surface.SetMaterial(blur2)
	--surface.SetDrawColor(color_white)
	--local x, y = panel:LocalToScreen(0, 0)
--
	--// those are currently hardcoded cuz it would be too much of a hassle to change this
	--blur2:SetFloat("$c0_x", (amount or 5) * 2500) // density
	--blur2:SetFloat("$c0_y", (passes or 0.2) * 2000) // noise (inverted)
	--blur2:SetFloat("$c0_z", 1) // blending
--
	--render.UpdateScreenEffectTexture()
	--surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())

	-- surface.SetDrawColor(0, 0, 0, alpha or 125)
	-- surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
end

BlurBackground = BlurBackground or hg.DrawBlur

local keydownattack
local keydownattack2
local keydownreload

hook.Add("HUDPaint","FUCKINGSAMENAMEUSEDINHOOKFUCKME",function()
    if LocalPlayer():Alive() then return end
    local spect = LocalPlayer():GetNWEntity("spect")
    if not IsValid(spect) then return end
    if viewmode == 3 then return end

    local function DrawTextShadow(txt, x, y)
        surface.SetTextColor(0, 0, 0, 180)
        surface.SetTextPos(x + 2, y + 2)
        surface.DrawText(txt)
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(x, y)
        surface.DrawText(txt)
    end

    surface.SetFont("HomigradFont")

    local txt = "Spectating player: "..spect:Name()
    local w, h = surface.GetTextSize(txt)
    DrawTextShadow(txt, ScrW() / 2 - w / 2, ScrH() / 8 * 7)

    local txt = "In-game name: "..spect:GetPlayerName()
    local w, h = surface.GetTextSize(txt)
    DrawTextShadow(txt, ScrW() / 2 - w / 2, ScrH() / 8 * 7 + h)

    local wep = spect:GetActiveWeapon()
    local wepName = "None"
    if IsValid(wep) then
        wepName = wep:GetPrintName() or wep:GetClass()
    end
    local txt = "Weapon on hands: "..wepName
    local w, h = surface.GetTextSize(txt)
    DrawTextShadow(txt, ScrW() / 2 - w / 2, ScrH() / 8 * 7 + h * 2)
end)

hook.Add("HG_CalcView", "zzzzzzzUwU", function(ply, pos, angles, fov)
	if not lply:Alive() then
		if lply:KeyDown(IN_ATTACK) then
			if not keydownattack then
				keydownattack = true
				net.Start("ZB_ChooseSpecPly")
				net.WriteInt(IN_ATTACK,32)
				net.SendToServer()
			end
		else
			keydownattack = false
		end

		if lply:KeyDown(IN_ATTACK2) then
			if not keydownattack2 then
				keydownattack2 = true
				net.Start("ZB_ChooseSpecPly")
				net.WriteInt(IN_ATTACK2,32)
				net.SendToServer()
			end
		else
			keydownattack2 = false
		end

		if lply:KeyDown(IN_RELOAD) then
			if not keydownreload then
				keydownreload = true
				net.Start("ZB_ChooseSpecPly")
				net.WriteInt(IN_RELOAD,32)
				net.SendToServer()
			end
		else
			keydownreload = false
		end

		local spect = lply:GetNWEntity("spect",spect)
		if not IsValid(spect) then return end

		local viewmode = lply:GetNWInt("viewmode",viewmode)
		
		if viewmode == 3 then
			if lply:GetMoveType()!=MOVETYPE_NOCLIP then
				lply:SetMoveType(MOVETYPE_NOCLIP)
			end
			lply:SetObserverMode(OBS_MODE_ROAMING)
			return
		else
			lply:SetPos(spect:GetPos())
		end
		
		local ent = hg.GetCurrentCharacter(spect)
		if not IsValid(ent) then return end
		
		local headBone = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("ValveBiped.Bip01_Spine1") or 1
		local bon = ent:GetBoneMatrix(headBone)
		
		if not bon then 
			local eyePos = ent:EyePos()
			if eyePos and eyePos ~= vector_origin then
				pos = eyePos
				ang = ent:EyeAngles()
			else
				pos = ent:GetPos() + Vector(0, 0, 64)
				ang = ent:GetAngles()
			end
		else
			pos, ang = bon:GetTranslation(), bon:GetAngles()
		end

		local eyePos, eyeAng = lply:EyePos(), lply:EyeAngles()
		
		local tr = {}
		tr.start = pos
		tr.endpos = pos + eyeAng:Forward() * -120
		tr.filter = {ent, lply, spect}
		tr.mins = Vector(-4, -4, -4)
		tr.maxs = Vector(4, 4, 4)
		tr = util.TraceHull(tr)

		if viewmode == 2 then
			pos = tr.HitPos + eyeAng:Forward() * 8
			ang = eyeAng
		elseif viewmode == 1 then
			if ent ~= spect and IsValid(ent) then
				local eyeAtt = ent:GetAttachment(ent:LookupAttachment("eyes"))
				if eyeAtt then
					ang = eyeAtt.Ang
				else
					ang = spect:EyeAngles()
				end
			else
				ang = spect:EyeAngles()
			end
			pos = pos + spect:EyeAngles():Forward() * 8
		else
			pos = eyePos
			ang = eyeAng
		end
		
		ang[3] = 0
		
		local view
		local hg_newspectate = GetConVar("hg_newspectate")
		if hg_newspectate and hg_newspectate:GetBool() then
			if not lply.spectLastPos then
				lply.spectLastPos = pos
				lply.spectLastAng = ang
			end
			
			local lerpFactor = FrameTime() * 10
			lply.spectLastPos = LerpVector(lerpFactor, lply.spectLastPos, pos)
			lply.spectLastAng = LerpAngle(lerpFactor, lply.spectLastAng, ang)

			view = {
				origin = lply.spectLastPos,
				angles = lply.spectLastAng,
				fov = fov,
			}
		else
			view = {
				origin = pos,
				angles = ang,
				fov = fov,
			}
		end

		return view
	else
		lply.spectLastPos = nil
		lply.spectLastAng = nil
		lply:SetObserverMode(OBS_MODE_NONE)
	end
end)

local SPECTATOR_FLASHLIGHT_KEY = KEY_E
local SPECTATOR_FLASHLIGHT_ENABLED = CreateClientConVar(
    "hg_spectator_flashlight",
    "1",
    true,
    false,
    "toggle spec flashlight",
    0,
    1
)

local spectLight = nil
local spectLightOn = false

local function CreateSpectLight()
    if IsValid(spectLight) then spectLight:Remove() end

    spectLight = ProjectedTexture()
    spectLight:SetTexture("effects/flashlight001")
    spectLight:SetFarZ(1000)
    spectLight:SetNearZ(10)
    spectLight:SetFOV(90)
    spectLight:SetBrightness(4)
    spectLight:SetColor(Color(255, 250, 230))
    spectLight:SetEnableShadows(true)
end

local function UpdateSpectLight()
    if not IsValid(spectLight) then return end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local origin = ply:EyePos()
    local angles = ply:EyeAngles()

    spectLight:SetPos(origin)
    spectLight:SetAngles(angles)
    spectLight:Update()
end

local function RemoveSpectLight()
    if IsValid(spectLight) then
        spectLight:Remove()
        spectLight = nil
    end
end

local function ToggleSpectFlashlight()
    if not SPECTATOR_FLASHLIGHT_ENABLED:GetBool() then return end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    if ply:Alive() then return end

    spectLightOn = not spectLightOn
    
    surface.PlaySound( "snb/flashlight.wav" )

    if spectLightOn then
        CreateSpectLight()
    else
        RemoveSpectLight()
    end
end

hook.Add("Think", "SpectatorFlashlight_Key", function()
    if not SPECTATOR_FLASHLIGHT_ENABLED:GetBool() then
        if spectLightOn then
            spectLightOn = false
            RemoveSpectLight()
        end
        return
    end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    if ply:Alive() then
        if spectLightOn then
            spectLightOn = false
            RemoveSpectLight()
        end
        return
    end

    if input.IsKeyDown(SPECTATOR_FLASHLIGHT_KEY) then
        if not ply._spectFlashlightKeyDown then
            ply._spectFlashlightKeyDown = true
            ToggleSpectFlashlight()
        end
    else
        ply._spectFlashlightKeyDown = false
    end
end)

hook.Add("PreRender", "SpectatorFlashlight_Update", function()
    if spectLightOn and IsValid(spectLight) then
        UpdateSpectLight()
    end
end)

hook.Add("ShutDown", "SpectatorFlashlight_Cleanup", function()
    RemoveSpectLight()
end)

hook.Add("PlayerSpawn", "SpectatorFlashlight_Reset", function(ply)
    if ply == LocalPlayer() and spectLightOn then
        spectLightOn = false
        RemoveSpectLight()
    end
end)

zb.fade = zb.fade or 0

hook.Add("RenderScreenspaceEffects", "huyhuyUwU", function()
	if zb.fade > 0 then
		zb.fade = math.Approach(zb.fade, 0, FrameTime() * 1)

		surface.SetDrawColor(0, 0, 0, 255 * math.min(zb.fade, 1))
		surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1 )
	end
end)

zb.ROUND_STATE = 0
net.Receive("RoundInfo", function()
	local rnd = net.ReadString()
	
	hook.Run("RoundInfoCalled", rnd)

	if zb.CROUND ~= rnd then
		if hg.DynaMusic then
			hg.DynaMusic:Stop()
		end
	end

	zb.CROUND = rnd

	zb.ROUND_STATE = net.ReadInt(4)
	
	if zb.ROUND_STATE == 0 then
		zb.fade = 7
	end

	if zb.CROUND ~= "" then
		if CurrentRound() then
			if zb.ROUND_STATE == 3 then
				if CurrentRound().EndRound then
					CurrentRound():EndRound()
				end
			elseif zb.ROUND_STATE == 1 then
				if CurrentRound().RoundStart then
					CurrentRound():RoundStart()
				end
			end
		end
	end
end)

if IsValid(scoreBoardMenu) then
	scoreBoardMenu:Remove()
	scoreBoardMenu = nil
end

hook.Add("Player Disconnected","retrymenu",function(data)
	if IsValid(scoreBoardMenu) then
		scoreBoardMenu:Remove()
		scoreBoardMenu = nil
	end
end)

--local hg_coolvetica = ConVarExists("hg_coolvetica") and GetConVar("hg_coolvetica") or CreateClientConVar("hg_coolvetica", "0", true, false, "changes every text to coolvetica because its good", 0, 1)
local hg_font = ConVarExists("hg_font") and GetConVar("hg_font") or CreateClientConVar("hg_font", "Bahnschrift", true, false, "Change UI text font")
local font = function() -- hg_coolvetica:GetBool() and "Coolvetica" or "Bahnschrift"
    local usefont = "Bahnschrift"

    if hg_font:GetString() != "" then
        usefont = hg_font:GetString()
    end

    return usefont
end

surface.CreateFont("ZB_InterfaceSmall", {
    font = font(),
	extended = true,
    size = ScreenScale(6),
    weight = 400,
    antialias = true
})

surface.CreateFont("ZB_InterfaceMedium", {
    font = font(),
	extended = true,
    size = ScreenScale(10),
    weight = 400,
    antialias = true
})

surface.CreateFont("ZB_ScrappersMedium", {
    font = font(),
	extended = true,
    size = ScreenScale(10),
    weight = 400,
    antialias = true
})

surface.CreateFont("ZB_InterfaceMediumLarge", {
    font = font(),
	extended = true,
    size = 35,
    weight = 400,
    antialias = true
})

surface.CreateFont("ZB_InterfaceLarge", {
    font = font(),
	extended = true,
    size = ScreenScale(20),
    weight = 400,
    antialias = true
})

surface.CreateFont("ZB_InterfaceHumongous", {
    font = font(),
	extended = true,
    size = 200,
    weight = 400,
    antialias = true
})

hg.playerInfo = hg.playerInfo or {}

local function addToPlayerInfo(ply, muted, volume)
	hg.playerInfo[ply:SteamID()] = {muted and true or false, volume}

	local json = util.TableToJSON(hg.playerInfo)
	file.Write("zcity_muted.txt", json)

	if file.Exists("zcity_muted.txt", "DATA") then
		local json = file.Read("zcity_muted.txt", "DATA")

		if json then
			hg.playerInfo = util.JSONToTable(json)
		end
	end

	//PrintTable(hg.playerInfo)
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "zcityhuy", function(data)
	local ply = Player(data.userid)
	if IsValid(ply) and ply.SetMuted and hg.playerInfo and hg.playerInfo[data.networkid] then
		ply:SetMuted(hg.playerInfo[data.networkid][1])
		ply:SetVoiceVolumeScale(hg.playerInfo[data.networkid][2])
	end
end)

hook.Add("InitPostEntity", "furryhuy", function()
	if file.Exists("zcity_muted.txt", "DATA") then
		local json = file.Read("zcity_muted.txt", "DATA")

		if json then
			hg.playerInfo = util.JSONToTable(json)
		end

		if hg.playerInfo then
			for i, ply in player.Iterator() do
				if not istable(hg.playerInfo[ply:SteamID()]) then
					local muted = hg.playerInfo[ply:SteamID()]
					hg.playerInfo[ply:SteamID()] = {}
					hg.playerInfo[ply:SteamID()][1] = muted
					hg.playerInfo[ply:SteamID()][2] = 1
				end//compatibility with old json

				if hg.playerInfo[ply:SteamID()] then
					ply:SetMuted(hg.playerInfo[ply:SteamID()][1])
					ply:SetVoiceVolumeScale(hg.playerInfo[ply:SteamID()][2])
				end
			end	
		end
	end
end)

local colGray = Color(122,122,122,255)
local colBlue = Color(130,10,10)
local colBlueUp = Color(160,30,30)
local col = Color(255,255,255,255)

local colSpect1 = Color(75,75,75,255)
local colSpect2 = Color(85,85,85,255)

local colorBG = Color(55,55,55,255)
local colorBGBlacky = Color(40,40,40,255)

hg.muteall = false
hg.mutespect = false

local function OpenPlayerSoundSettings(selfa, ply)
	local Menu = DermaMenu()
	
	if not hg.playerInfo[ply:SteamID()] or not istable(hg.playerInfo[ply:SteamID()]) then addToPlayerInfo(ply, false, 1) end

	local mute = Menu:AddOption( "Mute", function(self)
		if hg.muteall || hg.mutespect then return end
		
		self:SetChecked(not ply:IsMuted())
		ply:SetMuted( not ply:IsMuted() )
		selfa:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
		addToPlayerInfo(ply, ply:IsMuted(), hg.playerInfo[ply:SteamID()][2])
	end ) -- get your stupid one line ass outta here

	mute:SetIsCheckable( true )
	mute:SetChecked( ply:IsMuted() )
	local volumeSlider = vgui.Create("DSlider", Menu)
	volumeSlider:SetLockY( 0.5 )
	volumeSlider:SetTrapInside( true )
	volumeSlider:SetSlideX(hg.playerInfo[ply:SteamID()][2]) 
	volumeSlider.OnValueChanged = function(self, x, y)
		if not IsValid(ply) then return end
		if hg.muteall or (hg.mutespect && !ply:Alive()) then return end
		hg.playerInfo[ply:SteamID()][2] = x
		ply:SetVoiceVolumeScale(hg.playerInfo[ply:SteamID()][2])
		addToPlayerInfo(ply, ply:IsMuted(), hg.playerInfo[ply:SteamID()][2])
	end

	function volumeSlider:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0 ) )
		draw.RoundedBox( 0, 0, 0, w*self:GetSlideX(), h, Color( 255, 0, 0 ) )
		draw.DrawText( ( math.Round( 100*self:GetSlideX(), 0 ) ).."%", "DermaDefault", w/2, h/4, color_white, TEXT_ALIGN_CENTER )
	end
	function volumeSlider.Knob.Paint(self) end

	Menu:AddPanel(volumeSlider)
	Menu:Open()
end



hook.Add("Player Getup", "nomorespect", function(ply)
	if not hg.mutespect then return end

	//ply:SetMuted(ply.oldmutedspect)
	ply:SetVoiceVolumeScale(!hg.muteall and (hg.playerInfo[ply:SteamID()] and hg.playerInfo[ply:SteamID()][2] or 1) or 0)
	//ply.oldmutedspect = nil

	//if IsValid(ply.soundButton) then
		//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
	//end
end)

hook.Add("Player_Death", "fixSpectatorVoiceMute", function(ply)
	if not hg.mutespect then return end

	//ply.oldmutedspect = ply:IsMuted()
	//ply:SetMuted(hg.mutespect)
	ply:SetVoiceVolumeScale(0)
	//if IsValid(ply.soundButton) then
		//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
	//end
end)

hook.Add("Player_Death", "fixSpectatorVoiceEffect", function(ply)
	if eightbit and eightbit.EnableEffect and ply.UserID then
		eightbit.EnableEffect(ply:UserID(), 0)
	end
end)

local function GetGroupDisplayName(group)
	group = tostring(group or "user"):lower()

	local names = {
		superadmin = "Superadmin",
		admin      = "Admin",
		moderator  = "Moderator",
		vip        = "VIP",
		premium    = "Premium",
		user       = "User"
	}

	return names[group] or (string.upper(group:sub(1, 1)) .. group:sub(2))
end

local function CreateGroupHeader(parent, text, isSpectator)
	local header = vgui.Create("DButton", parent)
	header:SetSize(100, ScreenScaleH(14))
	header:Dock(TOP)
	header:DockMargin(8, 8, 8, 0)
	header:SetText("")
	header:SetMouseInputEnabled(false)

	header.Paint = function(self, w, h)
		if isSpectator then
			surface.SetDrawColor(80, 80, 80, 70)
		else
			surface.SetDrawColor(colBlueUp.r, colBlueUp.g, colBlueUp.b, 200)
		end
		surface.DrawRect(0, 0, w, h)

		--surface.SetDrawColor(150, 0, 0, 128)
		--surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetFont("ZCity_VerySuperTiny")
		if isSpectator then
			surface.SetTextColor(255, 255, 255, 90)
		else
			surface.SetTextColor(col.r, col.g, col.b, col.a)
		end
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
		surface.DrawText(text)
	end

	return header
end

local function GetGroupDisplayName(group)
	group = tostring(group or "user"):lower()

	local names = {
		superadmin = "Superadmin",
		admin      = "Admin",
		moderator  = "Moderator",
		vip        = "VIP",
		premium    = "Premium",
		user       = "User"
	}

	return names[group] or (string.upper(group:sub(1, 1)) .. group:sub(2))
end

local function CreateGroupHeader(parent, text, isSpectator)
	local header = vgui.Create("DButton", parent)
	header:SetSize(100, ScreenScaleH(14))
	header:Dock(TOP)
	header:DockMargin(8, 8, 8, 0)
	header:SetText("")
	header:SetMouseInputEnabled(false)

	header.Paint = function(self, w, h)
		if isSpectator then
			surface.SetDrawColor(80, 80, 80, 200)
		else
			surface.SetDrawColor(colBlueUp.r, colBlueUp.g, colBlueUp.b, 200)
		end
		surface.DrawRect(0, 0, w, h)

		surface.SetFont("ZB_InterfaceMediumLarge")
		if isSpectator then
			surface.SetTextColor(255, 255, 255, 255)
		else
			surface.SetTextColor(col.r, col.g, col.b, col.a)
		end
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
		surface.DrawText(text)
	end

	return header
end

local function UpdateSoundButtonIcon(btn, ply)
	if not IsValid(btn) or not IsValid(ply) then return end

	local steamid = ply:SteamID()
	local isHgMuted = hg.mute and hg.mute[steamid]
	local muted = ply:IsMuted() or isHgMuted

	btn:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")
end

local function ApplyWheelMute(btn, ply, delta)
	if not IsValid(ply) then return end

	hg.mute = hg.mute or {}

	local steamid = ply:SteamID()
	local cur = ply:GetVoiceVolumeScale()
	local newVolume = math.Clamp(cur + (delta / 100 * 5), 0, 2)

	ply:SetVoiceVolumeScale(newVolume)
	hg.mute[steamid] = (newVolume <= 0) or nil

	UpdateSoundButtonIcon(btn, ply)

	if IsValid(btn) then
		btn.LastTick = CurTime()
	end
end

local function CreateSoundButton(parent, ply)
	local soundButton = vgui.Create("DImageButton", parent)
	soundButton:Dock(RIGHT)
	soundButton:SetSize(30, 0)
	soundButton:DockMargin(5, 10, 45, 10)

	UpdateSoundButtonIcon(soundButton, ply)

	soundButton.DoClick = function(self)
		OpenPlayerSoundSettings(self, ply)
	end

	soundButton.OnMouseWheeled = function(self, delta)
		ApplyWheelMute(self, ply, delta)
	end

	soundButton.PaintOver = function(self, w, h)
		if not IsValid(ply) then return end

		local steamid = ply:SteamID()
		local isHgMuted = hg.mute and hg.mute[steamid]

		local a = 255 - math.Clamp(CurTime() - (self.LastTick or 0), 0, 3) * 255
		if a <= 0 then return end

		local vol = isHgMuted and 0 or math.ceil(ply:GetVoiceVolumeScale() * 100)

		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, a * 0.75))
		draw.SimpleText(vol .. "%", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	ply.soundButton = soundButton
	return soundButton
end

function GM:ScoreboardShow()
	if IsValid(scoreBoardMenu) then
		scoreBoardMenu:Remove()
		scoreBoardMenu = nil
	end
	Dynamic = 0
	scoreBoardMenu = vgui.Create("ZFrame")

	local sizeX, sizeY = ScrW() / 1.3, ScrH() / 1.2
	local posX, posY = ScrW() / 2 - sizeX / 2, ScrH() / 2 - sizeY / 2

	scoreBoardMenu:SetPos(posX, posY)
	scoreBoardMenu:SetSize(sizeX, sizeY)
	scoreBoardMenu:MakePopup()
	scoreBoardMenu:SetKeyboardInputEnabled(false)
	scoreBoardMenu:ShowCloseButton(false)

	local muteallbut = vgui.Create("DButton", scoreBoardMenu)
	local w, h = ScreenScale(30), ScreenScale(6)
	muteallbut:SetPos(scoreBoardMenu:GetWide() - w * 2.3, scoreBoardMenu:GetTall() - h * 1.5)
	muteallbut:SetSize(w, h)
	muteallbut:SetText("Mute all")

	muteallbut.Paint = function(self, w, h)
		surface.SetDrawColor(not hg.muteall and 255 or 0, hg.muteall and 255 or 0, 0, 128)
		surface.DrawOutlinedRect(0, 0, w, h, 2.5)
	end

	muteallbut.DoClick = function(self, w, h)
		hg.muteall = not hg.muteall

		for i, ply in player.Iterator() do
			if hg.muteall then
				ply:SetVoiceVolumeScale(0)
			else
				ply:SetVoiceVolumeScale((!hg.mutespect or ply:Alive()) and (hg.playerInfo[ply:SteamID()] and hg.playerInfo[ply:SteamID()][2] or 1) or 0)
			end
		end
	end

	local mutespectbut = vgui.Create("DButton", scoreBoardMenu)
	local w, h = ScreenScale(30), ScreenScale(6)
	mutespectbut:SetPos(scoreBoardMenu:GetWide() - w * 1.2, scoreBoardMenu:GetTall() - h * 1.5)
	mutespectbut:SetSize(w, h)
	mutespectbut:SetText("Mute spectators")

	mutespectbut.Paint = function(self, w, h)
		surface.SetDrawColor(not hg.mutespect and 255 or 0, hg.mutespect and 255 or 0, 0, 128)
		surface.DrawOutlinedRect(0, 0, w, h, 2.5)
	end

	mutespectbut.DoClick = function(self, w, h)
		hg.mutespect = not hg.mutespect

		for i, ply in player.Iterator() do
			if ply:Alive() then continue end

			if hg.mutespect then
				ply:SetVoiceVolumeScale(0)
			else
				ply:SetVoiceVolumeScale(!hg.muteall and (hg.playerInfo[ply:SteamID()] and hg.playerInfo[ply:SteamID()][2] or 1) or 0)
			end
		end
	end

	local function GetCurrentRoundName()
		if IsValid(LocalPlayer()) then
			local modeName = LocalPlayer():GetNetVar("zb_round_name", nil)
			if modeName and modeName ~= "" then
				return modeName
			end
		end

		if IsValid(game.GetWorld()) then
			local modeName = game.GetWorld():GetNetVar("zb_round_name", nil)
			if modeName and modeName ~= "" then
				return modeName
			end
		end

		return nil
	end

	local roundName = GetCurrentRoundName()
	local ServerName = "J-City | " .. (roundName or "Unknown")

	local function GetPlayerDisplayName(ply)
		if not IsValid(ply) then return "He quited..." end

		local nickname = ply:Name() or "He quited..."
		local appearanceName = ply:GetNWString("PlayerName", "")

		if appearanceName and appearanceName ~= "" and appearanceName ~= nickname then
			return nickname .. " (" .. appearanceName .. ")"
		end

		return nickname
	end

	local tick
	scoreBoardMenu.PaintOver = function(self, w, h)
		surface.SetDrawColor(255, 0, 0, 128)
		surface.DrawOutlinedRect(0, 0, w, h, 2.5)

		surface.SetFont("ZB_InterfaceLarge")
		surface.SetTextColor(col.r, col.g, col.b, col.a)
		local lengthX, lengthY = surface.GetTextSize(ServerName)
		surface.SetTextPos(w / 2 - lengthX / 2, 10)
		surface.DrawText(ServerName)

		surface.SetFont("ZB_InterfaceSmall")
		surface.SetTextColor(col.r, col.g, col.b, col.a * 0.1)
		local txt = "ZC Version: " .. hg.Version
		local lengthX, lengthY = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.01, h - lengthY - h * 0.01)
		surface.DrawText(txt)

		surface.SetFont("ZB_InterfaceMediumLarge")
		surface.SetTextColor(col.r, col.g, col.b, col.a)
		local lengthX, lengthY = surface.GetTextSize("Players:")
		surface.SetTextPos(w / 4 - lengthX / 2, ScreenScale(25))
		surface.DrawText("Players:")

		surface.SetFont("ZB_InterfaceMediumLarge")
		surface.SetTextColor(col.r, col.g, col.b, col.a)
		local lengthX, lengthY = surface.GetTextSize("Spectators:")
		surface.SetTextPos(w * 0.75 - lengthX / 2, ScreenScale(25))
		surface.DrawText("Spectators:")
		tick = math.Round(1 / engine.ServerFrameTime())
		local txt = "SV Tick: " .. tick
		local lengthX, lengthY = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.5 - lengthX / 2, ScreenScale(25))
		surface.DrawText(txt)
	end

	-- TEAMSELECTION
	if LocalPlayer():Team() ~= TEAM_SPECTATOR then
		local SPECTATE = vgui.Create("DButton", scoreBoardMenu)
		SPECTATE:SetPos(sizeX * 0.925, sizeY * 0.095)
		SPECTATE:SetSize(ScrW() / 20, ScrH() / 30)
		SPECTATE:SetText("")

		SPECTATE.DoClick = function()
			net.Start("ZB_SpecMode")
			net.WriteBool(true)
			net.SendToServer()
			scoreBoardMenu:Remove()
			scoreBoardMenu = nil
		end

		SPECTATE.Paint = function(self, w, h)
			surface.SetDrawColor(255, 0, 0, 128)
			surface.DrawOutlinedRect(0, 0, w, h, 2.5)
			surface.SetFont("ZB_InterfaceMedium")
			surface.SetTextColor(col.r, col.g, col.b, col.a)
			local lengthX, lengthY = surface.GetTextSize("Join")
			surface.SetTextPos(lengthX - lengthX / 2, 2)
			surface.DrawText("Join")
		end
	end

	if LocalPlayer():Team() == TEAM_SPECTATOR then
		local PLAYING = vgui.Create("DButton", scoreBoardMenu)
		PLAYING:SetPos(sizeX * 0.010, sizeY * 0.095)
		PLAYING:SetSize(ScrW() / 20, ScrH() / 30)
		PLAYING:SetText("")

		PLAYING.DoClick = function()
			net.Start("ZB_SpecMode")
			net.WriteBool(false)
			net.SendToServer()
			scoreBoardMenu:Remove()
			scoreBoardMenu = nil
		end

		PLAYING.Paint = function(self, w, h)
			surface.SetDrawColor(255, 0, 0, 128)
			surface.DrawOutlinedRect(0, 0, w, h, 2.5)
			surface.SetFont("ZB_InterfaceMedium")
			surface.SetTextColor(col.r, col.g, col.b, col.a)
			local lengthX, lengthY = surface.GetTextSize("Join")
			surface.SetTextPos(lengthX - lengthX / 2, 2)
			surface.DrawText("Join")
		end
	end

	-- без матов
	local DScrollPanel = vgui.Create("DScrollPanel", scoreBoardMenu)
	DScrollPanel:SetPos(10, ScreenScaleH(58))
	DScrollPanel:SetSize(sizeX / 2 - 10, sizeY - ScreenScaleH(72))
	function DScrollPanel:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 125)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 0, 0, 128)
		surface.DrawOutlinedRect(0, 0, w, h, 2.5)
	end

	local disappearance = lply:GetNetVar("disappearance", nil)

	local groups = {}
	for _, ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end
		if CurrentRound().name == "fear" and !ply:Alive() then continue end
		if disappearance and ply ~= lply then continue end

		local group = ply:GetUserGroup() or "user"
		groups[group] = groups[group] or {}
		table.insert(groups[group], ply)
	end

	-- костылыыыы
	local groupOrder = {
		"superadmin", "admin", "moderator", "vip", "premium", "user"
	}

	for group in pairs(groups) do
		local found = false
		for _, g in ipairs(groupOrder) do
			if g == group then found = true break end
		end
		if not found then table.insert(groupOrder, group) end
	end

	for _, group in ipairs(groupOrder) do
		local players = groups[group]
		if not players or #players == 0 then continue end

		table.sort(players, function(a, b)
			return a:Name() < b:Name()
		end)

		CreateGroupHeader(DScrollPanel, GetGroupDisplayName(group) .. ":", false) --  .. " (" .. #players .. ")"

		for _, ply in ipairs(players) do
			local but = vgui.Create("DButton", DScrollPanel)
			but:SetSize(100, ScreenScaleH(22))
			but:Dock(TOP)
			but:DockMargin(8, 6, 8, -1)
			but:SetText("")

			local avatarSize = ScreenScaleH(16)
			local avatar = vgui.Create("AnimatedAvatarImage", but)
			avatar:SetSize(avatarSize, avatarSize)
			avatar:SetPos(6, (but:GetTall() - avatarSize) / 2)
			avatar:SetPlayer(ply, 64)

			CreateSoundButton(but, ply)

			but.Paint = function(self, w, h)
				if not IsValid(ply) then return end
				surface.SetDrawColor(colBlueUp.r, colBlueUp.g, colBlueUp.b, colBlueUp.a)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(colBlue.r, colBlue.g, colBlue.b, colBlue.a)
				surface.DrawRect(0, h / 2, w, h / 2)

				surface.SetDrawColor(255, 0, 0, 128)
				surface.DrawOutlinedRect(6, h / 2 - avatarSize / 2, avatarSize, avatarSize, 1)

				local displayName = GetPlayerDisplayName(ply)
				surface.SetFont("ZB_InterfaceMediumLarge")
				surface.SetTextColor(col.r, col.g, col.b, col.a)
				local lengthX, lengthY = surface.GetTextSize(displayName)
				surface.SetTextPos(6 + avatarSize + 8, h / 2 - lengthY / 2)
				surface.DrawText(displayName)

				surface.SetFont("ZB_InterfaceMediumLarge")
				surface.SetTextColor(col.r, col.g, col.b, col.a)
				local lengthX, lengthY = surface.GetTextSize(ply:Ping() or "He quited...")
				surface.SetTextPos(w - lengthX - 15, h / 2 - lengthY / 2)
				surface.DrawText(ply:Ping() or "He quited...")
			end

			function but:DoClick()
				if ply:IsBot() then chat.AddText(Color(255, 0, 0), "no, you can't") return end
				gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64())
			end

			function but:DoRightClick()
				local Menu = DermaMenu()
				Menu:AddOption("Account", function(self)
					surface.PlaySound("buttons/button5.wav")
					zb.Experience.AccountMenu(ply)
				end)
				Menu:AddOption("Copy SteamID", function(self)
					surface.PlaySound("buttons/button5.wav")
					SetClipboardText(ply:SteamID())
				end)
				Menu:AddOption("Copy SteamID64", function(self)
					surface.PlaySound("buttons/button5.wav")
					SetClipboardText(ply:SteamID64())
				end)
				if LocalPlayer():IsAdmin() then
					Menu:AddSpacer()
					Menu:AddOption("Goto", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "goto", ply:Nick())
					end)
					Menu:AddOption("Bring", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "bring", ply:Nick())
					end)
					Menu:AddOption("Freeze", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "freeze", ply:Nick())
					end)
					Menu:AddOption("UnFreeze", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "unfreeze", ply:Nick())
					end)
					Menu:AddOption("Slay", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "slay", ply:Nick())
					end)
                    Menu:AddOption("Respawn", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "respawn", ply:Nick())
					end)
					Menu:AddOption("Kick", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "kick", ply:Nick(), "Kicked!")
					end)
				end

				Menu:Open()
			end

			DScrollPanel:AddItem(but)
		end
	end

	-- SPECTATORS
	local DScrollPanel = vgui.Create("DScrollPanel", scoreBoardMenu)
	DScrollPanel:SetPos(sizeX / 2 + 5, ScreenScaleH(58))
	DScrollPanel:SetSize(sizeX / 2 - 15, sizeY - ScreenScaleH(72))
	function DScrollPanel:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 125)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 0, 0, 128)
		surface.DrawOutlinedRect(0, 0, w, h, 2.5)
	end

	local specGroups = {}
	for _, ply in player.Iterator() do
		if ply:Team() ~= TEAM_SPECTATOR then continue end
		if CurrentRound().name == "fear" and !ply:Alive() then continue end
		if disappearance and ply ~= lply then continue end

		local group = ply:GetUserGroup() or "user"
		specGroups[group] = specGroups[group] or {}
		table.insert(specGroups[group], ply)
	end

	for _, group in ipairs(groupOrder) do
		local players = specGroups[group]
		if not players or #players == 0 then continue end

		table.sort(players, function(a, b)
			return a:Name() < b:Name()
		end)

		CreateGroupHeader(DScrollPanel, GetGroupDisplayName(group), true)

		for _, ply in ipairs(players) do
			local but = vgui.Create("DButton", DScrollPanel)
			but:SetSize(100, ScreenScaleH(22))
			but:Dock(TOP)
			but:DockMargin(8, 6, 8, -1)
			but:SetText("")

			local avatarSize = ScreenScaleH(16)
			local avatar = vgui.Create("AnimatedAvatarImage", but)
			avatar:SetSize(avatarSize, avatarSize)
			avatar:SetPos(6, (but:GetTall() - avatarSize) / 2)
			avatar:SetPlayer(ply, 64)

			CreateSoundButton(but, ply)

			but.Paint = function(self, w, h)
				if not IsValid(ply) then return end
				surface.SetDrawColor(90, 90, 90, 200)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(60, 60, 60, 200)
				surface.DrawRect(0, h / 2, w, h / 2)

				surface.SetDrawColor(255, 0, 0, 128)
				surface.DrawOutlinedRect(6, h / 2 - avatarSize / 2, avatarSize, avatarSize, 1)

				local displayName = GetPlayerDisplayName(ply)
				surface.SetFont("ZB_InterfaceMediumLarge")
				surface.SetTextColor(210, 210, 210, 255)
				local lengthX, lengthY = surface.GetTextSize(displayName)
				surface.SetTextPos(6 + avatarSize + 8, h / 2 - lengthY / 2)
				surface.DrawText(displayName)

				surface.SetFont("ZB_InterfaceMediumLarge")
				surface.SetTextColor(210, 210, 210, 255)
				local lengthX, lengthY = surface.GetTextSize(ply:Ping() or "He quited...")
				surface.SetTextPos(w - lengthX - 15, h / 2 - lengthY / 2)
				surface.DrawText(ply:Ping() or "He quited...")
			end

			function but:DoClick()
				if ply:IsBot() then chat.AddText("That bot.") return end
				gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64())
			end

			function but:DoRightClick()
				local Menu = DermaMenu()
				Menu:AddOption("Account", function(self)
					surface.PlaySound("buttons/button5.wav")
					zb.Experience.AccountMenu(ply)
				end)
				Menu:AddOption("Copy SteamID", function(self)
					surface.PlaySound("buttons/button5.wav")
					SetClipboardText(ply:SteamID())
				end)
				Menu:AddOption("Copy SteamID64", function(self)
					surface.PlaySound("buttons/button5.wav")
					SetClipboardText(ply:SteamID64())
				end)
				if LocalPlayer():IsAdmin() then
					Menu:AddSpacer()
					Menu:AddOption("Respawn", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "respawn", ply:Nick())
					end)
					Menu:AddOption("Kick", function()
						surface.PlaySound("buttons/button5.wav")
						RunConsoleCommand("ulx", "kick", ply:Nick(), "Kicked!")
					end)
				end

				Menu:Open()
			end

			DScrollPanel:AddItem(but)
		end
	end

	return true
end

function GM:ScoreboardHide()
	if IsValid(scoreBoardMenu) then
		scoreBoardMenu:Close()
		scoreBoardMenu = nil
	end
end

-- свет от молнии а саму молнию я не сделал skill issue
if CLIENT then
	net.Receive("PunishLightningEffect", function()
		local target = net.ReadEntity()
		if not IsValid(target) then return end
		local dlight = DynamicLight(target:EntIndex())
		if dlight then
			dlight.pos = target:GetPos()
			dlight.r = 126
			dlight.g = 139
			dlight.b = 212
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 500
			dlight.DieTime = CurTime() + 1
		end
	end)
end

/*  -- а кстати зачем здесь нэт, это же можно было на клиенте полностью сделать...
	if CLIENT then
		net.Receive("PluvCommand", function()
			local specialSteamID = "STEAM_0:1:81850653" 
			local playerSteamID = LocalPlayer():SteamID() 

			local imageURLs = {"https://sadsalat.github.io/salatis/music/boof.gif", "https://i.ibb.co/drt1Lks/KtvCLSs.webp", "https://media.tenor.com/kG4PmVvJuRIAAAAC/rain-world-rain-world-saint.gif"} 
			local soundURLs = {"https://sadsalat.github.io/salatis/music/sus-rock.mp3", "https://sadsalat.github.io/salatis/music/tiktok-raaaah-scream.mp3", "https://sadsalat.github.io/salatis/music/sus-rock.mp3"} 

			local chosenImage = imageURLs[math.random(#imageURLs)]
			local chosenSound = soundURLs[math.random(#soundURLs)]

			sound.PlayURL(chosenSound, "", function(station)
				if IsValid(station) then
					station:Play()
				else
					print("Unable to play the sound.")
				end
			end)

			local html = vgui.Create("HTML")
			html:OpenURL(chosenImage)
			html:SetSize(ScrW(), ScrH())
			html:Center()
			html:MakePopup()

			timer.Simple(3, function()
				if IsValid(html) then
					html:Remove()
				end
			end)
		end)
	end
*/

local lightningMaterial = Material("sprites/lgtning")

net.Receive("AnotherLightningEffect", function()
    local target = net.ReadEntity()
	if not IsValid(target) then return end
    local points = {}
    for i = 1, 27 do
        points[i] = target:GetPos() + Vector(0, 0, i * 50) + Vector(math.Rand(-20,20),math.Rand(-20,20),math.Rand(-20,20))
    end
    hook.Add( "PreDrawTranslucentRenderables", "LightningExample", function(isDrawingDepth, isDrawingSkybox)
        if isDrawingDepth or isDrawingSkybox then return end
        local uv = math.Rand(0, 1)
        render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_ADD, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD )
        render.SetMaterial(lightningMaterial)
        render.StartBeam(27)
        for i = 1, 27 do
            render.AddBeam(points[i], 20, uv * i, Color(255,255,255,255))
        end
        render.EndBeam()
        render.OverrideBlend( false )
    end )
    timer.Simple(0.1, function()
        hook.Remove("PreDrawTranslucentRenderables", "LightningExample")
    end)
end)

function GM:AddHint( name, delay )
	return false
end

local snakeGameOpen = false

concommand.Add("zb_snake", function() -- вот как здесь!
    if snakeGameOpen then
        print("[Snake Game] Игра уже запущена!")
        return
    end

    local frame = vgui.Create("ZFrame")
    frame:SetTitle("Snake Game")
    frame:SetSize(400, 400)
    frame:Center()
    frame:MakePopup()
    frame:SetDeleteOnClose(true)  
    snakeGameOpen = true  

    local gridSize = 20
    local gridWidth = 19  
    local gridHeight = 19  
    local snakePanel = vgui.Create("DPanel", frame)
    snakePanel:SetSize(380, 380)
    snakePanel:SetPos(10, 10)

    
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)

    local snake = {
        {x = 10, y = 10},
    }
	
    local snakeDirection = "RIGHT"
    local food = nil
    local score = 0
    local gameRunning = true

  
    local function spawnFood()
        local validPosition = false
        while not validPosition do
            local newFood = {
                x = math.random(0, gridWidth - 1), 
                y = math.random(0, gridHeight - 1)
            }
            validPosition = true

        
            for _, segment in ipairs(snake) do
                if segment.x == newFood.x and segment.y == newFood.y then
                    validPosition = false  
                    break
                end
            end

            
            if validPosition then
                food = newFood
            end
        end
    end

    
    local function drawSnake()
        surface.SetDrawColor(0, 255, 0, 255)
        for _, segment in ipairs(snake) do
            surface.DrawRect(segment.x * gridSize, segment.y * gridSize, gridSize - 1, gridSize - 1)
        end
    end

  
    local function drawFood()
        if food then
            surface.SetDrawColor(255, 0, 0, 255)
            surface.DrawRect(food.x * gridSize, food.y * gridSize, gridSize - 1, gridSize - 1)
        end
    end

   
    local function moveSnake()
        if not gameRunning then return end

        local head = table.Copy(snake[1])

        if snakeDirection == "UP" then
            head.y = head.y - 1
        elseif snakeDirection == "DOWN" then
            head.y = head.y + 1
        elseif snakeDirection == "LEFT" then
            head.x = head.x - 1
        elseif snakeDirection == "RIGHT" then
            head.x = head.x + 1
        end

        
        if head.x < 0 or head.x >= gridWidth or head.y < 0 or head.y >= gridHeight then
            gameRunning = false
        end

       
        for _, segment in ipairs(snake) do
            if segment.x == head.x and segment.y == head.y then
                gameRunning = false
            end
        end

       
        table.insert(snake, 1, head)


        if food and head.x == food.x and head.y == food.y then
            score = score + 1
            spawnFood()  
        else
            
            table.remove(snake)
        end
    end


    local function resetGame()
        snake = {{x = 10, y = 10}}
        snakeDirection = "RIGHT"
        score = 0
        gameRunning = true
        spawnFood()  
    end


    function snakePanel:Paint(w, h)
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(0, 0, w, h)

        if gameRunning then
            drawSnake()
            drawFood()
        else
            draw.SimpleText("Game Over! Press R to restart", "DermaDefault", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        draw.SimpleText("Score: " .. score, "DermaDefault", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end


    function frame:OnKeyCodePressed(key) -- ФУРИ МУВ теперь понятно почему лагает змейка
        if key == KEY_W and snakeDirection ~= "DOWN" then
            snakeDirection = "UP"
        elseif key == KEY_S and snakeDirection ~= "UP" then
            snakeDirection = "DOWN"
        elseif key == KEY_A and snakeDirection ~= "RIGHT" then
            snakeDirection = "LEFT"
        elseif key == KEY_D and snakeDirection ~= "LEFT" then
            snakeDirection = "RIGHT"
        elseif key == KEY_R then
            resetGame()
        end
    end


    timer.Create("SnakeGameTimer", 0.2, 0, function()
        if gameRunning then
            moveSnake()
        end
        snakePanel:InvalidateLayout(true)
    end)


    frame.OnClose = function()
        timer.Remove("SnakeGameTimer")
        snakeGameOpen = false  
        print("[Snake Game] Игра закрыта.") -- НЕ РАБОТАЕТ
    end


    resetGame()
end)

hook.Add("Player Spawn", "GuiltKnown",function(ply)
	if ply == LocalPlayer() then
		system.FlashWindow()
	end
end)
