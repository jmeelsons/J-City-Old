-- кто скрипхукнет у того мать сдохнет)
if not CLIENT then return end

zchat = zchat or {}
zchat.images = zchat.images or {}

local IMG = zchat.images

IMG.ENABLED    = CreateClientConVar("zchat_images", 1, true, false, "Show images from links in chat", 0, 1)
IMG.MAX_WIDTH  = CreateClientConVar("zchat_images_maxwidth", 320, true, false, "Max image width (px)", 64, 800)
IMG.MAX_HEIGHT = CreateClientConVar("zchat_images_maxheight", 240, true, false, "Max image height (px)", 64, 800)
IMG.FADE       = CreateClientConVar("zchat_images_fade", 0, true, false, "Fade images with chat (0 = keep, 1 = fade)", 0, 1)

local IMAGE_EXT = {
    png=true, jpg=true, jpeg=true, gif=true, webp=true, bmp=true,
    svg=true, apng=true, avif=true,
}

local function StripQuery(url) return url:gsub("[?#].*$", "") end

local function GetExt(url)
    local ext = StripQuery(url):match("%.([%w]+)$")
    return ext and ext:lower() or nil
end

local function IsImageURL(url)
    if type(url) ~= "string" then return false end
    if #url < 8 or #url > 2048 then return false end
    if not url:match("^https?://") then return false end

    local ext = GetExt(url)
    if ext and IMAGE_EXT[ext] then return true end

    local host = url:match("^https?://([^/]+)")
    if not host then return false end
    host = host:lower()

    if host:find("^i%.imgur%.com$")        then return true end
    if host:find("^media%.tenor%.com$")    then return true end
    if host:find("^media%.giphy%.com$")    then return true end
    if host:find("^cdn%.discordapp%.com$") then return true end
    if host:find("^i%.redd%.it$")          then return true end
    if host:find("^pbs%.twimg%.com$")      then return true end
    if host:find("^files%.catbox%.moe$")   then return true end
    if host:find("^cdn%.bsky%.app$")       then return true end
    if host:find("klipy%.com$")            then return true end
    if host:find("cdn%.klipy%.com$")       then return true end

    return false
end
IMG.IsImageURL = IsImageURL

function IMG.ExtractImageURL(text)
    if type(text) ~= "string" then return nil end
    for url in text:gmatch("https?://[%w%-_%.~:/?#%[%]@!$&'%(%)%*%+,;=]+") do
        local clean = url:gsub("[%.,;:!%)%]]+$", "")
        if IsImageURL(clean) then return clean end
    end
    return nil
end

local ERROR_IMG = "https://media.discordapp.net/attachments/1210677119823257643/1309934641582575706/attachment.gif?ex=6adc42f3&is=6adaf173&hm=e6e46ae1c7318c674b5b121c76ad773a6352b6a0e9a60daf5a06814311611f53&=" -- 😋

local function BuildInlineHTML(url)
    return string.format([[
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  html,body {
    margin:0; padding:0; height:100%%; width:100%%;
    background:transparent;
    overflow:hidden;
    display:flex; align-items:center; justify-content:center;
  }
  img {
    max-width:100%%; max-height:100%%; width:auto; height:auto;
    object-fit:contain;
    display:block;
  }
</style>
</head>
<body scroll="no">
<img src="%s"
     onload="if(window.gmod&&gmod.imgready)gmod.imgready(this.naturalWidth,this.naturalHeight);"
     onerror="this.onerror=null;this.src='%s';if(window.gmod&&gmod.imgerror)gmod.imgerror();">
</body>
</html>]], url, ERROR_IMG)
end

local function BuildFullscreenHTML(url)
    return string.format([[
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  html,body{
    background: transparent;
    height:100%%; width:100%%; margin:0; overflow:hidden;
    display:flex; justify-content:center; align-items:center;
  }
  img{
    max-width:100%%; max-height:100%%; width:auto; height:auto;
    position:absolute; top:0; left:0; bottom:0; right:0; margin:auto;
    transition:transform .2s;
  }
</style>
</head>
<body scroll="no">
<img id="img" src="%s"
     onerror="this.onerror=null;this.src='%s'">
<script>
(function(){
  var zoom=1;
  document.addEventListener('wheel',function(e){
    if(e.ctrlKey){
      zoom = e.deltaY<0 ? Math.min(zoom+0.1,10) : Math.max(zoom-0.1,0.3);
      document.body.style.zoom=zoom;
      e.preventDefault();
    }
  });
})();
</script>
</body>
</html>]], url, ERROR_IMG)
end

local PANEL = {}

