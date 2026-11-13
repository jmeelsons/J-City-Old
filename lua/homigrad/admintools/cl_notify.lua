local NOTIFY = {
    Font = "ZCity_Eblan",      
    Color = Color(255, 255, 255, 255),
    Background = Color(10, 10, 10, 200),
    Border = Color(200, 0, 0, 255),
    Padding = 20,
    Spacing = 10,
    MaxOnScreen = 3,              
    DisplayTime = 5,              
    FadeTime = 0.2,
    MinWidth = 300,
    MaxWidth = 700,
    PosY = 50,          
    Sound = "snd_jack_hint.wav",
    SenderFont = "ZCity_Tiny",
    SenderColor = Color(180, 180, 180),
    SenderOffset = 9,
}

local queue = {}
local active = {}

local function GetCenterX(width)
    return ScrW() / 2 - width / 2
end

function AddNotification(text, color, time, sender)
    surface.SetFont(NOTIFY.Font)
    local textWidth, textHeight = surface.GetTextSize(text)
    
    local blockWidth = math.max(NOTIFY.MinWidth, math.min(textWidth + NOTIFY.Padding * 2, NOTIFY.MaxWidth))
    if textWidth > NOTIFY.MaxWidth - NOTIFY.Padding * 2 then
        blockWidth = NOTIFY.MaxWidth
        textHeight = 60
    else
        textHeight = 60
    end

    local hasSender = sender and sender ~= ""
    local senderHeight = 0
    if hasSender then
        surface.SetFont(NOTIFY.SenderFont)
        local _, sH = surface.GetTextSize(sender)
        senderHeight = sH
        textHeight = textHeight + senderHeight + NOTIFY.SenderOffset
    end

    local entry = {
        text = text or "",
        color = color or NOTIFY.Color,
        time = time or NOTIFY.DisplayTime,
        start = CurTime(),
        alpha = 0,
        state = "fadein",
        y = 0,
        played_sound = false,
        width = blockWidth,
        height = textHeight,
        sender = sender or "",
        senderHeight = senderHeight,
    }

    table.insert(queue, entry)
    ProcessQueue()
end

function ProcessQueue()
    while #active < NOTIFY.MaxOnScreen and #queue > 0 do
        local entry = table.remove(queue, 1)
        entry.start = CurTime()
        entry.alpha = 0
        entry.state = "fadein"
        entry.played_sound = false
        table.insert(active, entry)
    end
end

hook.Add("Think", "NotifyThink", function()
    for i = #active, 1, -1 do
        local entry = active[i]
        local elapsed = CurTime() - entry.start

        if entry.state == "fadein" then
            local progress = elapsed / NOTIFY.FadeTime
            
            if not entry.played_sound and progress > 0.1 then
                entry.played_sound = true
                surface.PlaySound(NOTIFY.Sound)
            end
            
            if progress >= 1 then
                entry.alpha = 255
                entry.state = "visible"
                entry.start = CurTime()
            else
                entry.alpha = 255 * progress
            end
            
        elseif entry.state == "visible" then
            if elapsed >= entry.time then
                entry.state = "fadeout"
                entry.start = CurTime()
            end
            
        elseif entry.state == "fadeout" then
            local progress = elapsed / NOTIFY.FadeTime
            if progress >= 1 then
                entry.alpha = 0
                table.remove(active, i)
            else
                entry.alpha = 255 * (1 - progress)
            end
        end
    end

    if #active < NOTIFY.MaxOnScreen and #queue > 0 then
        ProcessQueue()
    end
end)

hook.Add("HUDPaint", "NotifyDraw", function()
    local yOffset = NOTIFY.PosY

    for i, entry in ipairs(active) do
        local alpha = math.Clamp(entry.alpha, 0, 255)
        if alpha <= 0 then continue end

        local centerX = GetCenterX(entry.width)

        local bgColor = Color(
            NOTIFY.Background.r,
            NOTIFY.Background.g,
            NOTIFY.Background.b,
            NOTIFY.Background.a * (alpha / 255)
        )
        local borderColor = Color(
            NOTIFY.Border.r,
            NOTIFY.Border.g,
            NOTIFY.Border.b,
            NOTIFY.Border.a * (alpha / 255)
        )
        local textColor = Color(
            entry.color.r,
            entry.color.g,
            entry.color.b,
            alpha
        )

        surface.SetDrawColor(bgColor)
        surface.DrawRect(
            centerX,
            yOffset,
            entry.width,
            entry.height
        )

        surface.SetDrawColor(borderColor)
        surface.DrawRect(
            centerX,
            yOffset,
            entry.width,
            3
        )

        local mainTextY
        if entry.sender ~= "" then
            mainTextY = yOffset + (entry.height - entry.senderHeight - NOTIFY.SenderOffset) / 2
        else
            mainTextY = yOffset + entry.height / 2
        end

        draw.SimpleText(
            entry.text,
            NOTIFY.Font,
            ScrW() / 2,
            mainTextY,
            textColor,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        if entry.sender ~= "" then
            local senderColor = Color(
                NOTIFY.SenderColor.r,
                NOTIFY.SenderColor.g,
                NOTIFY.SenderColor.b,
                alpha
            )
            draw.SimpleText(
                "By: " .. entry.sender,
                NOTIFY.SenderFont,
                ScrW() / 2,
                mainTextY + (entry.senderHeight + NOTIFY.SenderOffset) / 4 + 32,
                senderColor,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        end

        yOffset = yOffset + entry.height + NOTIFY.Spacing
    end
end)

net.Receive("AdminNotifyReceive", function()
    local text = net.ReadString()
    local color = net.ReadColor()
    local time = net.ReadFloat()
    local sender = net.ReadString()
    AddNotification(text, color, time, sender)
end)

concommand.Add("hg_notify_all", function(ply, cmd, args)
    local text = table.concat(args, " ")
    if text == "" then return end
    RunConsoleCommand("hg_notify_all_sv", text)
end)