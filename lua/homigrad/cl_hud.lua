local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudDamageIndicator"] = true,
	["CHudGeiger"] = true,
	["CHudSquadStatus"] = true,
	["CHudTrain"] = true,
	["CHudZoom"] = true,
	["CHudSuitPower"] = true,
	["CHUDQuickInfo"] = true,
	["CHudHistoryResource"] = true,
}

local gordon_hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudSuitPower"] = true,
}

hook.Add("HUDShouldDraw", "homigrad", function(name)
	if not lply then return end
	if hide[name] or lply.PlayerClassName and lply.PlayerClassName == "Gordon" and gordon_hide[name] then
		return false
	end
end)
hook.Add("HUDDrawTargetID", "homigrad", function()
	return false
end)

hook.Add("DrawDeathNotice", "homigrad", function()
	return false
end)

hook.Add("HUDWeaponPickedUp", "HidePickedStuff", function(wep)
	if IsValid(lply) and lply.PlayerClassName and lply.PlayerClassName == "Gordon" then
		return
	end

	return false
end)

hook.Add("HUDAmmoPickedUp", "HidePickedStuff", function(ammoname, amt)
	if IsValid(lply) and lply.PlayerClassName and lply.PlayerClassName == "Gordon" then
		return
	end

	return false
end)

hook.Add("HUDItemPickedUp", "HidePickedStuff", function(itemname)
	if IsValid(lply) and lply.PlayerClassName and lply.PlayerClassName == "Gordon" then
		return
	end

	return false
end)

hook.Add("HUDDrawPickupHistory", "HidePickedStuff", function()
	if IsValid(lply) and lply.PlayerClassName and lply.PlayerClassName == "Gordon" then
		return
	end

	return false
end)

local hg_font = ConVarExists("hg_font") and GetConVar("hg_font") or CreateClientConVar("hg_font", "Bahnschrift", true, false, "Change UI text font")
local hg_shit_sounds = ConVarExists("hg_shit_sounds") and GetConVar("hg_shit_sounds") or CreateClientConVar("hg_shit_sounds", "0", true, false, "Toggle radial menu sounds")
local font = function()
    local usefont = "Bahnschrift"

    if hg_font:GetString() != "" then
        usefont = hg_font:GetString()
    end

    return usefont
end

surface.CreateFont("HomigradFont", {
	font = font(),
	extended = true,
	size = ScreenScale(10),
	weight = 1100,
	outline = false
})

surface.CreateFont("ScoreboardPlayer", {
	font = font(),
	extended = true,
	size = ScreenScale(7),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontBig", {
	font = font(),
	extended = true,
	size = ScreenScale(12),
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontMedium", {
	font = font(),
	extended = true,
	size = ScreenScale(8),
	weight = 1100,
	outline = false,
})

surface.CreateFont("HomigradFontLarge", {
	font = font(),
	extended = true,
	size = ScreenScale(15),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontGigantoNormous", {
	font = font(),
	extended = true,
	size = ScreenScale(25),
	weight = 1100,
	outline = false,
	shadow = false
})

surface.CreateFont("HomigradFontSmall", {
	font = font(),
	extended = true,
	size = 17,
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontVSmall", {
	font = font(),
	extended = true,
	size = 12,
	weight = 400,
	outline = false
})

surface.CreateFont("CenterTitle", {
    font = font(),
	extended = true,
    size = 28,
    weight = 800,
    antialias = true
})

surface.CreateFont("CenterAmmo", {
    font = font(),
	extended = true,
    size = 22,
    weight = 500,
    antialias = true
})

surface.CreateFont("Sector_Norm", {
    font = font(),
	extended = true,
    size = 18,
    weight = 600,
    antialias = true
})

surface.CreateFont("Sector_Med", {
    font = font(),
	extended = true,
    size = 19,
    weight = 700,
    antialias = true
})

surface.CreateFont("Sector_Hover", {
    font = font(),
	extended = true,
    size = 20,
    weight = 800,
    antialias = true
})

local w, h

hook.Add("HUDPaint", "homigrad-dev", function()
	if engine.ActiveGamemode() ~= "sandbox" then return end
	w, h = ScrW(), ScrH()
end)

