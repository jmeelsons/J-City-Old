--говнокод
zb = zb or {}
local Mapsstf = {
    ["dr"] = {"dr_", "deathrun_"},
}

function GetModeMap(mapName)
    mapName = string.lower(mapName or game.GetMap() or "")
    for modeName, modeData in pairs(Mapsstf) do
        for _, prefix in ipairs(modeData) do
            if string.sub(mapName, 1, #prefix) == prefix then
                return modeName
            end
        end
    end
    return false
end

hook.Add("ZB_StartRound", "fmm", function()
    local detectedMode = GetModeMap()
    if detectedMode and zb and zb.modes and zb.modes[detectedMode] then
        zb.CROUND = detectedMode
        zb.CROUND_MAIN = detectedMode
        zb.LASTCROUND = detectedMode
        zb.nextround = detectedMode
    end
end)
hook.Add("ZB_PreRoundStart", "fprrnd", function()
    local detectedMode = GetModeMap()
    if detectedMode and zb and zb.modes and zb.modes[detectedMode] then
        zb.CROUND = detectedMode
        zb.CROUND_MAIN = detectedMode
        zb.LASTCROUND = detectedMode
        zb.nextround = detectedMode
    end
end)

local originalCurrentRound = CurrentRound
CurrentRound = function(...)
    local detectedMode = GetModeMap()
    if detectedMode and zb and zb.modes and zb.modes[detectedMode] then
        zb.CROUND_MAIN = detectedMode
        zb.LASTCROUND = detectedMode
        zb.CROUND = detectedMode
        return zb.modes[detectedMode], detectedMode
    end
    return originalCurrentRound(...)
end

local originalNextRound = NextRound
NextRound = function(round)
    local detectedMode = GetModeMap()
    if detectedMode and zb and zb.modes and zb.modes[detectedMode] then
        return originalNextRound(detectedMode)
    end
    return originalNextRound(round)
end

timer.Simple(0.1, function()
    local detectedMode = GetModeMap()
    if detectedMode and zb and zb.modes and zb.modes[detectedMode] then
        zb.CROUND = detectedMode
        zb.CROUND_MAIN = detectedMode
        zb.LASTCROUND = detectedMode
        zb.nextround = detectedMode
    end
end)

-- maps
zb.MapForcedModes = zb.MapForcedModes or {
    ["gm_construct"]                  = { mode = "sandbox", allow_change = true  },
    ["rp_truenorth_v1a"]              = { mode = "construct", allow_change = true  },
    ["gm_construct_sunset"]           = { mode = "sandbox", allow_change = true  },
    ["gm_construct_backrooms"]        = { mode = "sandbox", allow_change = true  },
    ["gm_flatgrass"]                  = { mode = "sandbox", allow_change = true  },
    ["gm_freespace_13"]               = { mode = "sandbox", allow_change = true  },
    ["gm_christruct"]                 = { mode = "sandbox", allow_change = true  },
    ["gm_christruct_noice"]           = { mode = "sandbox", allow_change = true  },
    ["gm_bigcity_dusk"]               = { mode = "sandbox", allow_change = true  },
    ["gm_bigcity_improved"]           = { mode = "sandbox", allow_change = true  },
    ["gm_highway14800"]               = { mode = "sandbox", allow_change = true  },
    ["rp_bangclaw"]                   = { mode = "sandbox", allow_change = true  },
    ["gm_genesis"]                    = { mode = "sandbox", allow_change = true  },
    ["gm_infinity_pools"]             = { mode = "sandbox", allow_change = true  },
    ["gm_playground_v1a"]             = { mode = "sandbox", allow_change = true  },
    ["pole_csm"]                      = { mode = "sandbox", allow_change = true  },
    ["gm_construct_15"]               = { mode = "sandbox", allow_change = true  },
    ["gm_avalanche"]                  = { mode = "event",   allow_change = true  },
    ["slash_highschool"]              = { mode = "event",   allow_change = true  },
    ["slash_summercamp"]              = { mode = "event",   allow_change = true  },
    ["zgr_ragcom_highway_valley"]     = { mode = "event",   allow_change = true  },
    ["commercial_district"]           = { mode = "event",   allow_change = false },
    ["industrial_district"]           = { mode = "event",   allow_change = false },
    ["residential_district"]          = { mode = "event",   allow_change = false },
    ["gm_br_pitfalls"]                = { mode = "event",   allow_change = true  },
    ["gm_br_complex"]                 = { mode = "event",   allow_change = true  },
    ["columbine_highschool"]          = { mode = "event",   allow_change = false },
    ["gm_devbattle"]                  = { mode = "event",   allow_change = false },
    ["gm_pole"]                       = { mode = "sandbox", allow_change = true  },
    ["l4dbeta_vs_smalltown"]          = { mode = "horror_crawler", allow_change = false },
    ["l4dbeta_vs_trainyard"]          = { mode = "horror_crawler", allow_change = false },
}

zb._forcedModeUnlocked = zb._forcedModeUnlocked or {}

local function zb_GetMapEntry()
    return zb.MapForcedModes and zb.MapForcedModes[game.GetMap()]
end

local function zb_GetForcedMapMode()
    local entry = zb_GetMapEntry()
    if not entry then return nil end
    if not (zb.modes and zb.modes[entry.mode]) then return nil end
    return entry.mode, entry.allow_change
end

local function zb_IsLocked()
    local _, allow_change = zb_GetForcedMapMode()
    if allow_change then return false end
    return true
end

local function zb_Unlock()
    local entry = zb_GetMapEntry()
    if not entry or not entry.allow_change then return false end
    if zb._forcedModeUnlocked[game.GetMap()] then return false end
    zb._forcedModeUnlocked[game.GetMap()] = true
    print("Forced mode unlocked for " .. game.GetMap())
    return true
end

local function zb_IsUnlocked()
    return zb._forcedModeUnlocked[game.GetMap()] == true
end

hook.Add("InitPostEntity", "zb_ForceMapMode_Apply", function()
    local forced, allow_change = zb_GetForcedMapMode()
    if not forced then return end

    if not zb._forced_orig_CurrentRound then
        zb._forced_orig_CurrentRound = CurrentRound
        zb._forced_orig_NextRound    = NextRound

        function CurrentRound()
            if zb_IsLocked() or (not zb_IsUnlocked() and zb_GetForcedMapMode()) then
                local f = zb_GetForcedMapMode()
                if f then
                    zb.CROUND      = f
                    zb.CROUND_MAIN = f
                    zb.LASTCROUND  = f
                    return zb.modes[f], f
                end
            end
            return zb._forced_orig_CurrentRound()
        end

        function NextRound(round)
            local f, can_change = zb_GetForcedMapMode()
            if not f then
                return zb._forced_orig_NextRound(round)
            end

            if zb_IsUnlocked() then
                return zb._forced_orig_NextRound(round)
            end

            if not can_change then
                zb.nextround = f
                return
            end

            if round and round ~= f then
                zb_Unlock()
                return zb._forced_orig_NextRound(round)
            end
                
            zb.nextround = f
        end
    end

    zb._forcedModeUnlocked[game.GetMap()] = false
    zb.CROUND      = forced
    zb.nextround   = forced
    zb.CROUND_MAIN = forced
    zb.LASTCROUND  = forced

    print(("Start mode for %s: %s (allow_change=%s)"):format(
        game.GetMap(), forced, tostring(allow_change)
    ))

    timer.Simple(1, function()
        if zb.UpdateHostname then zb.UpdateHostname(forced) end
        if zb.BroadcastRoundName then zb.BroadcastRoundName(forced) end
    end)
end)

hook.Add("InitPostEntity", "zb_ForceMapMode_NetHook", function()
    local forced, allow_change = zb_GetForcedMapMode()
    if not forced or not allow_change then return end
end)