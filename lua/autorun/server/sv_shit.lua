if CLIENT then return end

local function ApplyNetInterceptor()
    local original_OnlyGet = net.Receivers["onlyget_appearance"]
    
    if original_OnlyGet then
        net.Receivers["onlyget_appearance"] = function(len, client)
            if not IsValid(client) then return end
            
            local tAppearance = net.ReadTable()
            local bRandom = not tAppearance or table.IsEmpty(tAppearance)
            
            if hg and hg.Appearance then
                client.CachedAppearance = bRandom and (hg.Appearance.GetRandomAppearance and hg.Appearance.GetRandomAppearance()) or tAppearance
                
                if client.HG_FirstSpawnPending then
                    client.HG_FirstSpawnPending = nil
                    
                    if isfunction(hg.Appearance.ForceApplyAppearance) then
                        hg.Appearance.ForceApplyAppearance(client, client.CachedAppearance)
                    end
                end
            end
        end
    else
        timer.Simple(1, ApplyNetInterceptor)
    end
end

hook.Add("Initialize", "HG_Appearance_Fix_Init", function()
    timer.Simple(2, ApplyNetInterceptor)
end)

hook.Add("SetupMove", "HG_Appearance_Fix_SetupMove", function(ply, mv, cmd)
    if not IsValid(ply) or ply:IsBot() then return end
    
    if not ply.HG_Debug_FirstSpawnApplied then
        ply.HG_Debug_FirstSpawnApplied = true
        ply.HG_FirstSpawnPending = true
        
        timer.Simple(3, function()
            if not IsValid(ply) then return end
            
            if hg and hg.Appearance and hg.Appearance.ApplyAppearance then
                hg.Appearance.ApplyAppearance(ply, nil, nil, nil, true)
            end
        end)
    end
end)

local BannedEntities = {
    ["evil_crawler"] = true,
    ["evil_crawler_loose"] = true,
    ["weapon_vj_l4d_pipebomb"] = true,
    ["weapon_drg_ar2"] = true,
    ["weapon_vj_controller"] = true,
    ["weapon_vj_rpg"] = true,
    ["sent_vj_ply_healthkit"] = true,
    ["weapon_drg_ar2"] = true,
    ["obj_vj_flareround"] = true,
    ["obj_vj_grenade"] = true,
    ["proj_drg_flashbang"] = true,
    ["proj_drg_grenade"] = true,
    ["proj_drg_smoke_grenade"] = true,
    ["proj_drg_plasma"] = true,
    ["evil_fungus"] = true,
    ["evil_snake"] = true,
}

-- ГАВНООООООО
local function IsAdmin(ply)
    if not IsValid(ply) then return false end
    if ply:IsSuperAdmin() or ply:IsAdmin() then return true end
    --if ulx and ulx.getGroup then
    --    local group = ulx.getGroup(ply:GetUserGroup())
    --    if group and group.canTarget then
    --    end
    --end
    return false
end

hook.Add("OnEntityCreated", "poshel_nahui", function(ent)
    timer.Simple(0, function()
        if not IsValid(ent) then return end

        local class = ent:GetClass()
        if not BannedEntities[class] then return end

        local ply = ent:GetCreator() or ent:GetOwner()

        if IsValid(ply) and ply:IsPlayer() then
            if IsAdmin(ply) then return end

            ent:SetNWEntity("BannedCreator", ply)
            ply:Kick("нахуй пошел")
        else
            ent:Remove()
        end
    end)
end)

hook.Add("PlayerDisconnected", "remove_pidorasa", function(ply)
    if not IsValid(ply) then return end
    if IsAdmin(ply) then return end

    timer.Simple(0, function()
        for _, ent in ipairs(ents.GetAll()) do
            if not IsValid(ent) then continue end
            if not BannedEntities[ent:GetClass()] then continue end

            local creator = ent:GetCreator() or ent:GetOwner()
            local stored  = ent:GetNWEntity("BannedCreator")

            if creator == ply or stored == ply then
                ent:Remove()
            end
        end
    end)
end)