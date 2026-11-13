MODE.name = "bodycrawler"

local MODE = MODE

local matchStart
local timeLeft = MODE.ROUND_TIME or 420
local matchEnded = false
local survivorsWon = false

local MUSIC_TRACKS = {
    "main_theme.wav",
    "second_theme.wav",
--  "snb/saya_horror.mp3",
}
local MUSIC_SOUND = MUSIC_TRACKS[1]

local musicChannel = nil
local musicPlaying = false
local musicFadeTimer = "BodyCrawlerMusicFade"
local lastTrackIndex = 0

local function pickTrack()
    local idx
    if #MUSIC_TRACKS == 1 then
        idx = 1
    else
        repeat
            idx = math.random(#MUSIC_TRACKS)
        until idx ~= lastTrackIndex
    end
    lastTrackIndex = idx
    return MUSIC_TRACKS[idx]
end

local function stopRoundMusic(fadeTime)
    if not musicPlaying or not musicChannel then
        musicPlaying = false
        musicChannel = nil
        timer.Remove(musicFadeTimer)
        return
    end

    fadeTime = fadeTime or 1.5
    local ch = musicChannel
    local steps = 30
    local interval = fadeTime / steps
    local step = 0

    timer.Remove(musicFadeTimer)
    timer.Create(musicFadeTimer, interval, steps, function()
        step = step + 1
        if not musicPlaying or musicChannel ~= ch then
            timer.Remove(musicFadeTimer)
            return
        end
        local vol = math.max(0, 1 - (step / steps))
        ch:ChangeVolume(vol, 0)
        if step >= steps then
            ch:Stop()
            musicChannel = nil
            musicPlaying = false
            timer.Remove(musicFadeTimer)
        end
    end)
end

local function playRoundMusic()
    if musicPlaying then return end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    MUSIC_SOUND = pickTrack()
    --print("Playing music: " .. MUSIC_SOUND)

    musicChannel = CreateSound(ply, MUSIC_SOUND)
    if not musicChannel then
        musicPlaying = false
        return
    end

    musicPlaying = true
    musicChannel:SetSoundLevel(0)
    musicChannel:Play()
    musicChannel:ChangeVolume(0, 0)
    musicChannel:ChangeVolume(1, 1.5)
end

local function formatTime(sec)
    sec = math.max(0, math.floor(sec))
    return string.format("%02d:%02d", math.floor(sec / 60), sec % 60)
end

net.Receive("bodycrawler_sync", function()
    timeLeft = net.ReadUInt(16) or 420
    matchStart = CurTime()
    matchEnded = false

    playRoundMusic()
end)

net.Receive("bodycrawler_start", function()
    matchStart = nil
    timeLeft = MODE.ROUND_TIME or 420
    matchEnded = false
    survivorsWon = false
end)

net.Receive("bodycrawler_end", function()
    survivorsWon = net.ReadBool()
    matchEnded = true

    stopRoundMusic(2)
end)

hook.Add("OnRoundEnd", "BodyCrawlerMusicStop", function()
    stopRoundMusic(2)
end)

hook.Add("ShutDown", "BodyCrawlerMusicStop", function()
    stopRoundMusic(0)
end)

function MODE:HUDPaint()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if zb.ROUND_START and zb.ROUND_START + 8 > CurTime() then
        local fade = math.Clamp(zb.ROUND_START + 8 - CurTime(), 0, 1)
        draw.SimpleText("THE BODY CRAWLER HUNT", "ZB_HomicideMediumLarge",
            ScrW() * 0.5, ScrH() * 0.1,
            Color(200, 30, 30, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText("You are Survivor", "ZB_HomicideMediumLarge",
            ScrW() * 0.5, ScrH() * 0.5,
            Color(0, 120, 190, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText("Just survive. Roadside assistance? Just wait 7 minutes.", "ZB_HomicideMedium",
            ScrW() * 0.5, ScrH() * 0.15,
            Color(255, 255, 255, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end

    if not matchStart or not ply:Alive() then return end
    if matchEnded then
        draw.SimpleText(survivorsWon and "EVERY STAY ALIVE!" or "EVERY HUMANITY DEAD.",
            "ZB_HomicideMediumLarge",
            ScrW() * 0.5, ScrH() * 0.5,
            survivorsWon and Color(50, 200, 50) or Color(200, 30, 30),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end

    local left = timeLeft - (CurTime() - matchStart)

    local col = Color(255, 255, 255)
    if left <= 60 then col = Color(255, 80, 80) end
    if left <= 20 then
        local pulse = math.sin(CurTime() * 8) * 0.5 + 0.5
        col = Color(255, 50 * pulse, 50 * pulse)
    end

    draw.SimpleText(formatTime(left), "ZB_HomicideMediumLarge",
        ScrW() * 0.01, ScrH() * 0.10,
        col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function MODE:RenderScreenspaceEffects()
    if not matchStart or matchEnded then return end
    local left = timeLeft - (CurTime() - matchStart)
    if left <= 60 and left > 0 then
        local intensity = (60 - left) / 60
        DrawMaterialOverlay("effects/red_flash.vmt", intensity * 0.12)
        DrawColorModify({
            ["$pp_colour_addr"] = 0.05 * intensity,
            ["$pp_colour_addg"] = 0,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = -0.05 * intensity,
            ["$pp_colour_contrast"] = 1 + 0.05 * intensity,
            ["$pp_colour_colour"] = 1,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0,
        })
    end
end