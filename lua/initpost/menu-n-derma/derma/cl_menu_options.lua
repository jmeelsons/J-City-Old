hg.settings = hg.settings or {}
hg.settings.tbl = hg.settings.tbl or {}

function hg.settings:AddOpt( strCategory, strConVar, strTitle, bDecimals, bString, category)
    self.tbl[strCategory] = self.tbl[strCategory] or {}
    self.tbl[strCategory][strConVar] = { strCategory, strConVar, strTitle, bDecimals or false, bString or false, category }
end
local hg_firstperson_death = CreateClientConVar("hg_firstperson_death", "0", true, false, "Toggle first-person death camera view", 0, 1)
local hg_font = CreateClientConVar("hg_font", "Bahnschrift", true, false, "change every text font to selected because ui customization is cool")
local hg_attachment_draw_distance = CreateClientConVar("hg_attachment_draw_distance", 512, true, nil, "distance to draw attachments", 0, 4096)
local clr_1 = Color(255,255,255,104)
local clr_2 = Color(122,122,122,104)
local clr_3 = Color(28,28,28)
local clr_4 = Color(0, 0, 0, 30)
local clr_5 = Color(30, 29, 29, 30)
local clr_6 = Color(255, 255, 255, 100)
local clr_7 = Color(255, 255, 255, 200)
local clr_8 = Color(70, 130, 180)
xbars = 17
ybars = 30

gradient_l = Material("vgui/gradient-l")

blur = Material("pp/blurscreen")
blur2 = Material("effects/shaders/zb_blur" )
local sw, sh = ScrW(), ScrH()

local font = function() -- hg_coolvetica:GetBool() and "Coolvetica" or "Bahnschrift"
    local usefont = "Bahnschrift"

    if hg_font:GetString() != "" then
        usefont = hg_font:GetString()
    end

    return usefont
end

surface.CreateFont("ZCity_setiings_tiny", {
	font = font(),
    extended = true,
	size = ScreenScale(7),
	weight = 100
})

surface.CreateFont("ZCity_setiings_fine", {
	font = font(),
    extended = true,
	size = ScreenScale(10),
	weight = 100
})

surface.CreateFont("ZCity_setiings_category", {
	font = font(),
    extended = true,
	size = ScreenScale(15),
	weight = 100
})

surface.CreateFont("ZCity_search_font", {
    font = font(),
    extended = true,
    size = ScreenScale(12),
    weight = 100
})


--hg.settings:AddOpt("Gameplay","hg_old_notificate", "Old Notifications") Не юзается
hg.settings:AddOpt("Gameplay","hg_showthoughts", "Show thoughts")
hg.settings:AddOpt("Gameplay","hg_hints", "Show hints")
hg.settings:AddOpt("Gameplay","hg_gary", "HG GARY")
hg.settings:AddOpt("Gameplay","hg_deathfadeout", "Death fade out")
hg.settings:AddOpt("Gameplay","zb_pluvtown_enabled","PluvTown")
hg.settings:AddOpt("Gameplay","hg_spectator_flashlight", "Spectator Flashlights")

if LocalPlayer():IsAdmin() then
    hg.settings:AddOpt("Debug","hg_show_hitposmuzzle", "Show weapon hitpos")
    hg.settings:AddOpt("Debug","hg_setzoompos", "Edit weapon zoompos, check console for results")
    hg.settings:AddOpt("Debug","hg_show_hitbox", "Show hitboxes")
    hg.settings:AddOpt("View","hg_gun_cam", "Gun camera (WIP Admin only)")
end

hg.settings:AddOpt("Optimization","hg_potatopc", "Potato PC Mode")
hg.settings:AddOpt("Optimization","hg_anims_draw_distance", "Animations Draw Distance", true, nil, "int")
hg.settings:AddOpt("Optimization","hg_anim_fps", "Animations FPS", nil, nil, "int")
hg.settings:AddOpt("Optimization","hg_attachment_draw_distance", "Attachment Draw Distance", true, nil, "int")
hg.settings:AddOpt("Optimization","hg_maxsmoketrails", "Maximum Smoke Trails", nil, nil, "int")
hg.settings:AddOpt("Optimization","hg_tpik_distance", "TPIK Render Distance", true, nil, "int")

