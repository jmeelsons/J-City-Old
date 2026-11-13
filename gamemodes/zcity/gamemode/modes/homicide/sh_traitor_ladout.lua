hg = hg or {}

hg.traitor_role = {}
hg.traitor_role.tbl = {}

local APmodule = hg.Appearance

function hg.CreateTraitorOption(typed, name, desc, points, ingame_name, ids, preview_model)
    if not hg.traitor_role.tbl[typed] then
        hg.traitor_role.tbl[typed] = {}
    end

    local key = ids or ingame_name

    hg.traitor_role.tbl[typed][key] = {
        func = ingame_name,
        name = name,
        desc = desc,
        typed = typed,
        ids = key,
        preview_model = preview_model
    }
end

function hg.Validate(data, mode)
    local modet = (mode == 'soe' and 3 or 2)
    local mode2 = (mode == 'soe' and 1 or 4)
    local funcsss = {}

    if not data.soe or not data.soe.traitor_role then
        return false, 'NO DATA FOR SOE!'
    end
    if not data.standard.traitor_role then
        return false, '[Z-CITY | data/zcity/ladout.json] NO DATA FOR STD!'
    end

    if not data[mode] or not data[mode].traitor_role then
        return false, 'NO TRAITOR ROLE FOR MODE ' .. tostring(mode)
    end

    -- ПРЯМО ИСПОЛЬЗУЕМ role_name КАК КЛЮЧ
    local role_key = data[mode].traitor_role  -- "traitor_default_soe"

    if not hg.traitor_role.tbl[modet] or not hg.traitor_role.tbl[modet][role_key] then
        return false, 'ROLE NOT FOUND: ' .. tostring(role_key) .. ' in tbl[' .. tostring(modet) .. ']'
    end

    local ittems = mode == 'soe' and data.soe['items'] or data.standard['items']

    if not ittems then
        return false, 'NO ITEMS FOUND'
    end

    for _, i in pairs(ittems) do
        if not i.ids then
            return false, '[Z-CITY | data/zcity/ladout.json] FILE IS BROKEN PLEASE RECHECK IT!'
        end

        local typed_for_item = mode == 'soe' and 1 or 4

        if not hg.traitor_role.tbl[typed_for_item] or not hg.traitor_role.tbl[typed_for_item][i.ids] then
            return false, '[Z-CITY | data/zcity/ladout.json] ITEM NOT FOUND: ' .. tostring(i.ids)
        end

        table.insert(funcsss, hg.traitor_role.tbl[typed_for_item][i.ids].func)
    end

    return true, funcsss, role_key
end
-- 2 - Тип Трейторы STD
-- 3 - Тип трейтора SOE
-- 1 - Оружие в SOE
-- 4 - Оружие в STD

local pistoletto = {
    "weapon_zoraki",
    "weapon_zoraki_glock",
    "weapon_92berreta",
}

hg.CreateTraitorOption(2,"Chemist","123123",0,"traitor_chemist")
hg.CreateTraitorOption(2,"Defoko","123123",0,"traitor_default")
hg.CreateTraitorOption(2,"Assasin","123123",0,"traitor_assasin")
hg.CreateTraitorOption(2,"Infiltrator","123123",0,"traitor_infiltrator")

hg.CreateTraitorOption(3,"Defoko","123123",0,"traitor_default_soe")
hg.CreateTraitorOption(3,"Infiltrator","123123",0,"traitor_infiltrator_soe")
hg.CreateTraitorOption(3,"Assasin","123123",0,"traitor_assasin_soe")

hg.CreateTraitorOption(1,"Walter P22","WEAPON",0,function(ply)
    local p22 = ply:Give("weapon_p22")
    hg.AddAttachmentForce(ply,p22,"supressor4")
end,'weapon_p22', "models/weapons/zcity/c_p22.mdl")

hg.CreateTraitorOption(4,"Taser","WEAPON",0,function(ply)
    local taser = ply:Give("weapon_taser")
    ply:GiveAmmo(taser.Primary.ClipSize * 2, taser.Primary.Ammo, true)
end,'weapon_taser')

hg.CreateTraitorOption(4,"PB-4 Osa","WEAPON",0,function(ply)
    local osapb = ply:Give("weapon_osapb")
    ply:GiveAmmo(osapb.Primary.ClipSize * 3, osapb.Primary.Ammo, true)
end,'weapon_osapb')

hg.CreateTraitorOption(1,"Additional Magazine for Walter P22","AMMO",0,function(ply)
    local p22 = weapons.Get("weapon_p22")
    ply:GiveAmmo(p22.Primary.ClipSize * 1, p22.Primary.Ammo, true)
end,'weapon_p22_ammo')

hg.CreateTraitorOption(1,"SOG SEAL 2000","MELEE",0,function(ply)
    ply:Give("weapon_sogknife")
end,'weapon_sogknife', "models/zcity/weapons/w_sog_knife.mdl")

hg.CreateTraitorOption(4,"Buck 200 General","MELEE",0,function(ply)
    ply:Give("weapon_buck200knife")
end,'weapon_buck200knife', "models/zcity/weapons/custom_knife/buck.mdl")

hg.CreateTraitorOption(1,"Epinephrine Autoinject","MEDICINE",0,function(ply)
    ply:Give("weapon_adrenaline")
end,'weapon_adrenaline')

