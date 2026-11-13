--
local PANEL = {}

local Statics = {
    {"Kills", "Kills"},
    {"Suicides", "Suicides"},
    {"Deaths", "Deaths"},
    --{"Victories being a traitor", "zb_hmcd_t_wins"},
   -- {"Neutralizings a traitor", "zb_hmcd_ino_t_kills"}
}

function PANEL:Init()
    self:SetSize(ScrW()/2,ScrH()*0.6)
    self:Center()
    
    self.MainInfo = vgui.Create("ZB_ExpPanel",self)
    local MInfo = self.MainInfo
    MInfo:Dock(LEFT)
    MInfo:SetSize(self:GetWide()*0.35,self:GetTall())

    self.SecInfo = vgui.Create( "DPropertySheet", self )
    local SInfo = self.SecInfo
    SInfo:Dock( FILL )

    local panel1 = vgui.Create( "DScrollPanel", SInfo )
    self.StatPanel = panel1
    function panel1:Paint() end

    SInfo:AddSheet( "Statistics", panel1, "icon16/chart_bar.png" )
end
--
--function PANEL:SetPlayer(ply)
--    self.MainInfo:SetPlayer(ply)
--    self.MainInfo.PlyLabel:SetText( ply:Nick() )
--
--    self.StatPanel:Clear()
--    self.StatItems = {}
--
--    local totalTime = 0
--    if ply.GetUTimeTotalTime then
--        local ok, result = pcall(ply.GetUTimeTotalTime, ply)
--        if ok and result then
--            totalTime = result
--        end
--    end
--
--    local timeLabel = vgui.Create("DLabel", self.StatPanel)
--    timeLabel:SetText( "Player Time: " .. self:FormatTime(totalTime) )
--    timeLabel:Dock(TOP)
--    timeLabel:DockMargin(5,5,5,5)
--    timeLabel:SetSize(0,self:GetTall()*0.05)
--    timeLabel:SetFont("ZB_InterfaceMedium")
--    table.insert(self.StatItems, timeLabel)
--
--    for i,stats in pairs(Statics) do
--        self.StatPanel[i] = vgui.Create("DLabel",self.StatPanel)
--        local Stat = self.StatPanel[i]
--        Stat:SetText( stats[1]..": "..ply:GetStatVal(stats[2], 0) )
--        Stat:Dock(TOP)
--        Stat:DockMargin(5,5,5,5)
--        Stat:SetSize(0,self:GetTall()*0.05)
--        Stat:SetFont("ZB_InterfaceMedium")
--        table.insert(self.StatItems, Stat)
--    end
--end
--
--function PANEL:Udpate(ply)
--    self:Update(ply)
--end
--
--function PANEL:Update(ply)
--    if not IsValid(ply) then return end
--
--    if self.StatItems and self.StatItems[1] and IsValid(self.StatItems[1]) then
--        local totalTime = 0
--        if ply.GetUTimeTotalTime then
--            local ok, result = pcall(ply.GetUTimeTotalTime, ply)
--            if ok and result then
--                totalTime = result
--            end
--        end
--        self.StatItems[1]:SetText( "Player Time: " .. self:FormatTime(totalTime) )
--    end
--
--    local statIndex = 2
--    for i,stats in pairs(Statics) do
--        if self.StatItems and self.StatItems[statIndex] and IsValid(self.StatItems[statIndex]) then
--            self.StatItems[statIndex]:SetText( stats[1]..": "..(ply.SvDB and ply.SvDB[ stats[2] ] or 0) )
--        end
--        statIndex = statIndex + 1
--    end
--end
--
--function PANEL:FormatTime(seconds)
--    seconds = math.floor(seconds)
--    local days = math.floor(seconds / 86400)
--    local hours = math.floor((seconds % 86400) / 3600)
--    local minutes = math.floor((seconds % 3600) / 60)
--    local secs = seconds % 60
--    
--    if days > 0 then
--        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
--    elseif hours > 0 then
--        return string.format("%dh %02dm %02ds", hours, minutes, secs)
--    elseif minutes > 0 then
--        return string.format("%dm %02ds", minutes, secs)
--    else
--        return string.format("%ds", secs)
--    end
--end
--

local gradient_d = Material("vgui/gradient-d")

local blurMat = Material("pp/blurscreen")
local Dynamic = 0

BlurBackground = hg.DrawBlur

local function PaintFrame(self,w,h)
	BlurBackground(self)
    surface.SetDrawColor(155, 0, 0, 155)
    surface.SetMaterial(gradient_d)
    surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( 255, 0, 0, 128)
    surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end

function PANEL:Paint( w, h )  
    PaintFrame( self, w, h )
end

vgui.Register( "ZB_AccountFrame", PANEL, "ZFrame" )