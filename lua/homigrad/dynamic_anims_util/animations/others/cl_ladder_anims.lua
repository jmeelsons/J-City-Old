if SERVER then
    AddCSLuaFile()
end

local ENABLED = true
local ACT_IDLE = ACT_VM_IDLE_DEPLOYED_1
local ACT_UP   = ACT_SHIPLADDER_UP
local ACT_DOWN = ACT_SHIPLADDER_DOWN

local SUPPRESSED_TURN_ACTS = {
    [ACT_GESTURE_TURN_LEFT45]       = true,
    [ACT_GESTURE_TURN_LEFT45_FLAT]  = true,
    [ACT_GESTURE_TURN_RIGHT45]      = true,
    [ACT_GESTURE_TURN_RIGHT45_FLAT] = true,
}

local TRACE_DIST             = 128
local TRACE_ANGLES           = { 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330 }
local HEIGHT_OFFSETS         = { 4, 16, 28, 40, 52 }
local HULL_HALF              = Vector(8, 8, 8)
local LADDER_SEARCH_RADIUS   = 96
local TOP_DISMOUNT_TOLERANCE = 135
local MAX_NORMAL_Z           = 0.65
local RECOMPUTE_FRAMES       = 12

local wasOnLadder   = {}
local lockedFaceAng = {}
local ladderInfo    = {}
local recomputeLeft = {}

local function FlattenNormal(n)
    local flat = Vector(n.x, n.y, 0)
    if flat:LengthSqr() < 0.01 then return nil end
    flat:Normalize()
    return flat
end

local function AngleFromFlatNormal(n)
    local flat = FlattenNormal(n)
    if not flat then return nil end
    return Angle(0, flat:Angle().y + 180, 0)
end

local function IsAcceptableNormal(n)
    if not isvector(n) then return false end
    if n:LengthSqr() < 0.01 then return false end
    if math.abs(n.z) > MAX_NORMAL_Z then return false end
    return true
end

local function SafeGetName(ent)
    if not IsValid(ent) then return "" end
    local ok, name = pcall(function() return ent:GetName() end)
    return (ok and name) or ""
end

