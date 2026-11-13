hg.Binds = hg.Binds or {}
hg.Binds.CurrentBinds = hg.Binds.CurrentBinds or {}
hg.Binds.StandartBinds = hg.Binds.StandartBinds or {}
hg.Binds.BindCommands = hg.Binds.BindCommands or {}

function hg.Binds:CreateBind(type_bind, key, key2, type_std, command)
    if not self.CurrentBinds then self.CurrentBinds = {} end
    if not self.StandartBinds then self.StandartBinds = {} end
    if not self.BindCommands then self.BindCommands = {} end

    if not self.CurrentBinds[type_bind] then
        self.CurrentBinds[type_bind] = {key, key2}
    end

    if type_std then
        self.StandartBinds[type_bind] = {key, key2}
    end

    if command then
        self.BindCommands[type_bind] = command
    end
end

function hg.Binds:SetBindCommand(type_bind, command)
    self.BindCommands = self.BindCommands or {}
    self.BindCommands[type_bind] = command
end

function hg.Binds:GetBindCommand(type_bind)
    return (self.BindCommands or {})[type_bind]
end

function hg.Binds.SaveThem()
    local json_table = util.TableToJSON(hg.Binds.CurrentBinds)
    file.CreateDir('zcity/binds')
    file.Write('zcity/binds/main.json', json_table)
    file.Write('zcity/binds/commands.json', util.TableToJSON(hg.Binds.BindCommands or {}))

    net.Start('Bullshit_binds')
    net.WriteTable(hg.Binds.CurrentBinds)
    net.WriteTable(hg.Binds.BindCommands or {})
    net.SendToServer()
end

function hg.Binds.LoadBinds()
    if file.Exists('zcity/binds/main.json', 'DATA') then
        local data = file.Read('zcity/binds/main.json', 'DATA')
        if data and data ~= "" then
            local tbl = util.JSONToTable(data)
            if tbl then
                for k, v in pairs(tbl) do
                    if istable(v) then
                        hg.Binds.CurrentBinds[k] = v
                    end
                end
            end
        end
    end

    if file.Exists('zcity/binds/commands.json', 'DATA') then
        local data = file.Read('zcity/binds/commands.json', 'DATA')
        if data and data ~= "" then
            local tbl = util.JSONToTable(data)
            if tbl then
                hg.Binds.BindCommands = tbl
            end
        end
    end

    if not file.Exists('zcity/binds/main.json', 'DATA') then
        hg.Binds.SaveThem()
    end
end

hg.Binds:CreateBind('FAKE', KEY_G, nil, true, 'fake')
hg.Binds:CreateBind('KICK', KEY_B, nil, true, 'hg_kick')
hg.Binds:CreateBind('DROP', KEY_O, nil, true, 'drop')
hg.Binds:CreateBind('HOLD BREATH', KEY_J, nil, true, 'hmcd_holdbreath')
hg.Binds:CreateBind('TOGGLE LASER', KEY_L, nil, true, 'hmcd_togglelaser')
hg.Binds:CreateBind('SUICIDE', KEY_H, nil, true, 'suicide')
hg.Binds:CreateBind('ZOOM', KEY_N, nil, true, '+hg_zoom')
hg.Binds:CreateBind('ALT LEFT', KEY_COMMA, nil, true, '+alt1')
hg.Binds:CreateBind('ALT RIGHT', KEY_PERIOD, nil, true, '+alt2')
hg.Binds:CreateBind('LOOK', KEY_LALT, nil, true, '+altlook')
--hg.Binds:CreateBind('CLOSE BUTTON', KEY_R, nil, true)
--hg.Binds:CreateBind('HEAVY ATTACK', KEY_R, nil, true)

timer.Simple(0.1, function()
    hg.Binds.LoadBinds()
end)

hook.Add('BindActivated', 'zcity_binds_execute_command_cl', function(ply, bind_name)
    if ply ~= LocalPlayer() then return end

    local cmd = hg.Binds:GetBindCommand(bind_name)
    if not cmd or cmd == "" then return end

    local args = string.Explode(" ", cmd)
    RunConsoleCommand(unpack(args))
end)