hg.settings:AddOpt("Blood","hg_blood_draw_distance", "Blood Draw Distance")
hg.settings:AddOpt("Blood","hg_blood_fps", "Blood FPS")
hg.settings:AddOpt("Blood","hg_blood_sprites", "Blood Sprites (DISABLED FOR EVERYONE)")
hg.settings:AddOpt("Blood","hg_old_blood", "Old blood")

hg.settings:AddOpt("UI","hg_font", "Change Custom Font", false, true)
--hg.settings:AddOpt("UI","hg_watermark", "Enable/Disable Server watermark")
hg.settings:AddOpt("UI","zb_radial_dance", "Quick Dance Radial Option")
hg.settings:AddOpt("UI","hg_shit_sounds", "Radial Menu Sounds")
hg.settings:AddOpt("UI","zmeyka_legs", "Zmeyka Legs")

hg.settings:AddOpt("Weapons","hg_weaponshotblur_enable", "Shooting Blur")
hg.settings:AddOpt("Weapons","hg_dynamic_mags", "Dynamic Ammo Inspect")
hg.settings:AddOpt("Weapons","hg_zoomsensitivity", "Scope sensitivity")
hg.settings:AddOpt("Weapons","hg_highpitchgunfire", "Toggle high pitched gunfire sounds inside buildings")

hg.settings:AddOpt("View","hg_firstperson_death", "First-Person Death")
hg.settings:AddOpt("View","hg_fov", "Field Of View")
hg.settings:AddOpt("View","hg_newspectate", "Smooth Spectator Camera")
hg.settings:AddOpt("View","hg_cshs_fake", "C'sHS Ragdoll Camera")
hg.settings:AddOpt("View","hg_nofovzoom", "Disable/Enable FOV Zoom")
hg.settings:AddOpt("View","hg_realismcam", "Realism camera (shitty)")
hg.settings:AddOpt("View","hg_gopro", "GoPro camera")
hg.settings:AddOpt("View","hg_newfakecam", "New fake camera")
hg.settings:AddOpt("View","hg_leancam_mul", "Lean camera mul", true, nil, "int")
--hg_hints
--hg_leancam_mul
  --hg_newfakecam
hg.settings:AddOpt("Sound","hg_dmusic", "Dynamic Music")
hg.settings:AddOpt("Sound","hg_quietshots", "Enable/Disable Quietshoot Sounds")
hg.settings:AddOpt("Sound","hg_quietshots", "Enable/Disable Quietshoot Sounds")


hg.settings:AddOpt("Binds","FAKE", "Lay down/Get up.")
hg.settings:AddOpt("Binds","KICK", "To kick it with one\'s own foot")
hg.settings:AddOpt("Binds","DROP", "To drop a weapon or item")
hg.settings:AddOpt("Binds","HOLD BREATH", "To hold your breath while aiming")
hg.settings:AddOpt("Binds","TOGGLE LASER", "Toggle weapon laser")
hg.settings:AddOpt("Binds","SUICIDE", "i have no words...")
hg.settings:AddOpt("Binds","ALT LEFT", "To lean to the left")
hg.settings:AddOpt("Binds","ALT RIGHT", "To lean to the right")
hg.settings:AddOpt("Binds","LOOK", "To take a look around")
--hg.settings:AddOpt("Binds","CLOSE BUTTON", "Close button for UI's")
--hg.settings:AddOpt("Binds","HEAVY ATTACK", "Heavy attack for melee weapons [ WORKS NOT ON EVERY MELEE! ]")


