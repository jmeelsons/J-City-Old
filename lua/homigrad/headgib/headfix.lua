if CLIENT then return end

local DEFAULT_HEAD = "models/gleb/zcity/headboom.mdl"

local HEADS = {
    "models/headpartial/headpartial.mdl",
    "models/headpartial/headpartial1.mdl",
    "models/headpartial/headpartial2.mdl",
    "models/headpartial/headpartial3.mdl",
    "models/headpartial/headpartial5.mdl"
}

for _, path in ipairs(HEADS) do
    util.PrecacheModel(path)
end

local function ReplaceHeadStump(ent)
    if not IsValid(ent) then return false end
    if ent:GetClass() ~= "prop_dynamic" then return false end
    if ent.__ZCityGoreHeadStumpFixed then return true end

    local model = string.lower(tostring(ent:GetModel() or ""))
    if model ~= DEFAULT_HEAD then return false end

    local parent = ent:GetParent()
    if not IsValid(parent) or not parent:IsRagdoll() then return false end

    local chosen = HEADS[math.random(#HEADS)]

    ent:SetModel(chosen)
    ent:SetModelScale(1, 0)
    ent:SetNotSolid(true)
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ent:DrawShadow(false)
    ent.__ZCityGoreHeadStumpFixed = true
    ent:SetNWString("ZCityGoreHeadModel", chosen)

    return true
end

hook.Add("OnEntityCreated", "ZCityGoreHeadStumpFix_Create", function(ent)
    if not IsValid(ent) or ent:GetClass() ~= "prop_dynamic" then return end

    for _, delay in ipairs({0, 0.03, 0.1, 0.25}) do
        timer.Simple(delay, function()
            if IsValid(ent) and not ent.__ZCityGoreHeadStumpFixed then
                ReplaceHeadStump(ent)
            end
        end)
    end
end)

local nextCheck = 0

hook.Add("Think", "ZCityGoreHeadStumpFix_Fallback", function()
    if CurTime() < nextCheck then return end
    nextCheck = CurTime() + 0.2

    for _, ent in ipairs(ents.FindByClass("prop_dynamic")) do
        if IsValid(ent) and not ent.__ZCityGoreHeadStumpFixed then
            if string.lower(tostring(ent:GetModel() or "")) == DEFAULT_HEAD then
                ReplaceHeadStump(ent)
            end
        end
    end
end)
