--[[
local HINTS = {
    Font        = "ZCity_Eblan",
    TitleFont   = "ZCity_Tiny",
    SmallFont   = "ZCity_Tiny",
    Color       = Color(255, 255, 255, 255),
    TitleColor  = Color(255, 80, 80, 255),
    SmallColor  = Color(180, 180, 180),
    Background  = Color(10, 10, 10, 220),
    Border      = Color(200, 0, 0, 255),
    Button      = Color(30, 30, 30, 255),
    ButtonHover = Color(60, 60, 60, 255),
    ButtonText  = Color(255, 255, 255, 255),
    Padding     = 20,
    Spacing     = 12,
    MinWidth    = 500,
    MaxWidth    = 750,
    MaxHeight   = 600,
    FadeTime    = 0.25,
    Sound       = "snd_jack_hint.wav",
}

local DATA = {
    { title = "Правила", desc = "Изучите правила в Wikipedia" },
    { title = "Донат", desc = "Нажми F11 чтобы получить больше функций и быть пуськой сервера" },
    { title = "Режим Sandbox", desc = "Как заспавнится? zbox_respawn в консоль игры (буква ~ или ё)" },
    { title = "Базовое меню",  desc = "Голосования и другие важные функции вы можете найти в !menu в чате" },
    { title = "Функция свободной мыши",       desc = "Нажмите F3 чтобы освободилась мышь." },
    { title = "Мут",        desc = "Вы можете мутить игроков через колесико мыши." },
    { title = "Как открыть SpawnMenu?",        desc = "Нажми F1 и оно откроется!" },
}

local shownCVar = CreateClientConVar("hints_shown", "0", true, false)

local frame, alpha, state, stateStart
local soundPlayed = false
local pendingClose = nil

local function GetFrameWidth()
    return math.Clamp(ScrW() * 0.5, HINTS.MinWidth, HINTS.MaxWidth)
end

local function CalcFrameHeight()
    local cardH = 70
    local headerH = 90
    local footerH = 70
    local total = headerH + (#DATA * (cardH + HINTS.Spacing)) + footerH
    return math.min(total, HINTS.MaxHeight)
end

local function DestroyPanel()
    if IsValid(frame) then
        frame:Remove()
    end
    frame = nil
    state = nil
    pendingClose = nil
end

local function ClosePanel(saveValue)
    if not IsValid(frame) then return end
    if state == "fadeout" then return end

    state = "fadeout"
    stateStart = CurTime()
    pendingClose = saveValue
end

local function OpenPanel()
    if IsValid(frame) then
        frame:Remove()
        frame = nil
        pendingClose = nil
    end

    local w = GetFrameWidth()
    local h = CalcFrameHeight()

    frame = vgui.Create("ZFrame")
    frame:SetSize(w, h)
    frame:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetAlpha(0)
    frame:SetKeyboardInputEnabled(false)

    local bg = vgui.Create("DPanel", frame)
    bg:SetPos(0, 0)
    bg:SetSize(w, h)
    bg:SetMouseInputEnabled(false)
    bg.Paint = function(self, bw, bh)
        local a = HINTS.Background.a * (alpha / 255)
        surface.SetDrawColor(HINTS.Background.r, HINTS.Background.g, HINTS.Background.b, a)
        surface.DrawRect(0, 0, bw, bh)

        local bA = HINTS.Border.a * (alpha / 255)
        surface.SetDrawColor(HINTS.Border.r, HINTS.Border.g, HINTS.Border.b, bA)
        surface.DrawRect(0, 0, bw, 3)
    end

    local header = vgui.Create("DPanel", frame)
    header:SetPos(0, 3)
    header:SetSize(w, 90)
    header:SetMouseInputEnabled(false)
    header.Paint = function(self, hw, hh)
        local a = alpha
        draw.SimpleText(
            "ДОБРО ПОЖАЛОВАТЬ В J-CITY",
            HINTS.Font,
            hw / 2, 25,
            Color(HINTS.TitleColor.r, HINTS.TitleColor.g, HINTS.TitleColor.b, a),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
        draw.SimpleText(
            "Вы первый раз на сервере? Прочитайте это:",
            HINTS.SmallFont,
            hw / 2, 58,
            Color(HINTS.SmallColor.r, HINTS.SmallColor.g, HINTS.SmallColor.b, a),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
    end

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(HINTS.Padding, 100)
    scroll:SetSize(w - HINTS.Padding * 2, h - 100 - 80)

    local sbar = scroll:GetVBar()
    sbar:SetWide(5)
    sbar.Paint = function(self, sw, sh)
        surface.SetDrawColor(20, 20, 20, 200 * (alpha / 255))
        surface.DrawRect(0, 0, sw, sh)
    end
    sbar.btnGrip.Paint = function(self, sw, sh)
        surface.SetDrawColor(
            HINTS.Border.r, HINTS.Border.g, HINTS.Border.b,
            HINTS.Border.a * (alpha / 255)
        )
        surface.DrawRect(0, 0, sw, sh)
    end

    for i, hint in ipairs(DATA) do
        local card = vgui.Create("DPanel", scroll)
        card:SetTall(70)
        card:Dock(TOP)
        card:DockMargin(0, 0, 0, HINTS.Spacing)
        card:SetMouseInputEnabled(false)

        card.Paint = function(self, cw, ch)
            local a = alpha
            local bgA = HINTS.Background.a * (a / 255)

            surface.SetDrawColor(15, 15, 15, bgA)
            surface.DrawRect(0, 0, cw, ch)

            surface.SetDrawColor(
                HINTS.Border.r, HINTS.Border.g, HINTS.Border.b,
                HINTS.Border.a * (a / 255)
            )
            surface.DrawRect(0, 0, 3, ch)

            draw.SimpleText(
                hint.title,
                HINTS.TitleFont,
                HINTS.Padding, 18,
                Color(HINTS.TitleColor.r, HINTS.TitleColor.g, HINTS.TitleColor.b, a),
                TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP
            )
            draw.SimpleText(
                hint.desc,
                HINTS.SmallFont,
                HINTS.Padding, 44,
                Color(HINTS.Color.r, HINTS.Color.g, HINTS.Color.b, a),
                TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP
            )
            draw.SimpleText(
                "#" .. i,
                HINTS.SmallFont,
                cw - HINTS.Padding, ch / 2,
                Color(HINTS.SmallColor.r, HINTS.SmallColor.g, HINTS.SmallColor.b, a * 0.6),
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
            )
        end
    end

    local btnPanel = vgui.Create("DPanel", frame)
    btnPanel:SetPos(HINTS.Padding, h - 70)
    btnPanel:SetSize(w - HINTS.Padding * 2, 50)
    btnPanel.Paint = function() end

    local function MakeButton(text, xPos, w2, onClick)
        local btn = vgui.Create("DButton", btnPanel)
        btn:SetSize(w2, 40)
        btn:SetPos(xPos, 5)
        btn:SetText("")
        btn.DoClick = onClick
        btn.Paint = function(self, bw, bh)
            local a = alpha
            local col = self:IsHovered() and HINTS.ButtonHover or HINTS.Button
            surface.SetDrawColor(col.r, col.g, col.b, col.a * (a / 255))
            surface.DrawRect(0, 0, bw, bh)

            surface.SetDrawColor(
                HINTS.Border.r, HINTS.Border.g, HINTS.Border.b,
                HINTS.Border.a * (a / 255)
            )
            surface.DrawRect(0, 0, bw, 2)

            draw.SimpleText(
                text,
                HINTS.Font,
                bw / 2, bh / 2,
                Color(HINTS.ButtonText.r, HINTS.ButtonText.g, HINTS.ButtonText.b, a),
                TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
            )
        end
        return btn
    end

    local gap = 10
    local btnW = (w - HINTS.Padding * 2 - gap) / 2

    MakeButton("Понятно", 0, btnW, function()
        ClosePanel("1")
        surface.PlaySound( "cool-click.mp3" )   
    end)

    MakeButton("Больше не показывать", btnW + gap, btnW, function()
        ClosePanel("2")
        surface.PlaySound( "cool-click.mp3" )    
    end)
end

hook.Add("Think", "govno", function()
    if not IsValid(frame) then return end

    if state == "fadein" then
        local progress = (CurTime() - stateStart) / HINTS.FadeTime

        if not soundPlayed and progress > 0.1 then
            soundPlayed = true
            surface.PlaySound(HINTS.Sound)
        end

        if progress >= 1 then
            alpha = 255
            state = "idle"
        else
            alpha = 255 * progress
        end
        frame:SetAlpha(alpha)

    elseif state == "fadeout" then
        local progress = (CurTime() - stateStart) / HINTS.FadeTime

        if progress >= 1 then
            if pendingClose then
                RunConsoleCommand("hints_shown", pendingClose)
            end
            DestroyPanel()
        else
            alpha = 255 * (1 - progress)
            frame:SetAlpha(alpha)
        end
    end
end)

hook.Add("InitPostEntity", "firsttime", function()
    timer.Simple(3, function()
        if not IsValid(LocalPlayer()) then return end
        if shownCVar:GetInt() == 0 then
            OpenPanel()
            alpha = 0
            state = "fadein"
            stateStart = CurTime()
            soundPlayed = false
        end
    end)
end)

local function ManualOpen()
    OpenPanel()
    alpha = 0
    state = "fadein"
    stateStart = CurTime()
    soundPlayed = false
end

concommand.Add("hints", ManualOpen)
--]]