function hg.CreateCategory(ctgName, ParentPanel, yPos)
    local pppanel = vgui.Create('DPanel', ParentPanel)
    pppanel:SetSize(ParentPanel:GetWide() / 1.05, ParentPanel:GetTall() * 0.07)
    pppanel:SetPos(ParentPanel:GetWide() / 2 - pppanel:GetWide() / 2, yPos)
    --pppanel:SetText(ctgName)
    pppanel.Paint = function(self,w,h)
        surface.SetDrawColor(60, 60, 60, 145)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(42, 42, 42, 184)
        surface.DrawRect(0, h-5, w, 5)

        draw.SimpleText(ctgName, 'ZCity_setiings_category', w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end



    return pppanel
end

function hg.GetConVarType(convar)
    local stringv = convar:GetString()
    local floatVal = convar:GetFloat()
    local intVal = convar:GetInt()
    local boolVal = convar:GetBool()

    if (stringv == '0' and not boolVal) or (stringv == '1' and boolVal) then
        return 'bool'
    end

    if tonumber(stringv) and math.floor(stringv) == floatVal then
        if intVal == floatVal then
            return "int"
        end
    end

    return "string"
end

local function SetConVarValue(convar, value)
    if not convar then
        return
    end

    local name = convar.GetName and convar:GetName()
    if not name or name == "" then
        return
    end

    if isbool(value) then
        RunConsoleCommand(name, value and "1" or "0")
        return
    end

    RunConsoleCommand(name, tostring(value))
end

function hg.CreateBindButton(buttonData, convarName, ParentPanel, yPos)
    local bindName = buttonData[2]
    if not hg.Binds or not hg.Binds.CurrentBinds or not hg.Binds.CurrentBinds[bindName] then
        return
    end

    local pppanel = vgui.Create('DPanel', ParentPanel)
    pppanel:SetSize(ParentPanel:GetWide()/1.05, ParentPanel:GetTall()/15)
    pppanel:SetPos(ParentPanel:GetWide()/2 - pppanel:GetWide()/2, yPos)

    surface.SetFont('ZCity_setiings_fine')
    local w2, h2 = surface.GetTextSize(buttonData[3])

    local keyCode = hg.Binds.CurrentBinds[bindName][1]
    local currentBind = (keyCode and keyCode ~= -999 and input.GetKeyName(keyCode)) and input.GetKeyName(keyCode):upper() or "NO"

    local isWaiting = false

    pppanel.Paint = function(self, w, h)
        surface.SetDrawColor(43, 43, 43, 145)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(47, 47, 47, 145)
        surface.DrawRect(0, h-3, w, 3)
        draw.SimpleText(buttonData[2], 'ZCity_setiings_fine', 30, h/2 - h2/2.5, clr_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(buttonData[3], 'ZCity_setiings_tiny', 30, h/2 + h2/2, clr_2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local bindButton = vgui.Create('DButton', pppanel)
    bindButton:SetSize(pppanel:GetTall() / 2, pppanel:GetTall() / 2)
    bindButton:SetPos(pppanel:GetWide() - bindButton:GetWide() - 25, pppanel:GetTall()/2 - bindButton:GetTall()/2)
    bindButton:SetText("")

    bindButton.Paint = function(self, w, h)
        local col = isWaiting and Color(80, 180, 80, 0) or Color(50, 50, 50, 0)

        surface.SetDrawColor(clr_3)
        draw.RoundedBox(4, 0, 0, w, h, clr_3)

        surface.SetDrawColor(col)
        draw.RoundedBox(4, 2, 2, w-4, h-4, col)

        local txt = isWaiting and "?" or currentBind
        draw.SimpleText(txt, 'ZCity_setiings_fine', w/2, h/2, clr_7, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    bindButton.DoClick = function()
        isWaiting = true
        bindButton:RequestFocus()
    end

    bindButton.OnKeyCodePressed = function(self, keyCode)
        if not isWaiting then return end

        local keyName = input.GetKeyName(keyCode)
        if keyName and keyName ~= "None" then
            currentBind = keyName:upper()
            hg.Binds.CurrentBinds[bindName] = {keyCode}
            hg.Binds.SaveThem()
        end

        isWaiting = false
        bindButton:KillFocus()
    end

    bindButton.OnLoseFocus = function()
        isWaiting = false
    end

    local clearButton = vgui.Create('DButton', pppanel)
    clearButton:SetSize(pppanel:GetTall() / 2, pppanel:GetTall() / 2)
    clearButton:SetPos(pppanel:GetWide() - bindButton:GetWide()*2 - 35, pppanel:GetTall()/2 - clearButton:GetTall()/2)
    clearButton:SetText("")

    clearButton.Paint = function(self, w, h)
        surface.SetDrawColor(clr_3)
        draw.RoundedBox(4, 0, 0, w, h, clr_3)
        draw.SimpleText("×", 'ZCity_setiings_fine', w/2, h/2, Color(200, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    clearButton.DoClick = function()
        currentBind = "NO"
        hg.Binds.CurrentBinds[bindName] = {-999}
        hg.Binds.SaveThem()
        surface.PlaySound('glide/headlights_on.wav')
    end
--[[
    local cmdEntry = vgui.Create('DTextEntry', pppanel)
    cmdEntry:SetSize(pppanel:GetWide() / 3.5, pppanel:GetTall() / 2)
    cmdEntry:SetPos(pppanel:GetWide() - bindButton:GetWide() * 2 - 35 - cmdEntry:GetWide() - 10, pppanel:GetTall()/2 - cmdEntry:GetTall()/2)
    cmdEntry:SetFont('ZCity_setiings_tiny')
    cmdEntry:SetText(hg.Binds:GetBindCommand(bindName) or "")
    cmdEntry:SetUpdateOnType(true)

    cmdEntry.Paint = function(self, w, h)
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(60, 60, 60, 255)
        surface.DrawOutlinedRect(0, 0, w, h)

        if self:GetText() == "" and not self:HasFocus() then
            draw.SimpleText("command...", 'ZCity_setiings_tiny', 6, h/2, Color(150, 150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        self:DrawTextEntryText(color_white, clr_8, color_white)
    end

    cmdEntry.OnValueChange = function(self, val)
        hg.Binds:SetBindCommand(bindName, val)
        hg.Binds.SaveThem()
    end
--]]
    return pppanel
end

function hg.CreateButton(buttonData, convarName, ParentPanel, yPos)
    if buttonData[1]:lower() == 'binds' then return hg.CreateBindButton(buttonData, convarName, ParentPanel, yPos,isBind) end
    local convar = GetConVar(convarName)

    if not convar then 
        return 
    end
    local pppanel = vgui.Create('DPanel', ParentPanel)
    pppanel:SetSize(ParentPanel:GetWide()/1.05, ParentPanel:GetTall()/15)
    pppanel:SetPos(ParentPanel:GetWide()/2-pppanel:GetWide()/2, yPos)
    
    surface.SetFont('ZCity_setiings_fine')
    local width2, height2 = surface.GetTextSize(buttonData[3])
    
    convarType = buttonData[6] or hg.GetConVarType(convar)
    pppanel.Paint = function(self,w,h)
        surface.SetDrawColor(43, 43, 43, 145)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(47, 47, 47, 145)
        surface.DrawRect(0, h-3, w, 3)

        draw.SimpleText(buttonData[3], 'ZCity_setiings_fine', 30, h / 2 -height2/2.5, clr_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(convar:GetHelpText(), 'ZCity_setiings_tiny', 30, h / 2+height2/2, clr_2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if convarType == 'bool' then
        local toggle = vgui.Create('DButton', pppanel)
        toggle:SetSize(pppanel:GetWide() / 18, pppanel:GetTall() / 2)

        
        toggle:SetPos(pppanel:GetWide() - toggle:GetWide()*1.4 - pppanel:GetWide() / 20, pppanel:GetTall() / 2 - toggle:GetTall() / 2)
        toggle:SetText('')
        
        local animProgress = convar:GetBool() and 1 or 0
        local targetProgress = animProgress
        
        function toggle:Paint(w, h)
            if animProgress ~= targetProgress then
                animProgress = Lerp(FrameTime() * 8, animProgress, targetProgress)
            end
            
            local bgColor = Color(
                Lerp(animProgress, 180, 80),  
                Lerp(animProgress, 30, 120),  
                Lerp(animProgress, 30, 50)   
            )
            
            local shadowColor = Color(0, 0, 0, Lerp(animProgress, 150, 40))
            surface.SetDrawColor(clr_3)
            draw.RoundedBox(0, 0, 0, w, h, clr_3)
            
            surface.SetDrawColor(clr_5)
            draw.RoundedBox(0, 2, 2, w - 4, h - 4, clr_4)
            
            local slsize = h - 12
            local slPos = Lerp(animProgress, 6, w - slsize - 6)
            surface.SetDrawColor(bgColor)
            draw.RoundedBox(0, slPos, 6, slsize, slsize, bgColor)
            surface.SetDrawColor(shadowColor)
            surface.DrawRect(slPos, slsize+4, slsize, 3)
    
            surface.SetDrawColor(clr_6)
        end
        
        function toggle:DoClick()
            if convar then
                local newValue = not convar:GetBool()
                SetConVarValue(convar, newValue)

                surface.PlaySound('glide/headlights_on.wav')
                targetProgress = newValue and 1 or 0
            end
        end
        
    elseif convarType == 'int' then
        local slider = vgui.Create('DNumSlider', pppanel)
        slider:SetSize(280, 30)
        slider:SetPos(pppanel:GetWide() - 300, pppanel:GetTall() / 2 - 15)
        slider:SetText('')
        
        local min = convar:GetMin() or 0
        local max = convar:GetMax() or 100
        local decimals = buttonData[4] and 2 or 0
        
        slider:SetMin(min)
        slider:SetMax(max)
        slider:SetDecimals(decimals)
        slider:SetValue(decimals > 0 and convar:GetFloat() or convar:GetInt())
        
        function slider:OnValueChanged(val)
            if convar then
                SetConVarValue(convar, decimals > 0 and math.Round(val, decimals) or math.Round(val))
            end
        end
        
        local valueLabel = vgui.Create('DLabel', pppanel)
        valueLabel:SetPos(pppanel:GetWide() - 350, pppanel:GetTall() / 2 - 8)
        valueLabel:SetSize(50, 20)
        valueLabel:SetText(convar:GetInt())
        valueLabel:SetTextColor(clr_7)
        valueLabel:SetFont('ZCity_setiings_tiny')
        
        slider.Think = function()
            if convar then
                valueLabel:SetText(convar:GetInt())
            end
        end
        
    elseif convarType == 'string' then
        local textEntry = vgui.Create('DTextEntry', pppanel)
        textEntry:SetSize(pppanel:GetWide()/8, pppanel:GetTall()/2)
        textEntry:SetPos(pppanel:GetWide()-pppanel:GetWide()/8-20, pppanel:GetTall()/2-textEntry:GetTall()/2)
        textEntry:SetText(convar:GetString())
        textEntry:SetUpdateOnType(true) 
        textEntry:SetFont('ZCity_Tiny')
        
    
        textEntry.Paint = function(self, w, h)
            surface.SetDrawColor(30, 30, 30, 255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(60, 60, 60, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
            
            self:DrawTextEntryText(color_white, clr_8, color_white)
        end
        
        function textEntry:OnValueChange(val)
            if convar then
                SetConVarValue(convar, val)
            end
        end
    end
    
    return pppanel
end

function hg.DrawSettings(ParentPanel)
    ParentPanel:SetAlpha(0)
    ParentPanel.Paint = function(self,w,h)
        surface.SetDrawColor(28,28,28,255)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(107, 107, 107,20)

        for i = 1, (ybars + 1) do
            surface.DrawRect((sw / ybars) * i - (CurTime() * 30 % (sw / ybars)), 0, ScreenScale(1), sh)
        end

        for i = 1, (xbars + 1) do
            surface.DrawRect(0, (sh / xbars) * (i - 1) + (CurTime() * 30 % (sh / xbars)), sw, ScreenScale(1))
        end

        local border_size = ScreenScale(2)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(gradient_l)
        surface.DrawTexturedRect(0, 0, border_size, sh)
        surface.SetMaterial(blur)
        surface.SetDrawColor(28,28,28,208)
        surface.DrawRect(0, 0, w, h)
    end
    hg.DrawBlur(ParentPanel, 5)
    ParentPanel:AlphaTo(255,0.15,0)
    
    local pppanel3 = vgui.Create('DScrollPanel', ParentPanel)
    pppanel3:SetSize(ParentPanel:GetWide(), ParentPanel:GetTall())
    pppanel3:SetPos(0,0)
    pppanel3.Paint = function() end

    local searchPanel = vgui.Create('DPanel', pppanel3)
    searchPanel:SetSize(pppanel3:GetWide() / 2, pppanel3:GetTall() * 0.06)
    searchPanel:SetPos(pppanel3:GetWide() / 4, pppanel3:GetTall() / 100)
    searchPanel.Paint = function(self,w,h)
        surface.SetDrawColor(60,60,60,145)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(42, 42, 42, 184)
        surface.DrawRect(0, h-2, w, 2)
    end

    local searchEntry = vgui.Create('DTextEntry', searchPanel)
    searchEntry:SetSize(searchPanel:GetWide() - 20, searchPanel:GetTall() - 10)
    searchEntry:SetPos(10, 5)
    searchEntry:SetText("")
    searchEntry:SetFont('ZCity_search_font')
    searchEntry:SetTextColor(Color(200, 200, 200, 200))
    
    local searchPlaceholder = "Search..."
    
    searchEntry.Paint = function(self, w, h)
        surface.SetDrawColor(30, 30, 30, 200)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if self:GetText() == "" and not self:HasFocus() then
            draw.SimpleText(searchPlaceholder, 'ZCity_search_font', 10, h/2, Color(150, 150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        self:DrawTextEntryText(color_white, clr_8, color_white)
    end

    local settingPanels = {}
    
    local function rebuildSettings(searchText)
        for _, panel in ipairs(settingPanels) do
            if IsValid(panel) then
                panel:Remove()
            end
        end
        settingPanels = {}
        
        local yOffset = searchPanel:GetTall() + pppanel3:GetTall() / 100 + 12
        
        for categoryName, categoryTable in pairs(hg.settings.tbl) do
            local matchingItems = {}

            for convarName, settingData in pairs(categoryTable) do
                local title = settingData[3] or ""
                local categoryNameLower = categoryName:lower()
                local titleLower = title:lower()
                local searchLower = searchText:lower()
                
                if searchText == "" or 
                   string.find(categoryNameLower, searchLower, 1, true) or 
                   string.find(titleLower, searchLower, 1, true) then
                    table.insert(matchingItems, {convarName = convarName, settingData = settingData})
                end
            end

            if #matchingItems > 0 then
                local category = hg.CreateCategory(categoryName, pppanel3, yOffset)
                table.insert(settingPanels, category)
                yOffset = yOffset + category:GetTall() + 12
                
                for _, item in ipairs(matchingItems) do
                    local vbv = hg.CreateButton(item.settingData, item.convarName, pppanel3, yOffset)
                    if IsValid(vbv) then
                        table.insert(settingPanels, vbv)
                        yOffset = yOffset + vbv:GetTall() + 12
                    end
                end
            end
        end

        local pppanel23 = vgui.Create('DPanel', pppanel3)
        pppanel23:SetSize(0, 0)
        pppanel23:SetPos(0, yOffset + 12)
        table.insert(settingPanels, pppanel23)
    end

    local searchTimer = 0
    searchEntry.OnValueChange = function(self, val)
        searchTimer = CurTime() + 0.3
    end

    pppanel3.Think = function()
        if searchTimer > 0 and CurTime() >= searchTimer and IsValid(pppanel3) then
            searchTimer = 0
            if IsValid(searchEntry) then
                rebuildSettings(searchEntry:GetText())
            end
        end
    end
    -- NO BOGLER's HERE... 🗣️
    timer.Simple(0.1, function()
        if IsValid(searchEntry) and IsValid(pppanel3) then
            rebuildSettings("")
        end
    end)
end