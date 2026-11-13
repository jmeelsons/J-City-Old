--
----
local PANEL = {}
--[[
hg.VGUI.SecondaryColor = Color(155,0,0,240)
hg.VGUI.BackgroundColor = Color(25,25,35,220)]]
local color_blacky = Color(25,25,30,220)
local color_reddy = Color(155,0,0,240)

local xbars = 17
local ybars = 30
local gradient_d = Material("vgui/gradient-d")
local gradient_u = Material("vgui/gradient-u")
local gradient_l = Material("vgui/gradient-l")
local gradient_r = Material("vgui/gradient-r")

function PANEL:Init()
    self.Itensens = {}
    self:SetAlpha( 0 )
    self:SetTitle( "" )

    self.DrawBorder = true

    self.ColorBG = Color(color_blacky:Unpack())
    self.ColorBR = Color(color_reddy:Unpack())
    self.BlurStrengh = 2

    self.AnimTime = 0
    self.EnableBackgroundAnimation = true
    self.BackgroundLineColor = Color(107, 107, 107, 20)

    timer.Simple(0,function()
        if self.First then
            self:First()
        end
    end)
end

function PANEL:Paint(w,h)
    if self.EnableBackgroundAnimation then
        self.AnimTime = self.AnimTime or 0
        self.AnimTime = self.AnimTime + FrameTime()

        draw.RoundedBox(0, 0, 0, w, h, self.ColorBG)

        surface.SetDrawColor(self.BackgroundLineColor)
        local sw, sh = ScrW(), ScrH()
        
        for i = 1, (ybars + 1) do
            local xPos = (sw / ybars) * i - (self.AnimTime * 30 % (sw / ybars))
            surface.DrawRect(xPos, 0, ScreenScale(1), sh)
        end

        for i = 1, (xbars + 1) do
            local yPos = (sh / xbars) * (i - 1) + (self.AnimTime * 30 % (sh / xbars))
            surface.DrawRect(0, yPos, sw, ScreenScale(1))
        end

        local border_size = 5
        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(gradient_l)
        surface.DrawTexturedRect(0, 0, border_size, sh)
        
    else
        draw.RoundedBox(0, 0, 0, w, h, self.ColorBG)
    end

    hg.DrawBlur(self, self.BlurStrengh)

    if self.DrawBorder then
        surface.SetDrawColor(self.ColorBR)
        surface.DrawOutlinedRect(0, 0, w, h, 1.5)
    end
end

function PANEL:SetBorder( bDraw )
    self.DrawBorder = bDraw
end

function PANEL:SetColorBG( cColor )
    self.ColorBG = cColor
end

function PANEL:SetColorBR( cColor )
    self.ColorBR = cColor
end

function PANEL:SetBlurStrengh( floatVal )
    self.BlurStrengh = floatVal
end

function PANEL:SetBackgroundAnimationEnabled( bEnabled )
    self.EnableBackgroundAnimation = bEnabled
end

function PANEL:SetBackgroundLineColor( cColor )
    self.BackgroundLineColor = cColor
end

function PANEL:First( ply )
    self:SetY(self:GetY() + self:GetTall())
    self:MoveTo(self:GetX(), self:GetY() - self:GetTall(), 0.4, 0, 0.2, function() end)
    self:AlphaTo( 255, 0.2, 0.1, nil )

    if self.PostInit then
        self:PostInit()
    end
end

function PANEL:Close()
    if self.Closing then return end
    self.Closing = true
    self:MoveTo(self:GetX(), ScrH() / 2 + self:GetTall(), 5, 0, 0.3, function()
    end)
    self:AlphaTo( 0, 0.2, 0, function() 
        if self.OnClose then self:OnClose() end 
        self:Remove() 
    end)
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
end

vgui.Register( "ZFrame", PANEL, "DFrame")

