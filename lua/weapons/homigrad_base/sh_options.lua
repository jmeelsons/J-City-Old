if CLIENT then
	concommand.Add("hg_unload_ammo", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		if wep and ishgweapon(wep) and wep:Clip1() > 0 and wep:CanUse() then
			net.Start("unload_ammo")
			net.WriteEntity(wep)
			net.SendToServer()
			wep:SetClip1(0)
			wep.drawBullet = nil
		end
	end)

	concommand.Add("hg_change_ammotype", function(ply, cmd, args)
	    local wep = ply:GetActiveWeapon()
	    local type_ = math.Round(args[1])
	    if wep and ishgweapon(wep) and (wep:Clip1() == 0 or wep.AllwaysChangeAmmo) and wep:CanUse() and wep.AmmoTypes and wep.AmmoTypes[type_] then
	        ply:ChatPrint("Changed ammotype to: " .. wep.AmmoTypes[type_][1])
	        net.Start("changeAmmoType")
	        net.WriteEntity(wep)
	        net.WriteInt(type_, 4)
	        net.SendToServer()
	    end
	end)

	net.Receive("unload_ammo",function()
		local wep = net.ReadEntity()
		if wep.AnimList["unload"] then
			wep:PlayAnim("unload", wep.UnloadAnimTime)
		else
			wep:AttachAnim()
		end
		if wep.Unload then
			wep:Unload()
		end
	end)
else
	util.AddNetworkString("unload_ammo")
	util.AddNetworkString("changeAmmoType")

	net.Receive("unload_ammo", function(len, ply)
		local wep = net.ReadEntity()
        if ply:GetNWFloat("willsuicide", 0) > 0 then return end -- you cant escape.
        wep.drawBullet = nil
        if wep and wep:GetOwner() == ply and ishgweapon(wep) and wep:Clip1() > 0 and wep:CanUse() then
			ply:GiveAmmo(wep:Clip1(), wep:GetPrimaryAmmoType(), true)
			wep:SetClip1(0)
			if wep.Unload then
				wep:Unload()
			end
			net.Start("unload_ammo")
			net.WriteEntity(wep)
			net.Broadcast()
			hg.GetCurrentCharacter(ply):EmitSound("snd_jack_hmcd_ammotake.wav")
		end
	end)

	net.Receive("changeAmmoType", function(len, ply)
	    local wep = net.ReadEntity()
	    local type_ = net.ReadInt(4)
	    if not IsValid(wep) then return end
	    if wep:GetOwner() ~= ply then return end
	    if not ishgweapon(wep) then return end
	    if not wep:CanUse() then return end
	    if not wep.AmmoTypes or not wep.AmmoTypes[type_] then return end
	    if not wep.AllwaysChangeAmmo and wep:Clip1() ~= 0 then return end
	    wep:ApplyAmmoChanges(type_)
	end)
end

hg.postures = {
    [0] = "Regular hold",
    [1] = "Hipfire",
    [2] = "Left shoulder",
    [3] = "High ready",
    [4] = "Low ready",
    [5] = "Point shooting",
    [6] = "Shooting from cover",
    [7] = {"Gangsta",isPistolOnly = true},
    [8] = {"One-handed",isPistolOnly = true},
	[9] = "Somalian",
}

if CLIENT then
	local printed

	concommand.Add("hg_change_posture", function(ply, cmd, args)
		if not args[1] and not isnumber(args[1]) and not printed then print([[Change your gun posture:
0 - regular hold
1 - hipfire
2 - left shoulder
3 - high ready
4 - low ready
5 - point shooting
6 - shooting from cover
7 - gangsta shooting
8 - one-handed shooting
9 - somalian shooting
]]) printed = true end
		local pos = math.Round(args[1] or -1)
		net.Start("change_posture")
		net.WriteInt(pos, 8)
		net.SendToServer()
	end)

	net.Receive("change_posture", function()
		local ply = net.ReadEntity()
		local pos = net.ReadInt(8)
		
		ply.posture = pos
	end)
else
	util.AddNetworkString("change_posture")
	net.Receive("change_posture", function(len, ply)
		local pos = net.ReadInt(8)

		if (ply.change_posture_cooldown or 0) > CurTime() then return end
		ply.change_posture_cooldown = CurTime() + 0.1

		local gun = ply:GetActiveWeapon()
		if IsValid(gun) and ishgweapon(gun) then
			ply:EmitSound("weapons/zmirli/shared/foley_light" .. math.random(1,4) .. ".wav", 45, math.random(95,105))
		end

		if pos ~= -1 then
			if pos == ply.posture then
				ply.posture = 0
				pos = 0
			else
				ply.posture = pos
			end
		else
			ply.posture = ply.posture or 0
			ply.posture = (ply.posture + 1) > #hg.postures and 0 or ply.posture + 1
		end
		net.Start("change_posture")
		net.WriteEntity(ply)
		net.WriteInt(ply.posture, 9)
		net.Broadcast()
	end)
end

if SERVER then
	util.AddNetworkString("hg_viewgun")

	concommand.Add("hg_inspect", function(ply, cmd, args)
		local gun = ply:GetActiveWeapon()
		if not IsValid(gun) or not gun or not gun.AllowedInspect then return end
		gun.inspect = CurTime() + 5
		net.Start("hg_viewgun")
		net.WriteEntity(gun)
		net.WriteFloat(gun.inspect)
		net.Broadcast()
	end)
else
	net.Receive("hg_viewgun", function() 
		local ent = net.ReadEntity()
		local time = net.ReadFloat()
		ent.inspect = time
		ent.hudinspect = time
	end)
end

