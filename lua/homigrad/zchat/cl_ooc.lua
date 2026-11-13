local OOC_TAG = Color(160, 160, 160)
local OOC_FALLBACK = Color(255, 200, 80)

net.Receive("zChat.OOC", function()
    local ply  = net.ReadEntity()
    local text = net.ReadString()

    local name   = IsValid(ply) and ply:Nick() or "Console"
    local pcolor = IsValid(ply) and ply:GetPlayerColor():ToColor() or OOC_FALLBACK

    local rich
    if zchat and zchat.RichText then
        rich = zchat.RichText(text)
    else
        rich = text
    end

    chat.AddText(
        OOC_TAG, "[OOC] ",
        pcolor,  name,
        color_white, ": ",
        rich
    )
end)