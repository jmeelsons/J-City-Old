--[[
util.AddNetworkString("hg_pointshop_request_buy")

local PLUGIN = hg.Pointshop
local pending = {}

local function SetPending(ply, points)
    if points <= 0 then
        pending[ply:SteamID64()] = nil
    else
        pending[ply:SteamID64()] = points
    end
end

local function TakePending(ply)
    local sid = ply:SteamID64()
    local p = pending[sid]
    pending[sid] = nil
    return p
end

net.Receive("hg_pointshop_request_buy", function(len, ply)
    local points = net.ReadUInt(32)
    points = math.Clamp(points, 0, 1000000)
    SetPending(ply, points)
    ply:ChatPrint("Заявка принята. После пополнения начислим " .. points .. " поинтов.")
end)

hook.Add("PlayerDisconnected", "hg_pointshop_clear_pending", function(ply)
    pending[ply:SteamID64()] = nil
end)

local function OnIGSPaid(ply, sum, reason)
    if not IsValid(ply) then return end

    local points = TakePending(ply)
    if not points or points <= 0 then return end

    if ply.PS_AddPoints then
        ply:PS_AddPoints(points, "IGS Donate")
    elseif PLUGIN and PLUGIN.AddPoints then
        PLUGIN:AddPoints(ply, points)
    end

    ply:ChatPrint("Начислено " .. points .. " поинтов за пополнение!")
end

hook.Add("IGS.PlayerDonated", "hg_pointshop_reward", OnIGSPaid)

PLUGIN.PlaytimeRewards = PLUGIN.PlaytimeRewards or {}

local REWARD_CONFIG = {
    { time = 30 * 60,   points = 100,   name = "30 minutes"  },
    { time = 5 * 60 * 60,  points = 5000,  name = "5 hours"   },
    { time = 10 * 60 * 60, points = 10000, name = "10 hours"  },
}

hook.Add("PlayerInitialSpawn", "Pointshop_PlaytimeRewards_Init", function(ply)
    local steamID64 = ply:SteamID64()
    PLUGIN.PlaytimeRewards[steamID64] = {
        startTime = CurTime(),
        nextRewards = {},
    }
    for i, reward in ipairs(REWARD_CONFIG) do
        PLUGIN.PlaytimeRewards[steamID64].nextRewards[i] = reward.time
    end
end)

hook.Add("PlayerDisconnected", "Pointshop_PlaytimeRewards_Cleanup", function(ply)
    local steamID64 = ply:SteamID64()
    PLUGIN.PlaytimeRewards[steamID64] = nil
end)

hook.Add("Think", "Pointshop_PlaytimeRewards_Think", function()
    local now = CurTime()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        local steamID64 = ply:SteamID64()
        local data = PLUGIN.PlaytimeRewards[steamID64]
        if not data then continue end

        local elapsed = now - data.startTime

        for i, reward in ipairs(REWARD_CONFIG) do
            if elapsed >= data.nextRewards[i] then
                ply:PS_AddPoints(reward.points)
                ply:PrintMessage(HUD_PRINTTALK, "Вы получили " .. reward.points .. " поинтов за " .. reward.name .. " на сервере!")
                data.nextRewards[i] = data.nextRewards[i] + reward.time
            end
        end
    end
end)

hook.Add("ZB_TraitorWinOrNot", "Pointshop_RoundWinReward", function(ply, winner)
    if not IsValid(ply) then return end
    if winner == 1 then
        ply:PS_AddPoints(2000)
        ply:PrintMessage(HUD_PRINTTALK, "YOU ARE WINNER! CHECK YOUR BALANCE IN POINTSHOP")
    end
end)
--]]