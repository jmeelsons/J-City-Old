local cvEnabled = GetConVar("hg_handsgrab") or CreateClientConVar("hg_handsgrab", "1", true, false, "Enable Hands Grab mod", 0, 1)
local cvStamina = GetConVar("hg_handsgrab_stamina") or CreateClientConVar("hg_handsgrab_stamina", "1", true, false, "Enable stamina", 0, 1)
local cvShaking = GetConVar("hg_handsgrab_shaking") or CreateClientConVar("hg_handsgrab_shaking", "1", true, false, "Enable shaking", 0, 1)
--local cvSkin = GetConVar("hg_handsgrab_skin") or CreateClientConVar("hg_handsgrab_skin", "0", true, false, "Hands emoji skin (0 = default, 1 = hands grab 2)", 0, 1)

local materialPacks = {
    [0] = { left = "hand_r.png", right = "hand.png" }
}

local matHandLeft, matHandRight

local function UpdateMaterials()
    local pack = materialPacks[0]
    matHandLeft = Material(pack.left, "smooth nocull")
    matHandRight = Material(pack.right, "smooth nocull")
end

local deadZoneRatio = 0.12
local lhAlpha, rhAlpha = 0, 0
local lhScreenPos, rhScreenPos = Vector(0, 0, 0), Vector(0, 0, 0)
local lhVisible, rhVisible = true, true

local function GetHandBonePos(ply, hand)
    local rag = ply.FakeRagdoll
    if not IsValid(rag) then return nil end

    local boneName = hand == "left" and "ValveBiped.Bip01_L_Hand" or "ValveBiped.Bip01_R_Hand"
    local bone = rag:LookupBone(boneName)
    if not bone then return nil end

    local m = rag:GetBoneMatrix(bone)
    if not m then return nil end

    local pos = m:GetTranslation()
    local ang = m:GetAngles()
    local forward = ang:Forward()

    pos = pos + forward * 3

    return pos
end

local function IsPlayerInVehicle()
    local ply = LocalPlayer()
    if not IsValid(ply) then return false end
    
    local vehicle = ply:GetVehicle()
    return IsValid(vehicle)
end

local function WorldToScreenInfo(pos3D)
    local pos2D = pos3D:ToScreen()
    local x, y = pos2D.x, pos2D.y
    local sw, sh = ScrW(), ScrH()
    local onScreen = x >= 0 and x <= sw and y >= 0 and y <= sh
    return x, y, onScreen
end

local function ClampToSafeZone(x, y, size)
    local sw, sh = ScrW(), ScrH()
    local dzX = sw * deadZoneRatio
    local dzY = sh * deadZoneRatio
    local minX = dzX + size
    local maxX = sw - dzX - size
    local minY = dzY + size
    local maxY = sh - dzY - size

    x = math.Clamp(x, minX, maxX)
    y = math.Clamp(y, minY, maxY)
    return x, y
end

local function GetEdgePos(screenX, screenY, size)
    local sw, sh = ScrW(), ScrH()
    local cx, cy = sw * 0.5, sh * 0.5
    local dx, dy = screenX - cx, screenY - cy

    if dx == 0 and dy == 0 then return cx, cy end

    local dzX = sw * deadZoneRatio
    local dzY = sh * deadZoneRatio
    local minX = dzX + size
    local maxX = sw - dzX - size
    local minY = dzY + size
    local maxY = sh - dzY - size

    local tx = (dx > 0) and (maxX - cx) / dx or (minX - cx) / dx
    local ty = (dy > 0) and (maxY - cy) / dy or (minY - cy) / dy
    local t = math.min(math.abs(tx), math.abs(ty))

    local edgeX = cx + dx * t
    local edgeY = cy + dy * t

    edgeX = math.Clamp(edgeX, minX, maxX)
    edgeY = math.Clamp(edgeY, minY, maxY)

    return edgeX, edgeY
end

local function GetStaminaRatio()
    local ply = LocalPlayer()
    if not IsValid(ply) then return 1 end

    local org = ply.organism
    if not org or not org.stamina or org.stamina.max == 0 then return 1 end

    return math.Clamp(org.stamina[1] / org.stamina.max, 0, 1)
end

local function GetStaminaColor(alpha)
    if not cvStamina:GetBool() then return Color(255, 255, 255, alpha) end

    local ratio = GetStaminaRatio()
    local g = math.floor(255 * ratio)
    local b = math.floor(255 * ratio)

    return Color(255, g, b, alpha)
end

local function GetStaminaJitter(s)
    if not cvShaking:GetBool() then return 0 end

    local ratio = GetStaminaRatio() * 100

    if ratio > 75 then
        return 0
    elseif ratio > 40 then
        return 0.1 * s
    elseif ratio > 30 then
        return 0.2 * s
    end
    return 0.3 * s
end

