hg = hg or {}

hg.traitor_role = hg.traitor_role or {}
hg.traitor_role.tbl = hg.traitor_role.tbl or {}

local APmodule = hg.Appearance
clr_5 = Color(30, 29, 29, 30)
local sizeX, sizeY = ScrW(), ScrH()

gradient_l = gradient_l or Material("vgui/gradient-l")
gradient_r = gradient_r or Material("vgui/gradient-r")
blur       = blur       or Material("pp/blurscreen")

hg._traitorLoadoutPooled = hg._traitorLoadoutPooled or (engine.ActiveGamemode() == "sandbox")

local NET_TRAITOR_LOADOUT = "HMCD_GetTraitorLadOut"


local function StripFunctions(tbl)
    if type(tbl) ~= "table" then
        return tbl
    end

    local clean = {}
    for k, v in pairs(tbl) do
        if type(v) == "function" then
            -- skip
        elseif type(v) == "table" then
            clean[k] = StripFunctions(v)
        else
            clean[k] = v
        end
    end
    return clean
end

local function SaveLoadout()
    if not file.IsDir("zcity", "DATA") then
        file.CreateDir("zcity")
    end

    local data = util.TableToJSON(selected_things)
    file.Write("zcity/ladout.json", data)

    if not hg._traitorLoadoutPooled then return end

    net.Start(NET_TRAITOR_LOADOUT)
    net.WriteTable(StripFunctions(selected_things))
    net.SendToServer()
end

local function LoadLoadout()
    if not file.IsDir("zcity", "DATA") then
        file.CreateDir("zcity")
    end

    if not file.Exists("zcity/ladout.json", "DATA") then
        return
    end

    local data = file.Read("zcity/ladout.json", "DATA")
    if not data or data == "" then return end

    local loaded = util.JSONToTable(data)
    if not loaded or type(loaded) ~= "table" then return end

    selected_things = loaded

    selected_things.standard = selected_things.standard or {}
    selected_things.soe = selected_things.soe or {}

    selected_things.standard.items = selected_things.standard.items or {}
    selected_things.soe.items = selected_things.soe.items or {}

    selected_things.standard.points = nil
    selected_things.soe.points = nil

    selected_things.standard.traitor_role = selected_things.standard.traitor_role or ""
    selected_things.soe.traitor_role = selected_things.soe.traitor_role or ""
end


selected_things = selected_things or {
    standard = {
        traitor_role = "",
        items = {}
    },
    soe = {
        traitor_role = "",
        items = {}
    }
}

CreateConVar("hg_traitor_mode_s", "presets", {FCVAR_ARCHIVE, FCVAR_USERINFO}, "Last traitor selection mode: presets or loadout")


function ClearPanel(panel)
    if not IsValid(panel) then return end

    local children = panel:GetChildren()
    if not children then return end

    for i = #children, 1, -1 do
        local child = children[i]
        if IsValid(child) then
            child:MoveTo(ScrW(), child:GetY(), 0.5, 0, 3, function()
                child:Remove()
            end)
        end
    end
end

function SelectShit(data, ids)
    local modes = (data.typed == 1 or data.typed == 3) and 'soe' or 'standard'

    if data.typed == 2 or data.typed == 3 then
        -- Selecting a traitor role resets items for that mode.
        if selected_things[modes].traitor_role ~= ids then
            selected_things[modes].traitor_role = ids
            selected_things[modes].items = {}
        end
    elseif data.typed == 1 or data.typed == 4 then
        if not selected_things[modes].traitor_role or selected_things[modes].traitor_role == "" then
            return false, "Select traitor role first"
        end

        selected_things[modes].items = selected_things[modes].items or {}

        if selected_things[modes].items[ids] then
            selected_things[modes].items[ids] = nil
        else
            selected_things[modes].items[ids] = data
        end
    end

    SaveLoadout()
    return true
end


function hg.CreateSelectModeButton(text,pos,parent,outlineRect,colord,func)
    local button = vgui.Create("DButton", parent)
    button:SetText(" ")
    surface.SetFont('HomigradFont')
    local w2,h2 = surface.GetTextSize(text)
    button:SetSize(w2+50, h2+20)
    button:SetPos(pos[1], pos[2])
    button.DoClick = func
    local sizeXX = button:GetWide()-((outlineRect)*4)
    local sizeYY = button:GetTall()-((outlineRect)*4)
    button.Paint = function(self,w,h)
        surface.SetDrawColor( colord)
        surface.DrawOutlinedRect( 0, 0, w2+50, h2+20, outlineRect )
        surface.DrawRect( outlineRect*2, outlineRect*2, sizeXX, sizeYY )
        surface.SetDrawColor( clr_5)

        surface.SetFont('HomigradFont')
        surface.SetTextColor(255, 255, 255, 255)

        local textW, textH = surface.GetTextSize(text)
        local textX = ((w2+50) - w2) / 2
        local textY = ((h2+20) - h2) / 2

        surface.SetTextPos(textX, textY)
        surface.DrawText(text)
    end
    return button
