hg.Binds = hg.Binds or {}
hg.Binds.CurrentBinds = hg.Binds.CurrentBinds or {}

local PLAYERMETA = FindMetaTable('Player')

function hg.Binds.GetButton(shit, ply)
    if SERVER then
        return ((ply.binds or {})[shit] or false)
    else
        return (hg.Binds.CurrentBinds[shit] or false)
    end
end

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

hook.Add('PlayerButtonDown', 'dsfsdf', function(ply, button)
    if not ply.downedbuttons then ply.downedbuttons = {} end
    ply.downedbuttons[button] = true

    local binds = hg.Binds.CheckBinds(ply)
    for k in pairs(binds) do
        hook.Run('BindActivated_' .. k, ply)
        hook.Run('BindActivated', ply, k)
    end
end)

hook.Add('PlayerButtonUp', 'zcity_keybinds_shit', function(ply, button)
    if not ply.downedbuttons then ply.downedbuttons = {} end
    ply.downedbuttons[button] = nil
end)

if SERVER then
    util.AddNetworkString('Bullshit_binds')
    net.Receive('Bullshit_binds', function(len, ply)
        ply.binds = (net.ReadTable() or {})
        ply.bind_commands = (net.ReadTable() or {})
    end)
end