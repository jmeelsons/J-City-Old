local MODE = MODE

MODE.name = "bodycrawler"
MODE.PrintName = "Body Crawler"
MODE.LootSpawn = true
MODE.GuiltDisabled = true
MODE.randomSpawns = true

MODE.ForBigMaps = true
MODE.Chance = 0.1

MODE.shouldfreeze = false
MODE.start_time = 8
MODE.end_time = 6
MODE.ROUND_TIME = 420

MODE.CrawlerCount = 5
MODE.CrawlerPerPlayer = 4
MODE.MaxCrawlers = 10
MODE.Waves = {
    [0]   = 1,
    [120] = 1,
    [240] = 1,
    [360] = 1,
}

util.AddNetworkString("bodycrawler_start")
util.AddNetworkString("bodycrawler_end")
util.AddNetworkString("bodycrawler_sync")

local crawlers = {}
local spawnedWaves = {}
local survivorsWon = false

local function roundPlaying()
    return zb.ROUND_STATE == 1
end

local function getAliveSurvivors()
    local tbl = {}
    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end
        if ply.organism and ply.organism.incapacitated then continue end
        tbl[#tbl + 1] = ply
    end
    return tbl
end

local function isCrawler(ent)
    return IsValid(ent) and ent:GetClass() == "evil_crawler"
end

local function isCrawlerAlive(ent)
    if not IsValid(ent) then return false end
    if ent.Health and ent:Health() <= 0 then return false end
    if ent.GetAct and EvilCrawler then
        local act = ent:GetAct()
        if act == EvilCrawler.ACT_DEAD or act == EvilCrawler.ACT_OUT then
            return false
        end
    end
    return true
end

local FAR = 800
local TRIES = 60
local BOUNDS = Vector(16, 16, 16)

local function findCrawlerSpawn()
    local zp = (zonepoint and zonepoint.pos) or Vector(0, 0, 0)
    local areas = navmesh.GetAllNavAreas() or {}

    local function randomPoint()
        if #areas > 0 then
            local a = areas[math.random(#areas)]
            return a:GetRandomPoint()
        end
        local players = getAliveSurvivors()
        if #players > 0 then
            local ply = table.Random(players)
            return ply:GetPos() + Vector(math.random(-800, 800), math.random(-800, 800), 0)
        end
        return zp + VectorRand() * 500
    end

    local function exposure(pos)
        local seen, nearest = false, math.huge
        for _, ply in player.Iterator() do
            if ply:Alive() then
                local eye = ply:EyePos()
                nearest = math.min(nearest, eye:Distance(pos))
                local tr = util.TraceLine({
                    start = eye, endpos = pos, mask = MASK_BLOCKLOS, filter = ply,
                })
                if not tr.Hit then seen = true end
            end
        end
        return seen, nearest
    end

    local best, bestNormal, bestScore = nil, nil, -math.huge

    for _ = 1, TRIES do
        local point = randomPoint()

        local down = util.TraceLine({
            start = point + vector_up * 128,
            endpos = point - vector_up * 512,
            mask = MASK_SOLID,
        })

        if down.Hit and not down.HitSky and not down.StartSolid then
            local floor = down.HitPos
            local normal = down.HitNormal
            local spawnPos = floor + normal * 32

            local room = util.TraceHull({
                start = floor + normal * 4,
                endpos = spawnPos,
                mins = -BOUNDS, maxs = BOUNDS,
                mask = MASK_SOLID,
            })

            if not room.Hit and util.IsInWorld(spawnPos) then
                local seen, dist = exposure(spawnPos)
                if not seen and dist >= FAR then
                    return spawnPos, normal
                end
                local score = dist - (seen and 1e6 or 0)
                if score > bestScore then
                    best, bestNormal, bestScore = spawnPos, normal, score
                end
            end
        end
    end

    if not best then
        local players = getAliveSurvivors()
        if #players > 0 then
            local ply = table.Random(players)
            local origin = ply:GetPos()
            for _ = 1, 40 do
                local offset = Vector(math.random(-600, 600), math.random(-600, 600), 0)
                local tryPos = origin + offset
                local tr = util.TraceLine({
                    start = tryPos + vector_up * 512,
                    endpos = tryPos - vector_up * 512,
                    mask = MASK_SOLID,
                })
                if tr.Hit and not tr.HitSky and not tr.StartSolid then
                    return tr.HitPos + tr.HitNormal * 36, tr.HitNormal
                end
            end
        end

        local tr = util.TraceLine({
            start = zp + vector_up * 2048,
            endpos = zp - vector_up * 2048,
            mask = MASK_SOLID,
        })
        if tr.Hit and not tr.HitSky then
            return tr.HitPos + tr.HitNormal * 48, tr.HitNormal
        end

        return nil, nil
    end

    return best, bestNormal
end

local function spawnCrawler(plySpawner)
    local pos, up = findCrawlerSpawn()
    if not pos then
        print("findCrawlerSpawn: no valid position")
        return nil
    end

    local crawler = ents.Create("evil_crawler")
    if not IsValid(crawler) then
        print("ents.Create('evil_crawler') failed — addon not installed")
        return nil
    end

    crawler:SetPos(pos)
    crawler:SetAngles(Angle(0, math.random(0, 360), 0))
    crawler.Master = IsValid(plySpawner) and plySpawner or NULL
    crawler.SpawnUp = up or vector_up
    crawler:Spawn()
    crawler:Activate()

    if not IsValid(crawler) then
        print("crawler invalid after Spawn")
        return nil
    end

    crawler.IsBodyCrawlerEvent = true
    crawlers[crawler] = true

    print("Spawned at " .. tostring(pos))

    timer.Simple(0.2, function()
        if not IsValid(crawler) then
            crawlers[crawler] = nil
            return
        end
        local p = crawler:GetPos()
        if p.z < -2000 then
            print("crawler fell out of world (z=" .. p.z .. "), removing")
            crawlers[crawler] = nil
            crawler:Remove()
        end
    end)

    return crawler
end

local function countAliveCrawlers()
    local n = 0
    for ent in pairs(crawlers) do
        if isCrawlerAlive(ent) then n = n + 1 end
    end
    return n
end

local function desiredCrawlers()
    local alive = #getAliveSurvivors()
    local want = math.max(MODE.CrawlerCount, math.ceil(alive / MODE.CrawlerPerPlayer))
    return math.min(want, MODE.MaxCrawlers)
end

function MODE:CanLaunch()
    if not Evil or not EvilCrawler then
        print("Evil API / EvilCrawler not installed")
        return false, "Evil Crawler not installed"
    end
    return true
end

function MODE:Intermission()
    game.CleanUpMap()

    for _, ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        ApplyAppearance(ply)
        ply:SetupTeam(0)
    end

    local rndpoints = zb.GetMapPoints("RandomSpawns")
    if not rndpoints or #rndpoints == 0 then
        print("WARNING: no RandomSpawns map points, using fallback")
        zonepoint = { pos = Vector(0, 0, 0) }
    else
        zonepoint = table.Random(rndpoints)
    end

    net.Start("bodycrawler_start")
    net.Broadcast()
end

function MODE:RoundStart()
    crawlers = {}
    spawnedWaves = {}
    survivorsWon = false
    self.survivorsWon = nil
    self.nextDynamicSpawn = 0

    if not EvilCrawler then
        print("CRITICAL: EvilCrawler none. Crawlers cannot spawn!")
    end

    for _, ply in player.Iterator() do
        if not ply:Alive() then continue end

        ply:SetSuppressPickupNotices(true)
        ply.noSound = true
        local hands = ply:Give("weapon_hands_sh")
        ply:SelectWeapon("weapon_hands_sh")

        timer.Simple(0.1, function()
            if IsValid(ply) then ply.noSound = false end
        end)

        ply:SetSuppressPickupNotices(false)
        zb.GiveRole(ply, "Survivor", Color(50, 200, 50))
    end

    net.Start("bodycrawler_sync")
        net.WriteUInt(MODE.ROUND_TIME, 16)
    net.Broadcast()

    timer.Simple(5, function()
        if not roundPlaying() then
            print("Round not playing at +5s, skip wave 0")
            return
        end
        local count = MODE.Waves[0] or 1
        for _ = 1, count do spawnCrawler() end
        spawnedWaves[0] = true
        print("Wave 0 spawned (" .. count .. ")")
    end)

    timer.Create("BodyCrawlerHuntBrain", 3, 0, function()
        if not roundPlaying() then
            timer.Remove("BodyCrawlerHuntBrain")
            return
        end

        local elapsed = CurTime() - (zb.ROUND_START or CurTime())

        for t, count in pairs(MODE.Waves) do
            if t > 0 and not spawnedWaves[t] and elapsed >= t then
                spawnedWaves[t] = true
                for _ = 1, count do spawnCrawler() end
                print("Wave " .. t .. " spawned (" .. count .. ")")
            end
        end

        local want = desiredCrawlers()
        local alive = countAliveCrawlers()
        if alive < want and elapsed > 30 then
            if (self.nextDynamicSpawn or 0) < CurTime() then
                self.nextDynamicSpawn = CurTime() + 15
                spawnCrawler()
                print("Dynamic spawn (alive=" .. alive .. "/" .. want .. ")")
            end
        end
    end)
end

function MODE:GiveWeapons() end
function MODE:GiveEquipment() end

function MODE:ShouldRoundEnd()
    if #getAliveSurvivors() <= 0 then
        return true
    end

    local alive = 0
    local total = 0
    for ent in pairs(crawlers) do
        if IsValid(ent) then
            total = total + 1
            if isCrawlerAlive(ent) then alive = alive + 1 end
        end
    end

    if total > 0 and alive == 0 then
        return true
    end

    return false
end

function MODE:RoundThink()
    if not zb.ROUND_START then return end
    if not roundPlaying() then return end

    local elapsed = CurTime() - zb.ROUND_START
    if elapsed >= MODE.ROUND_TIME then
        self.survivorsWon = true
        survivorsWon = true
        zb:EndRound()
    end
end

function MODE:EndRound()
    timer.Remove("BodyCrawlerHuntBrain")

    timer.Simple(2, function()
        net.Start("bodycrawler_end")
            net.WriteBool(survivorsWon)
        net.Broadcast()
    end)

    self.survivorsWon = nil
    survivorsWon = false
end