if CLIENT then
	local DRUM_SLOTS = 6

	local COL_EMPTY  = Color(140, 30, 30)
	local COL_LOADED = Color(40, 140, 60)
	local COL_HOVER  = Color(255, 255, 255, 60)

	local function IsRevolverWithDrum(wep)
		if not IsValid(wep) then return false end
		if not wep.Drum then return false end
		if not wep.GetDrum then return false end
		return true
	end

	local function GetDrumFromNW(wep)
		local str = wep:GetNWString("drum", "1 1 1 1 1 1")
		local t = string.Split(str, " ")
		local drum = {}
		for i = 1, DRUM_SLOTS do
			drum[i] = tonumber(t[i]) or 0
		end
		return drum
	end

	function hg.OpenRevolverDrumMenu()
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()

		if not IsRevolverWithDrum(wep) then return end

		local options = {}

		for i = 1, DRUM_SLOTS do
			local slotIndex = i

			options[#options + 1] = {
				function(mouseClick)
					if mouseClick ~= 1 then return end

					local p = LocalPlayer()
					local w = p:GetActiveWeapon()
					if not IsRevolverWithDrum(w) then return end

					RunConsoleCommand("hg_insertbullet", tostring(slotIndex))
					return -1
				end,
				"Slot " .. slotIndex,
				nil, nil, nil,
				COL_EMPTY,
				COL_HOVER,
			}
		end

		hg.CreateRadialMenu(options)

		timer.Simple(0, function()
			if not IsValid(MENUPANELHUYHUY) then return end

			MENUPANELHUYHUY.Think = function(self)
				local w = LocalPlayer():GetActiveWeapon()
				if not IsRevolverWithDrum(w) then return end

				local drum = GetDrumFromNW(w)

				for i = 1, DRUM_SLOTS do
					local loaded = drum[i] == 1
					local opt = options[i]
					if opt then
						opt[2] = "Slot " .. i .. (loaded and "\nLOADED" or "\nEMPTY")
						opt[6] = loaded and COL_LOADED or COL_EMPTY
					end
				end
			end
		end)
	end

	concommand.Add("hg_revolver_drummenu", function()
		hg.OpenRevolverDrumMenu()
	end)
end

if CLIENT then
	hook.Add("radialOptions", "weapon_manipulations", function()
		local wep = lply:GetActiveWeapon()
		local organism = lply.organism or {}
		
		if !lply:Alive() or !organism or organism.otrub or !organism.canmove then return end
		
		local attmenu = {
			[1] = function()
				RunConsoleCommand("hg_get_attachments", 0)

				return 0
			end,
			[2] = "Attachments Menu"
		}

        if !IsValid(wep) or !ishgweapon(wep) then
			if #hg.GetAttachmentsInv() > 0 then
				hg.radialOptions[#hg.radialOptions + 1] = attmenu
			end

			return
		end
		
        local tbl = {
            [1] = {
                [1] = function(mouseClick)
                    if mouseClick == 1 then
                        RunConsoleCommand("hg_change_posture", -1)
                    else
                        local tbl2 = {}

                        for i, str in pairs(hg.postures) do -- DO. NOT. CHANGE. TO. IPAIRS. kthxbye
							if istable(str) then
								if str.isPistolOnly and !wep:IsPistolHoldType() then continue end
							end
                            tbl2[#tbl2 + 1] = {
                                [1] = function()
                                    RunConsoleCommand("hg_change_posture", i)

                                end,
                                [2] = istable(str) and str[1] or str
                            }
                        end

                        hg.CreateRadialMenu(tbl2)
                    end

                    return -1
                end,
                [2] = "Change Posture\nRMB - Menu"
            },
            [2] = {
                [1] = function()
                    RunConsoleCommand("hg_change_posture", 0)
                end,
                [2] = "Reset Posture"
            },
			[3] = attmenu,
        }

		if wep.GetDrum then
			tbl[#tbl + 1] = {
				[1] = function()
					RunConsoleCommand("hg_rolldrum")
				end,
				[2] = "Roll Drum"
			}

			tbl[#tbl + 1] = {
				[1] = function()
					if hg.OpenRevolverDrumMenu then
						hg.OpenRevolverDrumMenu()
					end
				end,
				[2] = "Drum Slots\n RMB - Menu"
			}
		end

        if wep.AllowedInspect then
            tbl[#tbl + 1] = {
                [1] = function()
                    RunConsoleCommand("hg_inspect")
                end,
                [2] = "Inspect" 
            }
        end

        if wep:Clip1() > 0 then
            tbl[#tbl + 1] = {
                [1] = function()
                    RunConsoleCommand("hg_unload_ammo", 0)
                end,
                [2] = "Unload" 
            }
        elseif (wep:Clip1() == 0 or wep.AllwaysChangeAmmo) and wep.AmmoTypes and not wep.reload then
            tbl[#tbl + 1] = {
                [1] = function()
                    local ammotypes = {}

                    for k, ammotype in ipairs(wep.AmmoTypes) do
                        ammotypes[#ammotypes + 1] = {
                            [1] = function()
                                RunConsoleCommand("hg_change_ammotype", k)
                            end,
                            [2] = ammotype[1]
                        }
                    end

                    hg.CreateRadialMenu(ammotypes)
                end,
                [2] = "Change Ammo Type\n RMB - Menu"
            }
        end

        local laser = wep.attachments and wep.attachments.underbarrel
        if (laser and not table.IsEmpty(laser)) or wep.laser then
			tbl[#tbl + 1] = {
                [1] = function()
                    RunConsoleCommand("hmcd_togglelaser")
                end,
                [2] = "Toggle Laser" 
            }
		end

        hg.radialOptions[#hg.radialOptions + 1] = {
            [1] = function(mouseClick)
                hg.CreateRadialMenu(tbl)

                return -1
            end,
            [2] = "Weapon Menu"
        }
    end)
end