function draw.CirclePart(x, y, radius, seg, parts, pos)
	local cir = {}
	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360 / parts - pos * 360 / parts) + math.pi
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	surface.DrawPoly(cir)
	render.PopFilterMin()
end

if IsValid(MENUPANELHUYHUY) then
	MENUPANELHUYHUY:Remove()
	MENUPANELHUYHUY = nil
end

hg.radialOptions = hg.radialOptions or {}
local colBlack = Color(0, 0, 0, 152)
local colOption = Color(40, 0, 55, 152)
local colWhite = Color(255, 255, 255, 255)
local colWhiteTransparent = Color(176, 40, 40, 100)
local colTransparent = Color(0, 0, 0, 0)
local matHuy = Material("vgui/white")
local vecXY = Vector(0, 0)
local vecDown = Vector(0, 1)
local isMouseIntersecting = false
local isMouseOnRadial = false
local current_option = 1
local current_option_select = 1
local hook_Run = hook.Run

local incoentCol = Color(128,0,0)
local taitorCol = Color(155,0,0)

local menuPanel

local lastHovered = 0
local lastHoverTime = 0
local HOVER_SOUND = "cool-hover.mp3"
local HOVER_COOLDOWN = 0.05

local colBack = Color(0,0,0)
local surface, draw, hook, IsColor, IsValid, math, input = surface, draw, hook, IsColor, IsValid, math, input

local function PlayRadialSound(sound)
	if hg_shit_sounds:GetBool() then
		surface.PlaySound(sound)
	end
end

local function sectorDeg(num, total)
	return 360 / total
end

local function DrawMultilineText(txt, font, tx, ty, color, alignX, alignY)
	local lines = string.Explode("\n", txt)
	
	if #lines <= 1 then
		draw.SimpleText(txt, font, tx, ty, color, alignX or TEXT_ALIGN_CENTER, alignY or TEXT_ALIGN_CENTER)
		return
	end
	
	surface.SetFont(font)
	
	local lineData = {}
	local totalH = 0
	for i, line in ipairs(lines) do
		local lw, lh = surface.GetTextSize(line)
		lineData[i] = {text = line, w = lw, h = lh}
		totalH = totalH + lh
	end
	
	local curY = ty - totalH * 0.5
	for i, ld in ipairs(lineData) do
		draw.SimpleText(ld.text, font, tx, curY + ld.h * 0.5, color, alignX or TEXT_ALIGN_CENTER, alignY or TEXT_ALIGN_CENTER)
		curY = curY + ld.h
	end
end

