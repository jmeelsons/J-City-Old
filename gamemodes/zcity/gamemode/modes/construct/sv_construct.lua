local MODE = MODE

MODE.name = "construct"
MODE.PrintName = "Construct"
MODE.LootSpawn = false
MODE.GuiltDisabled = true
MODE.randomSpawns = true
MODE.ForBigMaps = true
MODE.Chance = 0.01
MODE.EndLogicType = 3
MODE.LootEnabled = false
MODE.SURVIVE_TIME = 3600
MODE.ROUND_TIME = 3600 -- ебать костыли просто пиздец блять...

util.AddNetworkString("construct_start")
util.AddNetworkString("construct_end")
util.AddNetworkString("construct_timer")

local SANDBOX_SPAWN_PROTECT_TIME   = 5
local SANDBOX_SPAWN_PROTECT_PRIORITY = -15

local function IsConstructActive()
    local mode, round = CurrentRound()
    return round == "construct" or (mode and mode.name == "construct")
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

    local bestPos, bestDist = nil, -1
    for _, pos in ipairs(points) do
        local occupied = false
        for _, other in ipairs(player.GetAll()) do
            if other == ply or not other:Alive() then continue end
            if other:GetPos():DistToSqr(pos) < 64 * 64 then
                occupied = true; break
            end
        end
        if occupied then continue end

        local nearest = math.huge
        for _, other in ipairs(player.GetAll()) do
            if other == ply or not other:Alive() then continue end
            nearest = math.min(nearest, other:GetPos():DistToSqr(pos))
        end
        if nearest > bestDist then bestDist = nearest; bestPos = pos end
    end

    return bestPos or table.Random(points)
end

local function ConstructClearSpawnProtect(ply)
    if not IsValid(ply) then return end
    ply.SandboxSpawnProtectUntil = 0
    ply:SetNWFloat("SandboxSpawnProtectUntil", 0)
    timer.Remove("SandboxSpawnProtect_" .. ply:EntIndex())
    if ply.organism then
        ply.organism.godmode = ply.SandboxSpawnProtectPrevGod or false
        ply.SandboxSpawnProtectPrevGod = nil
    end
end

local function ConstructApplySpawnProtect(ply)
    if not IsValid(ply) then return end
    if not IsConstructActive() then return end
    if zb.ROUND_STATE ~= 1 then return end

    local untilTime = CurTime() + SANDBOX_SPAWN_PROTECT_TIME
    ply.SandboxSpawnProtectUntil = untilTime
    ply:SetNWFloat("SandboxSpawnProtectUntil", untilTime)

    local function applyGod()
        if not IsValid(ply) or not ply.organism then return end
        ply.organism.godmode = true
    end
    if ply.organism then applyGod() else timer.Simple(0.05, applyGod) end

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

local function NotifyAll(msg)
    for _, p in ipairs(player.GetAll()) do p:ChatPrint(msg) end
end

function MODE:CanLaunch() return true end

function MODE:Intermission()
    game.CleanUpMap()

    for _, ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        ApplyAppearance(ply)
        ply:SetupTeam(0)
    end

    local rndpoints = zb.GetMapPoints("RandomSpawns")
    zonepoint = table.Random(rndpoints)

    self:SpawnScrapperVehicles()

    net.Start("construct_start")
    net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "construct_connect", function(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end
        if not IsConstructActive() then return end
        if zb.ROUND_STATE ~= 1 then return end
        if ply:Team() == TEAM_SPECTATOR then return end

        if not ply:Alive() then
            MODE:spawnconstructplayer(ply)
        end
    end)
end)