local function DrawHand()
    if not cvEnabled:GetBool() then return end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    if IsPlayerInVehicle() then
        lhAlpha = 0
        rhAlpha = 0
        return
    end

    if not matHandLeft or not matHandRight then
        UpdateMaterials()
        if not matHandLeft or not matHandRight then
            return -- Still nil? Exit to avoid error btw
        end
    end

    local inFake = IsValid(ply.FakeRagdoll)
    if not inFake then
        lhAlpha = 0
        rhAlpha = 0
        return
    end

    local size = ScrH() * 0.035
    local lhGrab = ply:GetNWBool("HG_LHandGrab", false)
    local rhGrab = ply:GetNWBool("HG_RHandGrab", false)

    lhAlpha = Lerp(0.12, lhAlpha, lhGrab and 255 or 0)
    rhAlpha = Lerp(0.12, rhAlpha, rhGrab and 255 or 0)

    if lhAlpha > 1 then
        local pos3D = GetHandBonePos(ply, "left")
        if pos3D then
            local x, y, onScreen = WorldToScreenInfo(pos3D)
            if onScreen then
                x, y = ClampToSafeZone(x, y, size)
                lhScreenPos.x = x
                lhScreenPos.y = y
                lhVisible = true
            else
                x, y = GetEdgePos(x, y, size)
                lhScreenPos.x = x
                lhScreenPos.y = y
                lhVisible = false
            end
        end
    end

    if rhAlpha > 1 then
        local pos3D = GetHandBonePos(ply, "right")
        if pos3D then
            local x, y, onScreen = WorldToScreenInfo(pos3D)
            if onScreen then
                x, y = ClampToSafeZone(x, y, size)
                rhScreenPos.x = x
                rhScreenPos.y = y
                rhVisible = true
            else
                x, y = GetEdgePos(x, y, size)
                rhScreenPos.x = x
                rhScreenPos.y = y
                rhVisible = false
            end
        end
    end

    if lhAlpha > 1 then
        surface.SetMaterial(matHandLeft)
        surface.SetDrawColor(GetStaminaColor(lhAlpha))
        local jitter = GetStaminaJitter(size)
        local jx = jitter > 0 and math.random(-jitter, jitter) or 0
        local jy = jitter > 0 and math.random(-jitter, jitter) or 0
        surface.DrawTexturedRect(lhScreenPos.x - size + jx, lhScreenPos.y - size + jy, size * 2, size * 2)
    end

    if rhAlpha > 1 then
        surface.SetMaterial(matHandRight)
        surface.SetDrawColor(GetStaminaColor(rhAlpha))
        local jitter = GetStaminaJitter(size)
        local jx = jitter > 0 and math.random(-jitter, jitter) or 0
        local jy = jitter > 0 and math.random(-jitter, jitter) or 0
        surface.DrawTexturedRect(rhScreenPos.x - size + jx, rhScreenPos.y - size + jy, size * 2, size * 2)
    end
end

hook.Add("HUDPaint", "HG_DrawHandEmoji", DrawHand)

local order = {"hg_handsgrab", "hg_handsgrab_stamina", "hg_handsgrab_shaking"}

--[[
local function RegisterHandsGrabSettings()
    if not hg or not hg.settings or not hg.settings.AddOpt then
        timer.Simple(0.1, RegisterHandsGrabSettings)
        return
    end

    for _, categoryTable in pairs(hg.settings.tbl) do
        if categoryTable["hg_handsgrab"] then
            categoryTable["hg_handsgrab"][3] = "Hands Grab"
            categoryTable["hg_handsgrab_stamina"][3] = "Stamina Effect"
            categoryTable["hg_handsgrab_shaking"][3] = "Shaking Effect"
            categoryTable["hg_handsgrab_skin"][3] = "Hands Skin"
            categoryTable._order = order
            return
        end
    end

    hg.settings:AddOpt("Hands grab", "hg_handsgrab", "Hands Grab")
    hg.settings:AddOpt("Hands grab", "hg_handsgrab_stamina", "Stamina Effect")
    hg.settings:AddOpt("Hands grab", "hg_handsgrab_shaking", "Shaking Effect")
    hg.settings:AddOpt("Hands grab", "hg_handsgrab_skin", "Hands Skin")

    local cat = hg.settings.tbl["Hands grab"]
    if not cat then return end
    cat._order = order

    local sw, sh = ScrW(), ScrH()
    local gradient_l = Material("vgui/gradient-l")
    local blur = Material("pp/blurscreen")

    hg.DrawSettings = function(ParentPanel)
        ParentPanel:SetAlpha(0)
        ParentPanel.Paint = function(self,w,h)
            surface.SetDrawColor(28,28,28,255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(107, 107, 107,20)
            for i = 1, 31 do
                surface.DrawRect((sw / 30) * i - (CurTime() * 30 % (sw / 30)), 0, ScreenScale(1), sh)
            end
            for i = 1, 18 do
                surface.DrawRect(0, (sh / 17) * (i - 1) + (CurTime() * 30 % (sh / 17)), sw, ScreenScale(1))
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
        pppanel3.Paint = function()end

        local yOffset = pppanel3:GetTall()/100

        for categoryName, categoryTable in pairs(hg.settings.tbl) do
            local category = hg.CreateCategory(categoryName, pppanel3, yOffset)
            yOffset = yOffset + category:GetTall() + 12
            local convars = categoryTable._order
            if convars then
                for _, convarName in ipairs(convars) do
                    local settingData = categoryTable[convarName]
                    if not settingData then continue end
                    local vbv = hg.CreateButton(settingData, convarName, pppanel3, yOffset)
                    if not vbv then continue end
                    yOffset = yOffset + (vbv:GetTall()) + 12
                end
            else
                for convarName, settingData in pairs(categoryTable) do
                    local vbv = hg.CreateButton(settingData, convarName, pppanel3, yOffset)
                    if not vbv then continue end
                    yOffset = yOffset + (vbv:GetTall()) + 12
                end
            end
        end
        local pppanel23 = vgui.Create('DPanel', pppanel3)
        pppanel23:SetSize(0, 0)
        pppanel23:SetPos(0,yOffset+12)
    end
end

timer.Simple(0, RegisterHandsGrabSettings)]]