local function CreateRadialMenu(options_arg, bAutoClose)
	local sizeX, sizeY = ScrW(), ScrH()
	hg.radialOptions = {}
	local paining = lply.organism and lply.organism.pain and (lply.organism.pain > 100 or lply.organism.brain > 0.2) or false
	
	if !options_arg then
		local functions = hook.GetTable()["radialOptions"]
		for i, func in SortedPairs(functions) do
			func()
		end
	end

	local options1 = options_arg or hg.radialOptions

	hg.radialOptions = options1
	
	if IsValid(MENUPANELHUYHUY) then
		MENUPANELHUYHUY:Remove()
		MENUPANELHUYHUY = nil
	end

	local scrH, scrW = ScrH(), ScrW()

	MENUPANELHUYHUY = vgui.Create("DPanel")
	menuPanel = MENUPANELHUYHUY
	menuPanel:SetPos(scrW / 2 - sizeX / 2, scrH / 2 - sizeY / 2)
	menuPanel:SetSize(sizeX, sizeY)
	menuPanel:MakePopup()
	menuPanel:SetKeyBoardInputEnabled(false)
	menuPanel:SetAlpha(0)
	menuPanel:AlphaTo(255, 0.2)
	menuPanel.bAutoClose = bAutoClose
	
	lastHovered = 0
	lastHoverTime = 0
	
	if !options_arg then input.SetCursorPos(sizeX / 2, sizeY / 2) end

	function menuPanel:Close()
		if not IsValid(menuPanel) then return end
		menuPanel:AlphaTo(0, 0.1, 0, function()
			if IsValid(menuPanel) then
				menuPanel:Remove()
				menuPanel = nil
			end
		end)
	end

	local thinkwait = 0
	if !options_arg then
		menuPanel.Think = function()
			if menuPanel:GetAlpha() < 255 then return end
			if thinkwait > CurTime() then return end
			thinkwait = CurTime() + 0.25
			table.Empty(hg.radialOptions)
			local functions = hook.GetTable()["radialOptions"]
			
			for i, func in SortedPairs(functions) do
				func()
			end
		end
	end
	
	local sizePan = 0
	local anims = {}
	local alpha = 0
	local centerAlpha = 0
	local lastSelected = 0
	
	local geometry = {}
	local function BuildGeometry(count, innerR, outerR, cx, cy)
		geometry = {}
		if count <= 0 then return end
		local sector = 360 / count
		local segments = math.max(3, math.ceil(sector / 5))
		for i = 1, count do
			local start = (i - 1) * sector - 90 - sector * 0.5
			local data = {
				polygons = {},
				angle = math.rad(start + sector * 0.5)
			}
			for j = 0, segments - 1 do
				local a1 = math.rad(start + sector * j / segments)
				local a2 = math.rad(start + sector * (j + 1) / segments)
				local c1, s1 = math.cos(a1), math.sin(a1)
				local c2, s2 = math.cos(a2), math.sin(a2)
				data.polygons[#data.polygons + 1] = {
					{x = cx + c1 * innerR, y = cy + s1 * innerR},
					{x = cx + c1 * outerR, y = cy + s1 * outerR},
					{x = cx + c2 * outerR, y = cy + s2 * outerR},
					{x = cx + c2 * innerR, y = cy + s2 * innerR}
				}
			end
			geometry[i] = data
		end
	end
	
	menuPanel.Paint = function(self, w, h)
		local x, y = input.GetCursorPos()
		x = x - sizeX / 2
		y = y - sizeY / 2
		vecXY.x = x
		vecXY.y = y
		local deg = (vecXY:GetNormalized() - vecDown):Angle()
		deg = math.NormalizeAngle((deg[2] - 180) * 2) + 180
		
		local options = {}
		if paining then
			options[#options + 1] = {function() RunConsoleCommand("hg_phrase") end, ""}
		else
			options = options1
		end

		alpha = Lerp(FrameTime() * 15, alpha, 1)
		centerAlpha = Lerp(FrameTime() * 10, centerAlpha, isMouseOnRadial and 1 or 0)
		
		sizePan = LerpFT( menuPanel:GetAlpha() > 100 and 0.05 or 0.25, sizePan, (menuPanel:GetAlpha()/255))
		local viewLerp = Lerp(math.ease.OutExpo(sizePan), 0, 1)
		
		local outerR = scrH * (options_arg ~= nil and 0.4 or 0.45) * viewLerp
		local innerR = outerR * 0.6
		local cx, cy = w / 2, h / 2
		
		if #geometry ~= #options then
			BuildGeometry(#options, innerR, outerR, cx, cy)
		else
			local count = #options
			local sector = 360 / count
			local segments = math.max(3, math.ceil(sector / 5))
			for i = 1, count do
				local start = (i - 1) * sector - 90 - sector * 0.5
				local data = geometry[i]
				if data then
					for j = 0, segments - 1 do
						local a1 = math.rad(start + sector * j / segments)
						local a2 = math.rad(start + sector * (j + 1) / segments)
						local c1, s1 = math.cos(a1), math.sin(a1)
						local c2, s2 = math.cos(a2), math.sin(a2)
						local poly = data.polygons[j + 1]
						if poly then
							poly[1].x = cx + c1 * innerR; poly[1].y = cy + s1 * innerR
							poly[2].x = cx + c1 * outerR; poly[2].y = cy + s1 * outerR
							poly[3].x = cx + c2 * outerR; poly[3].y = cy + s2 * outerR
							poly[4].x = cx + c2 * innerR; poly[4].y = cy + s2 * innerR
						end
					end
				end
			end
		end
		
		local sqrt = math.sqrt(x ^ 2 + y ^ 2)
		local selected = 0
		local count = #options
		
		if count > 0 then
			if sqrt < innerR then
				selected = 0
			else
				local angle = math.deg(math.atan2(y, x))
				if angle < 0 then angle = angle + 360 end
				local sector = 360 / count
				selected = math.ceil(((angle + 90 + sector * 0.5) % 360) / sector)
				if selected <= 0 or selected > count then selected = 1 end
			end
		end
		
		isMouseOnRadial = sqrt <= outerR and sqrt > innerR
		current_option = selected > 0 and selected or current_option
		
		if selected ~= lastHovered then
			if selected > 0 and CurTime() >= lastHoverTime + HOVER_COOLDOWN then
				PlayRadialSound(HOVER_SOUND)
				lastHoverTime = CurTime()
			end
			lastHovered = selected
		end
		
		draw.NoTexture()
		
		for num = 1, #options do
			local option = options[num]
			local data = geometry[num]
			if not data then continue end
			
			anims[num] = Lerp(FrameTime() * 12, anims[num] or 0, num == selected and 1 or 0)
			local a = anims[num]
			
			if option[3] then
				local col = Color(40, 40, 40)
				surface.SetDrawColor(
					Lerp(a, 40, col.r),
					Lerp(a, 40, col.g),
					Lerp(a, 40, col.b),
					220 * alpha
				)
				for j = 1, #data.polygons do
					surface.DrawPoly(data.polygons[j])
				end
				
				local count2 = #option[4]
				local selectedPart = count2 - math.floor((outerR - sqrt) / (outerR / count2))
				current_option_select = selectedPart
				
				for i, opt in pairs(option[4]) do
					local selected2 = selectedPart == i
					local r2 = innerR + (outerR - innerR) * (i / count2)
					local rr = r2
					surface.SetDrawColor((selected2 and isMouseIntersecting) and colWhiteTransparent or colTransparent)
					draw.CirclePart(cx, cy, rr, 40, #options, num - 1)
					
					local aa = -sectorDeg(num, #options) * 0.5
					aa = math.rad(aa) + math.pi
					draw.DrawText(opt, "HomigradFont",
						cx + math.sin(aa) * rr * 0.85,
						cy + math.cos(aa) * rr * 0.85,
						colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				continue
			end
			
			local targetColor
			if option[6] and IsColor(option[6]) then
				targetColor = option[6]
			else
				targetColor = options_arg ~= nil and colOption or colBlack
			end
			
			surface.SetDrawColor(
				Lerp(a, 40, targetColor.r),
				Lerp(a, 40, targetColor.g),
				Lerp(a, 40, targetColor.b),
				220 * alpha
			)
			for j = 1, #data.polygons do
				surface.DrawPoly(data.polygons[j])
			end
			
			local dist = innerR + (outerR - innerR) * 0.5
			local tx = cx + math.cos(data.angle) * dist
			local ty = cy + math.sin(data.angle) * dist
			
			local fnt = a > 0.8 and "Sector_Hover" or (a > 0.3 and "Sector_Med" or "Sector_Norm")
			
			local txtCol = Color(
				Lerp(a, 180, 255),
				Lerp(a, 180, 255),
				Lerp(a, 180, 255),
				255 * alpha
			)
			
			local txt = option[2]
			if txt and !options_old then
			else
				if paining then
					math.randomseed(math.Round(CurTime() / 5 + num, 0))
					txt = hg.get_status_message(ply)
					math.randomseed(os.time())
				end
				
				if option[5] then
					surface.SetMaterial(option[5])
					surface.SetDrawColor(255, 255, 255, 255 * alpha)
					surface.DrawTexturedRect(tx - scrW * 0.05, ty - scrH * 0.05, scrW * 0.1, scrH * 0.1)
				elseif txt then
					DrawMultilineText(txt, fnt, tx, ty, txtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
		
		if centerAlpha > 0.01 and options[lastSelected] then
			local ca = centerAlpha * alpha * 255
			local opt = options[lastSelected]
			local title = opt[2] or ""
			
			DrawMultilineText(
				title,
				"CenterTitle",
				cx, cy - 16,
				Color(255, 240, 240, ca),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
			)
			
			draw.SimpleText(
				"",
				"CenterAmmo",
				cx, cy + 16,
				Color(200, 200, 200, ca),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
			)
		end
		
		if selected > 0 then lastSelected = selected end
		
		if selected == 0 then
			surface.SetDrawColor(255, 255, 255, 100 * alpha)
			surface.DrawRect(cx - 1, cy - 1, 2, 2)
		end
		
		if !paining then
			draw.SimpleText(lply:GetPlayerName(),"HomigradFontGigantoNormous",scrW * 0.0215* viewLerp,scrH * 0.042, colBack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( ( (lply.role and lply.role.name) or ""),"HomigradFontGigantoNormous" ,scrW * 0.0215 * viewLerp,scrH * 0.098, colBack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local col = lply:GetPlayerColor():ToColor()
			draw.SimpleText(lply:GetPlayerName(),"HomigradFontGigantoNormous",scrW * 0.02 * viewLerp,scrH * 0.04, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( ( (lply.role and lply.role.name) or ""),"HomigradFontGigantoNormous" ,scrW * 0.02 * viewLerp,scrH * 0.095, lply.role and lply.role.color or incoentCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

local function PressRadialMenu(mouseClick)
	local options = hg.radialOptions

	hook_Run("RadialMenuPressed")

	local needed_mouseclick
	if IsValid(menuPanel) and options[current_option] and isMouseOnRadial then
		PlayRadialSound("cool-click.mp3")
		
		local func = options[current_option][1]
		if isfunction(func) then needed_mouseclick = func(mouseClick, current_option_select) end
	end

	if needed_mouseclick != -1 and IsValid(menuPanel) and mouseClick != (needed_mouseclick or 2) and not menuPanel.bAutoClose then
		menuPanel:Close()
	end
end

hg.CreateRadialMenu = CreateRadialMenu
hg.PressRadialMenu = PressRadialMenu

local firstTime = true
local firstTime2 = true
local firstTime3 = true
local firstTime4 = true
local firstTime5 = true
local firstTime6 = true

hook.Add("HG_OnOtrub", "resetshit", function(ply)
	if ply == lply then
		hook_Run("RadialMenuPressed")

		if IsValid(menuPanel) then
			menuPanel:Close()
		end
	end
end)

hook.Add( "PlayerBindPress", "PlayerBindPressExample2huy", function( ply, bind, pressed )
	if string.find(bind, "+menu") then

		if (lply.organism and lply.organism.otrub) then
			return (bind == "+menu") or nil
		end

		if (bind == "+menu") then
			if pressed and !IsValid(MENUPANELHUYHUY) then
				CreateRadialMenu()
			else
				PressRadialMenu(1)
			end
			return true
		end
	end
end)

hook.Add("Think", "hg-radial-menu", function()
	if (lply.organism and lply.organism.otrub) then

		if IsValid(menuPanel) then
			hook_Run("RadialMenuPressed")
			menuPanel:Close()
		end

		return
	end
	
	if (engine.ActiveGamemode() ~= "sandbox" and input.IsKeyDown(KEY_Q)) or (engine.ActiveGamemode() == "sandbox" and input.IsKeyDown(KEY_C)) then
		if firstTime then
			firstTime = false
		end

		firstTime4 = true
	else
		if firstTime4 then
			firstTime4 = false
		end

		firstTime = true
	end

	if input.IsMouseDown(MOUSE_LEFT) then
		if firstTime2 then
			firstTime2 = false
		end

		firstTime3 = true
	else
		if firstTime3 then
			firstTime3 = false
			PressRadialMenu(1)
		end

		firstTime2 = true
	end

	if input.IsMouseDown(MOUSE_RIGHT) then
		if firstTime5 then
			firstTime5 = false
		end

		firstTime6 = true
	else
		if firstTime6 then
			firstTime6 = false
			PressRadialMenu(2)
		end

		firstTime5 = true
	end
end)

local function dropWeapon()
	RunConsoleCommand("drop")
end

hook.Add("radialOptions", "77", function()
	local organism = lply.organism or {}
	if not organism.otrub and IsValid(lply:GetActiveWeapon()) and lply:GetActiveWeapon():GetClass() ~= "weapon_hands_sh" then
		local tbl = {dropWeapon, "Drop Weapon"}
		hg.radialOptions[#hg.radialOptions + 1] = tbl
	end
end)

local danceMenu = CreateClientConVar("zb_radial_dance", "0", true, false, "On/Off Radial Options for quick dances")

hook.Add("radialOptions", "dolbaeb", function()
    if not danceMenu:GetBool() then return end

    local ply = lply
    local organism = ply.organism or {}

    if ply:Alive() and not organism.otrub and hg.GetCurrentCharacter(ply) == ply then
        hg.radialOptions[#hg.radialOptions + 1] = {
            function(mouseClick)
                if mouseClick == 1 then
                    RunConsoleCommand("actmod_menu")
                end
            end,
            "Dance Menu"
        }
    end
end)

--[[
local randomGestures = {
	"wave",
	"salute",
	"halt",
	"group",
	"forward",
	"disagree",
	"becon",
	{"point", function() RunConsoleCommand("hg_hand_gesture", "point") end},
	{"fuck you", function() RunConsoleCommand("hg_hand_gesture", "fuckyou") end},
	{"thumb_up", function() RunConsoleCommand("hg_hand_gesture" , "thumb_up") end},
}

hook.Add("radialOptions", "7", function()
    local ply = LocalPlayer()
    local organism = ply.organism or {}

    if ply:Alive() and not organism.otrub and hg.GetCurrentCharacter(ply) == ply then
        if ply.GetPlayerClass and ply:GetPlayerClass() and ply:GetPlayerClass().CanUseGestures ~= nil and not ply:GetPlayerClass().CanUseGestures then return end
		local tbl = {function(mouseClick)
			if mouseClick == 1 then
				RunConsoleCommand("act", randomGestures[math.random(#randomGestures)])
				if (ply.NextFoley or 0) < CurTime() then
					ply:EmitSound("player/clothes_generic_foley_0" .. math.random(5) .. ".wav", 55)
					ply.NextFoley = CurTime() + 1
				end
			else
				local commands = {}
				for i, str in ipairs(randomGestures) do
					commands[i] = {
						[1] = function()
							if istable(str) then
								str[2]()
							else
								RunConsoleCommand("act", str)
								if (ply.NextFoley or 0) < CurTime() then
									ply:EmitSound("player/clothes_generic_foley_0" .. math.random(5) .. ".wav", 55)
									ply.NextFoley = CurTime() + 1
								end
							end
						end,
						[2] = string.NiceName(istable(str) and str[1] or str)
					}
				end
				CreateRadialMenu(commands)
			end
		end, "Do Gesture\nRMB - Menu"}
        hg.radialOptions[#hg.radialOptions + 1] = tbl
    end
end)
--]]

local font_size = 50
surface.CreateFont("HG_font", {
	font = "Arial",
	extended = false,
	size = font_size,
	weight = 500,
	outline = true
})

local CurTime = CurTime

local vector_one = Vector( 1, 1, 1 )

local function CopyRight( text, font, x, y, color, ang, scale )
	local m = Matrix()
	m:Translate( Vector( x, y, 0 ) )
	m:Rotate( Angle( 0, ang, 0 ) )
	m:Scale( vector_one * ( scale or 1 ) )

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	m:Translate( Vector( -(w / 2)-25, -h / 2, 0 ) )

	cam.PushModelMatrix( m, true )
		draw.RoundedBox(5,0,2,w+52,h+2,Color(0,0,0))
		draw.RoundedBox(5,0,2,w+50,h,Color(255,0,0))
		draw.DrawText( text, font, 25, 0, color )	
	cam.PopModelMatrix()
end

hook.Add("HUDPaint","Identifier",function()
	if lply.organism and lply.organism.otrub then return end
	if !lply:Alive() then return end
	if lply:GetNetVar("disappearance", nil) then return end 
	
	local trace = hg.eyeTrace(lply)
	
	if not trace then return end

	local Size = math.max(math.min(1 - trace.Fraction, 1), 0.1)
	local x, y = trace.HitPos:ToScreen().x, trace.HitPos:ToScreen().y

	if trace.Hit and (trace.Entity:IsRagdoll() or trace.Entity:IsPlayer()) then
		if trace.Entity.PlayerClassName == "sc_infiltrator" then return end
		if trace.Entity:GetNetVar("disappearance", nil) then return end

		draw.NoTexture()

		local col = trace.Entity:GetPlayerColor():ToColor()
		col.a = 255 * Size * 1.5

		local coloutline = (col.r < 50 and col.g < 50 and col.b < 50) and Color(100,100,100) or Color(0,0,0)
		coloutline.a = 255 * Size * 1

		draw.DrawText(trace.Entity:GetPlayerName() or "", "HomigradFontLarge", x + 1, y + 31, coloutline, TEXT_ALIGN_CENTER)

		draw.DrawText(trace.Entity:GetPlayerName() or "", "HomigradFontLarge", x, y + 30, col, TEXT_ALIGN_CENTER)
	end
end)

function scare()
	-- hook.Add("RenderScreenspaceEffects","Scare",function()
	-- end)
end

local hint
local hg_hints = ConVarExists("hg_hints") and GetConVar("hg_hints") or CreateClientConVar("hg_hints", "1", true, false, "Toggle UI hints")

local HintBackgroundColor = Color( 0, 0, 0, 200 )

hook.Add("HUDPaint","EntHints",function()
	if not hg_hints:GetBool() then return end 
	if lply.organism and lply.organism.otrub then return end
	if !lply:Alive() then return end
	if lply:InVehicle() then return end
	
	local trace = hg.eyeTrace(lply)

	if not trace then return end

	HintBackgroundColor.a = LerpFT(0.1, HintBackgroundColor.a, (IsValid(trace.Entity) and trace.Entity.HudHintMarkup) and 200 or 0)

	hg.BasicHudHint(trace.Entity, trace, hint)
end)

function hg.BasicHudHint(ent, trace)
	hint = (IsValid(ent) and ent.HudHintMarkup) or hint

	if not hint then return end

	local x, y = trace.HitPos:ToScreen().x, trace.HitPos:ToScreen().y
	y = y + 145 + -45

	draw.RoundedBox(2, x - hint:GetWidth() / 2 - 2.5, y - 2.5, hint:GetWidth() + 5, hint:GetHeight() + 5, HintBackgroundColor)
	
	hint:Draw(x, y, TEXT_ALIGN_CENTER, nil, 175 * (HintBackgroundColor.a / 200), TEXT_ALIGN_CENTER)

	if ent.AdditionalInfoFunc then
		local str = ent.AdditionalInfoFunc()

		local w, h = surface.GetTextSize(str)
		surface.SetFont("ZCity_Tiny")
		surface.SetTextColor(color_white)
		surface.SetTextPos(x - w * 0.5, y + hint:GetHeight() + h)
		surface.DrawText(str)
	end
end

local leg = Material("zbattle/medical/broken_bone.png", "")

local white = Color(255, 255, 255, 255)
local bkg = Color(43, 30, 30)
hook.Add("HUDPaint","afflictionlist",function()
end)

local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
local anim = 0
local soundPlayed = false

hook.Add("PlayerBindPress", "dbg-zalupa", function(ply, bind, pressed)
	if not pressed then return end
	if string.lower(bind) ~= "gm_showteam" then return end

	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
		soundPlayed = false
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end)

hook.Add("HUDPaint", "dbg-clicker", function()
	anim = math.Approach(anim, GUIToggled and 1 or 0, FrameTime() * 3)
	if anim ~= 0 and anim ~= 1 then
		local offset = 16 * math.pow(anim, 0.4)
		local poly = {}
		for i = 1, 24 do
			poly[i] = {
				x = mouseX + math.cos(math.pi / 12 * i) * offset,
				y = mouseY + math.sin(math.pi / 12 * i) * offset
			}
		end
		draw.NoTexture()
		surface.SetDrawColor(235, 235, 235, math.pow(1 - anim, 2) * 255)
		
		if not soundPlayed then
			PlayRadialSound("cool-click.mp3")
			soundPlayed = true
		end
		
		surface.DrawPoly(poly)
	end

	if anim > 0 then
		local text = "Press F2 to deselect the cursor."
		surface.SetFont("ZCity_Tiny")
		local tw, th = surface.GetTextSize(text)

		local x = ScrW() / 2 - tw / 2
		local y = ScrH() - 40

		draw.SimpleText(text, "ZCity_Tiny", x + 1, y + 1, Color(0, 0, 0, 200 * anim), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "ZCity_Tiny", x, y, Color(255, 255, 255, 255 * anim), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end)

if game.SinglePlayer() then
	hook.Add("HUDPaint","Exit the singleplayer",function()
		draw.SimpleText("Z-City is not meant to be played in singleplayer, in map selection menu change SINGLEPLAYER (green button top right corner) to 2 players or any.", "HomigradFontMedium", ScrW() / 2,ScrH() / 2, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("A lot of stuff won't work and we won't provide any fixes to singleplayer EVER", "HomigradFontMedium", ScrW() / 2,ScrH() * 7 / 12, nil,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end