end

local TRAITOR_CATEGORY_ORDER = {
    ALL = 0,
    WEAPON = 1,
    AMMO = 2,
    MELEE = 3,
    MEDICINE = 4,
    POISON = 5,
    TACTICAL = 6,
    THROWABLE = 7,
    EXPLOSIVE = 8
}

local TRAITOR_CATEGORY_DESCRIPTIONS = {
    WEAPON = "A weapon intended for direct combat.",
    AMMO = "Additional ammunition for your selected weapon.",
    MELEE = "A concealable weapon for close-range attacks.",
    MEDICINE = "Medical equipment used to keep yourself or another player alive.",
    POISON = "A covert chemical tool intended to incapacitate or kill a target.",
    TACTICAL = "Special-purpose equipment that provides a tactical advantage.",
    THROWABLE = "A throwable item that activates after being deployed.",
    EXPLOSIVE = "An explosive device capable of damaging players and the environment."
}

local function GetTraitorItemPresentation(data)
    local id = tostring(data.ids or data.func or "")
    local category = string.upper(tostring(data.desc or "ITEM"))
    local description = data.description
    local model = data.preview_model

    local weaponData = weapons.Get(id)
    if weaponData then
        description = description or weaponData.InstructionsBasic or weaponData.Instructions
    end

    local storedEntity = scripted_ents.GetStored(id)
    local entityData = storedEntity and storedEntity.t
    if entityData then
        description = description or entityData.Description or entityData.Instructions
    end

    local armorName = string.Replace(id, "ent_armor_", "")
    for _, armorTable in pairs(hg.armor or {}) do
        local armorData = armorTable[armorName]
        if armorData then
            description = description or armorData.description
            break
        end
    end

    if isstring(description) and string.StartWith(description, "#") then
        local translated = language.GetPhrase(string.sub(description, 2))
        description = translated ~= "" and translated or description
    end

    description = isstring(description) and string.Trim(description) or ""
    if description == "" or description == category then
        description = TRAITOR_CATEGORY_DESCRIPTIONS[category] or "No detailed description is available for this item."
    end

    if not isstring(model) or model == "" or not util.IsValidModel(model) then
        model = nil
    end

    return category, description, model
end

