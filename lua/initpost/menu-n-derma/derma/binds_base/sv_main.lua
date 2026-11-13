hg = hg or {}
hg.Binds = hg.Binds or {}
hg.Binds.CurrentBinds = hg.Binds.CurrentBinds or {}

local PLAYERMETA = FindMetaTable('Player')

util.AddNetworkString('Bullshit_binds')

net.Receive('Bullshit_binds', function(len, ply)
    if not IsValid(ply) then return end

    local tbl = net.ReadTable()
    if not istable(tbl) then tbl = {} end
    ply.binds = tbl

    local cmds = net.ReadTable()
    ply.bind_commands = istable(cmds) and cmds or {}
end)

local function OnButtonDown(ply, button)
    if not IsValid(ply) then return end
    if not ply.downedbuttons then ply.downedbuttons = {} end
    ply.downedbuttons[button] = true

    if hg.Binds and hg.Binds.CheckBinds then
        local binds = hg.Binds.CheckBinds(ply)
        for k in pairs(binds) do
            hook.Run('BindActivated_' .. k, ply)
            hook.Run('BindActivated', ply, k)
        end
    end
end
hook.Add('PlayerButtonDown', 'zcity_binds_sv', OnButtonDown)

local function OnButtonUp(ply, button)
    if not IsValid(ply) then return end
    if not ply.downedbuttons then ply.downedbuttons = {} end
    ply.downedbuttons[button] = nil
end
hook.Add('PlayerButtonUp', 'zcity_binds_sv', OnButtonUp)

hook.Add('BindActivated', 'zcity_binds_execute_command_sv', function(ply, bind_name)
    if not IsValid(ply) then return end

    local cmd = (ply.bind_commands or {})[bind_name]
    if not cmd or cmd == "" then return end

    ply:ConCommand(cmd)
end)

if not hg.Binds.GetButton then
    function hg.Binds.GetButton(shit, ply)
        if SERVER then
            return ((ply.binds or {})[shit] or false)
        else
            return (hg.Binds.CurrentBinds[shit] or false)
        end
    end
end

if not hg.Binds.CheckBinds then
    function hg.Binds.CheckBinds(ply)
        local shit = {}
        local downed = ply.downedbuttons or {}
        local bindsTable = ply == lply and hg.Binds.CurrentBinds or (ply.binds or {})

        for k, v in pairs(bindsTable) do
            local key1 = v[1]
            local key2 = v[2]

            if not key1 or key1 == -999 then continue end

            if key2 and key1 then
                if downed[key1] and downed[key2] then
                    shit[k] = true
                end
            elseif downed[key1] then
                shit[k] = true
            end
        end
        return shit
    end
end

if not PLAYERMETA.IsBindPressed then
    function PLAYERMETA:IsBindPressed(bind_name)
        if not bind_name then return false end

        local binds = self == lply and hg.Binds.CurrentBinds or (self.binds or {})
        local bind = binds[bind_name]
        if not bind then return false end

        local key1 = bind[1]
        local key2 = bind[2]

        if not key1 or key1 == -999 then return false end

        local downed = self.downedbuttons or {}

        if key2 and key1 then
            return downed[key1] and downed[key2]
        else
            return downed[key1] == true
        end
    end
end

hook.Add('PlayerDisconnected', 'zcity_binds_cleanup', function(ply)
    if IsValid(ply) then
        ply.downedbuttons = nil
        ply.binds = nil
        ply.bind_commands = nil
    end
end)

hook.Add('PlayerSpawn', 'zcity_binds_reset_down', function(ply)
    if IsValid(ply) then
        ply.downedbuttons = {}
    end
end)