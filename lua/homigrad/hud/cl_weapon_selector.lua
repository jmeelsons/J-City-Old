--
hg = hg or {}
hg.WeaponSelector = hg.WeaponSelector or {}
local WS = hg.WeaponSelector

local furryColor1 = Color(121, 97, 217)
local furryColor2 = Color(187, 187, 255)
local furryColor3 = Color(164, 171, 235)

function WS.GetPrintName( self )
	local class = self:GetClass()
	local phrase = language.GetPhrase(class)
	return phrase ~= class and phrase or self:GetPrintName()
end

WS.Show = 0
WS.Transparent = 0
WS.LastSelectedSlot = 0
WS.LastSelectedSlotPos = 0

WS.SelectedSlot = 0
WS.SelectedSlotPos = 0

if CLIENT then
    surface.CreateFont("ZB_ProotLarge_WS", {
        font = "Ari-W9500",
        size = ScreenScale(10),
        extended = true,
        weight = 400,
        antialias = true
    })

    surface.CreateFont("ZB_ProotLarge2_WS", {
        font = "Ari-W9500",
        size = ScreenScale(8),
        extended = true,
        weight = 400,
        antialias = true
    })

    surface.CreateFont("ZB_ProotOSHUD_WS", {
        font = "Ari-W9500",
        size = ScreenScale(25),
        extended = true,
        weight = 400,
    })

    surface.CreateFont("ZB_ProotOSMedium_WS", {
        font = "Ari-W9500",
        size = ScreenScale(6),
        extended = true,
        weight = 500,
        antialias = true
    })
end

function WS.DrawText(text, font, posX, posY, color, textAlign, isFurry)
    if isFurry then
        draw.SimpleText(text, font, posX + 2, posY + 2, ColorAlpha(color_black, color.a), textAlign)
        draw.SimpleText(text, font, posX, posY, ColorAlpha(color, color.a), textAlign)
    else
        draw.DrawText(text, font, posX + 2, posY + 2, ColorAlpha(color_black, color.a), textAlign)
        draw.DrawText(text, font, posX, posY, ColorAlpha(color, color.a), textAlign)
    end
end

function WS.GetSelectedWeapon()
    if not IsValid( LocalPlayer() ) or not LocalPlayer():Alive() then return end
    local Weapons = WS.GetWeaponTable( LocalPlayer() )
    return Weapons[WS.SelectedSlot] and Weapons[WS.SelectedSlot][WS.SelectedSlotPos] or Weapons[WS.LastSelectedSlot][WS.LastSelectedSlotPos] or Weapons[0][0]
end

