util.AddNetworkString("AdminNotifyReceive")

function NotifyAllPlayers(text, color, time, sender)
    for _, ply in ipairs(player.GetAll()) do
        net.Start("AdminNotifyReceive")
            net.WriteString(text)
            net.WriteColor(color or Color(255, 255, 255))
            net.WriteFloat(time or 5)
            net.WriteString(sender or "")
        net.Send(ply)
    end
end

concommand.Add("hg_notify_all_sv", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not ply:IsAdmin() then 
        ply:ChatPrint("У вас нет прав на использование этой команды!")
        return 
    end
    
    local text = table.concat(args, " ")
    if text == "" then return end
    
    NotifyAllPlayers(text, Color(255, 255, 255), 5, ply:Name())
end)

--[[
hook.Add("PlayerInitialSpawn", "NotifyAllOnJoin", function(ply)
    if IsValid(ply) then
        NotifyAllPlayers("Игрок " .. ply:Name() .. " зашёл на сервер", Color(100, 255, 100), 3, "Сервер")
    end
end)

hook.Add("PlayerDisconnected", "NotifyAllOnLeave", function(ply)
    if IsValid(ply) then
        NotifyAllPlayers("Игрок " .. ply:Name() .. " покинул сервер", Color(255, 100, 100), 3, "Сервер")
    end
end)
]]