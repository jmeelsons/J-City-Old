MODE.name = "construct"

local MODE = MODE
local StartTime = 0
local SurviveEndTime = 0

local spawnOrbMat = Material("hmcd_dmzone")
local spawnOrbRadius = 54

net.Receive("construct_start", function()
    StartTime = CurTime()
    zb.RemoveFade()
    if IsValid(hmcdEndMenu) then hmcdEndMenu:Remove(); hmcdEndMenu = nil end
end)

net.Receive("construct_timer", function()
    SurviveEndTime = net.ReadFloat()
end)

function MODE:RenderScreenspaceEffects()
    if StartTime + 7.5 < CurTime() then return end
    local fade = math.Clamp(StartTime + 7.5 - CurTime(), 0, 1)
    surface.SetDrawColor(0, 0, 0, 255 * fade)
    surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
end

function MODE:HUDPaint()
    if SurviveEndTime > 0 and lply:Alive() then
        local left = math.max(0, SurviveEndTime - CurTime())
        local h = math.floor(left / 3600)
        local m = math.floor((left % 3600) / 60)
        local s = math.floor(left % 60)
        draw.SimpleText(
            string.format("%02d:%02d:%02d", h, m, s),
            "ZB_HomicideMediumLarge",
            sw * 0.01, sh * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP
        )
    end

    if StartTime + 8 > CurTime() then
        local fade = math.Clamp(StartTime + 8 - CurTime(), 0, 1)
        draw.SimpleText(
            "ZCity | Construct",
            "ZB_HomicideMediumLarge",
            sw * 0.5, sh * 0.1,
            Color(0, 200, 120, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
        draw.SimpleText(
            "Build a base, find allies, just survive...",
            "ZB_HomicideMediumLarge",
            sw * 0.5, sh * 0.5,
            Color(255, 255, 255, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
    end
end

function MODE:PostDrawTranslucentRenderables(bDepth, bSkybox, isDraw3DSkybox)
    if bSkybox or isDraw3DSkybox then return end
    if zb.CROUND ~= "construct" then return end

    local ct = CurTime()

    for _, ply in player.Iterator() do
        if not IsValid(ply) or not ply:Alive() then continue end
        local protectUntil = ply:GetNWFloat("SandboxSpawnProtectUntil", 0)
        local remaining = protectUntil - ct
        if remaining <= 0 then continue end

        local ent = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or ply
        if not IsValid(ent) then continue end
        local pos = ent:WorldSpaceCenter()
        if not pos then continue end

        local frac = math.Clamp(remaining / 5, 0, 1)
        local eased = frac * frac

        render.SetMaterial(spawnOrbMat)
        render.SetColorModulation(0, 0.8, 0.3)
        render.SetBlend(0.45 * eased)
        render.DrawSphere(pos, spawnOrbRadius, 30, 30, color_white)
        render.SetBlend(1)
        render.SetColorModulation(1, 1, 1)
    end
end

net.Receive("construct_end", function()
    local ent = net.ReadEntity()
    if IsValid(ent) then ent.won = true end
end)

function MODE:RoundStart()
    for _, ply in player.Iterator() do
        ply.won = nil
    end
end