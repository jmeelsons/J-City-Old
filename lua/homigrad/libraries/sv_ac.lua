if true then return end

local mside = GetConVar("cl_sidespeed"):GetInt()
local mforw = GetConVar("cl_forwardspeed"):GetInt()

local curtime = CurTime()
local _math_abs = math.abs

local limit = 30

local function admin_advert(ply, n)
	if curtime > CurTime() then return end
	curtime = CurTime() + 2

	local text = string.format("%s - возможно использует чит. ПО. [%i/%i]", ply:Name(), n, limit)
	Msg("[AC] ")print(text)

	for k, v in ipairs(player.GetAll()) do
		if v:IsAdmin() then
			v:ChatPrint(text)
		end
	end

	if tonumber(n) > limit and not ply.PlayerBlocked then
		RunConsoleCommand("ulx", "banid", ply:SteamID(), "0", "[AC] Cheat Manipulations")
		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				v:ChatPrint( ply:Name() .. " ЧИТЕР ПОГАНЫЙ!" )
			end
		end
	end
end

local function mvcheck(ply, cmd)
	if (ply.ac_Anti or 0) > CurTime() then
		return
	end

	local side = cmd:GetSideMove()
	local forward = cmd:GetForwardMove()
	side = _math_abs(side)
	forward = _math_abs(forward)
	
	if (side == 0 and forward == 0 ) then return end 
	if (mforw == forward or mside == side) then return end

	if (side > mside or forward > mforw) then 
		ply.AimCheck = ply.AimCheck + 1 admin_advert(ply, ply.AimCheck) 
		return
	end

	if (side > mside - 5) then 
		ply.AimCheck = ply.AimCheck + 1 admin_advert(ply, ply.AimCheck) 
		return
	end

	if (forward > mforw - 5) then 
		ply.AimCheck = ply.AimCheck + 1 admin_advert(ply, ply.AimCheck) 
		return
	end
	// табуляция говно ыыыы кто писал эта гавно
end

hook.Add("StartCommand", "ac_check", mvcheck)

local function initial_aimcheck(ply)
	ply.AimCheck = 0
end

hook.Add("PlayerInitialSpawn", "ac_add", initial_aimcheck)

if(ULib)then
	local function checkBan( steamid64, ip, password, clpassword, name, noRefresh )
		local steamid = util.SteamIDFrom64( steamid64 )
		local banData = ULib.bans[ steamid ]
		if not noRefresh then
			timer.Simple(0,function()
				ULib.refreshBans()
				local hasBan,reason = checkBan( steamid64, ip, password, clpassword, name, true )
				if hasBan==false then
					game.KickID(steamid,reason)
				end
			end)
		end
		if not banData then return end -- Not banned
		-- Nothing useful to show them, go to default message
		if not banData.admin and not banData.reason and not banData.unban and not banData.time then return end
	
		local message = ULib.getBanMessage( steamid )
		Msg(string.format("%s (%s)<%s> was kicked by ULib because they are on the ban list\n", name, steamid, ip))
		return false, message
	end
	
	hook.Add( "CheckPassword", "ULibBanCheck", checkBan )
	
	hook.Add( "NetworkIDValidated", "KickIdiotFromServer", function( name, steamID, ownerID )
		timer.Simple(0,function()
			local hasBan,reason = checkBan( ownerID )
			if hasBan == false then
				game.KickID(steamid,reason)
				return
			end
		end)
	end )
end