function WS.GetWeaponTable( ply )
    if not IsValid( ply ) or not ply:Alive() then return end
    local WeaponsGet = ply:GetWeapons()
    local FormatedTable = {
        [0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {},
    }

    table.sort(WeaponsGet, function(a, b) return (a.SlotPos or 0) > (b.SlotPos or 0) end)

    for k,wep in ipairs(WeaponsGet) do
        local tTbl = FormatedTable[wep.Slot or 0]
        local iMinPos = math.min( (wep.SlotPos and wep.SlotPos) or 1, ((#tTbl or 0) + 1)) - 1
        local iPos = tTbl[ iMinPos ] and #tTbl + 1 or iMinPos
        tTbl[ iPos ] = wep
    end
    return FormatedTable
end

local scrW, scrH = ScrW(), ScrH()

local AcsentColor = Color(155,0,0)
local gradient_u = Material("vgui/gradient-d")

local function GetFurryColor(alpha)
    local ply = LocalPlayer()
    if ply and ply:IsPlayer() and ply.PlayerClassName == "furry" then
        local pulse = math.sin(CurTime() * 3) * 0.2 + 0.8
        return Color(
            furryColor1.r * pulse,
            furryColor1.g * pulse,
            furryColor1.b * pulse,
            alpha
        )
    end
    return AcsentColor
end

local function GetFurryFont(size)
    local ply = LocalPlayer()
    if ply and ply:IsPlayer() and ply.PlayerClassName == "furry" then
        if size == "large" then
            return "ZB_ProotLarge_WS"
        elseif size == "medium" then
            return "ZB_ProotOSMedium_WS"
        elseif size == "hud" then
            return "ZB_ProotOSHUD_WS"
        else
            return "ZB_ProotLarge2_WS"
        end
    end
    return "HomigradFontMedium"
end

function WS.WeaponSelectorDraw( ply )
    if not IsValid( ply ) or not ply:Alive() or GetGlobalBool("RadialInventory", false) then return end
    if WS.Show < CurTime() then 
        WS.SelectedSlot = WS.LastSelectedSlot 
        WS.SelectedSlotPos = -1
        
        return 
    end
    local Weapons = WS.GetWeaponTable( ply )
    local SelectedWep = WS.GetSelectedWeapon()
    if not IsValid(SelectedWep) then return end
    WS.Transparent = LerpFT( 0.2, WS.Transparent, math.min( WS.Show - CurTime(), 1 ) )
    
    local SuperAmmout = 0
    local AmmoutSlots = 0
    for i = 0, #Weapons do
        local slotTbl = Weapons[i]
        if table.Count(slotTbl) < 1 then continue end
        AmmoutSlots = AmmoutSlots + 1
    end

    local isFurry = ply.PlayerClassName == "furry"
    local currentColor = isFurry and GetFurryColor(WS.Transparent*255) or AcsentColor
    
    local slotFont = isFurry and "ZB_ProotLarge_WS" or "HomigradFontMedium"
    local weaponFont = isFurry and "ZB_ProotOSMedium_WS" or "HomigradFontSmall"

    for i = 0, #Weapons do
        local slotTbl = Weapons[i]
        if table.Count(slotTbl) < 1 then continue end
        local sizeX = scrW*0.1
        local position = scrW/2 + ( ( SuperAmmout -  (AmmoutSlots/2)) * sizeX )
        
        local slotTextColor = isFurry and furryColor2 or color_white
        WS.DrawText( i+1, slotFont, position + sizeX/2, scrH*0.02, ColorAlpha(slotTextColor,WS.Transparent*255) ,TEXT_ALIGN_CENTER, isFurry )
        
        local Ammout = 0
        local lastPos = 0
        for Id = 0, #slotTbl do
            wepId = Id
            local wep = slotTbl[wepId]
            if not wep then continue end
            
            local sizeH = SelectedWep == wep and (scrH *0.12) or (scrH *0.025)
            local LastSelected = 0
            if slotTbl[wepId-1] and SelectedWep == slotTbl[wepId-1] then
                lastPos = (scrH *0.095) 
            end
            
            local bgColor = isFurry and ColorAlpha(Color(50, 40, 80), WS.Transparent*205) or ColorAlpha(color_black, WS.Transparent*205)
            draw.RoundedBox(
                0,
                position,
                (scrH * 0.025) * (Ammout) + (scrH * 0.05) + lastPos,
                sizeX,
                sizeH, 
                bgColor
            )
            
            draw.RoundedBox(
                0,
                position,
                ((scrH * 0.025) * (Ammout) + (scrH * 0.05) + lastPos) + sizeH-2,
                sizeX,
                2, 
                bgColor
            )
            
            surface.SetDrawColor( currentColor.r, currentColor.g, currentColor.b, WS.Transparent*( SelectedWep == wep and 200 or 0 )  )
            surface.SetMaterial( gradient_u )
            surface.DrawTexturedRect( position, (scrH * 0.025) * (Ammout) + (scrH * 0.05) + lastPos, sizeX, sizeH )
            
            if SelectedWep == wep then
                local outlineColor = isFurry and furryColor3 or Color(255, 0, 0)
                surface.SetDrawColor( outlineColor.r, outlineColor.g, outlineColor.b, WS.Transparent*155 )
	            surface.DrawOutlinedRect( position, (scrH * 0.025) * (Ammout) + (scrH * 0.05) + lastPos, sizeX, sizeH, 2 )
            end
            
            local sizeHi = (scrH *0.025) * (Ammout) + (scrH * 0.05) + lastPos
            sizeHi = sizeHi + 2.5
            
            local textColor = isFurry and furryColor2 or color_white
            WS.DrawText( WS.GetPrintName(wep), weaponFont, position + sizeX/2, sizeHi, ColorAlpha(textColor,WS.Transparent*255) ,TEXT_ALIGN_CENTER, isFurry )
            
            Ammout = Ammout + 1

            if SelectedWep == wep and wep.DrawWeaponSelection then
                wep:DrawWeaponSelection(position + 5, (scrH * 0.025) * (Ammout) + (scrH * 0.055) + lastPos, sizeX - 10, sizeH, WS.Transparent*255)
            end
        end
        SuperAmmout = SuperAmmout + 1
    end
end

local tAcceptKeys = {
    ["slot1"] = 1,
    ["slot2"] = 2,
    ["slot3"] = 3,
    ["slot4"] = 4,
    ["slot5"] = 5,
    ["slot6"] = 6,
}

local function GetUpper(Weapons)
    if #LocalPlayer():GetWeapons() < 1 then return end
    WS.SelectedSlot = WS.SelectedSlot < 0 and #Weapons or WS.SelectedSlot - 1
    WS.SelectedSlotPos = Weapons[WS.SelectedSlot] and #Weapons[WS.SelectedSlot] or 0

    if Weapons[WS.SelectedSlot] == nil or Weapons[WS.SelectedSlot][WS.SelectedSlotPos] == nil then
        GetUpper(Weapons)
    end
end

local function GetDown(Weapons)
    if #LocalPlayer():GetWeapons() < 1 then return end
    WS.SelectedSlot = WS.SelectedSlot > #Weapons and 0 or WS.SelectedSlot + 1
    WS.SelectedSlotPos = 0

    if Weapons[WS.SelectedSlot] == nil or Weapons[WS.SelectedSlot][WS.SelectedSlotPos] == nil then
        GetDown(Weapons)
    end
end

local LastSelected = 0

local function get_active_tool(ply, tool)
    local activeWep = ply:GetActiveWeapon()
    if not IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end
    return activeWep:GetToolObject(tool)
end

local function canUseSelector(ply)
    local wep = ply:GetActiveWeapon()
    local tool = get_active_tool(ply, "submaterial")
    if tool and IsValid(ply:GetEyeTraceNoCursor().Entity) then
        return true
    end

    return IsAiming(ply) or (IsValid(wep) and wep:GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) or (lply.organism and lply.organism.pain and lply.organism.pain > 100) or GetGlobalBool("RadialInventory", false)
end

function WS.ChangeSelectionWep( ply, key )
    if not IsValid( ply ) or not ply:Alive() or GetGlobalBool("RadialInventory", false) then return end
    if ply.organism and ply.organism.otrub then return end
    if canUseSelector( ply ) then return end
    
    local iPos = tAcceptKeys[ key ]
    if iPos or key == "invnext" or key == "invprev" or key == "lastinv" then

        local Weapons = WS.GetWeaponTable( ply )

        WS.Show = CurTime() + 4
        
        surface.PlaySound("arc9_eft_shared/weapon_generic_rifle_spin"..math.random(10)..".ogg")
        
        if iPos then
            iPos = iPos - 1
            if LastSelected ~= iPos then 
                WS.SelectedSlotPos = -1
            end
            WS.SelectedSlotPos = (Weapons[iPos] and LastSelected == iPos and WS.SelectedSlotPos + 1 > #Weapons[iPos] and 0 or math.min( WS.SelectedSlotPos + 1, #Weapons[iPos] )) or 0
            WS.SelectedSlot = iPos
            LastSelected = iPos
        elseif key == "invprev" then
            WS.SelectedSlotPos = WS.SelectedSlotPos - 1
            if Weapons[WS.SelectedSlot] and WS.SelectedSlotPos < 0  then
                GetUpper(Weapons)
            end
        elseif key == "invnext" then
            WS.SelectedSlotPos = WS.SelectedSlotPos + 1
            if Weapons[WS.SelectedSlot] and WS.SelectedSlotPos > #Weapons[WS.SelectedSlot] then
                GetDown(Weapons)
            end
        elseif key == "lastinv" and IsValid(WS.LastInv) then
            WS.Show = 0
            WS.LastInv = WS.LastInv or "weapon_hands_sh"
            local oldwep = ply:GetActiveWeapon()
            input.SelectWeapon( WS.LastInv )
            WS.LastInv = oldwep
        end

    end
end

function WS.SetActuallyWeapon( ply, cmd )
    if not IsValid( ply ) or not ply:Alive() or GetGlobalBool("RadialInventory", false) then return end
    if (cmd:KeyDown( IN_ATTACK ) or cmd:KeyDown( IN_ATTACK2 )) and WS.Show > CurTime() then

        if WS.Selected and WS.Selected > CurTime() then 
            cmd:RemoveKey(IN_ATTACK) 
            cmd:RemoveKey(IN_ATTACK2) 
        else
            cmd:RemoveKey(IN_ATTACK)
            cmd:RemoveKey(IN_ATTACK2) 
            
            if IsValid(WS.GetSelectedWeapon()) then
                WS.LastInv = WS.LastInv ~= ply:GetActiveWeapon() and WS.LastInv or ply:GetActiveWeapon()
                input.SelectWeapon( WS.GetSelectedWeapon() )
            end
            cmd:RemoveKey(IN_ATTACK)
            cmd:RemoveKey(IN_ATTACK2) 

            WS.LastSelectedSlot = WS.SelectedSlot
            WS.LastSelectedSlotPos = WS.SelectedSlotPos
            WS.Selected = CurTime() + 0.2
            WS.Show = CurTime() + 0.2
            
            surface.PlaySound("arc9_eft_shared/weapon_generic_spin"..math.random(1,10)..".ogg")
        end
    end
end

hook.Add( "PlayerBindPress", "WeaponSelector_PlayerBindPress", WS.ChangeSelectionWep )
hook.Add( "HUDPaint", "WeaponSelector_Draw", function()
    WS.WeaponSelectorDraw( LocalPlayer() )
end)
hook.Add( "StartCommand", "WeaponSelector_StartCommand", WS.SetActuallyWeapon )

local tHideElements = {
    ["CHudWeaponSelection"] = true
}

hook.Add("HUDShouldDraw", "WeaponSelector_HUDShouldDraw", function(sElementName)
    if tHideElements[sElementName] then return false end
end)

-- Я ТАК ЗАДОЛБАЛСЯ ПРОСТО УБЕЙТЕ МЕНЯ ХАХАХАХАХАХАХАХАХАХААХАХАХАХАХАХА
-- ПОЛЧАСА Я ПЫТАЛСЯ СДЕЛАТЬ НОРМЛАЬНОЕ ПЕРЕКЛЮЧЕНИЕ ГОВНА!!!
-- ЗАТО ПОЛУЧИЛОСЬ!!!!
-- УЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
--[[
    /\_/\
    |_ _|
    |   |__
   /_|_____\ -- IT'S SO OVER
--]]