function hg.CreateTraitorSelectOptionA(parent)
    local frame_base = vgui.Create('DFrame',parent)
    frame_base:SetSize(math.min(parent:GetWide() * 0.62, 980), math.min(parent:GetTall() * 0.72, 780))
    local centerX = parent:GetX() + (parent:GetWide() - frame_base:GetWide()) / 4
    local centerY = parent:GetY() + (parent:GetTall() - frame_base:GetTall()) / 2

    frame_base:SetDraggable(false)
    frame_base:SetX(-ScrW())
    frame_base:SetY(centerY)
    frame_base:MoveTo(centerX, centerY, 0.3,0,2)
    frame_base:SetTitle('Traitor loadout')
    frame_base.OnClose = function()
        local pp = parent and parent:GetParent()
        ClearPanel(pp)
        if not pp then return end
        timer.Simple(0.5,function()
            if not parent then return end
            if not pp then return end
            hg.DrawTraitorRole(pp,true)
        end)
    end

    local mode = "standard"
    local selectedCategory = "ALL"
    local modes_panel = vgui.Create('DPanel', frame_base)
    modes_panel:Dock(TOP)
    modes_panel:SetTall(42)
    modes_panel:DockMargin(8,8,8,0)

    modes_panel.Paint = function() end

    local xuyanna = vgui.Create('DLabel', modes_panel)
    xuyanna:Dock(LEFT)
    xuyanna:SetWide(frame_base:GetWide() * 0.34)
    xuyanna:DockMargin(0,0,8,0)
    xuyanna:SetText(' ')
    xuyanna.Paint = function(self,w,h)
        surface.SetDrawColor(Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('zcity://darknet.united/killer_'..mode,'ZB_InterfaceSmall',5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local btn_default = vgui.Create('DButton', modes_panel)
    btn_default:Dock(LEFT)
    btn_default:SetWide(82)
    btn_default:DockMargin(0,0,8,0)
    btn_default:SetText(' ')

    local btn_soe = vgui.Create('DButton', modes_panel)
    btn_soe:SetText(' ')
    btn_soe:Dock(LEFT)
    btn_soe:SetWide(82)

    local budgetPanel = vgui.Create('DPanel', modes_panel)
    budgetPanel:Dock(FILL)
    budgetPanel:DockMargin(8,0,0,0)
    budgetPanel.Paint = function(self,w,h)
        surface.SetDrawColor(22,22,22,235)
        surface.DrawRect(0,0,w,h)

        local selection = selected_things[mode] or {}
        local roleType = mode == "soe" and 3 or 2
        local roleData = hg.traitor_role.tbl[roleType] and hg.traitor_role.tbl[roleType][selection.traitor_role]

        if not roleData then
            draw.SimpleText("SELECT A ROLE", 'ZB_InterfaceSmall', w - 12, h / 2, Color(190,190,190), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            return
        end

        draw.SimpleText("ROLE: " .. tostring(roleData.name or selection.traitor_role), 'ZB_InterfaceSmall', w - 12, h / 2, Color(220,220,220), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local categoryPanel = vgui.Create('DPanel', frame_base)
    categoryPanel:Dock(TOP)
    categoryPanel:SetTall(38)
    categoryPanel:DockMargin(8,8,8,0)
    categoryPanel.Paint = function() end

    local contentPanel = vgui.Create('DPanel', frame_base)
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(8,8,8,8)
    contentPanel.Paint = function() end

    local listPanel = vgui.Create('DPanel', contentPanel)
    listPanel:Dock(LEFT)
    listPanel:SetWide(frame_base:GetWide() * 0.6)
    listPanel:DockMargin(0,0,8,0)
    listPanel.Paint = function() end

    local detailsPanel = vgui.Create('DPanel', contentPanel)
    detailsPanel:Dock(FILL)
    detailsPanel.Paint = function(self,w,h)
        surface.SetDrawColor(20,20,20,238)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(130,0,0,220)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    local detailTitle = vgui.Create('DLabel', detailsPanel)
    detailTitle:Dock(TOP)
    detailTitle:SetTall(42)
    detailTitle:DockMargin(12,8,12,0)
    detailTitle:SetFont('ZB_InterfaceMedium')
    detailTitle:SetTextColor(Color(255,255,255))
    detailTitle:SetText('ITEM PREVIEW')

    local detailMeta = vgui.Create('DLabel', detailsPanel)
    detailMeta:Dock(TOP)
    detailMeta:SetTall(26)
    detailMeta:DockMargin(12,0,12,0)
    detailMeta:SetFont('ZB_InterfaceSmall')
    detailMeta:SetTextColor(Color(175,70,70))
    detailMeta:SetText('HOVER OVER AN ITEM')

    local detailModel = vgui.Create('DModelPanel', detailsPanel)
    detailModel:Dock(TOP)
    detailModel:SetTall(math.min(frame_base:GetTall() * 0.36, 260))
    detailModel:DockMargin(8,4,8,4)
    detailModel:SetMouseInputEnabled(false)
    detailModel:SetVisible(false)
    detailModel.LayoutEntity = function() end

    local descriptionScroll = vgui.Create('DScrollPanel', detailsPanel)
    descriptionScroll:Dock(FILL)
    descriptionScroll:DockMargin(12,6,12,12)

    local detailDescription = vgui.Create('DLabel', descriptionScroll)
    detailDescription:Dock(TOP)
    detailDescription:SetFont('ZB_InterfaceSmall')
    detailDescription:SetTextColor(Color(205,205,205))
    detailDescription:SetWrap(true)
    detailDescription:SetAutoStretchVertical(true)
    detailDescription:SetText('Point at an equipment item to inspect its appearance and read the full description.')

    local function ShowItemDetails(data)
        local category, description, model = GetTraitorItemPresentation(data)
        detailTitle:SetText(string.upper(tostring(data.name or data.ids or "ITEM")))
        detailMeta:SetText(category)
        detailDescription:SetText(description)
        detailDescription:SizeToContentsY()
        descriptionScroll:GetVBar():SetScroll(0)

        detailModel:SetVisible(model ~= nil)
        if not model then return end

        detailModel:SetModel(model)
        timer.Simple(0, function()
            if not IsValid(detailModel) or not IsValid(detailModel.Entity) then return end

            local mins, maxs = detailModel.Entity:GetRenderBounds()
            local center = (mins + maxs) * 0.5
            local radius = math.max((maxs - mins):Length() * 0.55, 12)
            detailModel:SetFOV(36)
            detailModel:SetLookAt(center)
            detailModel:SetCamPos(center + Vector(radius * 1.35, radius * 1.35, radius * 0.45))
        end)
    end

    local frame_scroll = vgui.Create('DScrollPanel', listPanel)
    frame_scroll:Dock(FILL)
    frame_scroll:SetPaintBackground(false)

    local canvas = vgui.Create('DPanel', frame_scroll)
    canvas:Dock(TOP)
    canvas:SetTall(0)
    canvas:SetPaintBackground(false)

    local function AddItemToCanvas(item)
        item:SetParent(canvas)
        item:Dock(TOP)
        item:DockMargin(0,6,0,0)
        item:InvalidateLayout(true)
        if item:GetTall() == 0 then item:SetTall(40) end
        canvas:SetTall(canvas:GetTall() + item:GetTall() + 6)
    end

    local resetButtons

    local function RebuildCategories()
        for _, child in ipairs(categoryPanel:GetChildren()) do
            child:Remove()
        end

        local itemType = mode == "soe" and 1 or 4
        local available = {ALL = true}
        for _, data in pairs(hg.traitor_role.tbl[itemType] or {}) do
            available[string.upper(tostring(data.desc or "ITEM"))] = true
        end

        local categories = {}
        for category in pairs(available) do
            categories[#categories + 1] = category
        end
        table.sort(categories, function(a,b)
            local orderA = TRAITOR_CATEGORY_ORDER[a] or 100
            local orderB = TRAITOR_CATEGORY_ORDER[b] or 100
            return orderA == orderB and a < b or orderA < orderB
        end)

        if not available[selectedCategory] then selectedCategory = "ALL" end

        local buttonGap = 6
        local availableWidth = frame_base:GetWide() - 16
        local buttonWidth = math.max(math.floor((availableWidth - buttonGap * (#categories - 1)) / #categories), 60)

        for _, category in ipairs(categories) do
            local button = vgui.Create('DButton', categoryPanel)
            button:Dock(LEFT)
            button:SetWide(buttonWidth)
            button:DockMargin(0,0,buttonGap,0)
            button:SetText(' ')
            button.DoClick = function()
                if selectedCategory == category then return end
                selectedCategory = category
                resetButtons(false)
            end
            button.Paint = function(self,w,h)
                local active = selectedCategory == category
                surface.SetDrawColor(active and Color(145,0,0,230) or Color(45,45,45,220))
                surface.DrawRect(0,0,w,h)
                draw.SimpleText(category, 'ZB_InterfaceSmall', w / 2, h / 2, active and color_white or Color(175,175,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    local function UpdateModeButtons()
        if mode == "soe" then
            btn_soe.Clicked = true
            btn_default.Clicked = false
        else
            btn_default.Clicked = true
            btn_soe.Clicked = false
        end
        selectedCategory = "ALL"
        resetButtons(false)
    end

    btn_default.DoClick = function()
        mode = "standard"
        UpdateModeButtons()
    end
    btn_default.Paint = function(self,w,h)
        surface.SetDrawColor(self.Clicked and Color(155,0,0,200) or Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('STD','ZB_InterfaceSmall',10,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    btn_soe.DoClick = function()
        mode = "soe"
        UpdateModeButtons()
    end
    btn_soe.Paint = function(self,w,h)
        surface.SetDrawColor(self.Clicked and Color(155,0,0,200) or Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('SOE','ZB_InterfaceSmall',10,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local lsd = {}
    resetButtons = function(keepScroll)
        local oldScroll = keepScroll == false and 0 or frame_scroll:GetVBar():GetScroll()
        for _, item in ipairs(lsd) do
            if IsValid(item) then
                item:Remove()
            end
        end
        lsd = {}
        canvas:SetTall(0)
        RebuildCategories()

        local item = vgui.Create('DLabel')
        item:SetText(" ")
        item.Selected = false
        item:SetTall(40)

        item.Paint = function(self, w, h)
            surface.SetDrawColor(9, 9, 9, 0)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText("[ [ TYPE OF TRAITOR ] ]", 'ZB_InterfaceMedium', w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        table.insert(lsd, item)
        AddItemToCanvas(item)
        local modes = mode == 'soe' and 3 or 2
        local roles = {}
        for name, data in pairs(hg.traitor_role.tbl[modes] or {}) do
            roles[#roles + 1] = {id = name, data = data}
        end
        table.sort(roles, function(a,b)
            return tostring(a.data.name) < tostring(b.data.name)
        end)

        for _, roleEntry in ipairs(roles) do
            local name, data = roleEntry.id, roleEntry.data
            local title = data.name

            local item = vgui.Create('DButton')
            item:SetText(" ")
            item._role_id = name
            item.Selected = false
            item:SetTall(40)

            item.DoClick = function()
                local d,d1 = SelectShit(data,name)
                if not d then
                    LocalPlayer():ChatPrint(d1)
                end
                resetButtons()
            end

            item.Paint = function(self, w, h)
                if selected_things[mode] and selected_things[mode].traitor_role == name then
                    surface.SetDrawColor(46, 92, 0, 200)
                else
                    surface.SetDrawColor(45, 45, 45, 200)
                end
                surface.DrawRect(0, 0, w, h)
                draw.SimpleText(title, 'ZB_InterfaceSmall', 10, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            table.insert(lsd, item)
            AddItemToCanvas(item)
        end

        local item = vgui.Create('DLabel')
        item:SetText(" ")
        item.Selected = false
        item:SetTall(40)

        item.Paint = function(self, w, h)
            surface.SetDrawColor(9, 9, 9, 0)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText("[ [ TRAITOR'S EQUIPMENT ] ]", 'ZB_InterfaceMedium', w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        table.insert(lsd, item)
        AddItemToCanvas(item)
        local mtd = modes == 3 and 1 or 4
        local equipment = {}
        for name, data in pairs(hg.traitor_role.tbl[mtd] or {}) do
            local category = string.upper(tostring(data.desc or "ITEM"))
            if selectedCategory == "ALL" or selectedCategory == category then
                equipment[#equipment + 1] = {id = name, data = data, category = category}
            end
        end
        table.sort(equipment, function(a,b)
            local orderA = TRAITOR_CATEGORY_ORDER[a.category] or 100
            local orderB = TRAITOR_CATEGORY_ORDER[b.category] or 100
            if orderA ~= orderB then return orderA < orderB end
            return tostring(a.data.name) < tostring(b.data.name)
        end)

        for _, equipmentEntry in ipairs(equipment) do
            local name, data = equipmentEntry.id, equipmentEntry.data
            local title = data.name
            local desc = equipmentEntry.category

            local item = vgui.Create('DButton')
            item:SetText(" ")
            item._role_id = data.ids
            item.Selected = false
            item:SetTall(40)
            item.OnCursorEntered = function()
                ShowItemDetails(data)
            end
            item.DoClick = function()
                local d, d1 = SelectShit(data,data.ids)
                if not d then
                    LocalPlayer():ChatPrint(d1)
                end
                resetButtons()
            end

            item.Paint = function(self, w, h)
                local selection = selected_things[mode] or {}
                local selected = selection.items and selection.items[data.ids] ~= nil
                if selected then
                    surface.SetDrawColor(155, 0, 0, 200)
                else
                    surface.SetDrawColor(45, 45, 45, 200)
                end
                surface.DrawRect(0, 0, w, h)
                surface.SetFont('ZB_InterfaceSmall')
                local w4, h2 = surface.GetTextSize(title)
                draw.SimpleText(title, 'ZB_InterfaceSmall', 10, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(desc, 'ZB_InterfaceSmall', w4+20, h/2, Color(111,111,111), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            table.insert(lsd, item)
            AddItemToCanvas(item)
        end

        if IsValid(canvas) then
            canvas:InvalidateLayout(true)
            if IsValid(frame_scroll) then
                frame_scroll:InvalidateLayout(true)
                timer.Simple(0, function()
                    if IsValid(frame_scroll) then frame_scroll:GetVBar():SetScroll(oldScroll) end
                end)
            end
        end
    end

    UpdateModeButtons()

    return frame_base
end


local function SaveSelection(role_id,mode)
    if mode == "soe" then
        RunConsoleCommand("hmcd_subrole_traitor_soe", tostring(role_id))
    else
        RunConsoleCommand("hmcd_subrole_traitor", tostring(role_id))
    end
end

function hg.CreateTraitorSelectOptionB(parent)
    local frame_base = vgui.Create('DFrame',parent)
    frame_base:SetSize(parent:GetWide()/2.5,parent:GetTall()/2)
    local centerX = parent:GetX() + (parent:GetWide() - frame_base:GetWide()) / 4
    local centerY = parent:GetY() + (parent:GetTall() - frame_base:GetTall()) / 2

    frame_base:SetDraggable(false)
    frame_base:SetX(-ScrW())
    frame_base:SetY(centerY)
    frame_base:MoveTo(centerX, centerY, 0.3,0,2)
    frame_base:SetTitle('Chose preset for traitor.')
    frame_base.OnClose = function()
        local pp = parent and parent:GetParent()
        ClearPanel(pp)
        if not pp then return end
        timer.Simple(0.5,function()
            if not parent then return end
            if not pp then return end
            hg.DrawTraitorRole(pp,true)
        end)
    end

    local mode = "standard"
    local modes_panel = vgui.Create('DPanel', frame_base)
    modes_panel:Dock(TOP)
    modes_panel:SetTall(36)
    modes_panel:DockMargin(8,8,8,0)

    modes_panel.Paint = function() end

    local xuyanna = vgui.Create('DLabel', modes_panel)
    xuyanna:Dock(LEFT)
    xuyanna:SetWide(frame_base:GetWide()/2)
    xuyanna:DockMargin(0,0,8,0)
    xuyanna:SetText(' ')
    xuyanna.Paint = function(self,w,h)
        surface.SetDrawColor(Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('zcity://darknet.united/killer_'..mode,'ZB_InterfaceSmall',5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local btn_default = vgui.Create('DButton', modes_panel)
    btn_default:Dock(LEFT)
    btn_default:SetWide(frame_base:GetWide()/6)
    btn_default:DockMargin(0,0,8,0)
    btn_default:SetText(' ')

    local btn_soe = vgui.Create('DButton', modes_panel)
    btn_soe:SetText(' ')
    btn_soe:Dock(LEFT)
    btn_soe:SetWide(frame_base:GetWide()/6)

    local function UpdateModeButtons()
        if mode == "soe" then
            btn_soe.Clicked = true
            btn_default.Clicked = false
        else
            btn_default.Clicked = true
            btn_soe.Clicked = false
        end
        resetButtons()
    end

    btn_default.DoClick = function()
        mode = "standard"
        UpdateModeButtons()
    end
    btn_default.Paint = function(self,w,h)
        surface.SetDrawColor(self.Clicked and Color(155,0,0,200) or Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('STD','ZB_InterfaceSmall',10,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    btn_soe.DoClick = function()
        mode = "soe"
        UpdateModeButtons()
    end
    btn_soe.Paint = function(self,w,h)
        surface.SetDrawColor(self.Clicked and Color(155,0,0,200) or Color(60,60,60,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText('SOE','ZB_InterfaceSmall',10,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local frame_scroll = vgui.Create('DScrollPanel', frame_base)
    frame_scroll:Dock(FILL)
    frame_scroll:DockMargin(8, 8, 8, 8)
    frame_scroll:SetPaintBackground(false)

    local canvas = vgui.Create('DPanel', frame_scroll)
    canvas:Dock(TOP)
    canvas:SetTall(0)
    canvas:SetPaintBackground(false)

    local function AddItemToCanvas(item)
        item:SetParent(canvas)
        item:Dock(TOP)
        item:DockMargin(0,6,0,0)
        item:InvalidateLayout(true)
        if item:GetTall() == 0 then item:SetTall(40) end
        canvas:SetTall(canvas:GetTall() + item:GetTall() + 6)
    end


    local MODE = hg.homicide or {}

    local lsd = {}
    function resetButtons()
        for _, item in ipairs(lsd) do
            if IsValid(item) then
                item:Remove()
            end
        end
        lsd = {}

        if MODE.SubRoles and MODE.RoleChooseRoundTypes then
            local round_config = MODE.RoleChooseRoundTypes[mode]
            if round_config and round_config.Traitor then
                local processedRoles = {}

                for role_id, _ in pairs(round_config.Traitor) do
                    if MODE.SubRoles[role_id] and not processedRoles[role_id] then
                        processedRoles[role_id] = true
                        local title = MODE.SubRoles[role_id].Name

                        local item = vgui.Create('DButton')
                        item:SetText(" ")
                        item._role_id = role_id
                        item:SetTall(40)
                        item.DoClick = function()
                            SaveSelection(role_id,mode)
                        end
                        txt2 = 'hmcd_subrole_traitor_soe'
                        if mode != 'soe' then txt2 = 'hmcd_subrole_traitor' end
                        item.Paint = function(self,w,h)
                            if GetConVarString(txt2) == role_id then
                                surface.SetDrawColor(155,0,0,200)
                            else
                                surface.SetDrawColor(45,45,45,200)
                            end
                            surface.DrawRect(0,0,w,h)
                            draw.SimpleText(title,'ZB_InterfaceSmall',10,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                        end
                        table.insert(lsd,item)
                        AddItemToCanvas(item)
                    end
                end
            end
        end

        if IsValid(canvas) then
            canvas:InvalidateLayout(true)
            if IsValid(frame_scroll) then
                frame_scroll:InvalidateLayout(true)
            end
        end
    end

    local saved_default = (GetConVarString and GetConVarString('hmcd_subrole_traitor')) or nil
    local saved_soe = (GetConVarString and GetConVarString('hmcd_subrole_traitor_soe')) or nil

    if saved_default and saved_default ~= "" then
        mode = "standard"
        timer.Simple(0.1, function()
            if IsValid(frame_base) then
                SaveSelection(saved_default)
                resetButtons()
            end
        end)
    elseif saved_soe and saved_soe ~= "" then
        mode = "soe"
        timer.Simple(0.1, function()
            if IsValid(frame_base) then
                SaveSelection(saved_soe)
                resetButtons()
            end
        end)
    else
        mode = "standard"
        timer.Simple(0.1, function()
            if IsValid(frame_base) then
                resetButtons()
            end
        end)
    end

    UpdateModeButtons()

    return frame_base
end

function hg.CreateFrame(ParentPanel, type1)
    local pppanel2 = vgui.Create('DFrame', ParentPanel)
    pppanel2:SetSize(ParentPanel:GetWide(), ParentPanel:GetTall())
    pppanel2:SetPos(0,0)
    pppanel2:ShowCloseButton(false)
    pppanel2:SetDraggable(false)
    pppanel2:SetText(' ')
    pppanel2:SetTitle(' ')

    pppanel2.Paint = function() end

    AppearanceTable = AppearanceTable
        or (hg.Appearance.SelectedAppearance
            and hg.Appearance.LoadAppearanceFile(hg.Appearance.SelectedAppearance:GetString()))
        or APmodule.GetRandomAppearance()

    if not istable(AppearanceTable) then
        AppearanceTable = APmodule.GetRandomAppearance() or {
            AModel = "normal",
            AColor = Color(255,255,255),
            AClothes = {},
            AFacemap = "Default",
            AAttachments = {},
            ABodygroups = {}
        }
    end

    local tMdl = (APmodule.PlayerModels[1] and APmodule.PlayerModels[1][AppearanceTable.AModel])
        or (APmodule.PlayerModels[2] and APmodule.PlayerModels[2][AppearanceTable.AModel])

    local viewer = vgui.Create("DModelPanel",pppanel2)
    viewer:SetSize(pppanel2:GetWide()/2,ScrH())
    viewer:SetPos(pppanel2:GetWide()/1-(pppanel2:GetWide()/2),0)
    viewer:SetModel( (tMdl and util.IsValidModel( tostring(tMdl.mdl) ) and tostring(tMdl.mdl)) or "models/player/group01/female_01.mdl" )
    viewer:SetFOV( 15 )
    viewer:SetLookAng( Angle( -3, 180, 0 ) )
    viewer:SetCamPos( Vector( 200, 0, 55 ) )
    viewer:SetDirectionalLight(BOX_RIGHT, Color(255, 0, 0))
    viewer:SetDirectionalLight(BOX_LEFT, Color(125, 155, 255))
    viewer:SetDirectionalLight(BOX_FRONT, Color(160, 160, 160))
    viewer:SetDirectionalLight(BOX_BACK, Color(0, 0, 0))
    viewer:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
    viewer:SetDirectionalLight(BOX_BOTTOM, Color(0, 0, 0))
    viewer:SetAmbientLight(Color(255, 0, 0, 255))

    viewer:SetX(ScrW())
    viewer:MoveTo(pppanel2:GetWide()/1-(pppanel2:GetWide()/2), viewer:GetY(), 1, 0, 0.2)
    viewer:AlphaTo( 255, 0.2, 0.1, nil )

    function viewer:LayoutEntity( Entity )
        if not IsValid(Entity) then return end
        local tbl = AppearanceTable
        if not istable(tbl) then return end
        if not tbl.AModel then return end

        tMdl = (APmodule.PlayerModels[1] and APmodule.PlayerModels[1][tbl.AModel])
            or (APmodule.PlayerModels[2] and APmodule.PlayerModels[2][tbl.AModel])
        if not tMdl or not tMdl.mdl then return end

        local lookX, lookY = input.GetCursorPos()
        lookX = lookX / sizeX - 0.5
        lookY = lookY / sizeY - 0.5
        Entity.Angles = Entity.Angles or Angle(0,0,0)
        Entity.Angles = LerpAngle(FrameTime() * 5,Entity.Angles,Angle(lookY * 2,math.min((self.Rotate and -179 or 0) -lookX * -75,-10),0))

        Entity:SetNWVector("PlayerColor",Vector(
            (tbl.AColor and tbl.AColor.r or 255) / 255,
            (tbl.AColor and tbl.AColor.g or 255) / 255,
            (tbl.AColor and tbl.AColor.b or 255) / 255
        ))
        Entity:SetAngles(Entity.Angles)
        Entity:SetSequence(Entity:LookupSequence("pose_againstwall"))
        Entity:SetSubMaterial()
        self:SetCamPos( Vector( 100, 0, 55 * (self.OffsetY or 1) ) )
        if Entity:GetModel() != tMdl.mdl then
            Entity:SetModel(tMdl.mdl)
            self:SetModel(tMdl.mdl)
            tbl.AFacemap = "Default"
        end

        local mats = Entity:GetMaterials()
        tbl.AClothes = tbl.AClothes or {}
        tbl.ABodygroups = tbl.ABodygroups or {}
        tbl.AFacemap = tbl.AFacemap or "Default"

        local sex = tMdl.sex and 2 or 1
        for k, v in SortedPairs(tMdl.submatSlots or {}) do
            local slot = 1
            for i = 1, #mats do
                if mats[i] == v then slot = i-1 break end
            end
            local clothesKey = tbl.AClothes[k] or "normal"
            local clothesMat = hg.Appearance.Clothes
                and hg.Appearance.Clothes[sex]
                and hg.Appearance.Clothes[sex][clothesKey]
            Entity:SetSubMaterial(slot, clothesMat)
            Entity:SetNWString("Colthes" .. k, clothesKey)
        end
        for i = 1, #mats do
            local facemapSlot = hg.Appearance.FacemapsSlots and hg.Appearance.FacemapsSlots[mats[i]]
            if facemapSlot and facemapSlot[tbl.AFacemap] then
                Entity:SetSubMaterial(i - 1, facemapSlot[tbl.AFacemap])
            end
        end
        local bodygroups = Entity:GetBodyGroups()
        for k, v in SortedPairs(bodygroups) do
            if not tbl.ABodygroups[v.name] then continue end
            for i = 0, #v.submodels do
                local b = v.submodels[i]
                local bgTable = hg.Appearance.Bodygroups
                    and hg.Appearance.Bodygroups[v.name]
                    and hg.Appearance.Bodygroups[v.name][sex]
                    and hg.Appearance.Bodygroups[v.name][sex][tbl.ABodygroups[v.name]]
                if not bgTable then continue end
                if bgTable[1] != b then continue end
                Entity:SetBodygroup(k-1,i)
            end
        end
    end

    function pppanel2:OnClose()
        pppanel2:AlphaTo(0,0.5,0,function()
            pppanel2:Close()
        end)
        viewer:MoveTo(viewer:GetX(), viewer:GetY()+ viewer:GetTall(), 1, 0, 0.2, function() viewer:Remove() end)
    end

    function viewer:PostDrawModel(Entity)
        local tbl = AppearanceTable
        if not istable(tbl) or not tbl.AAttachments then return end
        for k,attach in ipairs(tbl.AAttachments) do
            DrawAccesories(Entity, Entity, attach, hg.Accessories[attach],false,true)
        end
        Entity:SetupBones()
    end

    if type1 == 1 then
        hg.CreateTraitorSelectOptionB(pppanel2)
    else
        hg.CreateTraitorSelectOptionA(pppanel2)
    end
end

function hg.DrawBackGround(ParentPanel)
    ParentPanel:SetAlpha(0)
    ParentPanel.Paint = function(self,w,h)
        surface.SetDrawColor(28,28,28)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(40,36,36,255)

        for i = 1, (ybars + 1) do
            surface.DrawRect((sw / ybars) * i - (CurTime() * 30 % (sw / ybars)), 0, ScreenScale(1), sh)
        end

        for i = 1, (xbars + 1) do
            surface.DrawRect(0, (sh / xbars) * (i - 1) + (CurTime() * 30 % (sh / xbars)), sw, ScreenScale(1))
        end

        local border_size = ScreenScale(10)

        if gradient_l then
            surface.SetDrawColor(5,5,5)
            surface.SetMaterial(gradient_l)
            surface.DrawTexturedRect(0, 0, border_size, sh)
        end

        if blur then
            surface.SetMaterial(blur)
            surface.SetDrawColor(28,28,28,208)
            surface.DrawRect(0, 0, w, h)
        end
    end

    if hg.DrawBlur then
        hg.DrawBlur(ParentPanel, 5)
    end
    ParentPanel:AlphaTo(255,0.15,0)
    local pppanel3 = vgui.Create('DFrame', ParentPanel)
    pppanel3:SetSize(ParentPanel:GetWide(), ParentPanel:GetTall())
    pppanel3:SetPos(0,0)
    pppanel3:ShowCloseButton(false)
    pppanel3:SetTitle(' ')
    pppanel3:SetDraggable(false)

    pppanel3.Paint = function() end
    return pppanel3
end

function hg.DrawTraitorRole(ParentPanel,dd)
    if not dd then pppanel3 = hg.DrawBackGround(ParentPanel) end
    if dd then pppanel3 = ParentPanel end
    if not pppanel3 or not pppanel3:IsValid() then return end
    local textEE = vgui.Create('DLabel',pppanel3)
    textEE:SetFont('ZB_InterfaceLarge')
    textEE:SetText('Choose what you want.')
    textEE:SizeToContents()
    textEE:SetPos(30,((pppanel3:GetTall()-textEE:GetTall())/2.5))
    surface.SetFont('HomigradFontBig')
    local w3,h3 = surface.GetTextSize('PRESETS')
    if not pppanel3 or not pppanel3:IsValid() then return end

    local button1 = hg.CreateSelectModeButton("PRESETS",{30, ((ParentPanel:GetTall()-textEE:GetTall())/2.5)+h3*2},pppanel3,3,Color(168,54,54),function()
        GetConVar("hg_traitor_mode_s"):SetString("presets")
        SaveLoadout()
        ClearPanel(ParentPanel)
        timer.Simple(0.5,function()
            hg.CreateFrame(ParentPanel,1)
        end)
    end)
    surface.SetFont('HomigradFontBig')
    local w5,h5 = surface.GetTextSize('LOADOUT')
    h5 = (h5 + button1:GetTall()*2)
    local button2 = hg.CreateSelectModeButton("LOADOUT",{30, ((ParentPanel:GetTall()-textEE:GetTall())/2.5)+h5},pppanel3,3,Color(168,54,54),function()
        GetConVar("hg_traitor_mode_s"):SetString("loadout")
        SaveLoadout()
        ClearPanel(ParentPanel)
        timer.Simple(0.5,function()
            hg.CreateFrame(ParentPanel,2)
        end)
    end)
end

if engine.ActiveGamemode() != 'sandbox' then
    net.Receive('HMCD_GetTraitorLadOut',function(len)
        hg._traitorLoadoutPooled = true
        net.Start('HMCD_GetTraitorLadOut')
        net.WriteTable(StripFunctions(selected_things))
        net.SendToServer()
    end)

    LoadLoadout()
end

hook.Add("InitPostEntity", "TraitorLoadout_SyncOnJoin", function()
    timer.Simple(1, function()
        if selected_things then
            hg._traitorLoadoutPooled = true
            SaveLoadout()
        end
    end)
end)