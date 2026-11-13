local PANEL = {}
local curent_panel 
local red_select = Color(192,0,0)

DISCORD_URL = "https://discord.gg/ab4b8Ue7qe"

local appearance_preview = {
    width = 340,
    height = 920,
    right = 0,
    top = 210,
    enter_time = 1.35,
    enter_delay = 0.35,
    exit_time = 0.3,
    exit_delay = 0.05,
    ambient = Color(0, 0, 0, 255),
    light_right = Color(115, 115, 115, 255),
    light_left = Color(85, 85, 85, 255),
    light_front = Color(92, 92, 92, 255),
    light_back = Color(0, 0, 0, 255),
    light_top = Color(55, 55, 55, 255),
    light_bottom = Color(0, 0, 0, 255),
    fov = 13,
    cam_pos = Vector(100, 0, 65),
    look_ang = Angle(11, 180, 0),
    entity_ang = Angle(0, 0, 0),
    head_yaw = -45,
    head_pitch = 0,
    head_mouse_yaw = 70,
    head_mouse_pitch = 70,
    sequence = "idle_suitcase"
}

local menu_live = {
    drift_x = 14,
    drift_y = 10,
    shake_x = 1,
    shake_y = 1,
    enter_x = 18,
    enter_y = 12
}

local function MenuUnit(num)
    return math.floor(num * math.min(ScrW(), ScrH()) / 1000)
end

local function CleanupPreviewAccessories(ent)
    if not IsValid(ent) or not ent.modelAccess then return end
    for k, v in pairs(ent.modelAccess) do
        if IsValid(v) then
            v:Remove()
        end
        ent.modelAccess[k] = nil
    end
end

local Selects = {
    {Title = "Disconnect", Func = function(luaMenu)
        hg.ShowExitConfirm(function(confirmed)
            if confirmed then
                RunConsoleCommand("disconnect")
            end
        end)
    end},
    {Title = "Main Menu", Func = function(luaMenu) gui.ActivateGameUI() luaMenu:Close() end},
    {Title = "Discord", Func = function(luaMenu) luaMenu:Close() gui.OpenURL(DISCORD_URL)  end},
    {Title = "Donate", Func = function(luaMenu) luaMenu:Close() surface.PlaySound( "buttons/button5.wav" ) end},
    {Title = "Traitor Role",
    Func = function(luaMenu,pp)
        hg.DrawTraitorRole(pp) 
    end},
    {Title = "Achievements", Func = function(luaMenu,pp) 
        hg.DrawAchievmentsMenu(pp)
    end},
    {Title = "Settings", Func = function(luaMenu,pp) 
        hg.DrawSettings(pp) 
    end},
    {Title = "Appearance", Func = function(luaMenu,pp) hg.CreateApperanceMenu(pp) end},
    {Title = "Return", Func = function(luaMenu) luaMenu:Close() end},
}

--pep
local splaspep = {
    'It\'s back...',
    'It\'s it...',
    'Not enough...',
    'Hi...',
}    

local splasheh = {
    'AOAOAOAOAAOAOAOAOAOAOAOAOAOAOAOAOAO<',
    'SNB it\'s not dead...',
    'DANILLA REVENGE',
    'WHAT YOU A WAN\'T?',
    'ULX? NOOO IM NOT A SISSY BOY :P',
    'UWU-SERVER',
    'HELO EVERYONE :3',
    'why <',
    'JOHN Z-CITY',
    ':steamhappy:',
    'CHECHA UNREAL',
    'TSSSS...',
    'NOT ME, I JUST INNOCENT GIRL!',
    'SMALLOOOTOWN...',
    'HELL IS NEAR',
    'I WISH YOU GOOD HEALTH, JASON STATHAM',
    'REST IN PEACE, CHUCK NORRIS.'
}

local Pluv = Material("pluv/pluvkid.jpg")

local xbars = 17
local ybars = 30
local gradient_d = surface.GetTextureID("vgui/gradient-d")
local gradient_r = surface.GetTextureID("vgui/gradient-u")
local gradient_l = surface.GetTextureID("vgui/gradient-l")

local clr_1 = Color(102,0,0,35)

PlayerExpCache = PlayerExpCache or {}

net.Receive("zb_xp_get", function()
    local ent = net.ReadEntity()
    local skill = net.ReadFloat()
    local exp = net.ReadInt(19)

    if not IsValid(ent) then return end

    ent.skill = skill
    ent.exp = exp

    PlayerExpCache[ent] = PlayerExpCache[ent] or {}
    PlayerExpCache[ent].skill = skill
    PlayerExpCache[ent].experience = exp

    if IsValid(MainMenu) and MainMenu.playerInfoPanel then
        MainMenu.playerInfoPanel:InvalidateLayout()
    end

    if zb and zb.Experience and zb.Experience._OnExpReceived then
        zb.Experience._OnExpReceived(ent, skill, exp)
    end
end)

function GetPlayerExpData(ply)
    if not IsValid(ply) then return 0, 0, nil, nil end

    local cache = PlayerExpCache[ply]
    local exp = cache and cache.experience or 0
    local skill = cache and cache.skill or 0

    local Band, Medal = nil, nil
    if zb and zb.Experience and zb.Experience.GetAwards then
        Band, Medal = zb.Experience.GetAwards({ skill = skill, exp = exp })
    end

    return exp, skill, Band, Medal
