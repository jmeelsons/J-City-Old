GM.Name = "ZCity"
GM.Author = "uzelezz, sadsalat, Mr. Point, Zac90, Deka, Mannytko"
GM.Email = "N/A"
GM.Website = "N/A"

team.SetUp(0, "Players", Color(255, 0, 0))
team.SetUp(1, "Players2", Color(0, 0, 255))
team.SetUp(2, "Players3", Color(0, 255, 0))

DeriveGamemode("sandbox")

local blur = Material("pp/blurscreen")
local hg_potatopc -- НАДО ЭТО ГОВНО ПЕРЕПИСАТЬ НОРМАЛЬНО, И ВСЕ МЕНЮШКИ ОДИНАКОВЫЕ ТОЖЕ!!!
function hg.DrawBlur(panel, amount, passes, alpha)
	if is3d2d then return end
	amount = amount or 5
	hg_potatopc = hg_potatopc or hg.ConVars.potatopc

	if(hg_potatopc:GetBool())then
		surface.SetDrawColor(0, 0, 0, alpha or (amount * 20))
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(0, 0, 0, alpha or 125)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

		local x, y = panel:LocalToScreen(0, 0)

		for i = -(passes or 0.2), 1, 0.2 do
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()
			
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end

CreateConVar( "zc_getspawn", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED )

zb = zb or {}
zb.SpawnMenuBlockedModes = zb.SpawnMenuBlockedModes or {
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
	["dr"]  = true,
    ["flatout"]  = true,
    ["bodycrawler"]  = true,
	["sandbox"]  = false,
    ["construct"]  = false,
}

local function IsPrivileged( ply )
	return IsValid( ply ) and ( ply:IsAdmin() or ply:IsSuperAdmin() )
end

local function IsSpawnBlockedMode()
	if not zb or not zb.CROUND then return false end
	return zb.SpawnMenuBlockedModes[zb.CROUND] == true
end

local function BlockSpawn( ply )
	if game.SinglePlayer() then return true end
	if IsPrivileged( ply ) then return true end

	if IsSpawnBlockedMode() then return false end

	if GetConVar( "zc_getspawn" ):GetBool() then return true end

	return false
end

local spawnHooks = {
	"PlayerGiveSWEP",
	"PlayerSpawnEffect",
	"PlayerSpawnNPC",
	"PlayerSpawnObject",
	"PlayerSpawnProp",
	"PlayerSpawnRagdoll",
	"PlayerSpawnSENT",
	"PlayerSpawnSWEP",
	"PlayerSpawnVehicle",
}

for _, v in ipairs( spawnHooks ) do
	hook.Add( v, "BlockSpawn", BlockSpawn )
end

hook.Add( "PlayerSpawnNPC", "BlockNPCForRegularPlayers", function( ply )
	if game.SinglePlayer() then return end
	if IsPrivileged( ply ) then return end
	return false
end )

hook.Add( "PlayerNoClip", "BlockNoclipForRegularPlayers", function( ply, desiredState )
	if game.SinglePlayer() then return end
	if IsPrivileged( ply ) then return true end

	if desiredState then
		return false
	end
	return true
end )

if CLIENT then
	hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
		local ply = LocalPlayer()
		if not IsValid( ply ) then return false end

		if ply:IsSuperAdmin() or ply:IsAdmin() then return end

		if zb and zb.CROUND and zb.SpawnMenuBlockedModes and zb.SpawnMenuBlockedModes[zb.CROUND] then
			return false
		end

		local allow = GetConVar( "zc_getspawn" )
		if allow and allow:GetBool() then return end

		return false
	end )
end

local team_GetAllTeams = team.GetAllTeams

function zb:CheckTeams()
	local tbl = {}
	for i, info in pairs(team_GetAllTeams()) do
		tbl[i] = {}
	end

	for _, ply in player.Iterator() do
		tbl[ply:Team()][#tbl[ply:Team()] + 1] = ply
	end
	return tbl
end

function zb:CheckAliveTeams(incapacitatedcheck)
	local tbl = {}

	for i, info in pairs(team_GetAllTeams()) do
		if i == TEAM_UNASSIGNED or i == TEAM_SPECTATOR then continue end
		tbl[i] = {}
	end

	for _, ply in player.Iterator() do
		if not ply:Alive() then continue end
		if incapacitatedcheck and ply.organism and ply.organism.incapacitated then continue end

		tbl[ply:Team() or 0] = tbl[ply:Team() or 0] or {}
		tbl[ply:Team()][(#tbl[ply:Team() or 0] or 0) + 1] = ply
	end

	return tbl
end

function zb:CheckAlive(incapacitatedcheck)
	local tbl = {}
	for _, ply in player.Iterator() do
		if not ply:Alive() then continue end
		if incapacitatedcheck and ply.organism and ply.organism.incapacitated then continue end
		tbl[#tbl + 1] = ply
	end
	return tbl
end

function zb:CheckPlaying()
	local tbl = {}
	for _, ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end
		if not ply:Alive() then continue end
		
		tbl[#tbl + 1] = ply
	end
	return tbl
end

function GM:GrabEarAnimation(ply)
	hg.earanim(ply)
end