local function FindLadderPropFacing(ply)
    local plyPos = ply:GetPos()
    local origin = plyPos + Vector(0, 0, 36)

    for _, ent in ipairs(ents.FindInSphere(plyPos, LADDER_SEARCH_RADIUS)) do
        if IsValid(ent) and (ent:GetClass() == "prop_static" or ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_dynamic") then
            local mdl = string.lower(ent:GetModel() or "")
            if string.find(mdl, "ladder", 1, true) then
                local toProp = ent:GetPos() - origin
                toProp.z = 0
                if toProp:LengthSqr() < 36 then continue end
                toProp:Normalize()
                return Angle(0, toProp:Angle().y, 0)
            end
        end
    end
    return nil
end

local function FacingFromUseableLadder(ply)
    local plyPos = ply:GetPos()
    local nearestLadder = nil
    local nearestDistSqr = LADDER_SEARCH_RADIUS * LADDER_SEARCH_RADIUS

    for _, ent in ipairs(ents.FindInSphere(plyPos, LADDER_SEARCH_RADIUS)) do
        if IsValid(ent) and ent:GetClass() == "func_useableladder" then
            local distSqr = plyPos:DistToSqr(ent:GetPos())
            if distSqr < nearestDistSqr then
                nearestDistSqr = distSqr
                nearestLadder = ent
            end
        end
    end

    if not IsValid(nearestLadder) then return nil, nil end

    local bestNormal = nil
    local bestFrac   = 1

    for _, h in ipairs(HEIGHT_OFFSETS) do
        local probeOrigin = plyPos + Vector(0, 0, h)
        for _, offset in ipairs(TRACE_ANGLES) do
            local ang = Angle(0, offset, 0)
            local tr = util.TraceLine({
                start  = probeOrigin,
                endpos = probeOrigin + ang:Forward() * TRACE_DIST,
                filter = ply,
                mask   = MASK_SOLID_BRUSHONLY
            })
            if tr.Hit and tr.Fraction < bestFrac and IsAcceptableNormal(tr.HitNormal) then
                local prefer = bit.band(tr.Contents, CONTENTS_LADDER) ~= 0
                if prefer or bestNormal == nil then
                    bestFrac   = tr.Fraction
                    bestNormal = tr.HitNormal
                end
            end
        end
    end

    local propAng = FindLadderPropFacing(ply)
    if propAng then
        return propAng, nearestLadder
    end

    if bestNormal then
        local ang = AngleFromFlatNormal(bestNormal)
        if ang then
            return ang, nearestLadder
        end
    end

    return nil, nearestLadder
end

local function ComputeLadderFacingAngle(ply)
    local ladderNormal = ply:GetInternalVariable("m_vecLadderNormal")
    if IsAcceptableNormal(ladderNormal) then
        local ang = AngleFromFlatNormal(ladderNormal)
        if ang then return ang, false, nil, nil end
    end

    local useableAng, useableEnt = FacingFromUseableLadder(ply)
    if useableAng then
        local topZ = nil
        if IsValid(useableEnt) then
            local top = useableEnt:GetInternalVariable("m_vecPlayerMountPositionTop")
            if isvector(top) then topZ = top.z end
        end
        return useableAng, true, topZ, useableEnt
    end

    local baseOrigin = ply:GetPos()
    local eyeYaw     = ply:EyeAngles().y
    local bestNormal = nil
    local bestFrac   = 1
    local bestPrefer = false

    for _, h in ipairs(HEIGHT_OFFSETS) do
        local origin = baseOrigin + Vector(0, 0, h)
        for _, offset in ipairs(TRACE_ANGLES) do
            local ang = Angle(0, eyeYaw + offset, 0)
            local tr = util.TraceLine({
                start  = origin,
                endpos = origin + ang:Forward() * TRACE_DIST,
                filter = ply,
                mask   = MASK_SOLID_BRUSHONLY
            })
            if tr.Hit and IsAcceptableNormal(tr.HitNormal) then
                local prefer = bit.band(tr.Contents, CONTENTS_LADDER) ~= 0
                if prefer then
                    if not bestPrefer or tr.Fraction < bestFrac then
                        bestFrac   = tr.Fraction
                        bestNormal = tr.HitNormal
                        bestPrefer = true
                    end
                elseif not bestPrefer and tr.Fraction < bestFrac then
                    bestFrac   = tr.Fraction
                    bestNormal = tr.HitNormal
                end
            end
        end
    end

    local hullTr = util.TraceHull({
        start  = baseOrigin + Vector(0, 0, 36),
        endpos = baseOrigin + Vector(0, 0, 36),
        mins   = -HULL_HALF,
        maxs   =  HULL_HALF,
        filter = ply,
        mask   = MASK_SOLID_BRUSHONLY
    })
    if hullTr.Hit and IsAcceptableNormal(hullTr.HitNormal) then
        local prefer = bit.band(hullTr.Contents, CONTENTS_LADDER) ~= 0
        if prefer or bestNormal == nil then
            bestNormal = hullTr.HitNormal
        end
    end

    if bestNormal then
        local ang = AngleFromFlatNormal(bestNormal)
        if ang then return ang, false, nil, nil end
    end

    local propAng = FindLadderPropFacing(ply)
    if propAng then
        return propAng, false, nil, nil
    end

    return Angle(0, eyeYaw, 0), false, nil, nil
end

local function IsTopDismount(ply, info)
    if not info or not info.isUseable then return false end

    local plyPos = ply:GetPos()

    if info.topZ and math.abs(plyPos.z - info.topZ) <= TOP_DISMOUNT_TOLERANCE then
        return true
    end

    local radiusSqr = TOP_DISMOUNT_TOLERANCE * TOP_DISMOUNT_TOLERANCE
    for _, dismount in ipairs(ents.FindInSphere(plyPos, TOP_DISMOUNT_TOLERANCE)) do
        if IsValid(dismount) and dismount:GetClass() == "info_ladder_dismount" then
            if plyPos:DistToSqr(dismount:GetPos()) <= radiusSqr then
                local ladderName = SafeGetName(info.ladderEnt)
                if ladderName == "" then
                    return true
                end

                local targetName = dismount:GetInternalVariable("m_targetLadder")
                    or dismount:GetInternalVariable("ladderName")
                    or SafeGetName(dismount)

                if targetName == "" or targetName == ladderName then
                    return true
                end
            end
        end
    end

    return false
end

local function ChooseDismountGesture(ply, info)
    if IsTopDismount(ply, info) then
        return ACT_PICKUP_GROUND
    end
    return ACT_HL2MP_JUMP
end

-- ============================================
--  HOOKS (без EPA)
-- ============================================

hook.Add("CalcMainActivity", "CustomLadderAnimations", function(ply, velocity)
    if not ENABLED then return end
    if not IsValid(ply) then return end
    if ply:GetMoveType() ~= MOVETYPE_LADDER then return end

    local velZ = velocity.z
    if math.abs(velZ) < 10 then
        return ACT_IDLE, -1
    elseif velZ > 0 then
        return ACT_UP, -1
    else
        return ACT_DOWN, -1
    end
end)

hook.Add("TranslateActivity", "CustomLadderSuppressTurns", function(ply, act)
    if not ENABLED then return end
    if not IsValid(ply) then return end
    if ply:GetMoveType() ~= MOVETYPE_LADDER then return end

    if SUPPRESSED_TURN_ACTS[act] then
        return ACT_INVALID
    end
end)

hook.Add("UpdateAnimation", "CustomLadderFacingAndGestures", function(ply, velocity, maxSeqGroundSpeed)
    if not ENABLED then return end
    if not IsValid(ply) then return end

    local onLadder = ply:GetMoveType() == MOVETYPE_LADDER
    local plyIndex = ply:EntIndex()

    if onLadder then
        local engineNormal = ply:GetInternalVariable("m_vecLadderNormal")
        local engineAng = nil
        if IsAcceptableNormal(engineNormal) then
            engineAng = AngleFromFlatNormal(engineNormal)
        end

        local needsCompute = not lockedFaceAng[plyIndex]
            or (recomputeLeft[plyIndex] and recomputeLeft[plyIndex] > 0)
            or engineAng ~= nil

        if needsCompute then
            local ang, isUseable, topZ, ladderEnt

            if engineAng then
                ang = engineAng
                isUseable, topZ, ladderEnt = false, nil, nil
            else
                ang, isUseable, topZ, ladderEnt = ComputeLadderFacingAngle(ply)
            end

            lockedFaceAng[plyIndex] = ang
            ladderInfo[plyIndex] = {
                isUseable = isUseable,
                topZ      = topZ,
                ladderEnt = ladderEnt
            }

            if not recomputeLeft[plyIndex] then
                recomputeLeft[plyIndex] = RECOMPUTE_FRAMES
            else
                recomputeLeft[plyIndex] = math.max(0, recomputeLeft[plyIndex] - 1)
            end
        end

        ply:SetRenderAngles(lockedFaceAng[plyIndex])
        ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
        wasOnLadder[plyIndex] = true
    else
        if wasOnLadder[plyIndex] then
            wasOnLadder[plyIndex] = false

            local gesture = ChooseDismountGesture(ply, ladderInfo[plyIndex])
            ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture, true)

            lockedFaceAng[plyIndex] = nil
            ladderInfo[plyIndex]    = nil
            recomputeLeft[plyIndex] = nil
        end
    end
end)

hook.Add("PlayerDisconnected", "CustomLadderCleanup", function(ply)
    local idx = ply:EntIndex()
    wasOnLadder[idx]   = nil
    lockedFaceAng[idx] = nil
    ladderInfo[idx]    = nil
    recomputeLeft[idx] = nil
end)