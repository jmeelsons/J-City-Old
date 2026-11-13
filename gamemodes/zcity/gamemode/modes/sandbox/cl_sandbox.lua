MODE.name = "sandbox"

local MODE = MODE

local StartTime = 0

local respawntime = 0.5

local spawnOrbMat = Material("hmcd_dmzone")
local spawnOrbRadius = 54

net.Receive("sandbox_start", function()
    StartTime = CurTime()
    zb.RemoveFade()

    if IsValid(hmcdEndMenu) then
        hmcdEndMenu:Remove()
        hmcdEndMenu = nil
    end
end)

net.Receive("sandbox_respawn", function()
    respawntime = net.ReadFloat()

    hook.Add("HUDPaint", "_SandboxRespawn", function()
        if respawntime < CurTime() then
            hook.Remove("HUDPaint", "_SandboxRespawn")
            return
        end

        if lply:Alive() then return end

        local timeLeft = respawntime - CurTime()
        local fade = math.Clamp(timeLeft, 0, 1)

        draw.SimpleText(
            "Respawn in " .. string.format("%.1f", math.max(timeLeft, 0)),
            "ZB_HomicideMedium",
            sw * 0.5, sh * 0.8,
            Color(0, 162, 255, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
    end)
end)

function MODE:RenderScreenspaceEffects()
    if StartTime + 7.5 < CurTime() then return end
    local fade = math.Clamp(StartTime + 7.5 - CurTime(), 0, 1)

    surface.SetDrawColor(0, 0, 0, 255 * fade)
    surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
end

function MODE:HUDPaint()
    if not lply:Alive() then return end

    local fade = 1
    if StartTime + 8 > CurTime() then
        fade = math.Clamp(StartTime + 8 - CurTime(), 0, 1)
    end

    if StartTime + 8 > CurTime() then
        draw.SimpleText(
            "ZCity | Sandbox",
            "ZB_HomicideMediumLarge",
            sw * 0.5, sh * 0.1,
            Color(0, 162, 255, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "You are a Player",
            "ZB_HomicideMediumLarge",
            sw * 0.5, sh * 0.5,
            Color(0, 162, 255, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "The freedom...",
            "ZB_HomicideMedium",
            sw * 0.5, sh * 0.9,
            Color(200, 200, 200, 255 * fade),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )
    end
end

function MODE:PostDrawTranslucentRenderables(bDepth, bSkybox, isDraw3DSkybox)
    if bSkybox or isDraw3DSkybox then return end
    if zb.CROUND ~= "sandbox" then return end

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
        render.SetColorModulation(1, 0.15, 0.15)
        render.SetBlend(0.45 * eased)
        render.DrawSphere(pos, spawnOrbRadius, 30, 30, color_white)
        render.SetBlend(1)
        render.SetColorModulation(1, 1, 1)
    end
end

net.Receive("sandbox_end", function()
    local ent = net.ReadEntity()
    if IsValid(ent) then
        ent.won = true
    end
end)

function MODE:RoundStart()
    for _, ply in player.Iterator() do
        ply.won = nil
    end
end