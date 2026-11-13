if SERVER then return end

local gradient_d = Material("vgui/gradient-d")
local SpectateHideNick = false
local keyOld = false

local AvatarPanels = {}
local hasVRMod = vrmod and vrmod.IsPlayerInVR ~= nil

local function GetOrCreateAvatar(ply)
    if not IsValid(ply) then return nil end
    
    local sid64 = ply:SteamID64()
    if not sid64 then return nil end
    
    local pnl = AvatarPanels[sid64]
    if IsValid(pnl) then
        return pnl
    end
    
    local avatar = vgui.Create("AnimatedAvatarImage") -- or vgui.Create("AvatarImage")
    if not IsValid(avatar) then return nil end
    
    avatar:SetSize(64, 64)
    avatar:SetPlayer(ply, 64)
    avatar:SetVisible(false)
    avatar:SetMouseInputEnabled(false)
    avatar:SetKeyboardInputEnabled(false)
    avatar:SetParent(nil)
    
    AvatarPanels[sid64] = avatar
    return avatar
end

hook.Add("PlayerDisconnected", "ZCity_Spectate_Avatar_Cleanup", function(ply)
    local sid64 = ply:SteamID64()
    if not sid64 then return end
    local pnl = AvatarPanels[sid64]
    if IsValid(pnl) then
        pnl:Remove()
    end
    AvatarPanels[sid64] = nil
end)

net.Receive("ZCity_Spectator_Health_Sync", function()
    local count = net.ReadUInt(8)
    for i = 1, count do
        local ply = net.ReadEntity()
        local health = net.ReadFloat()
        if IsValid(ply) then
            ply.ZCitySpectatorHealth = health
        end
    end
end)

hook.Add("HUDPaint", "ZCity_Spectate_ALT_ESP", function()
    local lply = LocalPlayer()
    
    if lply:Alive() and lply:GetObserverMode() == OBS_MODE_NONE then
        for _, pnl in pairs(AvatarPanels) do
            if IsValid(pnl) then pnl:SetVisible(false) end
        end
        return
    end

    local key = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT)
    if keyOld ~= key and key then 
        SpectateHideNick = not SpectateHideNick 
    end 
    keyOld = key 

    local visibleSids = {}

    if not SpectateHideNick then 
        for _, v in ipairs(player.GetAll()) do
            if not v:Alive() or v == lply then continue end 

            local ent = IsValid(v:GetNWEntity("Ragdoll")) and v:GetNWEntity("Ragdoll") or v 
            local screenPosition = ent:GetPos():ToScreen() 
            local x, y = screenPosition.x, screenPosition.y 
            
            if x < -200 or x > ScrW() + 200 or y < -200 or y > ScrH() + 200 then
                continue
            end

            local teamColor = v:GetPlayerColor():ToColor() 
            local distance = lply:GetPos():Distance(v:GetPos()) 
            local factor = 1 - math.Clamp(distance / 1024, 0, 1) 
            local alpha = math.max(255 * factor, 80) 

            local steamID64 = v:SteamID64() or "BOT"
            local steamIDText = tostring(steamID64)
            local text = v:Name() 

            local avatarSize = math.max(24, math.floor(64 * factor))

            surface.SetFont("ZCity_Tiny") 
            local tw, th = surface.GetTextSize(text) 
            local sw, sh = surface.GetTextSize(steamIDText) 

            local totalHeight = avatarSize + th + sh + 6
            local startY = y - totalHeight / 2
            local centerX = x

            local avatarX = centerX - avatarSize / 2
            local avatarY = startY

            visibleSids[steamID64] = true

            local avatar = GetOrCreateAvatar(v)
            if IsValid(avatar) then
                avatar:SetSize(avatarSize, avatarSize)
                avatar:SetPos(avatarX, avatarY)
                avatar:SetAlpha(alpha)
                avatar:SetVisible(true)
            else
                surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha)
                surface.DrawRect(avatarX, avatarY, avatarSize, avatarSize)
            end

            surface.SetFont("ZCity_Tiny")
            surface.SetTextColor(255, 255, 255, alpha)
            surface.SetTextPos(centerX - tw / 2, avatarY + avatarSize + 2)
            surface.DrawText(text)

            surface.SetTextColor(200, 200, 200, alpha * 0.8)
            surface.SetTextPos(centerX - sw / 2, avatarY + avatarSize + th + 4)
            surface.DrawText(steamIDText)

            if hasVRMod and vrmod.IsPlayerInVR(v) then
                local vrText = "[VR]"
                local vw, vh = surface.GetTextSize(vrText)
                surface.SetTextColor(0, 255, 128, alpha)
                surface.SetTextPos(centerX - vw / 2, avatarY - vh - 4)
                surface.DrawText(vrText)
            end
        end 
    end

    for sid64, pnl in pairs(AvatarPanels) do
        if IsValid(pnl) and not visibleSids[sid64] then
            pnl:SetVisible(false)
        end
    end
end)

hook.Add("Think", "ZCity_Spectate_Avatar_Hide", function()
    local lply = LocalPlayer()
    if not IsValid(lply) then return end
    
    local shouldShow = (not lply:Alive() or lply:GetObserverMode() ~= OBS_MODE_NONE) and not SpectateHideNick
    
    if not shouldShow then
        for _, pnl in pairs(AvatarPanels) do
            if IsValid(pnl) and pnl:IsVisible() then
                pnl:SetVisible(false)
            end
        end
    end
end)