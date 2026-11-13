util.AddNetworkString("zChat.OOC")

local OOC_COOLDOWN = 3
local OOC_MAX_LEN  = 256
local OOC_PREFIX   = "//"

-- не удобна шо пиздец.
local OOC_WHITELIST = {
	["sandbox"]  = true,
	["construct"] = true,
    ["flatout"]  = true,
    ["dr"]  = true,
}

local OOC_BLACKLIST = {
	["hmcd"] = true,
	["coop"] = true,
	["criresp"] = true,
	["defense"]  = true,
	["dm"]  = true,
	["event"]  = true,
	["gwars"]  = true,
	["hl2dm"]  = true,
	["pathowogen"]  = true,
	["riot"]  = true,
	["scugarena"]  = true,
	["superfighters"]  = true,
	["tdm"]  = true,
	["as"]  = true,
	--["br"]  = true,
	--["gb"]  = true,
	["hns"]  = true,
	--["MeleeTDM"]  = true,
	--["smo"]  = true,
	--["dr"]  = true,
    --["flatout"]  = true,
    ["bodycrawler"]  = true,
}    

local lastTime = {}
local lastText = {}

local function Sanitize(text)
    text = tostring(text or "")
    text = text:gsub("[\r\n\t]+", " ")
    text = string.Trim(text)
    if text == "" then return nil end
    if string.utf8len(text) > OOC_MAX_LEN then
        text = string.utf8sub(text, 1, OOC_MAX_LEN)
    end
    return text
end

local function GetCurrentModeKey()
    if not zb or not zb.CROUND then return nil end

    local parent = zb:GetMode(zb.CROUND)
    return parent or zb.CROUND
end

local function IsOOCAllowed()
    local modeKey = GetCurrentModeKey()

    if not modeKey then return true end
    if OOC_BLACKLIST[modeKey] then return false end
    if next(OOC_WHITELIST) ~= nil then
        return OOC_WHITELIST[modeKey] == true
    end
    return true
end

local function BroadcastOOC(ply, text)
    local color = ply:GetPlayerColor():ToColor()
    MsgC(color, "[OOC] ", ply:Nick(), color_white, ": " .. text .. "\n")

    net.Start("zChat.OOC")
        net.WriteEntity(ply)
        net.WriteString(text)
    net.Broadcast()

    hook.Run("ZChatOOCMessage", ply, text)
end

hook.Add("HG_PlayerSay", "ZChat.OOC", function(ply, txt)
    if not IsValid(ply) then return end
    if type(txt) ~= "table" then return end
    local raw = txt[1]
    if type(raw) ~= "string" then return end
    if raw:sub(1, #OOC_PREFIX) ~= OOC_PREFIX then return end

    txt[1] = ""

    local body = Sanitize(raw:sub(#OOC_PREFIX + 1))
    if not body then return end

    if not IsOOCAllowed() then
        ply:ChatPrint("нее братан...")
        return
    end

    local now = CurTime()
    if lastTime[ply] and lastTime[ply] > now then
        ply:ChatPrint("Погоди радной чего спешиш???")
        return
    end
    if lastText[ply] == body then
        ply:ChatPrint("Не попугайничей")
        return
    end

    lastTime[ply] = now + OOC_COOLDOWN
    lastText[ply] = body

    BroadcastOOC(ply, body)
end)

hook.Add("PlayerSay", "ZChat.OOC.Suppress", function(ply, text)
    if type(text) == "string" and text:sub(1, #OOC_PREFIX) == OOC_PREFIX then
        return ""
    end
end)

hook.Add("HG_OnPlayerChat", "ZChat.OOC.Skip", function(ply, text)
    if type(text) == "table" and type(text[1]) == "string"
        and text[1]:sub(1, #OOC_PREFIX) == OOC_PREFIX then
        return true
    end
end)

hook.Add("PlayerSpawn", "ZChat.OOC.Reset", function(ply)
    lastTime[ply] = nil
    lastText[ply] = nil
end)

hook.Add("PlayerDisconnected", "ZChat.OOC.Cleanup", function(ply)
    lastTime[ply] = nil
    lastText[ply] = nil
end)

util.AddNetworkString("zChat.OOC.Status")

local function SendOOCStatus(ply)
    local allowed = IsOOCAllowed()
    net.Start("zChat.OOC.Status")
        net.WriteBool(allowed)
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "ZChat.OOC.SendStatus", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then SendOOCStatus(ply) end
    end)
end)

hook.Add("ZB_StartRound", "ZChat.OOC.SendStatusOnRound", function()
    for _, ply in player.Iterator() do
        SendOOCStatus(ply)
    end
end)

hook.Add("ZB_EndRound", "ZChat.OOC.SendStatusOnEnd", function()
    for _, ply in player.Iterator() do
        SendOOCStatus(ply)
    end
end)