function MODE:CheckAlivePlayers()
    local t = {}
    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end
        if ply.organism and ply.organism.incapacitated then continue end
        t[#t + 1] = ply
    end
    return t
end

function MODE:ShouldRoundEnd()
    if zb.ROUND_STATE ~= 1 then return false end
    if not zb.ROUND_START or zb.ROUND_START == 0 then return false end

    if zb.ROUND_START + MODE.SURVIVE_TIME < CurTime() then
        self._lastWinner = nil
        self._survivedAll = true
        return true
    end

    local alive = self:CheckAlivePlayers()
    if #alive <= 1 then
        self._lastWinner = (#alive == 1) and alive[1] or nil
        self._survivedAll = false
        return true
    end

    return false
end

function MODE:RoundStart()
    if not zb.ROUND_START or zb.ROUND_START == 0 then
        zb.ROUND_START = CurTime()
    end

    zb.ROUND_TIME = MODE.SURVIVE_TIME

    self._lastWinner = nil
    self._survivedAll = false

    net.Start("construct_timer")
        net.WriteFloat(CurTime() + MODE.SURVIVE_TIME)
    net.Broadcast()

    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end

        ply:SetSuppressPickupNotices(true)
        ply.noSound = true
        ply:Give("weapon_hands_sh")
        ply:Give("weapon_physgun")
        ply:Give("gmod_tool")
        ply:Give("gmod_camera")
        ply:SelectWeapon("weapon_hands_sh")

        timer.Simple(0.1, function()
            if IsValid(ply) then ply.noSound = false end
        end)
        ply:SetSuppressPickupNotices(false)

        zb.GiveRole(ply, "Survivor", Color(0, 200, 120))
        if ply:IsAdmin() then
            zb.GiveRole(ply, "Admin", Color(0, 162, 255))
        end
    end

    timer.Simple(0.1, function()
        for _, ply in player.Iterator() do
            if IsValid(ply) and ply:Alive() then
                ConstructApplySpawnProtect(ply)
            end
        end
    end)
end

MODE.Vehicles = {
	"exid_renault_12",
	"exid_1998_caprice_station_wagon",
	"exid_1982_ford_e_150_commercial_van",
	"exid_1990_mitsubishi_delica_starwagon",
	"exid_volkswagen_golf_mk2",
	"exid_lada_niva"    
}

function MODE:SpawnScrapperVehicles()
	if not zb.Points or not zb.Points["SCRAPPERS_VEHICLE"] then return end
	local points = zb.Points["SCRAPPERS_VEHICLE"].Points
	if not points or #points == 0 then return end

	for _, v in ipairs(points) do
		local random = math.random(1, 4)

		if random == 1 then
			local vehicle_class = self.Vehicles[math.random(#self.Vehicles)]

			local veh = ents.Create(vehicle_class)
			if not IsValid(veh) then continue end

			veh:SetPos(v.pos + Vector(0, 0, 100))
			veh:SetAngles(v.ang or Angle(0, 0, 0))
			veh:Spawn()
			veh:Activate()
		end
	end
end

function MODE:GiveWeapons() end
function MODE:GiveEquipment() end
function MODE:CanSpawn() return true end

function MODE:EndRound()
    local winner = self._lastWinner
    local survivedAll = self._survivedAll

    self._lastWinner = nil
    self._survivedAll = false

    if survivedAll then
        for _, ply in player.Iterator() do
            if IsValid(ply) and ply:Alive() then
                net.Start("construct_end")
                    net.WriteEntity(ply)
                net.Broadcast()
            end
        end
        if #self:CheckAlivePlayers() == 0 then
            net.Start("construct_end")
                net.WriteEntity(NULL)
            net.Broadcast()
        end
    else
        net.Start("construct_end")
            net.WriteEntity(IsValid(winner) and winner or NULL)
        net.Broadcast()
    end
end

function MODE:spawnconstructplayer(ply)
    if not IsValid(ply) then return end
    if ply:Team() == TEAM_SPECTATOR then return end
    if zb.ROUND_STATE ~= 1 then return end
    if not IsConstructActive() then return end

    if not ply:Alive() then ply:Spawn() end

    timer.Simple(0, function()
        if not IsValid(ply) or not ply:Alive() then return end
        local spawnPos = GetBestSpawnPoint(ply)
        if spawnPos then ply:SetPos(spawnPos) end
        ConstructApplySpawnProtect(ply)
    end)

    ply:SetSuppressPickupNotices(true)
    ply.noSound = true

    if not ply:HasWeapon("weapon_hands_sh") then
        ply:Give("weapon_hands_sh")
    end
    ply:SelectWeapon("weapon_hands_sh")

    zb.GiveRole(ply, "Survivor", Color(0, 200, 120))

    timer.Simple(0.1, function()
        if IsValid(ply) then ply.noSound = false end
    end)
    ply:SetSuppressPickupNotices(false)
end

function MODE:PlayerDeath(ply)
    if not IsValid(ply) then return end
    ConstructClearSpawnProtect(ply)
end

function MODE:RoundThink()
    self.ThinkEnd = self.ThinkEnd or CurTime()
    if self.ThinkEnd < CurTime() then
        self.ThinkEnd = CurTime() + 1

        if zb.ROUND_START and zb.ROUND_START + MODE.SURVIVE_TIME < CurTime() then
            NotifyAll("You survived, my good boy :3")
        end
    end
end

hook.Add("EntityTakeDamage", "ConstructSpawnProtect", function(ent, dmgInfo)
    if not IsConstructActive() then return end
    local vply = ent
    if IsValid(vply) and vply:IsRagdoll() and hg and hg.RagdollOwner then
        vply = hg.RagdollOwner(vply)
    elseif not (IsValid(vply) and vply:IsPlayer()) then
        return
    end
    if not IsValid(vply) or not vply:IsPlayer() then return end

    if (vply.SandboxSpawnProtectUntil or 0) > CurTime() then
        dmgInfo:SetDamage(0) return true
    end
    local att = dmgInfo:GetAttacker()
    if IsValid(att) and att:IsPlayer() and (att.SandboxSpawnProtectUntil or 0) > CurTime() then
        dmgInfo:SetDamage(0) return true
    end
end, SANDBOX_SPAWN_PROTECT_PRIORITY)

hook.Add("PlayerDisconnected", "ConstructCleanup", function(ply)
    timer.Remove("SandboxSpawnProtect_" .. ply:EntIndex())
end)