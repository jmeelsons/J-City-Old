-- WARNING! GPT AND BETA CODE!
local MODE = MODE
MODE.name = "flatout"
MODE.PrintName = "Badass Race"

MODE.ForBigMaps = true
MODE.ROUND_TIME = 900
MODE.Chance = 0
MODE.start_time = 70
MODE.end_time = 12

resource.AddFile("resource/fonts/Steadfast Oblique.ttf")

util.AddNetworkString("flatout_start")
util.AddNetworkString("flatout_begin")
util.AddNetworkString("flatout_ready")
util.AddNetworkString("flatout_readycount")
util.AddNetworkString("flatout_checkpoint")
util.AddNetworkString("flatout_finish")
util.AddNetworkString("flatout_positions")
util.AddNetworkString("flatout_roundend")
util.AddNetworkString("flatout_vehicle")
util.AddNetworkString("flatout_countdown")
util.AddNetworkString("flatout_checkpoints")
util.AddNetworkString("flatout_cp_effect")
util.AddNetworkString("flatout_music_start")
util.AddNetworkString("flatout_music_stop")

local MAX_PLAYERS = CreateConVar("flatout_maxplayers", 16, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Max players in BADASS race", 2, 32)

local assigned = {}
local positions = {}
local checkpoints = {}
local startTime = 0
local raceStarted = false
local finishedCount = 0

local START_COUNTDOWN = 3.5

local function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

local function BuildCheckpoints()
	table.Empty(checkpoints)
	local pts = zb.GetMapPoints("FLATOUT_CHECKPOINT")
	if not pts then
		print("[FLATOUT] ERROR: FLATOUT_CHECKPOINT map points are nil")
		return
	end

	for _, point in ipairs(pts) do
		local pos = isvector(point) and point or (istable(point) and point.pos or nil)
		if isvector(pos) then
			table.insert(checkpoints, pos)
		else
			print("[FLATOUT] WARNING: invalid checkpoint map point:", tostring(point))
		end
	end

	print("[FLATOUT] Broadcasting checkpoints:", #checkpoints)
	net.Start("flatout_checkpoints")
		net.WriteUInt(#checkpoints, 16)
		for _, pos in ipairs(checkpoints) do
			net.WriteVector(pos)
		end
	net.Broadcast()
end

function MODE:AssignTeams()
	table.Empty(assigned)
	table.Empty(positions)

	local players = player.GetAll()
	shuffle(players)

	local cap = math.min(#players, MAX_PLAYERS:GetInt())
	for i = 1, cap do
		local ply = players[i]
		if IsValid(ply) then
			assigned[ply] = 1
			positions[ply] = {
				cp = 0,
				finished = false,
				retired = false,
				time = 0,
				pos = i,
				vehicle = nil,
			}
		end
	end

	for i = cap + 1, #players do
		local ply = players[i]
		if IsValid(ply) then
			ply:ChatPrint("everything is filled, sorry")
		end
	end
end

local function CountReady()
	local ready, total = 0, 0
	for ply in pairs(assigned) do
		if not IsValid(ply) then assigned[ply] = nil continue end
		total = total + 1
		if ply.flatout_ready then ready = ready + 1 end
	end
	return ready, total
end

local function SyncReady()
	local ready, total = CountReady()

	net.Start("flatout_readycount")
		net.WriteUInt(ready, 8)
		net.WriteUInt(total, 8)
	net.Broadcast()

	if total > 0 and ready >= total and zb.ROUND_STATE == 0 then
		zb.START_TIME = math.min(zb.START_TIME or math.huge, CurTime() + 2)
	end
end

net.Receive("flatout_ready", function(len, ply)
	if zb.CROUND ~= "flatout" or zb.ROUND_STATE ~= 0 then return end
	if assigned[ply] == nil then return end
	ply.flatout_ready = true
	SyncReady()
end)

-- FIX: 8 бит вместо 4 — раньше всё >15 молча превращалось в мусор
net.Receive("flatout_vehicle", function(len, ply)
	if assigned[ply] == nil then return end
	local idx = net.ReadUInt(8)
	if idx >= 1 and MODE.Vehicles and MODE.Vehicles[idx] then
		ply.flatout_vehicle = idx
	else
		ply.flatout_vehicle = 1
	end
end)

function MODE:Intermission()
	game.CleanUpMap()
	self:AssignTeams()

	for _, ply in player.Iterator() do
		ply.flatout_ready = nil
		ply.flatout_vehicle = nil
		ply.flatout_started = nil
		ply.flatout_locked = nil
		ply.flatout_seated = nil
		ply.flatout_outside_since = nil
		ply.flatout_warned1 = nil
		ply.flatout_warned2 = nil
		ply.flatout_nextcp = nil
		ply:SetTeam(TEAM_SPECTATOR)
		ply:KillSilent()
	end

	net.Start("flatout_start")
	net.Broadcast()

	-- Send checkpoints AFTER flatout_start: the client start handler resets race state.
	BuildCheckpoints()

	timer.Create("flatout_readysync", 3, 0, function()
		if zb.CROUND ~= "flatout" or zb.ROUND_STATE ~= 0 then
			timer.Remove("flatout_readysync")
			return
		end
		SyncReady()
	end)
end

local function ForceEnterVehicle(ply, vehicle)
	if not IsValid(ply) or not IsValid(vehicle) then return false end
	if ply:InVehicle() then return true end

	if isfunction(vehicle.SetDriver) then
		local ok = pcall(function() vehicle:SetDriver(ply) end)
		if ok and ply:InVehicle() then return true end
	end

	local seat
	if isfunction(vehicle.GetDriverSeat) then
		seat = vehicle:GetDriverSeat()
	end

	if not IsValid(seat) and isfunction(vehicle.GetSeats) then
		local seats = vehicle:GetSeats()
		if istable(seats) then
			for _, s in ipairs(seats) do
				if IsValid(s) then seat = s break end
			end
		end
	end

	if IsValid(seat) then
		ply:EnterVehicle(seat)
		if ply:InVehicle() then return true end
	end

	ply:EnterVehicle(vehicle)
	if ply:InVehicle() then return true end

	return false
end

local function SetVehicleFrozen(vehicle, frozen)
	if not IsValid(vehicle) then return end

	local phys = vehicle:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(not frozen)
		if frozen then
			phys:Sleep()
		else
			phys:Wake()
		end
	end

	if vehicle.Freeze then
		vehicle:Freeze(frozen)
	end
end

local function RetireRacer(ply, finished)
	if not IsValid(ply) then return end

	local data = positions[ply]

	if data and IsValid(data.vehicle) then
		data.vehicle.flatout_owner = nil
		data.vehicle:Remove()
		data.vehicle = nil
	end

	if ply:InVehicle() then
		ply:ExitVehicle()
	end

	ply.flatout_locked = false
	ply.flatout_seated = false
	ply.flatout_outside_since = nil
	ply.flatout_warned1 = nil
	ply.flatout_warned2 = nil

	ply:SetTeam(TEAM_SPECTATOR)
	ply:KillSilent()
end

local function SpawnRacer(ply)
	if not IsValid(ply) then return end

	local pts = zb.GetMapPoints("FLATOUT_SPAWN")
	if not pts or #pts == 0 then
		ply:ChatPrint("No spawn points? please replace: FLATOUT_SPAWN!")
		return
	end

	local idx = positions[ply] and positions[ply].pos or 1
	local pnt = pts[((idx - 1) % #pts) + 1]
	local pos = pnt.pos + Vector(math.cos((idx - 1) * 0.6) * 80, math.sin((idx - 1) * 0.6) * 80, 32)
	local ang = pnt.ang or Angle(0, 0, 0)
	ang.p = 0
	ang.r = 0

	if not MODE.Vehicles or #MODE.Vehicles == 0 then
		ply:ChatPrint("The list of vehicles is empty!")
		return
	end

	if IsValid(positions[ply].vehicle) then
		positions[ply].vehicle.flatout_owner = nil
		positions[ply].vehicle:Remove()
		positions[ply].vehicle = nil
	end

	if ply:InVehicle() then
		ply:ExitVehicle()
	end

	-- FIX: надёжный фоллбэк, если по какой-то причине индекс невалиден
	local vehIdx = tonumber(ply.flatout_vehicle) or 1
	if vehIdx < 1 or vehIdx > #MODE.Vehicles then
		vehIdx = 1
	end
	local vehData = MODE.Vehicles[vehIdx]

	local vehicle = ents.Create(vehData.class)
	if not IsValid(vehicle) then
		ply:ChatPrint("Failed to create a vehicle of the class '" .. tostring(vehData.class) .. "'!")
		return
	end

	vehicle:SetPos(pos)
	vehicle:SetAngles(ang)
	vehicle:Spawn()
	vehicle:Activate()

	vehicle:SetNWEntity("flatout_owner", ply)
	vehicle.flatout_owner = ply

	SetVehicleFrozen(vehicle, true)

	if vehicle.TurnOn then
		timer.Simple(0.1, function()
			if IsValid(vehicle) then vehicle:TurnOn() end
		end)
	end

	positions[ply].vehicle = vehicle
	ply.flatout_started = CurTime()
	ply.flatout_nextcp = 1
	ply.flatout_locked = true
	ply.flatout_outside_since = nil
	ply.flatout_warned1 = nil
	ply.flatout_warned2 = nil

	ply:SetTeam(1)
	ply:Spawn()
	ply:Freeze(false)
	ply:SetupTeam(1)

	ply:StripWeapons()
	ply:Give("weapon_hands_sh")
	ply:SetSuppressPickupNotices(true)

	local function TryEnter(attempt)
		attempt = attempt or 0
		if not IsValid(ply) or not IsValid(vehicle) then return end

		if ply:InVehicle() then
			ply:SetEyeAngles(ang)
			ply:SetSuppressPickupNotices(false)
			ply.flatout_seated = true
			SetVehicleFrozen(vehicle, true)
			return
		end

		ForceEnterVehicle(ply, vehicle)

		if not ply:InVehicle() and attempt < 20 then
			timer.Simple(0.05, function() TryEnter(attempt + 1) end)
		elseif not ply:InVehicle() then
			ply:SetPos(vehicle:GetPos() + Vector(0, 0, 30))
			ply:SetEyeAngles(ang)
			ply:ChatPrint("Get in the car, quick! Press E")
			ply:SetSuppressPickupNotices(false)
		end
	end

	timer.Simple(0.15, function() TryEnter(0) end)
end

local function SortByProgress()
	local list = {}
	for ply, data in pairs(positions) do
		if IsValid(ply) then
			table.insert(list, {ply = ply, data = data})
		end
	end

	table.sort(list, function(a, b)
		local ad, bd = a.data, b.data
		local aReal = ad.finished and not ad.retired
		local bReal = bd.finished and not bd.retired

		if aReal and bReal then return (ad.time or 0) < (bd.time or 0) end
		if aReal then return true end
		if bReal then return false end
		if ad.finished and bd.finished then return ad.pos < bd.pos end
		if ad.finished then return true end
		if bd.finished then return false end
		if ad.cp ~= bd.cp then return ad.cp > bd.cp end
		return false
	end)

	for i, entry in ipairs(list) do
		if entry.data.pos ~= i then
			entry.data.pos = i
			net.Start("flatout_positions")
				net.WriteEntity(entry.ply)
				net.WriteUInt(i, 8)
			net.Broadcast()
		end
	end
end

local function CheckCheckpoints()
	if #checkpoints == 0 then return end

	local radius = MODE.CheckpointRadius or 520
	local radiusSqr = radius * radius
	local heightTolerance = 220

	for ply, data in pairs(positions) do
		if not IsValid(ply) or not ply:Alive() then continue end
		if data.finished then continue end

		local nextIdx = ply.flatout_nextcp or 1

		if nextIdx > #checkpoints then
			data.finished = true
			data.retired = false
			data.time = CurTime() - startTime
			finishedCount = finishedCount + 1
			data.pos = finishedCount

			net.Start("flatout_finish")
				net.WriteEntity(ply)
				net.WriteFloat(data.time)
				net.WriteUInt(data.pos, 8)
			net.Broadcast()

			ply:ChatPrint(string.format("FINISH! Position %d, time %.2f", data.pos, data.time))

			RetireRacer(ply, true)
			SortByProgress()
			continue
		end

		local cpPos = checkpoints[nextIdx]
		if not cpPos then continue end

		local plyPos = ply:GetPos()
		if ply:InVehicle() then
			plyPos = ply:GetVehicle():GetPos()
		end

		local dz = math.abs(plyPos.z - cpPos.z)
		local flatSqr = (plyPos.x - cpPos.x) ^ 2 + (plyPos.y - cpPos.y) ^ 2

		if flatSqr < radiusSqr and dz < heightTolerance then
			data.cp = nextIdx
			ply.flatout_nextcp = nextIdx + 1

			net.Start("flatout_checkpoint")
				net.WriteEntity(ply)
				net.WriteUInt(nextIdx, 8)
				net.WriteUInt(#checkpoints, 8)
			net.Broadcast()

			net.Start("flatout_cp_effect")
				net.WriteVector(cpPos)
				net.WriteUInt(nextIdx, 8)
			net.Broadcast()

			SortByProgress()
		end
	end
end

local function CheckDriversOutside()
	if not raceStarted then return end

	local timeout = MODE.OutsideVehicleTimeout or 3

	for ply, data in pairs(positions) do
		if not IsValid(ply) then continue end
		if data.finished then continue end
		if not ply:Alive() then continue end

		if ply:InVehicle() then
			ply.flatout_outside_since = nil
			ply.flatout_warned1 = nil
			ply.flatout_warned2 = nil
		else
			if not ply.flatout_outside_since then
				ply.flatout_outside_since = CurTime()
			end

			local outside = CurTime() - ply.flatout_outside_since
			local left = timeout - outside

			if outside >= 1 and not ply.flatout_warned1 then
				ply.flatout_warned1 = true
				ply:ChatPrint(math.ceil(left))
			elseif outside >= 2 and not ply.flatout_warned2 then
				ply.flatout_warned2 = true
				ply:ChatPrint(math.ceil(left))
			end

			if outside >= timeout then
				ply.flatout_outside_since = nil
				ply.flatout_warned1 = nil
				ply.flatout_warned2 = nil
				ply:ChatPrint("you are idiot! don't get out the car!")

				data.finished = true
				data.retired = true
				data.time = 0
				finishedCount = finishedCount + 1
				data.pos = finishedCount

				net.Start("flatout_finish")
					net.WriteEntity(ply)
					net.WriteFloat(0)
					net.WriteUInt(finishedCount, 8)
				net.Broadcast()

				RetireRacer(ply, false)
				SortByProgress()
			end
		end
	end
end

local function HandleDeath(ply)
	if not IsValid(ply) then return end
	if zb.CROUND ~= "flatout" or zb.ROUND_STATE ~= 1 then return end
	if not positions[ply] then return end
	if positions[ply].finished then return end

	positions[ply].finished = true
	positions[ply].retired = true
	positions[ply].time = 0
	finishedCount = finishedCount + 1
	positions[ply].pos = finishedCount

	ply:ChatPrint("You crashed and are out of the race.")

	net.Start("flatout_finish")
		net.WriteEntity(ply)
		net.WriteFloat(0)
		net.WriteUInt(finishedCount, 8)
	net.Broadcast()

	RetireRacer(ply, false)
	SortByProgress()
end

function MODE:PlayerDeath(ply)
	timer.Simple(0.5, function()
		HandleDeath(ply)
	end)
end

hook.Add("PlayerDeath", "flatout_playerdeath", function(ply)
	timer.Simple(0.5, function()
		HandleDeath(ply)
	end)
end)

hook.Add("PlayerEnteredVehicle", "flatout_block_foreign_vehicles", function(ply, vehicle, role)
	if zb.CROUND ~= "flatout" then return end
	if not IsValid(ply) or not IsValid(vehicle) then return end

	local owner = vehicle.flatout_owner
	if not IsValid(owner) then
		owner = vehicle:GetNWEntity("flatout_owner")
	end

	if not IsValid(owner) then return end

	if owner ~= ply then
		timer.Simple(0, function()
			if not IsValid(ply) or not IsValid(vehicle) then return end

			if ply:InVehicle() then
				ply:ExitVehicle()
			end

			ply:ChatPrint("DON'T DO THAT.")
		end)
	end
end)

function MODE:RoundStart()
	timer.Remove("flatout_readysync")
	BuildCheckpoints()

	for ply in pairs(assigned) do
		if IsValid(ply) then
			ply.flatout_nextcp = 1
			ply.flatout_locked = true
			ply.flatout_outside_since = nil
			ply.flatout_warned1 = nil
			ply.flatout_warned2 = nil
			timer.Simple(0.1, function()
				if IsValid(ply) then SpawnRacer(ply) end
			end)
		end
	end

	local raceStartAt = CurTime() + START_COUNTDOWN
	startTime = raceStartAt
	raceStarted = false
	finishedCount = 0

	net.Start("flatout_countdown")
		net.WriteFloat(START_COUNTDOWN)
	net.Broadcast()

	net.Start("flatout_music_start")
	net.Broadcast()

	hook.Add("StartCommand", "flatout_startlock", function(ply, mv)
		if not ply.flatout_locked then return end
		if zb.ROUND_STATE ~= 1 then return end

		mv:RemoveKey(IN_ATTACK)
		mv:RemoveKey(IN_ATTACK2)
		mv:RemoveKey(IN_FORWARD)
		mv:RemoveKey(IN_BACK)
		mv:RemoveKey(IN_MOVELEFT)
		mv:RemoveKey(IN_MOVERIGHT)
		mv:RemoveKey(IN_JUMP)
		mv:RemoveKey(IN_DUCK)
		mv:RemoveKey(IN_RELOAD)
	end)

	timer.Create("flatout_tick", 0.1, 0, function()
		if zb.CROUND ~= "flatout" or zb.ROUND_STATE ~= 1 then
			timer.Remove("flatout_tick")
			hook.Remove("StartCommand", "flatout_startlock")
			return
		end

		if not raceStarted and CurTime() >= startTime then
			raceStarted = true

			for ply, data in pairs(positions) do
				if IsValid(ply) and not data.finished then
					ply.flatout_locked = false

					local veh = data.vehicle
					if IsValid(veh) then
						SetVehicleFrozen(veh, false)
					end
				end
			end

			hook.Remove("StartCommand", "flatout_startlock")
		end

		if raceStarted then
			CheckCheckpoints()
			CheckDriversOutside()
		end
	end)

	timer.Create("flatout_positions_sync", 1, 0, function()
		if zb.CROUND ~= "flatout" or zb.ROUND_STATE ~= 1 then
			timer.Remove("flatout_positions_sync")
			return
		end
		SortByProgress()
	end)
end

function MODE:GiveEquipment() end
function MODE:RoundThink() end
function MODE:CanSpawn() end

function MODE:CheckAlivePlayers()
	local alive = {}
	for _, ply in ipairs(team.GetPlayers(1)) do
		local data = positions[ply]
		if ply:Alive() and (not data or not data.finished) then
			table.insert(alive, ply)
		end
	end
	return {alive}
end

function MODE:ShouldRoundEnd()
	if zb.ROUND_STATE ~= 1 then return false end

	local total = 0
	local done = 0
	local realFinished = 0

	for ply, data in pairs(positions) do
		if IsValid(ply) then
			total = total + 1
			if data.finished then
				done = done + 1
				if not data.retired then
					realFinished = realFinished + 1
				end
			end
		end
	end

	if total > 0 and done >= total then
		if realFinished == 0 then
			return true, 3
		end
		return true, 1
	end

	if zb.ROUND_BEGIN and zb.ROUND_BEGIN + MODE.ROUND_TIME < CurTime() then
		if realFinished == 0 then
			return true, 3
		end
		return true, 1
	end

	return false
end

function MODE:GetTeamSpawn()
	return {}, zb.TranslatePointsToVectors(zb.GetMapPoints("FLATOUT_SPAWN"))
end

function MODE:CanLaunch()
	local points = zb.GetMapPoints("FLATOUT_SPAWN")
	local cps = zb.GetMapPoints("FLATOUT_CHECKPOINT")
	local playing = zb:CheckPlaying()
	return points and #points > 0 and cps and #cps > 1 and #playing > 1
end

function MODE:EndRound()
	timer.Remove("flatout_tick")
	timer.Remove("flatout_positions_sync")
	timer.Remove("flatout_readysync")
	hook.Remove("StartCommand", "flatout_startlock")
	hook.Remove("PlayerDeath", "flatout_playerdeath")

	net.Start("flatout_music_stop")
	net.Broadcast()

	net.Start("flatout_checkpoints")
		net.WriteUInt(0, 16)
	net.Broadcast()

	net.Start("flatout_checkpoint")
		net.WriteEntity(NULL)
		net.WriteUInt(0, 8)
		net.WriteUInt(0, 8)
	net.Broadcast()

	for ply, data in pairs(positions) do
		if IsValid(ply) then
			ply.flatout_locked = false
			ply.flatout_outside_since = nil
			ply.flatout_warned1 = nil
			ply.flatout_warned2 = nil

			if IsValid(data.vehicle) then
				data.vehicle.flatout_owner = nil
				data.vehicle:Remove()
				data.vehicle = nil
			end

			if ply:InVehicle() then
				ply:ExitVehicle()
			end

			if ply:Team() ~= TEAM_SPECTATOR then
				ply:SetTeam(TEAM_SPECTATOR)
				ply:KillSilent()
			end
		end
	end

	local results = {}
	local realFinished = 0

	for ply, data in pairs(positions) do
		if IsValid(ply) then
			table.insert(results, {ply = ply, data = data})
			if data.finished and not data.retired then
				realFinished = realFinished + 1
			end
		end
	end

	table.sort(results, function(a, b)
		local ad, bd = a.data, b.data
		local aReal = ad.finished and not ad.retired
		local bReal = bd.finished and not bd.retired

		if aReal and bReal then return (ad.time or 0) < (bd.time or 0) end
		if aReal then return true end
		if bReal then return false end
		return ad.pos < bd.pos
	end)

	local isDraw = realFinished == 0
	local winner = (not isDraw) and results[1] and results[1].ply or NULL

	net.Start("flatout_roundend")
		net.WriteEntity(IsValid(winner) and winner or NULL)
		net.WriteUInt(#results, 8)
		for i, entry in ipairs(results) do
			net.WriteEntity(entry.ply)
			net.WriteUInt(entry.data.pos, 8)
			net.WriteFloat(entry.data.finished and entry.data.time or 0)
			net.WriteBool(entry.data.finished and not entry.data.retired)
		end
		net.WriteBool(isDraw)
	net.Broadcast()

	for i, entry in ipairs(results) do
		local ply = entry.ply
		if IsValid(ply) then
			if isDraw then
				ply:GiveExp(math.random(5, 12))
				ply:GiveSkill(math.Rand(0.02, 0.06))
			elseif i == 1 and entry.data.finished and not entry.data.retired then
				ply:GiveExp(math.random(25, 40))
				ply:GiveSkill(math.Rand(0.15, 0.25))
			elseif i <= 3 and entry.data.finished and not entry.data.retired then
				ply:GiveExp(math.random(15, 25))
				ply:GiveSkill(math.Rand(0.08, 0.15))
			else
				ply:GiveExp(math.random(5, 12))
				ply:GiveSkill(math.Rand(0.02, 0.06))
			end
		end
	end

	table.Empty(assigned)
	table.Empty(positions)
end