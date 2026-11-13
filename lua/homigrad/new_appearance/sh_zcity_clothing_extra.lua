ClothingAddonExtra = ClothingAddonExtra or {}
ClothingAddonExtra.Items = {
    naturalselection = {
        mat = "models/humans/group01/natural",
        desc = "Natural Selection"
    },
    AdamShirt = {
        mat = "models/humans/group01/test",
        desc = "Adam Shirt"
    },
    NoLivesMatter = {
        mat = "models/humans/group01/nolivesmatter",
        desc = "No Lives Matter"
    },
    razacherovanie = {
        mat = "models/humans/group01/razac",
        desc = "Razacherovanie"
    },
    wrath = {
        mat = "models/humans/group01/wrath",
        desc = "Wrath"
    },
    hatred = {
        mat = "models/humans/group01/hatred",
        desc = "Hatred"
    },

    bloodbath = {
        mat = "models/humans/group01/bloodbath",
        desc = "Bloodbath"
    },
    fbi = {
        mat = "models/humans/group01/fbi",
        desc = "FBI"
    },
    humanity = {
        mat = "models/humans/group01/humanity",
        desc = "Humanity"
    },
    itsourtimetorise = {
        mat = "models/humans/group01/itsourtimetorise",
        desc = "Its Our Time To Rise"
    },
    jackdaniels = {
        mat = "models/humans/group01/jackdaniels",
        desc = "Jack Daniels"
    },
    kmfdm = {
        mat = "models/humans/group01/kmfdm",
        desc = "KMFDM"
    },
    negativexp = {
        mat = "models/humans/group01/negativexp",
        desc = "Negative XP"
    },
    purgen = {
        mat = "models/humans/group01/purgen",
        desc = "Purgen"
    },
    ALX = {
        mat = "models/humans/group01/alx",
        desc = "ALX"
    }
}

local function RegisterClothes(reason)
    hg = hg or {}
    hg.Appearance = hg.Appearance or {}

    if not istable(hg.Appearance.Clothes) then

        return false
    end

    hg.Appearance.Clothes[1] = hg.Appearance.Clothes[1] or {}
    hg.Appearance.ClothesDesc = hg.Appearance.ClothesDesc or {}

    local added, updated, existing = 0, 0, 0
    for key, data in pairs(ClothingAddonExtra.Items) do
        local old = hg.Appearance.Clothes[1][key]
        if old == nil then
            added = added + 1
        elseif old ~= data.mat then
            updated = updated + 1
        else
            existing = existing + 1
        end

        hg.Appearance.Clothes[1][key] = data.mat
        hg.Appearance.ClothesDesc[key] = {
            desc = data.desc .. "\nMaterial: " .. data.mat
        }
    end

    ClothingAddonExtra.Registered = true
    
    return true
end

hook.Add("Initialize", "ClothingAddonExtra_Register_Initialize", function()
    timer.Simple(0, function() RegisterClothes("Initialize") end)
end)

hook.Add("InitPostEntity", "ClothingAddonExtra_Register_InitPostEntity", function()
    timer.Simple(0, function() RegisterClothes("InitPostEntity") end)
end)

hook.Add("ZPointshopLoaded", "ClothingAddonExtra_Register_ZPointshopLoaded", function()
    RegisterClothes("ZPointshopLoaded")
end)

for _, delay in ipairs({1, 3, 5, 10}) do
    timer.Simple(delay, function()
        RegisterClothes("timer " .. delay)
    end)
end