function PANEL:Init()
    self.url = nil
    self.naturalW = 0
    self.naturalH = 0
    self.loaded = false
    self.failed = false
    self._htmlLoaded = false

    self.html = self:Add("DHTML")
    self.html:Dock(FILL)
    self.html:SetMouseInputEnabled(true)
    self.html:SetKeyboardInputEnabled(false)
    self.html:SetAllowLua(false)

    self.html:AddFunction("gmod", "imgready", function(w, h)
        if not IsValid(self) then return end
        self.naturalW = tonumber(w) or 0
        self.naturalH = tonumber(h) or 0
        self.loaded = true
        self.failed = false
        if IsValid(self.html) then
            self.html:SetMouseInputEnabled(false)
        end
        self:SetMouseInputEnabled(true)
        self:SetCursor("hand")
        self:InvalidateLayout(true)
        self:OnLoaded()
    end)

    self.html:AddFunction("gmod", "imgerror", function()
        if not IsValid(self) then return end
        self.failed = true
        if IsValid(self.html) then
            self.html:SetMouseInputEnabled(false)
        end
        self:SetMouseInputEnabled(true)
        self:InvalidateLayout(true)
        self:OnLoaded()
    end)
end

function PANEL:SetImage(url)
    self.url = url
    self.loaded = false
    self.failed = false
    self._htmlLoaded = false

    local function doLoad()
        if not IsValid(self) then return end
        if self._htmlLoaded then return end
        self._htmlLoaded = true
        self.html:SetHTML(BuildInlineHTML(url))
    end

    timer.Simple(0, function()
        if not IsValid(self) then return end
        self:InvalidateLayout(true)
        doLoad()
    end)

    timer.Simple(0.1, doLoad)
end

function PANEL:GetDesiredHeight(width)
    local maxW = IMG.MAX_WIDTH:GetInt()
    local maxH = IMG.MAX_HEIGHT:GetInt()
    local w = math.min(width or maxW, maxW)

    if self.loaded and self.naturalW > 0 and self.naturalH > 0 then
        local scale = math.min(w / self.naturalW, maxH / self.naturalH, 1)
        return math.max(24, math.Round(self.naturalH * scale))
    end
    return math.Round(maxH * 0.6)
end

function PANEL:GetDesiredWidth(availWidth)
    local maxW = IMG.MAX_WIDTH:GetInt()
    if self.loaded and self.naturalW > 0 then
        return math.min(availWidth or maxW, maxW, self.naturalW)
    end
    return math.min(availWidth or maxW, maxW)
end

function PANEL:OnLoaded()
    local parent = self:GetParent()
    if IsValid(parent) and parent.OnImagePanelLoaded then
        parent:OnImagePanelLoaded(self)
    end
end

function PANEL:PerformLayout(w, h)
    if IsValid(self.html) then
        self.html:SetSize(w, h)
    end
end

function PANEL:OnMousePressed(code)
    if not self.url then return end

    if code == MOUSE_LEFT then
        IMG.OpenViewer(self.url)
    elseif code == MOUSE_RIGHT then
        local menu = DermaMenu()
        menu:AddOption("Open in browser", function()
            gui.OpenURL(self.url)
        end):SetImage("icon16/image.png")
        menu:AddOption("Copy link", function()
            SetClipboardText(self.url)
        end):SetImage("icon16/page_copy.png")
        menu:Open()
    end
end

function PANEL:OnRemove()
    if IsValid(self.html) then
        self.html:Remove()
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 40)
    surface.DrawRect(0, 0, w, h)

    if self.failed then
        surface.SetFont("zChatFontSmall")
        surface.SetTextColor(255, 80, 80, 220)
        surface.SetTextPos(w / 2 - 40, h / 2 - 4)
        surface.DrawText("image failed")
    end
end

vgui.Register("zChatInlineImage", PANEL, "Panel")

function IMG.OpenViewer(url)
    if IsValid(IMG.viewer) then IMG.viewer:Remove() end

    local frame = vgui.Create("ZFrame")
    IMG.viewer = frame
    frame:SetSize(math.Round(ScrW() * 0.8), math.Round(ScrH() * 0.8))
    frame:Center()
    frame:SetTitle("Image Viewer")
    frame:MakePopup()
    frame:SetDeleteOnClose(true)

    local browser = vgui.Create("DHTML", frame)
    browser:Dock(FILL)
    browser:SetHTML(BuildFullscreenHTML(url))

    frame.OnRemove = function()
        IMG.viewer = nil
    end
end

IMG.panels = {}

timer.Create("zChatImages.Cleanup", 30, 0, function()
    local list = IMG.panels
    if #list <= 15 then return end

    local toRemove = #list - 10
    for i = 1, toRemove do
        local p = table.remove(list, 1)
        if IsValid(p) then p:Remove() end
    end
end)

function IMG.Track(panel)
    if not IsValid(panel) then return end
    IMG.panels[#IMG.panels + 1] = panel
end

function IMG.FindImageURLs(text)
    local result = {}
    if type(text) ~= "string" then return result end
    for url in text:gmatch("https?://[%w%-_%.~:/?#%[%]@!$&'%(%)%*%+,;=]+") do
        local clean = url:gsub("[%.,;:!%)%]]+$", "")
        if IsImageURL(clean) then
            result[#result + 1] = clean
        end
    end
    return result
end

function IMG.StripURLs(text)
    if type(text) ~= "string" then return text end
    return (text:gsub("(https?://[%w%-_%.~:/?#%[%]@!$&'%(%)%*%+,;=]+)", function(url)
        local clean = url:gsub("[%.,;:!%)%]]+$", "")
        if IsImageURL(clean) then
            return ""
        end
        return url
    end))
end