hg.CreateTraitorOption(4,"Epinephrine Autoinject","MEDICINE",0,function(ply)
    ply:Give("weapon_adrenaline")
end,'weapon_adrenaline')

hg.CreateTraitorOption(1,"Medkit","MEDICINE",0,function(ply)
    ply:Give("weapon_medkit_sh")
end,'weapon_medkit_sh', "models/w_models/weapons/w_eq_medkit.mdl")

hg.CreateTraitorOption(4,"Medkit","MEDICINE",0,function(ply)
    ply:Give("weapon_medkit_sh")
end,'weapon_medkit_sh', "models/w_models/weapons/w_eq_medkit.mdl")

hg.CreateTraitorOption(1,"Tetrodotoxin syringe","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison1")
end,'weapon_traitor_poison1')

--hg.CreateTraitorOption(1,"M99","POISON",0,function(ply)
--    ply:Give("weapon_m99")
--end,'weapon_m99')
--
--hg.CreateTraitorOption(4,"M99","POISON",0,function(ply)
--    ply:Give("weapon_m99")
--end,'weapon_m99')

hg.CreateTraitorOption(4,"Tetrodotoxin syringe","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison1")
end,'weapon_traitor_poison1')

hg.CreateTraitorOption(1,"VX vial","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison2")
end,'weapon_traitor_poison2')

hg.CreateTraitorOption(4,"VX vial","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison2")
end,'weapon_traitor_poison2')

hg.CreateTraitorOption(4,"Cyanide capsule","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison_consumable")
end,'weapon_traitor_poison_consumable')

hg.CreateTraitorOption(1,"Cyanide canister","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison3")
end,'weapon_traitor_poison3')

hg.CreateTraitorOption(4,"Cyanide canister","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison3")
end,'weapon_traitor_poison3')

hg.CreateTraitorOption(4,"Curare vial","POISON",0,function(ply)
    ply:Give("weapon_traitor_poison4")
end,'weapon_traitor_poison4')

hg.CreateTraitorOption(1,"Suit","TACTICAL",0,function(ply)
    ply:Give("weapon_traitor_suit")
end,'weapon_traitor_suit')

hg.CreateTraitorOption(4,"Suit","TACTICAL",0,function(ply)
    ply:Give("weapon_traitor_suit")
end,'weapon_traitor_suit')

hg.CreateTraitorOption(4,"Door Wedge","TACTICAL",0,function(ply)
    ply:Give("weapon_hg_jam")
end,'weapon_hg_jam')

hg.CreateTraitorOption(4,"Shuriken","THROWABLE",0,function(ply)
    ply:Give("weapon_hg_shuriken")
end,'weapon_hg_shuriken')

hg.CreateTraitorOption(4,"IED","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_traitor_ied")
end,'weapon_traitor_ied')

hg.CreateTraitorOption(1,"IED","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_traitor_ied")
end,'weapon_traitor_ied')

hg.CreateTraitorOption(1,"RGD-5","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_hg_rgd_tpik")
end,'weapon_hg_rgd_tpik', "models/pwb/weapons/w_rgd5_thrown.mdl")

hg.CreateTraitorOption(4,"RGD-5","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_hg_rgd_tpik")
end,'weapon_hg_rgd_tpik', "models/pwb/weapons/w_rgd5_thrown.mdl")

hg.CreateTraitorOption(1,"Smoke Grenade","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_hg_smokenade_tpik")
end,'weapon_hg_smokenade_tpik', "models/props_junk/jlare.mdl")

hg.CreateTraitorOption(4,"Smoke Grenade","EXPLOSIVE",0,function(ply)
    ply:Give("weapon_hg_smokenade_tpik")
end,'weapon_hg_smokenade_tpik', "models/props_junk/jlare.mdl")

hg.CreateTraitorOption(4,"Grappling hook","TACTICAL",0,function(ply)
    ply:Give("weapon_grapplinghook")
end,'weapon_grapplinghook')

hg.CreateTraitorOption(1,"Grappling hook","TACTICAL",0,function(ply)
    ply:Give("weapon_grapplinghook")
end,'weapon_grapplinghook')

hg.CreateTraitorOption(4,"Folding box","TACTICAL",0,function(ply)
    ply:Give("weapon_hidebox")
end,'weapon_hidebox', "models/props_junk/wood_crate001a.mdl")

hg.CreateTraitorOption(1,"Folding box","TACTICAL",0,function(ply)
    ply:Give("weapon_hidebox")
end,'weapon_hidebox', "models/props_junk/wood_crate001a.mdl")

hg.CreateTraitorOption(4,"Kevlar","TACTICAL",0,function(ply)
    ply.armors = ply.armors or {}
    hg.AddArmor(ply, "vesttraitor")
    ply:SyncArmor()
end,'ent_armor_vesttraitor')

hg.CreateTraitorOption(1,"Kevlar","TACTICAL",0,function(ply)
    ply.armors = ply.armors or {}
    hg.AddArmor(ply, "vesttraitor")
    ply:SyncArmor()
end,'ent_armor_vesttraitor')

if SERVER then
    util.AddNetworkString('HMCD_GetTraitorLadOut')

    net.Receive('HMCD_GetTraitorLadOut',function(len, ply)
        if IsValid(ply) then
            ply.T_ladOut = net.ReadTable()
        end
    end)
end