concommand.Add("clothingaddon_extra_status", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end

    print("[ClothingAddonExtra] Статус: " .. (ClothingAddonExtra.Registered and "registered in hg.Appearance.Clothes[1]" or "not registered"))
    print("[ClothingAddonExtra] Регистрировался хотя бы раз: " .. tostring(ClothingAddonExtra.Registered == true))
    print("[ClothingAddonExtra] Целевая таблица существует: " .. tostring(istable(hg) and istable(hg.Appearance) and istable(hg.Appearance.Clothes) and istable(hg.Appearance.Clothes[1])))

    local count = 0
    for _ in pairs(ClothingAddonExtra.Items) do count = count + 1 end
    print("[ClothingAddonExtra] Предметов extra: " .. count)

    if istable(hg) and istable(hg.Appearance) and istable(hg.Appearance.Clothes) and istable(hg.Appearance.Clothes[1]) then
        for key, data in pairs(ClothingAddonExtra.Items) do
            print("[ClothingAddonExtra]   " .. key .. " = " .. tostring(hg.Appearance.Clothes[1][key]) .. " | expected: " .. data.mat)
        end
    end
end)

concommand.Add("clothingaddon_extra_checkfiles", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end

    for key, data in pairs(ClothingAddonExtra.Items) do
        print("[ClothingAddonExtra] file check " .. key .. ": " .. data.mat)
        print("[ClothingAddonExtra]   materials/" .. data.mat .. ".vmt = " .. tostring(file.Exists("materials/" .. data.mat .. ".vmt", "GAME")))
        print("[ClothingAddonExtra]   materials/" .. data.mat .. ".vtf = " .. tostring(file.Exists("materials/" .. data.mat .. ".vtf", "GAME")))
    end
end)

if CLIENT then
    concommand.Add("clothingaddon_extra_matcheck", function()
        for key, data in pairs(ClothingAddonExtra.Items) do
            local mat = Material(data.mat)
            print("[ClothingAddonExtra] material check " .. key .. ": " .. data.mat .. " | IsError=" .. tostring(mat:IsError()) .. " | shader=" .. tostring(mat:GetShader()))
        end
    end)
end

if SERVER then
    resource.AddFile("materials/models/humans/group01/natural.vmt")
    resource.AddFile("materials/models/humans/group01/natural.vtf")

    resource.AddFile("materials/models/humans/group01/nolivesmatter.vmt")
    resource.AddFile("materials/models/humans/group01/nolivesmatter.vtf")

    resource.AddFile("materials/models/humans/group01/razac.vmt")
    resource.AddFile("materials/models/humans/group01/razac.vtf")
    resource.AddFile("materials/models/humans/group01/wrath.vmt")
    resource.AddFile("materials/models/humans/group01/wrath.vtf")
    resource.AddFile("materials/models/humans/group01/hatred.vmt")
    resource.AddFile("materials/models/humans/group01/hatred.vtf")

    resource.AddFile("materials/models/humans/group01/test.vmt")
    resource.AddFile("materials/models/humans/group01/test.vtf")

    resource.AddFile("materials/models/humans/group01/bloodbath.vmt")
    resource.AddFile("materials/models/humans/group01/bloodbath.vtf")
    resource.AddFile("materials/models/humans/group01/fbi.vmt")
    resource.AddFile("materials/models/humans/group01/fbi.vtf")
    resource.AddFile("materials/models/humans/group01/humanity.vmt")
    resource.AddFile("materials/models/humans/group01/humanity.vtf")
    resource.AddFile("materials/models/humans/group01/itsourtimetorise.vmt")
    resource.AddFile("materials/models/humans/group01/itsourtimetorise.vtf")
    resource.AddFile("materials/models/humans/group01/jackdaniels.vmt")
    resource.AddFile("materials/models/humans/group01/jackdaniels.vtf")
    resource.AddFile("materials/models/humans/group01/kmfdm.vmt")
    resource.AddFile("materials/models/humans/group01/kmfdm.vtf")
    resource.AddFile("materials/models/humans/group01/negativexp.vmt")
    resource.AddFile("materials/models/humans/group01/negativexp.vtf")
    resource.AddFile("materials/models/humans/group01/purgen.vmt")
    resource.AddFile("materials/models/humans/group01/purgen.vtf")
    resource.AddFile("materials/models/humans/group01/alx.vmt")
    resource.AddFile("materials/models/humans/group01/alx.vtf")
end
