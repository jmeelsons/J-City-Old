local MODE = MODE

MODE.name = "sandbox"
MODE.PrintName = "Sandbox"
MODE.LootSpawn = false
MODE.GuiltDisabled = true
MODE.randomSpawns = false
MODE.ForBigMaps = true
MODE.Chance = 0
MODE.EndLogicType = 3
MODE.LootEnabled = false

MODE.RESPAWN_TIME = 5

util.AddNetworkString("sandbox_start")
util.AddNetworkString("sandbox_end")
util.AddNetworkString("sandbox_respawn")

local SANDBOX_SPAWN_PROTECT_TIME   = 5
local SANDBOX_SPAWN_PROTECT_PRIORITY = -15

local function IsSandboxActive()
    local mode, round = CurrentRound()
    return round == "sandbox" or (mode and mode.name == "sandbox")
end

local function GetSpawnPoints()
    local points = {}

    for _, ent in ipairs(ents.FindByClass("info_player_start")) do
        points[#points + 1] = ent:GetPos()
    end

    if #points == 0 then
        local default_spawns = {
            "info_player_deathmatch", "info_player_combine", "info_player_rebel",
            "info_player_counterterrorist", "info_player_terrorist", "info_player_axis",
            "info_player_allies", "gmod_player_start", "info_player_teamspawn",
            "info_player_coop", "info_player_human", "info_player_zombie"
        }
        for _, class in ipairs(default_spawns) do
            for _, ent in ipairs(ents.FindByClass(class)) do
                points[#points + 1] = ent:GetPos()
            end
        end
    end

    return points
end

local function GetBestSpawnPoint(ply)
    local points = GetSpawnPoints()
    if #points == 0 then return nil end

    local bestPos = nil
    local bestDist = -1

    for _, pos in ipairs(points) do
        local occupied = false
        for _, other in ipairs(player.GetAll()) do
            if other == ply then continue end
            if not other:Alive() then continue end
            if other:GetPos():DistToSqr(pos) < 64 * 64 then
                occupied = true
                break
            end
        end

        if occupied then continue end

        local nearest = math.huge
        for _, other in ipairs(player.GetAll()) do
            if other == ply then continue end
            if not other:Alive() then continue end
            nearest = math.min(nearest, other:GetPos():DistToSqr(pos))
        end

        if nearest > bestDist then
            bestDist = nearest
            bestPos = pos
        end
    end

    if not bestPos then
        bestPos = table.Random(points)
    end

    return bestPos
end

local function SandboxClearSpawnProtect(ply)
    if not IsValid(ply) then return end

    ply.SandboxSpawnProtectUntil = 0
    ply:SetNWFloat("SandboxSpawnProtectUntil", 0)

    timer.Remove("SandboxSpawnProtect_" .. ply:EntIndex())

    if ply.organism then
        ply.organism.godmode = ply.SandboxSpawnProtectPrevGod or false
        ply.SandboxSpawnProtectPrevGod = nil
    end
end

local function SandboxApplySpawnProtect(ply)
    if not IsValid(ply) then return end
    if not IsSandboxActive() then return end
    if zb.ROUND_STATE ~= 1 then return end

    local untilTime = CurTime() + SANDBOX_SPAWN_PROTECT_TIME

    ply.SandboxSpawnProtectUntil = untilTime
    ply:SetNWFloat("SandboxSpawnProtectUntil", untilTime)

    local function applyGod()
        if not IsValid(ply) or not ply.organism then return end
        ply.organism.godmode = ply.SandboxSpawnProtectPrevGod or false
        ply.organism.godmode = true
    end

    if ply.organism then
        applyGod()
    else
        timer.Simple(0.05, applyGod)
    end

    timer.Create("SandboxSpawnProtect_" .. ply:EntIndex(), SANDBOX_SPAWN_PROTECT_TIME, 1, function()
        if not IsValid(ply) then return end

        ply.SandboxSpawnProtectUntil = 0
        ply:SetNWFloat("SandboxSpawnProtectUntil", 0)

        if ply.organism then
            ply.organism.godmode = ply.SandboxSpawnProtectPrevGod or false
            ply.SandboxSpawnProtectPrevGod = nil
        end
    end)
end

function MODE:CanLaunch()
    return true
end

function MODE:Intermission()
    game.CleanUpMap()

    for _, ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        ApplyAppearance(ply)
        --ply:SetupTeam(0) GO FUCK YOURSELF FUCKING SHIT!!!!!1
    end

    local rndpoints = zb.GetMapPoints("RandomSpawns")
    zonepoint = table.Random(rndpoints)

    net.Start("sandbox_start")
    net.Broadcast()

    timer.Simple(0, function()
        for _, ply in player.Iterator() do
            ply:PrintMessage(HUD_PRINTTALK, "Sandbox Commands:\nzbox_respawn (console command for respawn)")
        end
    end)
end

hook.Add("PlayerInitialSpawn", "connect", function(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end
        if not IsSandboxActive() then return end
        if zb.ROUND_STATE ~= 1 then return end
        if ply:Team() == TEAM_SPECTATOR then return end

        if not ply:Alive() then
            ply.timeDeath = nil
            MODE:spawnsandboxplayer(ply)
        end

        ply:PrintMessage(HUD_PRINTTALK, "Sandbox Commands:\nzbox_respawn (console command for respawn)")
    end)
end)

hook.Add("PlayerDeath", "death", function(ply, inflictor, attacker)
    if not IsValid(ply) then return end
    if not IsSandboxActive() then return end
    if zb.ROUND_STATE ~= 1 then return end

    ply:PrintMessage(HUD_PRINTTALK, "zbox_respawn on console")
end)

function MODE:CheckAlivePlayers()
    local AlivePlyTbl = {}
    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end
        if ply.organism and ply.organism.incapacitated then continue end
        AlivePlyTbl[#AlivePlyTbl + 1] = ply
    end
    return AlivePlyTbl
end

function MODE:ShouldRoundEnd()
    return false
end

function MODE:RoundStart()
    if not zb.ROUND_START or zb.ROUND_START == 0 then
        zb.ROUND_START = CurTime()
    end

    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end

        ply:SetSuppressPickupNotices(true)
        ply.noSound = true

        ply:Give("weapon_hands_sh")
        ply:SelectWeapon("weapon_hands_sh")

        timer.Simple(0.1, function()
            if IsValid(ply) then ply.noSound = false end
        end)

        ply:SetSuppressPickupNotices(false)

        zb.GiveRole(ply, "Player", Color(0, 162, 255))

        if ply:IsAdmin() then
            zb.GiveRole(ply, "Admin", Color(0, 162, 255))
        end
    end

    timer.Simple(0.1, function()
        for _, ply in player.Iterator() do
            if IsValid(ply) and ply:Alive() then
                SandboxApplySpawnProtect(ply)
            end
        end
    end)
end

function MODE:GiveWeapons() end
function MODE:GiveEquipment() end
function MODE:CanSpawn() return true end

function MODE:EndRound()
    net.Start("sandbox_end")
    net.WriteEntity(NULL)
    net.Broadcast()
end

function MODE:spawnsandboxplayer(ply)
    if not IsValid(ply) then return end
    if ply:Team() == TEAM_SPECTATOR then return end
    if zb.ROUND_STATE ~= 1 then return end
    if not IsSandboxActive() then return end

    if not ply:Alive() then
        ply:Spawn()
    end

    timer.Simple(0, function()
        if not IsValid(ply) or not ply:Alive() then return end

        local spawnPos = GetBestSpawnPoint(ply)
        if spawnPos then
            ply:SetPos(spawnPos)
        end

        SandboxApplySpawnProtect(ply)
    end)

    ply:SetSuppressPickupNotices(true)
    ply.noSound = true

    if not ply:HasWeapon("weapon_hands_sh") then
        ply:Give("weapon_hands_sh")
    end
    ply:SelectWeapon("weapon_hands_sh")

    zb.GiveRole(ply, "Player", Color(0, 162, 255))
    
    if ply:IsAdmin() then
        zb.GiveRole(ply, "Admin", Color(0, 162, 255))
    end

    timer.Simple(0.1, function()
        if IsValid(ply) then ply.noSound = false end
    end)

    ply:SetSuppressPickupNotices(false)
end

function MODE:PlayerDeath(ply)
    if not IsValid(ply) then return end
    if zb.ROUND_STATE ~= 1 then return end
    if not IsSandboxActive() then return end

    SandboxClearSpawnProtect(ply)

    ply.timeDeath = CurTime() + self.RESPAWN_TIME

    net.Start("sandbox_respawn")
        net.WriteFloat(ply.timeDeath)
    net.Send(ply)
end

function MODE:RoundThink()
    self.ThinkPlayersDeath = self.ThinkPlayersDeath or CurTime()
    if self.ThinkPlayersDeath < CurTime() then
        self.ThinkPlayersDeath = CurTime() + 1

        for _, ply in ipairs(player.GetAll()) do
            if not IsValid(ply) then continue end
            if ply:Team() == TEAM_SPECTATOR then continue end
            if ply:Alive() then continue end
            if ply.organism and ply.organism.incapacitated then continue end
            if ply.timeDeath and ply.timeDeath < CurTime() then
                ply.timeDeath = nil
                self:spawnsandboxplayer(ply)
            end
        end
    end
end

hook.Add("PlayerDeathThink", "ZB_SandboxGlobalDeathThink", function(ply)
    if zb.ROUND_STATE ~= 1 then return end
    if not IsSandboxActive() then return end
end)

hook.Add("EntityTakeDamage", "SandboxSpawnProtect", function(ent, dmgInfo)
    if not IsSandboxActive() then return end

    local vply = ent
    if IsValid(vply) and vply:IsRagdoll() and hg and hg.RagdollOwner then
        vply = hg.RagdollOwner(vply)
    elseif not (IsValid(vply) and vply:IsPlayer()) then
        return
    end

    if not IsValid(vply) or not vply:IsPlayer() then return end

    if (vply.SandboxSpawnProtectUntil or 0) > CurTime() then
        dmgInfo:SetDamage(0)
        return true
    end

    local att = dmgInfo:GetAttacker()
    if IsValid(att) and att:IsPlayer() and (att.SandboxSpawnProtectUntil or 0) > CurTime() then
        dmgInfo:SetDamage(0)
        return true
    end
end, SANDBOX_SPAWN_PROTECT_PRIORITY)

hook.Add("PlayerDisconnected", "SandboxSpawnProtectCleanup", function(ply)
    timer.Remove("SandboxSpawnProtect_" .. ply:EntIndex())
end)

concommand.Add("zbox_respawn_all", function(ply, _, _, _)
    if not ply:IsAdmin() then return end
    for _, p in player.Iterator() do
        if p:Team() == TEAM_SPECTATOR then continue end
        if not p:Alive() then
            p.timeDeath = nil
            MODE:spawnsandboxplayer(p)
        end
    end
    ply:ChatPrint("ALL RESPAWNED!")
end)

concommand.Add("zbox_respawn", function(ply, _, _, _)
    if not IsValid(ply) then return end
    if ply:Team() == TEAM_SPECTATOR then return end
    if zb.ROUND_STATE ~= 1 then
        ply:ChatPrint("Round is not active.")
        return
    end
    if not IsSandboxActive() then
        ply:ChatPrint("haha, no.")
        return
    end

    if ply:Alive() then
        ply:ChatPrint("You are alive!")
        return
    end

    if ply.sandboxRespawnCD and ply.sandboxRespawnCD > CurTime() then
        ply:ChatPrint("Wait " .. math.ceil(ply.sandboxRespawnCD - CurTime()) .. " s.")
        return
    end

    ply.sandboxRespawnCD = CurTime() + 3
    ply.timeDeath = nil

    MODE:spawnsandboxplayer(ply)
end)