end

function RequestPlayerExpData(ply)
    if not IsValid(ply) then return end
    net.Start("zb_xp_get")
        net.WriteEntity(ply)
    net.SendToServer()
end

function PANEL:InitializeMarkup()
	local mapname = game.GetMap()
	local prefix = string.find(mapname, "_")
	if prefix then
		mapname = string.sub(mapname, prefix + 1)
	end
	local gm = splasheh[math.random(#splasheh)] .. " | " .. string.NiceName(mapname) 
    local huy = splaspep[math.random(#splaspep)]

    if hg.PluvTown.Active then
        local text = "<font=ZC_MM_Title><colour=199,2,2>    </colour>SISI</font>\n<font=ZCity_Tiny><colour=105,105,105>" .. gm .. "</colour></font>"

        self.SelectedPluv = table.Random(hg.PluvTown.PluvMats)

        return markup.Parse(text)
    end

    local playersCount = #player.GetAll()
    local text = "<font=ZC_MM_Title><colour=255,0,0,255>J</colour><colour=255,255,255,255>-CITY\n</font><font=ZCity_Tiny><colour=105,105,105>" .. gm .. "</colour></font>\n<font=ZCity_Tiny><colour=105,105,105>Player in server: " .. playersCount .. "</colour></font>"
    return markup.Parse(text)
end

local color_red = Color(255,25,25,45)
local clr_gray = Color(255,255,255,25)
local clr_verygray = Color(10,10,19,235)

function PANEL:GetPreviewAppearance()
    if not hg or not hg.Appearance then return end
    local appearance
    if hg.Appearance.LoadAppearanceFile and hg.Appearance.SelectedAppearance then
        appearance = hg.Appearance.LoadAppearanceFile(hg.Appearance.SelectedAppearance:GetString())
    end
    appearance = appearance or (hg.Appearance.GetRandomAppearance and hg.Appearance.GetRandomAppearance())
    if not appearance or not hg.Appearance.PlayerModels then return end
    local tMdl = hg.Appearance.PlayerModels[1][appearance.AModel] or hg.Appearance.PlayerModels[2][appearance.AModel]
    if not tMdl or not tMdl.mdl then return end
    return table.Copy(appearance), tMdl
end

function PANEL:GetLiveMouse()
    local mx, my = gui.MouseX(), gui.MouseY()
    if mx <= 0 and my <= 0 then
        mx = ScrW() * 0.5
        my = ScrH() * 0.5
    end
    local nx = math.Clamp((mx / ScrW() - 0.5) * 2, -1, 1)
    local ny = math.Clamp((my / ScrH() - 0.5) * 2, -1, 1)
    return mx, my, nx, ny
end

function PANEL:GetLiveOffset(xAmount, yAmount)
    local _, _, nx, ny = self:GetLiveMouse()
    return nx * xAmount, ny * yAmount
end

function PANEL:GetLiveShake(seedX, seedY, xAmount, yAmount)
    local t = RealTime()
    return math.sin(t * 1.8 + seedX) * xAmount, math.cos(t * 2.4 + seedY) * yAmount
end

function PANEL:GetPlayerInfo()
    local ply = LocalPlayer()
    if not IsValid(ply) then return "Unknown", 0, 0, nil, nil end

    local nick = ply:Nick()

    local exp, skill, Band, Medal = GetPlayerExpData(ply)

    if not PlayerExpCache[ply] then
        RequestPlayerExpData(ply)
    end

    return nick, exp, skill, Band, Medal
end

function PANEL:CreateAppearancePreview()
    local tbl, tMdl = self:GetPreviewAppearance()
    if not tbl or not tMdl then return end

    if hg.Appearance and hg.Appearance.PrecacheModels then
        hg.Appearance.PrecacheModels()
    end

    local holderW = MenuUnit(appearance_preview.width)
    local holderH = MenuUnit(appearance_preview.height)
    local targetX = ScrW() - holderW - MenuUnit(appearance_preview.right)
    local targetY = MenuUnit(appearance_preview.top)

    self.previewHolder = vgui.Create("DPanel", self)
    local holder = self.previewHolder
    holder:SetSize(holderW, holderH)
    holder:SetPos(targetX, ScrH())
    holder:SetAlpha(0)
    holder.TargetX = targetX
    holder.TargetY = targetY
    holder.ClosedY = ScrH()
    holder:SetMouseInputEnabled(false)
    holder.Paint = function() end
    holder.Think = function(this)
        if not this.AppearanceFollow then return end
        local x, y = this:GetPos()
        local targetPosX = this.TargetX or x
        local targetPosY = this.TargetY or y
        local nextX = LerpFT(0.18, x, targetPosX)
        local nextY = LerpFT(0.18, y, targetPosY)
        if math.abs(targetPosX - nextX) < 1 then
            nextX = targetPosX
        end
        if math.abs(targetPosY - nextY) < 1 then
            nextY = targetPosY
        end
        this:SetPos(math.Round(nextX), math.Round(nextY))
    end

    local preview = vgui.Create("DModelPanel", holder)
    self.previewModel = preview
    preview.OwnerMenu = self
    preview:Dock(FILL)
    preview:SetModel(util.IsValidModel(tostring(tMdl.mdl)) and tostring(tMdl.mdl) or "models/player/group01/female_01.mdl")
    preview:SetFOV(appearance_preview.fov)
    preview:SetLookAng(appearance_preview.look_ang)
    preview:SetCamPos(appearance_preview.cam_pos)
    preview:SetAmbientLight(appearance_preview.ambient)
    preview:SetDirectionalLight(BOX_RIGHT, appearance_preview.light_right)
    preview:SetDirectionalLight(BOX_LEFT, appearance_preview.light_left)
    preview:SetDirectionalLight(BOX_FRONT, appearance_preview.light_front)
    preview:SetDirectionalLight(BOX_BACK, appearance_preview.light_back)
    preview:SetDirectionalLight(BOX_TOP, appearance_preview.light_top)
    preview:SetDirectionalLight(BOX_BOTTOM, appearance_preview.light_bottom)
    preview:SetMouseInputEnabled(false)
    preview.AppearanceTable = tbl

    local oldPaint = preview.Paint
    preview.Paint = function(pnl, w, h)
        DisableClipping(true)
        oldPaint(pnl, w, h)
        DisableClipping(false)
    end

    function preview:LayoutEntity(ent)
        local appearance = self.AppearanceTable
        if not appearance or not hg or not hg.Appearance or not hg.Appearance.PlayerModels then return end

        local modelData = hg.Appearance.PlayerModels[1][appearance.AModel] or hg.Appearance.PlayerModels[2][appearance.AModel]
        if not modelData or not modelData.mdl then return end

        local colorData = appearance.AColor or color_white
        ent:SetNWVector("PlayerColor", Vector((colorData.r or 255) / 255, (colorData.g or 255) / 255, (colorData.b or 255) / 255))

        local targetEntityAngle = appearance_preview.entity_ang
        self.EntityAngle = LerpAngle(RealFrameTime() * 6, self.EntityAngle or targetEntityAngle, targetEntityAngle)
        ent:SetAngles(self.EntityAngle)

        local sequenceName = appearance_preview.sequence
        local seq = ent:LookupSequence(sequenceName)
        if seq and seq >= 0 then
            if self.ActiveSequenceName != sequenceName then
                ent:ResetSequence(seq)
                self.ActiveSequenceName = sequenceName
            end
            ent:SetPlaybackRate(1)
            ent:FrameAdvance(RealFrameTime())
        end

        local owner = self.OwnerMenu
        local nx, ny = 0, 0
        if IsValid(owner) and owner.GetLiveMouse then
            local _, _, newNX, newNY = owner:GetLiveMouse()
            nx, ny = newNX, newNY
        end
        local targetYaw = appearance_preview.head_yaw - nx * appearance_preview.head_mouse_yaw
        local targetPitch = appearance_preview.head_pitch - ny * appearance_preview.head_mouse_pitch
        self.HeadYawLerp = LerpFT(0.08, self.HeadYawLerp or appearance_preview.head_yaw, targetYaw)
        self.HeadPitchLerp = LerpFT(0.08, self.HeadPitchLerp or appearance_preview.head_pitch, targetPitch)
        ent:SetPoseParameter("head_yaw", self.HeadYawLerp)
        ent:SetPoseParameter("head_pitch", self.HeadPitchLerp)

        ent:SetSubMaterial()
        self:SetCamPos(appearance_preview.cam_pos)
        self:SetFOV(appearance_preview.fov)
        self:SetLookAng(appearance_preview.look_ang)

        if ent:GetModel() != modelData.mdl then
            CleanupPreviewAccessories(ent)
            ent:SetModel(modelData.mdl)
            self:SetModel(modelData.mdl)
            self.ActiveSequenceName = nil
        end

        local clothes = appearance.AClothes or {}
        local mats = ent:GetMaterials()
        for k, v in SortedPairs(modelData.submatSlots or {}) do
            local slot = 1
            for i = 1, #mats do
                if mats[i] == v then
                    slot = i - 1
                    break
                end
            end
            local sexID = modelData.sex and 2 or 1
            local clothMat = hg.Appearance.Clothes[sexID] and hg.Appearance.Clothes[sexID][clothes[k]]
            ent:SetSubMaterial(slot, clothMat or (hg.Appearance.Clothes[sexID] and hg.Appearance.Clothes[sexID].normal) or nil)
        end

        local facemapSlot = hg.Appearance.FacemapsModels and hg.Appearance.FacemapsModels[modelData.mdl]
        for i = 1, #mats do
            if facemapSlot and hg.Appearance.FacemapsSlots[mats[i]] and hg.Appearance.FacemapsSlots[mats[i]][appearance.AFacemap] then
                ent:SetSubMaterial(i - 1, hg.Appearance.FacemapsSlots[mats[i]][appearance.AFacemap])
            end
        end

        appearance.ABodygroups = appearance.ABodygroups or {}
        for k, v in SortedPairs(ent:GetBodyGroups()) do
            if not appearance.ABodygroups[v.name] then continue end
            local bodygroupData = hg.Appearance.Bodygroups[v.name]
            local bodygroupSet = bodygroupData and bodygroupData[modelData.sex and 2 or 1] and bodygroupData[modelData.sex and 2 or 1][appearance.ABodygroups[v.name]]
            if not bodygroupSet then continue end
            for i = 0, #v.submodels do
                if bodygroupSet[1] == v.submodels[i] then
                    ent:SetBodygroup(k - 1, i)
                    break
                end
            end
        end
    end

    function preview:PostDrawModel(ent)
        local appearance = self.AppearanceTable
        if not appearance or not appearance.AAttachments then return end
        for _, attach in ipairs(appearance.AAttachments) do
            local accessoryData = hg.Accessories and hg.Accessories[attach]
            if accessoryData then
                DrawAccesories(ent, ent, attach, accessoryData, false, true)
            end
        end
        ent:SetupBones()
    end

    function preview:OnRemove()
        if IsValid(self.Entity) then
            CleanupPreviewAccessories(self.Entity)
        end
    end

    holder.AppearanceFollow = true
    timer.Simple(0, function()
        if not IsValid(holder) then return end
        holder:MoveTo(targetX, targetY, appearance_preview.enter_time, 0, appearance_preview.enter_delay)
        holder:AlphaTo(255, appearance_preview.enter_time * 0.75, appearance_preview.enter_delay)
    end)
end

function PANEL:CreatePlayerInfoPanel()
    local panelW = MenuUnit(appearance_preview.width)
    local panelH = MenuUnit(170)
    local posX = ScrW() - panelW - MenuUnit(appearance_preview.right)
    local posY = MenuUnit(appearance_preview.top) - panelH - MenuUnit(15)

    self.playerInfoPanel = vgui.Create("DPanel", self)
    local info = self.playerInfoPanel
    info:SetSize(panelW, panelH)
    info:SetPos(posX, posY)
    info:SetAlpha(0)
    info:SetMouseInputEnabled(false)
    info.Paint = function() end

    local avatarSize = MenuUnit(64)
    local avatar = vgui.Create("AvatarImage", info)
    if IsValid(avatar) then
        avatar:SetSize(avatarSize, avatarSize)
        avatar:SetPos((panelW - avatarSize) * 0.5, MenuUnit(8))
        avatar:SetPlayer(LocalPlayer(), avatarSize)
        avatar:SetMouseInputEnabled(false)
    end

    info.Paint = function(this, w, h)
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local nick, exp, skill, Band, Medal = self:GetPlayerInfo()

        local textTop = MenuUnit(8) + avatarSize + MenuUnit(10)
        local textBottom = h - MenuUnit(10)
        local textAreaH = textBottom - textTop
        local centerX = w * 0.5

        local nickY = textTop + textAreaH * 0.28
        draw.SimpleText(nick, "ZCity_Small", centerX, nickY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local expText = "EXP: " .. exp .. "  |  SKILL: " .. string.format("%.2f", skill)
        local expY = textTop + textAreaH * 0.72
        draw.SimpleText(expText, "ZCity_Tiny", centerX, expY, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    RequestPlayerExpData(LocalPlayer())

    timer.Simple(0, function()
        if not IsValid(info) then return end
        info:AlphaTo(255, appearance_preview.enter_time * 0.75, appearance_preview.enter_delay)
    end)
end

function PANEL:Init()
    self:SetAlpha(0)
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:SetBorder(false)
    self:SetColorBG(clr_verygray)
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    curent_panel = nil
    self.Title, self.TitleShadow = self:InitializeMarkup()
    self.LiveLerp = 0
    self.AnimTime = 0
    self.EnableBackgroundAnimation = true
    self.BackgroundLineColor = Color(107, 107, 107, 20)

    self:CreateAppearancePreview()
    self:CreatePlayerInfoPanel()

    timer.Simple(0, function()
        if self.First then
            self:First()
        end
    end)

    self.lDock = vgui.Create("DPanel", self)
    local lDock = self.lDock
    lDock:Dock(LEFT)
    lDock:SetSize(ScrW() / 4, ScrH())
    lDock:DockMargin(ScreenScale(0), ScreenScaleH(90), ScreenScale(10), ScreenScaleH(90))
    lDock.Paint = function(this, w, h)
        if hg.PluvTown.Active then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.SelectedPluv or Pluv)
            surface.DrawTexturedRect(0, ScreenScale(27), ScreenScale(35), ScreenScale(27))
        end

        self.Title:Draw(ScreenScale(15), ScreenScale(50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 255, TEXT_ALIGN_LEFT)
    end

    self.Buttons = {}
    for k, v in ipairs(Selects) do
        if v.GamemodeOnly and engine.ActiveGamemode() != "zcity" then continue end
        self:AddSelect(lDock, v.Title, v)
    end


    local bottomDock = vgui.Create("DPanel", self)
    bottomDock:SetPos(ScreenScale(1), ScrH() - ScrH()/10)
    bottomDock:SetSize(ScreenScale(190), ScreenScaleH(40))
    bottomDock.Paint = function(this, w, h) end
    self.panelparrent = vgui.Create("DPanel", self)
    self.panelparrent:SetPos(bottomDock:GetWide()+bottomDock:GetX(), 0)
    self.panelparrent:SetSize(ScrW() - bottomDock:GetWide()*1, ScrH())
    self.panelparrent.Paint = function(this, w, h) end
    
    local git = vgui.Create("DLabel", bottomDock)
    git:Dock(BOTTOM)
    git:DockMargin(ScreenScale(10), 0, 0, 0)
    git:SetFont("ZCity_Tiny")
    git:SetTextColor(clr_gray)
    git:SetText("GitHub: github.com/" .. hg.GitHub_ReposOwner .. "/" .. hg.GitHub_ReposName)
    git:SetContentAlignment(4)
    git:SetMouseInputEnabled(true)
    git:SizeToContents()

    function git:DoClick()
        gui.OpenURL("https://github.com/" .. hg.GitHub_ReposOwner .. "/" .. hg.GitHub_ReposName)
    end

    local version = vgui.Create("DLabel", bottomDock)
    version:Dock(BOTTOM)
    version:DockMargin(ScreenScale(10), 0, 0, 0)
    version:SetFont("ZCity_Tiny")
    version:SetTextColor(clr_gray)
    version:SetText("Version: " .. hg.Version)
    version:SetContentAlignment(4)
    version:SizeToContents()

    local zteam = vgui.Create("DLabel", bottomDock)
    zteam:Dock(BOTTOM)
    zteam:DockMargin(ScreenScale(10), 0, 0, 0)
    zteam:SetFont("ZCity_Tiny")
    zteam:SetTextColor(clr_gray)
    zteam:SetText("Authors: uzelezz, Sadsalat, \nMr.Point, Zac90, Deka, Mannytko")
    zteam:SetContentAlignment(4)
    zteam:SizeToContents()

    local cum = vgui.Create("DLabel", self)
    cum:SetPos(ScrW() - ScreenScale(80), ScrH() - ScrH()/12 + ScreenScaleH(21))
    cum:SetFont("ZCity_Tiny")
    cum:SetTextColor(clr_gray)
    cum:SetText("Server by БАЙТЕК")
    cum:SetContentAlignment(5)
    cum:SizeToContents()
    cum:SetMouseInputEnabled(true)
end

function PANEL:First( ply )
    self:AlphaTo( 255, 0.1, 0, nil )
end

function PANEL:Think()
    self.LiveLerp = LerpFT(0.08, self.LiveLerp or 0, 1)

    if IsValid(self.playerInfoPanel) then
        local panelW = MenuUnit(appearance_preview.width)
        local panelH = MenuUnit(170)
        local posX = ScrW() - panelW - MenuUnit(appearance_preview.right)
        local posY = MenuUnit(appearance_preview.top) - panelH - MenuUnit(15)
        self.playerInfoPanel:SetPos(posX, posY)
        self.playerInfoPanel:SetSize(panelW, panelH)
    end
end

function PANEL:Paint(w,h)
    if self.EnableBackgroundAnimation then
        self.AnimTime = self.AnimTime or 0
        self.AnimTime = self.AnimTime + FrameTime()

        draw.RoundedBox(0, 0, 0, w, h, self.ColorBG)
        hg.DrawBlur(self, 5)

        surface.SetDrawColor(self.BackgroundLineColor or Color(107, 107, 107, 20))
        local sw, sh = ScrW(), ScrH()
        
        for i = 1, (ybars + 1) do
            local xPos = (sw / ybars) * i - (self.AnimTime * 30 % (sw / ybars))
            surface.DrawRect(xPos, 0, ScreenScale(1), sh)
        end

        for i = 1, (xbars + 1) do
            local yPos = (sh / xbars) * (i - 1) + (self.AnimTime * 30 % (sh / xbars))
            surface.DrawRect(0, yPos, sw, ScreenScale(1))
        end

        surface.SetDrawColor(self.ColorBG)
        surface.SetTexture(gradient_l)
        surface.DrawTexturedRect(0, 0, w, h)
        surface.SetDrawColor(clr_1)
        surface.SetTexture(gradient_d)
        surface.DrawTexturedRect(0, 0, w, h)
    else
        draw.RoundedBox(0, 0, 0, w, h, self.ColorBG)
        hg.DrawBlur(self, 5)
        surface.SetDrawColor(self.ColorBG)
        surface.SetTexture(gradient_l)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetDrawColor(clr_1)
        surface.SetTexture(gradient_d)
        surface.DrawTexturedRect(0,0,w,h)
    end
end

function PANEL:SetBackgroundAnimationEnabled(bEnabled)
    self.EnableBackgroundAnimation = bEnabled
end

function PANEL:SetBackgroundLineColor(cColor)
    self.BackgroundLineColor = cColor
end

function PANEL:AddSelect( pParent, strTitle, tbl )
    local id = #self.Buttons + 1
    self.Buttons[id] = vgui.Create( "DLabel", pParent )
    local btn = self.Buttons[id]
    btn:SetText( strTitle )
    btn:SetMouseInputEnabled( true )
    btn:SizeToContents()
    btn:SetFont( "ZC_MM_Buttons" )
    btn:SetTall( ScreenScale( 15 ) )
    btn:Dock(BOTTOM)
    btn:DockMargin(ScreenScale(15),ScreenScale(1.5),0,0)
    btn.Func = tbl.Func
    btn.HoveredFunc = tbl.HoveredFunc
    local luaMenu = self 
    if tbl.CreatedFunc then tbl.CreatedFunc(btn, self, luaMenu) end
    btn.RColor = Color(225,225,225)
    
    btn.IsRainbow = (strTitle == "Donate")
    
    function btn:DoClick()
        if curent_panel == string.lower(strTitle) then
			for i = 1, 3 do
				surface.PlaySound("cool-click.mp3")
			end
            luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
                luaMenu.panelparrent:Remove()
                luaMenu.panelparrent = nil
                luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
                
                luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
                luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
                luaMenu.panelparrent.Paint = function(this, w, h) end
                curent_panel = nil
            end)
            return 
        end
        some_size_x = luaMenu.panelparrent:GetWide()
        some_size_y = luaMenu.panelparrent:GetTall()
        some_coordinates_x = luaMenu.panelparrent:GetX()
        luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
            luaMenu.panelparrent:Remove()
            luaMenu.panelparrent = nil
            luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
            
            luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
            luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
            luaMenu.panelparrent.Paint = function(this, w, h) end
            btn.Func(luaMenu,luaMenu.panelparrent)
            curent_panel = string.lower(strTitle)
        end)
		for i = 1, 3 do
			surface.PlaySound("cool-click.mp3")
		end
    end

    function btn:Think()
        local isHovered = self:IsHovered() or (IsValid(self:GetChild(0)) and self:GetChild(0):IsHovered()) or (IsValid(self:GetChild(0)) and IsValid(self:GetChild(0):GetChild(0)) and self:GetChild(0):GetChild(0):IsHovered())

        if isHovered and not self.WasHovered then
            surface.PlaySound("cool-hover.mp3")
        end
        self.WasHovered = isHovered

        self.HoverLerp = LerpFT(0.2, self.HoverLerp or 0, isHovered and 1 or 0)

        local v = self.HoverLerp
        
        if self.IsRainbow then
            self.RainbowTime = (self.RainbowTime or 0) + FrameTime()
            local hue = (self.RainbowTime * 0.50) % 1
            local rainbowColor = HSVToColor(hue * 360, 1, 1)
            self:SetTextColor(rainbowColor:Lerp(red_select, v * 0.5))
        else
            self:SetTextColor(self.RColor:Lerp(red_select, v))
        end

        local targetText = isHovered and string.upper(strTitle) or strTitle
        local crw = self:GetText()

        if (crw ~= targetText) or (curent_panel == string.lower(strTitle)) then
            local ntxt = ""
            local will_text = (curent_panel == string.lower(strTitle) and not strTitle == 'Traitor Role') and '[ '..string.upper(strTitle)..' ]' or strTitle
            for i = 1, #will_text do
                local char = will_text:sub(i, i)
                if i <= math.ceil(#will_text * v) then
                    ntxt = ntxt .. string.upper(char)
                else
                    ntxt = ntxt .. char
                end
            end
            if self:GetText() ~= ntxt then
                self:SetText(ntxt)
            end
        end
        self:SizeToContents()
    end
end

function PANEL:Close()
    if IsValid(self.previewModel) and IsValid(self.previewModel.Entity) then
        CleanupPreviewAccessories(self.previewModel.Entity)
    end
    if IsValid(self.previewHolder) then
        self.previewHolder.AppearanceFollow = false
        self.previewHolder:MoveTo(self.previewHolder.TargetX or self.previewHolder:GetX(), self.previewHolder.ClosedY or ScrH(), appearance_preview.exit_time, 0, appearance_preview.exit_delay)
        self.previewHolder:AlphaTo(0, appearance_preview.exit_time * 0.75, appearance_preview.exit_delay)
    end
    if IsValid(self.playerInfoPanel) then
        self.playerInfoPanel:AlphaTo(0, appearance_preview.exit_time * 0.75, appearance_preview.exit_delay)
    end
    self:AlphaTo( 0, appearance_preview.exit_time, 0, function() if IsValid(self) then self:Remove() end end)
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
end

vgui.Register( "ZMainMenu", PANEL, "ZFrame" )

hook.Add("OnPauseMenuShow","OpenMainMenu",function()
    local run = hook.Run("OnShowZCityPause")
    if run != nil then
        return run
    end

    if MainMenu and IsValid(MainMenu) then
        MainMenu:Close()
        MainMenu = nil
        return false
    end

    MainMenu = vgui.Create("ZMainMenu")
    MainMenu:MakePopup()
    return false
end)

local EXIT_PANEL = {}

local ex_clr_bg    = Color(10, 10, 19, 245)
local ex_clr_red   = Color(192, 0, 0)
local ex_clr_white = Color(225, 225, 225)
local ex_clr_gray  = Color(140, 140, 140)
local ex_clr_line  = Color(107, 107, 107, 40)
local ex_grad_l = surface.GetTextureID("vgui/gradient-l")
local ex_grad_d = surface.GetTextureID("vgui/gradient-d")

local GLITCH_SLICES    = 40
local GLITCH_LERP      = 0.08
local GLITCH_MAX_SHIFT = 30
local GLITCH_TEXT_JIT  = 20

local GLITCH_SOUND_PATH    = "rem_seizure.ogg"
local GLITCH_SOUND_VOLUME  = 0.88
local GLITCH_SOUND_LERP    = 0.08
local GLITCH_SOUND_CUTOFF  = 0.002

function EXIT_PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:SetBorder(false)
    self:SetColorBG(ex_clr_bg)
    self:ShowCloseButton(false)
    self:SetAlpha(0)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self:MakePopup()

    self.AnimTime = 0
    self.OnConfirm = nil
    self.EscPressed = false
    self.ButtonAnim = 0
    self.Closing = false

    self.GlitchAmount = 0
    self.GlitchSeed = math.random(1, 9999)
    self.GlitchSlices = {}
    for i = 1, GLITCH_SLICES do
        self.GlitchSlices[i] = {
            y = 0, h = 0, offset = 0,
            r = 0, g = 0, b = 0, a = 0,
            active = false
        }
    end

    self.GlitchSound = nil
    self.GlitchSoundVolume = 0
    self.GlitchSoundStarted = false

    local parentMenu = self

    local btnW = MenuUnit(180)
    local btnH = MenuUnit(45)
    local spacing = MenuUnit(20)
    local totalW = btnW * 2 + spacing
    local startX = (ScrW() - totalW) * 0.5
    local btnY = ScrH() * 0.5 + MenuUnit(50)

    local yesBtn = vgui.Create("DButton", self)
    yesBtn:SetSize(btnW, btnH)
    yesBtn:SetPos(startX, btnY)
    yesBtn:SetText("")
    yesBtn.HoverLerp = 0
    yesBtn.Paint = function(this, w, h)
        local hovered = this:IsHovered()
        this.HoverLerp = LerpFT(0.2, this.HoverLerp or 0, hovered and 1 or 0)
        local v = this.HoverLerp

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(MenuUnit(2), MenuUnit(2), w, h)

        surface.SetDrawColor(Color(120, 0, 0, 220):Lerp(Color(192, 0, 0, 255), v))
        surface.DrawRect(MenuUnit(1), MenuUnit(1), w - MenuUnit(2), h - MenuUnit(2))

        if v > 0.05 then
            local shift = v * MenuUnit(3)
            draw.SimpleText("YES", "ZC_MM_Buttons", w * 0.5 - shift, h * 0.5, Color(255, 40, 40, 180 * v), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("YES", "ZC_MM_Buttons", w * 0.5 + shift, h * 0.5, Color(40, 200, 255, 180 * v), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(ex_clr_red:Lerp(ex_clr_white, v))
        surface.DrawOutlinedRect(0, 0, w, h, MenuUnit(1))

        draw.SimpleText("YES", "ZC_MM_Buttons", w * 0.5, h * 0.5, ex_clr_white:Lerp(color_white, v), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function yesBtn:DoClick()
        surface.PlaySound("cool-click.mp3")
        local cb = parentMenu.OnConfirm
        parentMenu.OnConfirm = nil
        if cb then cb(true) end
        parentMenu:Close()
    end

    self.YesButton = yesBtn

    local noBtn = vgui.Create("DButton", self)
    noBtn:SetSize(btnW, btnH)
    noBtn:SetPos(startX + btnW + spacing, btnY)
    noBtn:SetText("")
    noBtn.HoverLerp = 0
    noBtn.Paint = function(this, w, h)
        local hovered = this:IsHovered()
        this.HoverLerp = LerpFT(0.2, this.HoverLerp or 0, hovered and 1 or 0)
        local v = this.HoverLerp

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(MenuUnit(2), MenuUnit(2), w, h)

        surface.SetDrawColor(Color(30, 30, 30, 220):Lerp(Color(60, 60, 60, 255), v))
        surface.DrawRect(MenuUnit(1), MenuUnit(1), w - MenuUnit(2), h - MenuUnit(2))

        surface.SetDrawColor(ex_clr_gray:Lerp(ex_clr_white, v))
        surface.DrawOutlinedRect(0, 0, w, h, MenuUnit(1))

        draw.SimpleText("NO", "ZC_MM_Buttons", w * 0.5, h * 0.5, ex_clr_white:Lerp(color_white, v), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function noBtn:DoClick()
        surface.PlaySound("cool-click.mp3")
        local cb = parentMenu.OnConfirm
        parentMenu.OnConfirm = nil
        if cb then cb(false) end
        parentMenu:Close()
    end
end

function EXIT_PANEL:Think()
    self.AnimTime = (self.AnimTime or 0) + FrameTime()
    self.ButtonAnim = LerpFT(0.1, self.ButtonAnim or 0, 1)

    local yesHovered = false
    local yesBtn = self.YesButton
    if IsValid(yesBtn) then
        yesHovered = yesBtn:IsHovered()
    end

    local targetGlitch = yesHovered and 1 or 0
    self.GlitchAmount = LerpFT(GLITCH_LERP, self.GlitchAmount or 0, targetGlitch)

    if self.GlitchAmount > 0.005 then
        local t = RealTime()
        local intensity = self.GlitchAmount
        local seed = self.GlitchSeed

        for i, slice in ipairs(self.GlitchSlices) do
            local pulse = math.sin(t * (6 + i * 0.7) + seed + i) * 0.5 + 0.5
            slice.active = (pulse * intensity) > 0.35

            if slice.active then
                slice.y = math.Rand(0, 1)
                slice.h = math.Rand(0.005, 0.045) * (0.5 + intensity)
                slice.offset = math.Rand(-1, 1) * MenuUnit(GLITCH_MAX_SHIFT) * intensity
                slice.r = math.random(180, 255)
                slice.g = math.random(0, 60)
                slice.b = math.random(0, 60)
                slice.a = math.random(80, 200) * intensity
            else
                slice.a = 0
            end
        end
    else
        for i, slice in ipairs(self.GlitchSlices) do
            slice.a = 0
        end
    end

    self:UpdateGlitchSound()

    if input.IsKeyDown(KEY_ESCAPE) and not self.EscPressed then
        self.EscPressed = true
        local cb = self.OnConfirm
        self.OnConfirm = nil
        if cb then cb(false) end
        self:Close()
    elseif not input.IsKeyDown(KEY_ESCAPE) then
        self.EscPressed = false
    end
end

function EXIT_PANEL:UpdateGlitchSound()
    local targetVol = (self.GlitchAmount or 0) * GLITCH_SOUND_VOLUME

    if targetVol < 0.001 and not self.GlitchSound then
        return
    end

    if not self.GlitchSound and targetVol > 0.001 then
        self.GlitchSound = CreateSound(LocalPlayer(), GLITCH_SOUND_PATH)
        if self.GlitchSound then
            self.GlitchSound:SetSoundLevel(0)
            self.GlitchSound:Play()
            self.GlitchSoundStarted = true
            self.GlitchSoundVolume = 0
        end
    end

    if not self.GlitchSound then return end

    self.GlitchSoundVolume = LerpFT(GLITCH_SOUND_LERP, self.GlitchSoundVolume or 0, targetVol)

    self.GlitchSound:ChangeVolume(self.GlitchSoundVolume, 0)

    if self.GlitchSoundVolume < GLITCH_SOUND_CUTOFF and targetVol < 0.001 then
        self.GlitchSound:Stop()
        self.GlitchSound = nil
        self.GlitchSoundStarted = false
        self.GlitchSoundVolume = 0
    end
end

function EXIT_PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawRect(0, 0, w, h)

    local panelW = MenuUnit(560)
    local panelH = MenuUnit(240)
    local px = (w - panelW) * 0.5
    local py = (h - panelH) * 0.5

    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(px + MenuUnit(4), py + MenuUnit(4), panelW, panelH)

    surface.SetDrawColor(ex_clr_bg)
    surface.DrawRect(px, py, panelW, panelH)

    surface.SetDrawColor(ex_clr_gray)
    surface.DrawOutlinedRect(px, py, panelW, panelH, MenuUnit(1))

    local glitch = self.GlitchAmount or 0
    if glitch > 0.01 then
        local t = RealTime()
        local seed = self.GlitchSeed

        DisableClipping(true)

        for _, slice in ipairs(self.GlitchSlices) do
            if slice.a > 0 then
                local sy = py + slice.y * panelH
                local sh = slice.h * panelH
                surface.SetDrawColor(slice.r, slice.g, slice.b, slice.a)
                surface.DrawRect(px + slice.offset, sy, panelW, sh)

                surface.SetDrawColor(255, 60, 60, slice.a * 0.7)
                surface.DrawRect(px + slice.offset, sy, panelW, ScreenScale(1))
            end
        end

        local shift = glitch * MenuUnit(GLITCH_TEXT_JIT)
        local jitterX = math.sin(t * 30 + seed) * shift
        local jitterY = math.cos(t * 25 + seed * 1.7) * shift

        local textX = w * 0.5 + jitterX
        local textY = py + MenuUnit(100) + jitterY

        draw.SimpleText("Do you really want to leave?", "ZCity_Small", textX - shift, textY, Color(255, 30, 30, 160 * glitch), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Do you really want to leave?", "ZCity_Small", textX + shift, textY, Color(30, 200, 255, 160 * glitch), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        DisableClipping(false)
    end

    draw.SimpleText("Do you really want to leave?", "ZCity_Small", w * 0.5, py + MenuUnit(100), ex_clr_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if glitch > 0.05 then
        local frameOffset = math.sin(RealTime() * 40 + self.GlitchSeed) * MenuUnit(4) * glitch
        surface.SetDrawColor(255, 0, 0, 200 * glitch)
        surface.DrawOutlinedRect(px + frameOffset, py, panelW, panelH, MenuUnit(1))
        surface.SetDrawColor(0, 180, 255, 200 * glitch)
        surface.DrawOutlinedRect(px - frameOffset, py, panelW, panelH, MenuUnit(1))
    end
end

function EXIT_PANEL:Close()
    if self.Closing then return end
    self.Closing = true
    self.GlitchAmount = 0

    if self.GlitchSound then
        self.GlitchSound:Stop()
        self.GlitchSound = nil
    end
    self.GlitchSoundStarted = false
    self.GlitchSoundVolume = 0

    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
    self:AlphaTo(0, 0.15, 0, function()
        if IsValid(self) then self:Remove() end
        if hg.ExitConfirmMenu == self then
            hg.ExitConfirmMenu = nil
        end
    end)
end

vgui.Register("ZExitConfirm", EXIT_PANEL, "ZFrame")

function hg.ShowExitConfirm(onConfirm)
    if IsValid(hg.ExitConfirmMenu) then return end
    local menu = vgui.Create("ZExitConfirm")
    hg.ExitConfirmMenu = menu
    menu.OnConfirm = function(confirmed)
        if onConfirm then onConfirm(confirmed) end
    end
    return menu
end