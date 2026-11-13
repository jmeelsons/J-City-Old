--
hg = hg or {}

local bandanamat = Material("mats_jack_gmod_sprites/respirator_vignette.png")

hg.Accessories = {
	["none"] = {},

    ["eyeglasses"] = {
        model = "models/captainbigbutt/skeyler/accessories/glasses01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(3,-2.9,0), Angle(0,-70,-90), .9},
        fempos = {Vector(2.1,-2.7,0),Angle(0,-70,-90),.8},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Glasses"
    },

    ["bugeye sunglasses"] = {
        model = "models/captainbigbutt/skeyler/accessories/glasses04.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.2,-3.3,0),Angle(0,-70,-90),.9},
        fempos = {Vector(2.2,-3.3,0),Angle(0,-70,-90),.8},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Bugeye Sunglasses"
    },

    ["aviators"] = {
        model = "models/arctic_nvgs/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.7,0,0),Angle(0,-80,-90),1},
        fempos = {Vector(0.25,0,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        bPointShop = true,
        price = 5000,
        vpos = Vector(0,0,0),
        name = "Aviators"
    },

    ["nerd glasses"] = {
        model = "models/gmod_tower/klienerglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-2.2,0),Angle(0,-80,-90),1},
        fempos = {Vector(2.5,-2.5,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        bPointShop = true,
        price = 1000,
        name = "Nerd Glasses"
    },

    ["headphones"] = {
        model = "models/gmod_tower/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.6,-1,0),Angle(0,-80,-90),.85},
        fempos = {Vector(2.4,-1,0),Angle(0,-85,-90),.8},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Headphones"
    },

    ["baseball cap"] = {
        model = "models/gmod_tower/jaseballcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0,0),Angle(0,-75,-90), 1.12},
        fempos = {Vector(4,-0.1,0),Angle(0,-75,-90), 1.125},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Baseball Cap"
    },

    ["fedora"] = {
        model = "models/captainbigbutt/skeyler/hats/fedora.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5.5,-0.2,0),Angle(0,-80,-90), 0.7},
        fempos = {Vector(4.5,-0.2,0),Angle(0,-75,-90), 0.7},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Fedora"
    },

    ["stetson"] = {
        model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(6.2,0.6,0),Angle(0,-60,-90), 0.7},
        fempos = {Vector(5.2,0.5,0),Angle(0,-65,-90), 0.65},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Stetson"
    },

    ["straw hat"] = {
        model = "models/captainbigbutt/skeyler/hats/strawhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5.2,-0.4,0),Angle(0,-70,-90), 0.85},
        fempos = {Vector(4.5,-0.5,0),Angle(0,-75,-90), 0.8},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Straw Hat"
    },

    ["sun hat"] = {
        model = "models/captainbigbutt/skeyler/hats/sunhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.2,2,0),Angle(0,-90,-90), 0.8},
        fempos = {Vector(3.4,2,0),Angle(0,-90,-90), 0.75},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Sun Hat"
    },

    ["bling cap"] = {
        model = "models/captainbigbutt/skeyler/hats/zhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.9,0.1,0),Angle(0,-80,-90), 0.75},
        fempos = {Vector(3.5,0.2,0),Angle(-10,-80,-90), 0.75},
        skin = 0,
        norender = true,
        placement = "head"
    },

    ["top hat"] = {
        model = "models/player/items/humans/top_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0,-1.5,0),Angle(0,-80,-90), 1},
        fempos = {Vector(-0.8,-1.8,0),Angle(0,-80,-90), 1},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Top Hat (waffle)"
    },

    ["backpack"] = {
        model = "models/makka12/bag/jag.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-3,0,0),Angle(0,90,90),.75},
        fempos = {Vector(-3,-1,0),Angle(0,90,90),.6},
        skin = 0,
        norender = false,
        placement = "spine",
        name = "Backpack"
    },

    ["backpack hellokitty"] = {
        model = "models/gleb/backpack_pink.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,0),
        name = "HelloKitty Backpack"
    },

    ["kickme sticker"] = {
        model = "models/gleb/kickme.mdl",
        bone = "ValveBiped.Bip01_Pelvis",
        malepos = {Vector(0,4,-6.8),Angle(-75,-90,0),1},
        fempos = {Vector(0,4,-5.8),Angle(-65,-90,0),1},
        skin = 0,
        norender = false,
        placement = "spine",
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        name = "KickMe Sticker"
    },

    ["nerd tooths"] = {
        model = "models/gleb/nerd.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.3,-0.4,0),Angle(0,-85,-90),1},
        fempos = {Vector(1.9,-0.8,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "spine",
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        name = "Nerd Teeth"
    },

    ["purse"] = {
        model = "models/props_c17/BriefCase001a.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = {Vector(-7,1,7),Angle(0,90,100),.5},
        fempos = {Vector(-7,0,7),Angle(0,90,100),.5},
        skin = 0,
        norender = false,
        placement = "spine",
        name = "Purse"
    },
    --CAPS
    ["zcity cap"] = {
        model = "models/gleb/zcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1500,
        name = "ZCITY Baseball Cap"
    },

    ["gray cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Grey Baseball Cap"
    },

    ["light gray cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        name = "Light Gray Baseball Cap"
    },

    ["white cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Baseball Cap"
    },

    ["green cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.5,0.1),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 4,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Green Baseball Cap"
    },

    ["dark green cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 5,
        norender = true,
        placement = "head",
        name = "Dark Green Baseball Cap"
    },

    ["brown cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 6,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Brown Baseball Cap"
    },

    ["blue cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 7,
        norender = true,
        placement = "head",
        name = "Blue Baseball Cap"
    },
    -- FaceMasks
    ["bandana"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        bSetColor = true,
        vecColorOveride = Vector(0.2,0.2,0.2),
        norender = true,
        placement = "face",
        ScreenSpaceEffects = function()
            -- DrawColorModify(AviatorColor)
            surface.SetMaterial(bandanamat)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(-1,0,ScrW()*1.01,ScrH()*1.2)
         end,
        bPointShop = true,
        vpos = Vector(0,0,63),
        price = 1000,
        name = "Bandana"
    },

    ["bandana colorable"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        bSetColor = true,
        norender = true,
        placement = "face",
        ScreenSpaceEffects = function()
            -- DrawColorModify(AviatorColor)
            surface.SetMaterial(bandanamat)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(-1,0,ScrW()*1.01,ScrH()*1.2)
         end,
        bPointShop = true,
        vpos = Vector(0,0,63),
        price = 4500,
        name = "Bandana colorable"
    },

	-- cs stuff
    ["arctic_balaclava"] = {
        model = "models/d/balaklava/arctic_reference.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1.1},
        fempos = {Vector(-1,-0.8,0),Angle(180,105,90),1.05},
        skin = 0,
        norender = true,
        disallowinappearance = true,
        bonemerge = true,
        name = "Arctic Balaclava"
    },

    ["phoenix_balaclava"] = {
        model = "models/d/balaklava/phoenix_balaclava.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.95,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        norender = true,
        disallowinappearance = true,
        bonemerge = true,
        name = "Phoenix Balaclava"
    },
   	--[[
	["hood_balaclava"] = {
        model = "models/balaclava_hood/balaclava_hood.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27,-5,0),Angle(180,100,90),1},
		fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        norender = true,
		placement = "head",
		vpos = Vector(-45,-45,0),
        name = "Hood Balaclava"
    },
	]]
    ["terrorist_band"] = {
        model = "models/distac/band_team.mdl",
        femmodel = "models/distac/band_team_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.95,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        disallowinappearance = true,
        bonemerge = true,
        needcoolRender = true,
        flex = true,
        name = "Terrorist Armband"
    },

    -- scarfs
    ["white scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 0,
        norender = false,
        vpos = Vector(0,0,20),
        placement = "torso",
        name = "White Scarf"
    },

    ["gray scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 1,
        norender = false,
        vpos = Vector(0,0,20),
        placement = "torso",
        name = "Gray Scarf"
    },

    ["black scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 2,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Black Scarf"
    },

    ["blue scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 3,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Blue Scarf"
    },

    ["red scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 4,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Red Scarf"
    },

    ["green scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 5,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Green Scarf"
    },

    ["pink scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 6,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Pink Scarf"
    },
    -- earmuffs
    ["red earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 0,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Red Earmuffs"
    },

    ["pink earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 1,
        norender = true,
        bPointShop = true,
        price = 1000,
        name = "Pink Earmuffs"
    },

    ["green earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 2,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Green Earmuffs"
    },

    ["yellow earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 3,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Yellow Earmuffs"
    },
    -- fedoras

    ["gray fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Gray Fedora"
    },

    ["black fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Black Fedora"
    },

    ["white fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Fedora"
    },

    ["beige fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Beige Fedora"
    },

    ["black/red fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 5,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Black-n-Red Fedora"
    },

    ["blue fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 7,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Blue Fedora"
    },
    -- beanies
    ["striped beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Striped Beanie"
    },
    ["periwinkle beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Periwinkle Beanie"
    },

    ["fuschia beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Fuschia Beanie"
    },

    ["white beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,100,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Beanie"
    },

    ["gray beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,100,90),1},
        skin = 4,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Gray Beanie"
    },
    -- backpacks
    ["large red backpack"] = {
        model = "models/modified/backpack_1.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5.2,0),Angle(0,80,90),1},
        fempos = {Vector(-8,4,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Large Red Backpack"
    },

    ["large gray backpack"] = {
        model = "models/modified/backpack_1.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5.2,0),Angle(0,80,90),1},
        fempos = {Vector(-8,4,0),Angle(0,80,90),0.9},
        skin = 1,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Large Gray Backpack"
    },

    ["medium backpack"] = {
        model = "models/modified/backpack_3.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,4,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Medium Backpack"
    },

    ["medium gray backpack"] = {
        model = "models/modified/backpack_3.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,4,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 1,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Medium Gray Backpack"
    },

    ["monokl"] = {
        model = "models/distac/monokl.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.05,-4.8,-1.3),Angle(180,100,90),1},
        fempos = {Vector(-1,-0.8,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Monocle"
    },

    ["china hat"] = {
        model = "models/distac/china_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.5,-0.35,0),Angle(180,100,90),1},
        fempos = {Vector(3,-0.8,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,0),
        name = "China Hat"
    },

    ["helicopter cap"] = {
        model = "models/distac/cap_helecopterkid.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-70,-13.5,0),Angle(180,100,90),1.1},
        fempos = {Vector(-63,-18.5,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Helicopter Baseball Cap"
    },

    ["welding glasses"] = {
        model = "models/distac/glassis_welding glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Welding Glasses"
    },

    ["big glasses"] = {
        model = "models/distac/big_ahhh_glassis.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        isdpoint = false,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Big Glasses"
    },

    ["glasses with nose"] = {
        model = "models/distac/glasses_with_mustache.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "ОЧКИ С УСАМИ МЕМ"
    },

    ["glasses fmf"] = {
        model = "models/distac/street_kid_fmf.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        price = 3000,
        vpos = Vector(0,0,69),
        name = "FMF Glasses"
    },

    ["warmcap"] = {
        model = "models/distac/warmcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        flex = true,
        bPointShop = true,
        price = 2600,
        vpos = Vector(0,0,69),
        name = "Warmcap"
    },
    -- SCUGS!!!
    ["slugcat"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "0",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Survivor"
    },
    ["slugcat monk"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.6,5,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "1",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Monk"
    },
    ["slugcat gourmand"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "2",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Gourmand"
    },
    ["slugcat arti"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "3",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Artificer"
    },
    ["slugcat rivulet"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "4",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat WetMouse"
    },
    ["slugcat speermaster"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "5",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Spearmaster"
    },
    ["slugcat saint"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "6",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Saint"
    },
    ["pinklizard"] = {
        model = "models/zcity/lizard.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(2,1,-6),Angle(100,0,0),1},
        fempos = {Vector(1,0,-5),Angle(70,180,180),1},
        skin = 0,
        placement = "spine",
        bPointShop = true,
        price = 1, -- for those who notices :3
        vpos = Vector(0,0,0),
        name = "Pink Lizard"
    },
    ["headband"] = {
        model = "models/distac/headband.mdl",
        femmodel = "models/distac/headband_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,69),
        name = "Headband"
    },
    ["occluder"] = {
        model = "models/distac/occluder.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1200,
        vpos = Vector(0,0,69),
        name = "Occluder"
    },
    ["shapka ushanka"] = {
        model = "models/distac/shapka_ushanka.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        price = 2300,
        vpos = Vector(0,0,69),
        name = "Ushanka"
    },
    ["cap gop"] = {
        model = "models/distac/cap_gop.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        price = 2300,
        vpos = Vector(0,0,69),
        name = "Cap God"
    },
    ["glasses viktor"] = {
        model = "models/distac/viktor.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,69),
        name = "Viktor Glasses"
    },
    ["glasses folding"] = {
        model = "models/distac/folding.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        price = 1350,
        vpos = Vector(0,0,69),
        name = "Folding Glasses"
    },
    ["headband kamikadze"] = {
        model = "models/distac/headband.mdl",
        femmodel = "models/distac/headband_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        isdpoint = false,
        price = 750,
        vpos = Vector(0,0,69),
        name = "Kamikaze Headband"
    },
    ["mfdoom mask"] = {
        model = "models/distac/mfdoom.mdl",
        femmodel = "models/distac/mfdoom.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "MF Doom Mask"
    },
    ["anon mask"] = {
        model = "models/rawjesus/wear/anon.mdl",
        femmodel = "models/rawjesus/wear/anon.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-1.2,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 6500,
        vpos = Vector(0,0,0),
        name = "Anonymous Mask"
    },
    ["hockey mask"] = {
        model = "models/rawjesus/wear/jason.mdl",
        femmodel = "models/rawjesus/wear/jason.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Hockey Mask"
    },
    ["walakos mask"] = {
        model = "models/glad_valakas_by_goonya/valakas_mask.mdl",
        femmodel = "models/glad_valakas_by_goonya/valakas_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,-5,0),Angle(180,10,90),1},
        fempos = {Vector(2,-5.5,0),Angle(180,10,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 6500,
        vpos = Vector(0,0,0),
        name = "Glad Valakos Mask"
    },
    
    ["nose mask"] = {
        model = "models/noseybonk/noseybonk.mdl",
        femmodel = "models/noseybonk/noseybonk.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3,-2.9,0),Angle(-180,0,90),1},
        fempos = {Vector(3,-2.9,0),Angle(-180,0,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 6500,
        vpos = Vector(0,0,0),
        name = "Nosey Bonk Mask"
    },
    
    ["slayer mask"] = {
        model = "models/doometernal/items/slayer's mask.mdl",
        femmodel = "models/doometernal/items/slayer's mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-3,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-3,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Slayer Mask"
    },
    ["gag mask"] = {
        model = "models/snowzgmod/payday2/masks/maskthegagball.mdl",
        femmodel = "models/snowzgmod/payday2/masks/maskthegagball.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Gaged Mask"
    },
    ["manhunt mask"] = {
        model = "models/modified/mask5.mdl",
        femmodel = "models/modified/mask5.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Munhunt Mask"
    },
    
    ["larry mask"] = {
        model = "models/gtav_halloween_mask_pack/berd009/halloween_berd009_a.mdl",
        femmodel = "models/gtav_halloween_mask_pack/berd009/halloween_berd009_a.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-2,0),Angle(180,100,90),1},
        fempos = {Vector(0,-2.6,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Larry's Mask"
    },
    ["zombie mask"] = {
        model = "models/gtav_halloween_mask_pack/berd007/halloween_berd007_b.mdl",
        femmodel = "models/gtav_halloween_mask_pack/berd007/halloween_berd007_b.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,-3,0),Angle(180,100,90),1},
        fempos = {Vector(2,-2.6,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Zombie Mask"
    },
    ["berd mask"] = {
        model = "models/gtav_halloween_mask_pack/berd003/halloween_berd003_a.mdl",
        femmodel = "models/gtav_halloween_mask_pack/berd003/halloween_berd003_a.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,-3,0),Angle(180,100,90),1},
        fempos = {Vector(2,-3,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Berd Mask"
    },
    ["chort mask"] = {
        model = "models/gtav_halloween_mask_pack/berd008/halloween_berd008_a.mdl",
        femmodel = "models/gtav_halloween_mask_pack/berd008/halloween_berd008_a.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3,-4,0),Angle(180,100,90),1},
        fempos = {Vector(3,-4,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Chort Mask"
    },
    ["monkey mask"] = {
        model = "models/sal/halloween/monkey.mdl",
        femmodel = "models/sal/halloween/monkey.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Monkey Mask"
    },                        
    ["cat mask"] = {
        model = "models/sal/cat.mdl",
        femmodel = "models/sal/cat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(1,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Cat Mask"
    },
    ["skull mask"] = {
        model = "models/sal/halloween/skull.mdl",
        femmodel = "models/sal/halloween/skull.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(1,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Skull Mask"
    },
    ["hawk mask"] = {
        model = "models/sal/hawk_1.mdl",
        femmodel = "models/sal/hawk_1.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-1,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Hawk Mask"
    },
    ["bear mask"] = {
        model = "models/sal/bear.mdl",
        femmodel = "models/sal/bear.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(1,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Bear Mask"
    },            
    ["surgical mask"] = {
        model = "models/rebs/maske/maske.mdl",
        femmodel = "models/rebs/maske/maske.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-5.5,0),Angle(180,100,90),1},
        fempos = {Vector(0.5,-5.5,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Surgical Mask"
    },    
    ["piggy mask"] = {
        model = "models/sal/pig.mdl",
        femmodel = "models/sal/pig.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Piggy Mask"
    },
    ["hater mask"] = {
        model = "models/sal/halloween/headwrap1.mdl",
        femmodel = "models/sal/halloween/headwrap1.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Yellow Headwarp"
    },
    ["penguin mask"] = {
        model = "models/sal/penguin.mdl",
        femmodel = "models/sal/penguin.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Penguin Mask"
    },
    ["paper"] = {
        model = "models/sal/halloween/bag.mdl",
        femmodel = "models/sal/halloween/bag.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Paper Mask"
    },    

    ["hood"] = {
        model = "models/distac/kapishon2.mdl",
        femmodel = "models/distac/kapishon2_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = function(ent) 
            local colthes = IsValid(ent) and ent.GetNWString and ent:GetNWString("Colthesmain","normal") or ""
            --print(colthes == "cold" and 0 or 1)
            return colthes == "cold" and 0 or 1
        end,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        bPointShop = true,
        price = 850,
        vpos = Vector(0,0,69),
        name = "Hood",
        modelPreRenderCallback = function(ply,ent,model,accessories) -- я не знаю почему, но почему-то флексы начинают уходить в минус бесконечность, поэтому приходится менять флекс каждый кадр... изивините
            local accessories1 = accessories or ent.PredictedAccessories
            model.mfdoom = ((accessories1 and accessories1[2] == "mfdoom mask") and true or false)
            --print(model.mfdoom)
            model.flex = model.flex or model:GetFlexIDByName("M")
            model:SetFlexWeight(model.flex, model.mfdoom and 1 or 0)
        end,
    },

    ["christmas hat"] = {
        model = "models/grinchfox/head_wear/christmas_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,0.5,0),Angle(180,90,90),1},
        fempos = {Vector(0.2,0,0),Angle(180,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        name = "Christmas Hat"
    },
    ["cat hat"] = {
        model = "models/cathat/cathat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,-0.5,0),Angle(180,90,90),1},
        fempos = {Vector(0.2,-0.1,0),Angle(180,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        name = "Cat Hat"
    },
    ["cap deeper"] = {
        model = "models/grinchfox/head_wear/caphat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 7,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 850,
        vpos = Vector(0,0,5),
        name = "Deeper Cap"
    },

    ["cap nurse"] = {
        model = "models/grinchfox/head_wear/caphat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 9,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 750,
        vpos = Vector(0,0,5),
        name = "Nurse Cap"
    },

	["cap payot"] = {
        model = "models/grinchfox/head_wear/jewhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,5),
        name = "Payot Cap"
    },

	["burger king crown"] = {
        model = "models/roblox_assets/burger_king_crown.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(7.8,-0.1,0),Angle(-90,-80,-90),0.7},
        fempos = {Vector(7.8,-0.1,0),Angle(-90,-80,-90),0.7},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 99999999, -- не должно быть видно в поинтшопе типо нельзя купить (пасхалка)
        vpos = Vector(0,0,5),
        name = "Burger King Crown"
    },

    ["deal glasses"] = {
        model = "models/grinchfox/head_wear/dealglasses_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.5,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.5,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 7331,
        vpos = Vector(0,0,5),
        name = "DealGlasses™"
    },

    ["cool glasses"] = {
        model = "models/grinchfox/head_wear/fancyglasses2.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,5),
        name = "Fancy Glasses"
    },

    ["retro glasses"] = {
        model = "models/grinchfox/head_wear/fancyglasses3.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,5),
        name = "Retro Glasses"
    },

    ["tophat white"] = {
        model = "models/grinchfox/head_wear/tophat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
        skin = 1,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 1700,
        vpos = Vector(0,0,5),
        name = "White Tophat"
    },

    ["bandana groove"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 3,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1400,
        vpos = Vector(0,0,63),
        name = "Groove Bandana"
    },

    ["bandana crips"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 1,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1400,
        vpos = Vector(0,0,63),
        name = "Crips Bandana"
    },

    ["bandana white"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1100,
        vpos = Vector(0,0,63),
        name = "White Bandana"
    },

    ["bandana ghost"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 10,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,63),
        name = "Ghost Bandana"
    },

    ["bandana hm"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 11,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 1100,
        vpos = Vector(0,0,63),
        name = "HM Bandana"
    },

    ["bandana evil"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 5,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 1500,
        vpos = Vector(0,0,63),
        name = "Evil (evil) Bandana"
    },

    ["baseball hub"] = {
        model = "models/grinchfox/head_wear/baseballhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1.1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 6,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 1750,
        vpos = Vector(0,0,5),
        name = "Baseball Hat"
    },

    ["leather bag"] = {
        model = "models/distac/bag.mdl",
        femmodel = "models/distac/bagf.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "torso",
        bonemerge = true,
        bPointShop = true,
        isdpoint = false,
        price = 1550,
        vpos = Vector(0,0,42),
        name = "Leather Bag"
    },

    ["starglassis"] = {
        model = "models/distac/starglassis.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-64,-0.3,0),Angle(180,90,90),1},
        fempos = {Vector(-64,-0.3,0),Angle(180,90,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Star Glassis"
    },

    ["cap brain"] = {
        model = "models/distac/cap_brain.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,1.5,0),Angle(180,80,90),1},
        fempos = {Vector(0.5,1.5,0),Angle(180,80,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,0),
        name = "Brain Cap"
    },

    ["coolPro headphone"] = {
        model = "models/distac/headphone.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Headphones coolPro"
    },

    ["medieval hood"] = {
        model = "models/distac/kapishom_m.mdl",
        femmodel = "models/distac/kapishom_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        bPointShop = true,
        price = 950,
        vpos = Vector(0,0,69),
        name = "Medieval hood"
    },

    ["cap cool"] = {
        model = "models/distac/cap_brain.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,1.5,0),Angle(180,80,90),1},
        fempos = {Vector(0.5,1.5,0),Angle(180,80,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,0),
        SubMat = "distac/41/cap_fire",
        name = "Cool Cap"
    },
    --vest
    ["vest_normal"] = {
        model = "models/distac/vest_m.mdl",
        femmodel = "models/distac/vest_f.mdl",
        bone = "ValveBiped.Bip01_Spine2",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "torso",
        norender = false,
        bonemerge = true,
        bSetColor = false,
        bPointShop = false,
        price = 950,
        vpos = Vector(0,0,50),
        name = "Vest Closed"
    },
    ["vest_full_open"] = {
        model = "models/distac/vest_m.mdl",
        femmodel = "models/distac/vest_f.mdl",
        bone = "ValveBiped.Bip01_Spine2",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "torso",
        norender = false,
        bonemerge = true,
        bSetColor = false,
        bPointShop = false,
        price = 950,
        vpos = Vector(0,0,50),
        name = "Vest Opened",
        modelPreRenderCallback = function(ply,ent,model,accessories)
            model:SetFlexWeight(0, 1)
        end,
    },
    ["vest_neck_open"] = {
        model = "models/distac/vest_m.mdl",
        femmodel = "models/distac/vest_f.mdl",
        bone = "ValveBiped.Bip01_Spine2",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "torso",
        norender = false,
        bonemerge = true,
        bSetColor = false,
        bPointShop = false,
        price = 950,
        vpos = Vector(0,0,50),
        name = "Vest Neck Open",
        modelPreRenderCallback = function(ply,ent,model,accessories)
            model:SetFlexWeight(1, 1)
        end,
    },
        ["horse"] = {
            model = "models/horsie/horsiemask.mdl",
            bone = "ValveBiped.Bip01_Head1",
            malepos = {Vector(4.031,-4.021,0.058),Angle(87.1197,139.453,114.698),1},
            fempos = {Vector(4.031,-4.021,0.3154),Angle(87.1197,139.453,114.698),1},
            scaleVec = Vector(0.9,1,1),
            scaleVecFem = Vector(0.9,0.9,1),
            skin = 0,
            placement = "head",
            norender = true
    },
        ["cigarette"] = {
            model = "models/props/cigarettes/cigarette_marlboro.mdl",
            bone = "ValveBiped.Bip01_Head1",
            malepos = {Vector(0.8,-7,0),Angle(0,-90,-0),1},
            fempos = {Vector(-0.1,-7,0),Angle(0,-90,-0),1},
            scaleVec = Vector(0.9,1,1),
            scaleVecFem = Vector(0.9,0.9,1),
            skin = 0,
            placement = "face",
            norender = true
    },
    
	    ["mimi"] = {
	        model = "models/mimi_plush/mimi_plush.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,5.4344,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,3.4734,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },

	    ["meowl"] = {
	        model = "models/catowl/catowl.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,5.4344,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,3.4734,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },        
        
	    ["boywife"] = {
	        model = "models/Boywife.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,0,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,0,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },
        
	    ["sadsalat"] = {
	        model = "models/salatshit/newsalatisplush.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,0,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,0,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },
    
	    ["expie"] = {
	        model = "models/orsoniks/experimentplush.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,3.4344,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,1.47340,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },
	    ["trans shark"] = {
	        model = "models/geozek/props/emperorfaiz/blahaj_smol.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,0,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,0,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },
	    ["niko"] = {
	        model = "models/niko_plush/niko_plush.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,0,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,0,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
	        placement = "spine"
	    },
	    ["argemia red"] = {
	        model = "models/drm/argemia_plush.mdl",
	        bone = "ValveBiped.Bip01_L_Clavicle",
	        malepos = {Vector(3.5672,0,1.6674),Angle(-82.5258,-64.969,-19.946),0.55},
	        fempos = {Vector(4.6841,0,0.307),Angle(-89.3015,0,-84.7326),0.55},
	        skin = 0,
	        norender = false,
            bSetColor = false,
	        placement = "spine"
	    },    

    ["focusshat"] = {
        model = "models/focusshat/focusshat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.3,-1.5,0), Angle(0,-70,-90), 1.05},
        fempos = {Vector(2.1,-2.7,0),Angle(0,-70,-90),.9},
        skin = 0,
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "head",
        name = "Focus's hat"
    },
--[[
    ["piratehat"] = {
        model = "models/piratehat/piratehat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.3,-1.5,0), Angle(0,90,90), 1.05},
        fempos = {Vector(4.3,-1.5,0), Angle(0,90,90),.9},
        skin = 0,
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "head",
        name = "Pirate Hat"
    },

    ["piratehat1"] = {
        model = "models/piratehat/piratehat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.3,-1.5,0), Angle(0,110,90), 1},
        fempos = {Vector(4.3,-1.5,0), Angle(0,110,90),.9},
        skin = 0,
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "head",
        name = "Additional Pirate Hat"
    },
--]]
    ["smileface1"] = {
        model = "models/smailface/smailface.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.5,-5.79,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.5,-5.79,0),Angle(0,-80,-90),0.9},
        skin = 0,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Smile Face 1"
    },

    ["smileface2"] = {
        model = "models/smailface/smailface.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.5,-5.79,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.5,-5.79,0),Angle(0,-80,-90),0.9},
        skin = 1,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Smile Face 2"
    },

    ["smileface3"] = {
        model = "models/smailface/smailface.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.5,-5.79,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.5,-5.79,0),Angle(0,-80,-90),0.9},
        skin = 2,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Smile Face 3"
    },

    ["smileface4"] = {
        model = "models/smailface/smailface.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.5,-5.79,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.5,-5.79,0),Angle(0,-80,-90),0.9},
        skin = 3,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Smile Face 4"
    },

    ["killer228"] = {
        model = "models/killer228/killer228.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.5,-5.79,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.5,-5.79,0),Angle(0,-80,-90),0.9},
        skin = 0,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Killer228"
    },

    ["bignessmask1"] = {
        model = "models/bignessmask/bignessmask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.2,-5.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.2,-5.3,0),Angle(0,-80,-90),0.9},
        skin = 0,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Bigness Mask 1"
    },

    ["bignessmask2"] = {
        model = "models/bignessmask/bignessmask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.2,-5.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.2,-5.3,0),Angle(0,-80,-90),0.9},
        skin = 1,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Bigness Mask 2"
    },

    ["bignessmask3"] = {
        model = "models/bignessmask/bignessmask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-27.2,-5.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-25.2,-5.3,0),Angle(0,-80,-90),0.9},
        skin = 2,
        placement = "face",
        norender = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        pointshopPreview = {auto = true, flex = true},
        vpos = Vector(0,0,0),
        name = "Bigness Mask 3"
    },
--[[
    ["wwebelt5"] = {
        model = "models/wwecurrenttitle1.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(-4, 9, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 0,
        bPointShop = true,
        isdpoint = true,
        price = 10000,
        placement = "spine",
        name = "Avercry's belt"
    },
--]]
    ["dufflebag1"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 0,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Zebra"
    },

    ["dufflebag2"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 1,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Red Zebra"
    },

    ["dufflebag3"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 2,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Bigness Purple"
    },

    ["dufflebag4"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 3,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Guffy"
    },

    ["dufflebag5"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 5,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag G"
    },

    ["dufflebag6"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 6,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag G Gray"
    },

    ["dufflebag7"] = {
        model = "models/sportbag4/sportbag4.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 7,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Jackal"
    },

    ["sportbag1"] = {
        model = "models/sportbag3/sportbag3.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 0,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Black"
    },

    ["sportbag2"] = {
        model = "models/sportbag3/sportbag3.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = { Vector(0, 0, 0), Angle(0, 100, 90), .63},
        fempos = {Vector(-4, 9, 0),Angle(0, 100, 90),.6},
        skin = 1,
        pointshopPreview = {auto = true, flex = true},
        bonemerge = true,
        bPointShop = true,
        isdpoint = true,
        price = 100,
        placement = "spine",
        name = "Duffle bag Red"
    },
--[[
    ["cap_colorable"] = {
        model = "models/griggs/cap_colorable.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bSetColor = true,
        bPointShop = true,
        price = 1500,
        name = "Colorable Baseball Cap"
    },
--]]
    ["exclusive blue eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Exclusive blue glasses"
    },
    
    ["exclusive black eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Exclusive black glasses"
    },

    ["exclusive silver eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Exclusive silver glasses"
    },
    
    ["exclusive blue eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Exclusive blue glasses"
    },

   ["exclusive gold eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Exclusive gold glasses"
    },

    ["exclusive violet eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.5,-0.6,-.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 6,
        norender = true,
        placement = "face",
        name = "Exclusive violet glasses"
    },

    ["exclusive orange eyeglasses"] = {
        model = "models/exclusive_glasses/exclusive_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = { Vector(0.25,-0.3,0.1), Angle(0, 100, -90), 1},
        fempos = {Vector(-0.2,-1,0), Angle(0, 100, -90),.9},
        skin = 7,
        norender = true,
        placement = "face",
        name = "Exclusive orange glasses"
    },
    
    ["disco eyeglasses"] = {
        model = "models/eyeglasses_03/eyeglasses_03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-0.8,-1,0),Angle(0,-75,-90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Disco eyeglasses"
    },
    
    ["disco red eyeglasses"] = {
        model = "models/eyeglasses_03/eyeglasses_03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-0.8,-1,0),Angle(0,-75,-90),.95},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Disco red eyeglasses"
    },

    ["homigrad eyeglasses"] = {
        model = "models/eyeglasses_03/eyeglasses_03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-0.8,-1,0),Angle(0,-75,-90),.95},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Homigrad eyeglasses"
    },

    ["white eyeglasses"] = {
        model = "models/eyeglasses_03/eyeglasses_03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(0,-80,-90),1},
        fempos = {Vector(-0.8,-1,0),Angle(0,-75,-90),.95},
        skin = 11,
        norender = true,
        placement = "face",
        name = "White eyeglasses"
    },

    ["biker eyeglasses"] = {
        model = "models/biker_glasses/biker_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-0.4,-1.62,0),Angle(0,110,90),1},
        fempos = {Vector(-0.9,-1.5,0),Angle(0,110,90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Biker eyeglasses"
    },

    ["biker green eyeglasses"] = {
        model = "models/biker_glasses/biker_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-0.4,-1.62,0),Angle(0,110,90),1},
        fempos = {Vector(-0.9,-1.5,0),Angle(0,110,90),.95},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Biker green eyeglasses"
    },

    ["biker neon eyeglasses"] = {
        model = "models/biker_glasses/biker_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-0.4,-1.62,0),Angle(0,110,90),1},
        fempos = {Vector(-0.9,-1.5,0),Angle(0,110,90),.95},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Biker neon eyeglasses"
    },

    ["biker black eyeglasses"] = {
        model = "models/biker_glasses/biker_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-0.4,-1.62,0),Angle(0,110,90),1},
        fempos = {Vector(-0.9,-1.5,0),Angle(0,110,90),.95},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Biker black eyeglasses"
    },

    ["biker pink eyeglasses"] = {
        model = "models/biker_glasses/biker_glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-0.4,-1.62,0),Angle(0,110,90),1},
        fempos = {Vector(-0.9,-1.5,0),Angle(0,110,90),.95},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Biker pink eyeglasses"
    },

    ["pilot's glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Pilot's glasses"
    },
    ["panama1"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 1"
    },
    ["panama2"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 9,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 2"
    },
    ["panama3"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 3"
    },
    ["panama4"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 25,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 4"
    },
    ["panama5"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 17,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 5"
    },
    ["panama6"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 19,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 6"
    },
    ["panama7"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 24,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 7"
    },
    ["panama8"] = {
        model = "models/panama.001/panama.001.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(0,-0.5,0),Angle(0,-80,-90),1},
        skin = 18,
        norender = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Panama 8"
    },

    ["pilot's black glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Pilot's black glasses"
    },

    ["pilot's real black glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Pilot's real black glasses"
    },

    ["pilot's red glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Pilot's red glasses"
    },

    ["pilot's blue glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Pilot's blue glasses"
    },

    ["pilot's white glasses"] = {
        model = "models/airglasses/airglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.6,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Pilot's white glasses"
    },

    ["Aviators gta"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Golden aviators"
    },

    ["Aviators gta 1"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Violet aviators"
    },

    ["Aviators gta 2"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Gray aviators"
    },

    ["Aviators gta 3"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Green aviators"
    },

    ["Aviators gta 4"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Blue aviators"
    },
    
    ["Aviators gta 5"] = {
        model = "models/aviators/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Black aviators"
    },

    ["quad"] = {
        model = "models/quadglasses/quadglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Quad glasses"
    },

    ["Big glasses assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Big golden glasses"
    },

    ["Big glasses 2assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Big golden rain glasses"
    },

    ["Big glasses 1assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Big red glasses"
    },

    ["arabscarf1"] = {
        model = "models/arab/arab.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-4,4,0),Angle(0,80,90),1},
        fempos = {Vector(-4.9,-1.8,0),Angle(0,-80,-90),1},
        skin = 0,
        norender = true,
        placement = "spine",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Arab Scarf 1"
    },
    ["arabscarf2"] = {
        model = "models/arab/arab.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-4,4,0),Angle(0,80,90),1},
        fempos = {Vector(-4.9,-1.8,0),Angle(0,-80,-90),1},
        skin = 1,
        norender = true,
        placement = "spine",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Arab Scarf 2"
    },
    ["arabscarf3"] = {
        model = "models/arab/arab.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-4,4,0),Angle(0,80,90),1},
        fempos = {Vector(-4.9,-1.8,0),Angle(0,-80,-90),1},
        skin = 2,
        norender = true,
        placement = "spine",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Arab Scarf 3"
    },
    ["shotglasses1"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 1"
    },
    ["shotglasses2"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 2"
    },
    ["shotglasses3"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 2,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 3"
    },
    ["shotglasses4"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 3,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 4"
    },
    ["shotglasses5"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 4,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 5"
    },
    ["shotglasses6"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 5,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 6"
    },
    ["shotglasses7"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 6,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 7"
    },
    ["shotglasses8"] = {
        model = "models/shotgalsses/shotgalsses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.29,-0.4,0),Angle(0,-80,-90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 7,
        norender = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,0),
        name = "Shot Glasses 8"
    },
    ["wool beanie 1"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 1"
    },

    ["wool beanie 2"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 2"
    },

    ["wool beanie 3"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 3"
    },

    ["wool beanie 4"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 4"
    },

    ["wool beanie 5"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 8,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 5"
    },

    ["wool beanie 6"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 13,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 6"
    },

    ["wool beanie 7"] = {
        model = "models/snowbeanie/snowbeanie.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.4,-0.7,0),Angle(0,-80,-90),1.05},
        fempos = {Vector(-0.5,-1,0),Angle(0,-80,-90),1},
        skin = 21,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Wool Beanie 7"
    },
    
    ["Big glasses 3assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Big silver glasses"
    },

    ["Big glasses 4assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Big purple glasses"
    },

    ["Big glasses 5assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Big ocean glasses"
    },

    ["Big glasses 6assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 6,
        norender = true,
        placement = "face",
        name = "Big black glasses"
    },

    ["Big glasses 8assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 7,
        norender = true,
        placement = "face",
        name = "Big emo glasses"
    },

    ["Big glasses 7assduck"] = {
        model = "models/biggiglasses/biggiglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 8,
        norender = true,
        placement = "face",
        name = "Big acid glasses"
    },

    ["bandana black"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Bandana black"
    },

    ["Cool zebra glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Cool zebra glasses"
    },

    ["Cool candy glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 6,
        norender = true,
        placement = "face",
        name = "Cool candy glasses"
    },

    ["Cool golden glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 4,
        norender = true,
        placement = "face",
        name = "Cool golden glasses"
    },

    ["Cool girl glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Cool girl glasses"
    },

    ["Cool dark glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Cool dark glasses"
    },

    ["Cool orange glasses"] = {
        model = "models/eyeglasses_05/eyeglasses_05.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.3,-1,0),Angle(180,100,90),1},
        fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Cool orange glasses"
    },

    ["bandana skilet"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 1,
        norender = true,
        placement = "face",
        name = "Bandana skilet"
    },

    ["bandana gray"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 2,
        norender = true,
        placement = "face",
        name = "Bandana gray"
    },

    ["bandana camouflage"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 3,
        norender = true,
        placement = "face",
        name = "Bandana camouflage"
    },

    ["bandana green camouflage"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Bandana green camouflage"
    },

    ["bandana green"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-25,-10.5,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 5,
        norender = true,
        placement = "face",
        name = "Bandana green"
    },

    ["bandana purple"] = {
        model = "models/bandana01/bandana01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-24.5,-10,0),Angle(0,-72,-90),0.95},
        fempos = {Vector(-24.8,-6.5,0),Angle(0,-78,-90),.9},
        skin = 6,
        norender = true,
        placement = "face",
        name = "Bandana purple"
    },

    ["bugeye sunglasses"] = {
        model = "models/captainbigbutt/skeyler/accessories/glasses04.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.2,-3.3,0),Angle(0,-70,-90),.9},
        fempos = {Vector(2.2,-3.3,0),Angle(0,-70,-90),.8},
        skin = 0,
        norender = true,
        placement = "face",
        name = "Bugeye Sunglasses"
    },

    ["aviators"] = {
        model = "models/arctic_nvgs/aviators.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.7,0,0),Angle(0,-80,-90),1},
        fempos = {Vector(0.25,0,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        bPointShop = true,
        price = 5000,
        vpos = Vector(0,0,0),
        name = "Aviators"
    },

    ["nerd glasses"] = {
        model = "models/gmod_tower/klienerglasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-2.2,0),Angle(0,-80,-90),1},
        fempos = {Vector(2.5,-2.5,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "face",
        bPointShop = true,
        price = 1000,
        name = "Nerd Glasses"
    },

    ["headphones"] = {
        model = "models/gmod_tower/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.6,-1,0),Angle(0,-80,-90),.85},
        fempos = {Vector(2.4,-1,0),Angle(0,-85,-90),.8},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Headphones"
    },
    --[[
	["Roman's cap"] = {
        model = "models/roma/roma.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,-2,0),Angle(0,-80,-90), 0.9},
        fempos = {Vector(4.5,-0.2,0),Angle(0,-75,-90), 0.7},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Roman's cap"
    },
--]]
    ["baseball cap"] = {
        model = "models/gmod_tower/jaseballcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0,0),Angle(0,-75,-90), 1.12},
        fempos = {Vector(4,-0.1,0),Angle(0,-75,-90), 1.125},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Baseball Cap"
    },

    ["fedora"] = {
        model = "models/captainbigbutt/skeyler/hats/fedora.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5.5,-0.2,0),Angle(0,-80,-90), 0.7},
        fempos = {Vector(4.5,-0.2,0),Angle(0,-75,-90), 0.7},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Fedora"
    },

    ["stetson"] = {
        model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(6.2,0.6,0),Angle(0,-60,-90), 0.7},
        fempos = {Vector(5.2,0.5,0),Angle(0,-65,-90), 0.65},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Stetson"
    },

    ["straw hat"] = {
        model = "models/captainbigbutt/skeyler/hats/strawhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5.2,-0.4,0),Angle(0,-70,-90), 0.85},
        fempos = {Vector(4.5,-0.5,0),Angle(0,-75,-90), 0.8},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Straw Hat"
    },

    ["sun hat"] = {
        model = "models/captainbigbutt/skeyler/hats/sunhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.2,2,0),Angle(0,-90,-90), 0.8},
        fempos = {Vector(3.4,2,0),Angle(0,-90,-90), 0.75},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Sun Hat"
    },

    ["bling cap"] = {
        model = "models/captainbigbutt/skeyler/hats/zhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.9,0.1,0),Angle(0,-80,-90), 0.75},
        fempos = {Vector(3.5,0.2,0),Angle(-10,-80,-90), 0.75},
        skin = 0,
        norender = true,
        placement = "head"
    },

    ["Bigness cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 0,
        norender = true,
        placement = "head"
    },

    ["Bigness red cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 1,
        norender = true,
        placement = "head"
    },

    ["Bigness design cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 2,
        norender = true,
        placement = "head"
    },

    ["Bigness banana cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 3,
        norender = true,
        placement = "head"
    },

    ["Bigness guffy cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 4,
        norender = true,
        placement = "head"
    },
    
    ["Bigness cool cap"] = {
        model = "models/hat01/hat01.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.14,0),Angle(0,100,90), 1},
        fempos = {Vector(.5,-1,-0.059),Angle(0,115,90), 0.97},
        skin = 5,
        norender = true,
        placement = "head"
    },

    ["top hat"] = {
        model = "models/player/items/humans/top_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0,-1.5,0),Angle(0,-80,-90), 1},
        fempos = {Vector(-0.8,-1.8,0),Angle(0,-80,-90), 1},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Top Hat (waffle)"
    },

    ["backpack"] = {
        model = "models/makka12/bag/jag.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-3,0,0),Angle(0,90,90),.75},
        fempos = {Vector(-3,-1,0),Angle(0,90,90),.6},
        skin = 0,
        norender = false,
        placement = "spine",
        name = "Backpack"
    },

    ["backpack hellokitty"] = {
        model = "models/gleb/backpack_pink.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,0),
        name = "HelloKitty Backpack"
    },

    ["kickme sticker"] = {
        model = "models/gleb/kickme.mdl",
        bone = "ValveBiped.Bip01_Pelvis",
        malepos = {Vector(0,4,-6.8),Angle(-75,-90,0),1},
        fempos = {Vector(0,4,-5.8),Angle(-65,-90,0),1},
        skin = 0,
        norender = false,
        placement = "spine",
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        name = "KickMe Sticker"
    },

    ["nerd tooths"] = {
        model = "models/gleb/nerd.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.3,-0.4,0),Angle(0,-85,-90),1},
        fempos = {Vector(1.9,-0.8,0),Angle(0,-85,-90),.95},
        skin = 0,
        norender = true,
        placement = "spine",
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        name = "Nerd Teeth"
    },

    ["purse"] = {
        model = "models/props_c17/BriefCase001a.mdl",
        bone = "ValveBiped.Bip01_Spine1",
        malepos = {Vector(-7,1,7),Angle(0,90,100),.5},
        fempos = {Vector(-7,0,7),Angle(0,90,100),.5},
        skin = 0,
        norender = false,
        placement = "spine",
        name = "Purse"
    },
    --CAPS
    ["zcity cap"] = {
        model = "models/gleb/zcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1500,
        name = "ZCITY Baseball Cap"
    },

    ["gray cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        name = "Grey Baseball Cap"
    },

    ["light gray cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        name = "Light Gray Baseball Cap"
    },

    ["white cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Baseball Cap"
    },

    ["green cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.5,0.1),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 4,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Green Baseball Cap"
    },

    ["dark green cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 5,
        norender = true,
        placement = "head",
        name = "Dark Green Baseball Cap"
    },

    ["brown cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 6,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Brown Baseball Cap"
    },

    ["blue cap"] = {
        model = "models/modified/hat07.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(5,0.4,0),Angle(180,105,90),1},
        fempos = {Vector(3.5,0.2,0),Angle(180,105,90),1},
        skin = 7,
        norender = true,
        placement = "head",
        name = "Blue Baseball Cap"
    },
    -- FaceMasks
    ["bandana"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        bSetColor = true,
        vecColorOveride = Vector(0.2,0.2,0.2),
        norender = true,
        placement = "face",
        ScreenSpaceEffects = function()
            -- DrawColorModify(AviatorColor)
            surface.SetMaterial(bandanamat)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(-1,0,ScrW()*1.01,ScrH()*1.2)
         end,
        bPointShop = true,
        vpos = Vector(0,0,63),
        price = 1000,
        name = "Bandana"
    },
--[[
    ["bandana colorable"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        bSetColor = true,
        norender = true,
        placement = "face",
        ScreenSpaceEffects = function()
            -- DrawColorModify(AviatorColor)
            surface.SetMaterial(bandanamat)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(-1,0,ScrW()*1.01,ScrH()*1.2)
         end,
        bPointShop = true,
        vpos = Vector(0,0,63),
        price = 4500,
        name = "Bandana colorable"
    },
--]]
    ["arctic_balaclava"] = {
        model = "models/d/balaklava/arctic_reference.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1.1},
        fempos = {Vector(-1,-0.8,0),Angle(180,105,90),1.05},
        skin = 0,
        norender = true,
        disallowinappearance = true,
        bonemerge = true,
        name = "Arctic Balaclava"
    },

    ["phoenix_balaclava"] = {
        model = "models/d/balaklava/phoenix_balaclava.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.95,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        norender = true,
        disallowinappearance = true,
        bonemerge = true,
        name = "Phoenix Balaclava"
    },

    ["arctic_balaclava_pointshop"] = {
        model = "models/d/balaklava/arctic_reference.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1.1},
        fempos = {Vector(-1,-0.8,0),Angle(180,105,90),1.05},
        skin = 0,
        price = 8000,
        norender = true,
        bonemerge = true,
        bPointShop = true,
        placement = "face",
        name = "Arctic Balaclava"
    },

    ["phoenix_balaclava_pointshop"] = {
        model = "models/d/balaklava/phoenix_balaclava.mdl",
        femmodel = "models/distac/feminine_mask.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.95,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        price = 8000,
        norender = true,
        bonemerge = true,
        bPointShop = true,
        placement = "face",
        name = "Phoenix Balaclava"
    },
    ["terrorist_band"] = {
        model = "models/distac/band_team.mdl",
        femmodel = "models/distac/band_team_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,-0.95,0),Angle(180,100,90),0.95},
        fempos = {Vector(-0.6,-0.6,0),Angle(180,100,90),0.95},
        skin = 0,
        disallowinappearance = true,
        bonemerge = true,
        needcoolRender = true,
        flex = true,
        name = "Terrorist Armband"
    },
    -- scarfs
    ["white scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 0,
        norender = false,
        vpos = Vector(0,0,20),
        placement = "torso",
        name = "White Scarf"
    },

    ["gray scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 1,
        norender = false,
        vpos = Vector(0,0,20),
        placement = "torso",
        name = "Gray Scarf"
    },

    ["black scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 2,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Black Scarf"
    },

    ["blue scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 3,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Blue Scarf"
    },

    ["red scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 4,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Red Scarf"
    },

    ["green scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 5,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Green Scarf"
    },

    ["pink scarf"] = {
        model = "models/sal/acc/fix/scarf01.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-18,8,0),Angle(0,75,90),1},
        fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
        skin = 6,
        norender = false,
        placement = "torso",
        bPointShop = true,
        vpos = Vector(0,0,20),
        price = 1000,
        name = "Pink Scarf"
    },
    -- earmuffs
    ["red earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 0,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Red Earmuffs"
    },

    ["pink earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 1,
        norender = true,
        bPointShop = true,
        price = 1000,
        name = "Pink Earmuffs"
    },

    ["green earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 2,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Green Earmuffs"
    },

    ["yellow earmuffs"] = {
        model = "models/modified/headphones.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
        fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
        skin = 3,
        norender = true,
        placement = "ears",
        bPointShop = true,
        price = 1000,
        name = "Yellow Earmuffs"
    },
    -- fedoras

    ["gray fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Gray Fedora"
    },

    ["black fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Black Fedora"
    },

    ["white fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Fedora"
    },

    ["beige fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Beige Fedora"
    },

    ["black/red fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 5,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Black-n-Red Fedora"
    },

    ["blue fedora"] = {
        model = "models/modified/hat01_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
        skin = 7,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Blue Fedora"
    },
    -- beanies
    ["striped beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Striped Beanie"
    },
    ["periwinkle beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Periwinkle Beanie"
    },

    ["fuschia beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Fuschia Beanie"
    },

    ["Bikers band"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band"
    },

    ["Bikers band LS"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 1,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band LS"
    },

    ["Bikers band LS US"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 2,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band LS US"
    },

    ["Bikers band casino"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band casino"
    },

    ["Bikers band green"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 4,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band green"
    },

    ["Bikers band US"] = {
        model = "models/bikergtaband/bikergtaband.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,-0.9,0),Angle(180,105,90),1},
        fempos = {Vector(0,-0.9,0),Angle(180,105,90),1},
        skin = 6,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Bikers band US"
    },

    ["white beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,100,90),1},
        skin = 3,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "White Beanie"
    },

    ["gray beanie"] = {
        model = "models/modified/hat03.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4,0,0),Angle(180,105,90),1},
        fempos = {Vector(3.8,0.2,0),Angle(180,100,90),1},
        skin = 4,
        norender = true,
        placement = "head",
        bPointShop = true,
        price = 1000,
        name = "Gray Beanie"
    },
    -- backpacks
    ["large red backpack"] = {
        model = "models/modified/backpack_1.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5.2,0),Angle(0,80,90),1},
        fempos = {Vector(-8,4,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Large Red Backpack"
    },

    ["large gray backpack"] = {
        model = "models/modified/backpack_1.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,5.2,0),Angle(0,80,90),1},
        fempos = {Vector(-8,4,0),Angle(0,80,90),0.9},
        skin = 1,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Large Gray Backpack"
    },

    ["medium backpack"] = {
        model = "models/modified/backpack_3.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,4,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 0,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Medium Backpack"
    },

    ["medium gray backpack"] = {
        model = "models/modified/backpack_3.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(-7.5,4,0),Angle(0,80,90),1},
        fempos = {Vector(-8,3,0),Angle(0,80,90),0.9},
        skin = 1,
        norender = false,
        placement = "spine",
        bPointShop = true,
        price = 1000,
        name = "Medium Gray Backpack"
    },

    ["monokl"] = {
        model = "models/distac/monokl.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.05,-4.8,-1.3),Angle(180,100,90),1},
        fempos = {Vector(-1,-0.8,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Monocle"
    },

    ["china hat"] = {
        model = "models/distac/china_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(4.5,-0.35,0),Angle(180,100,90),1},
        fempos = {Vector(3,-0.8,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,0),
        name = "China Hat"
    },

    ["helicopter cap"] = {
        model = "models/distac/cap_helecopterkid.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-70,-13.5,0),Angle(180,100,90),1.1},
        fempos = {Vector(-63,-18.5,0),Angle(180,105,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Helicopter Baseball Cap"
    },

    ["welding glasses"] = {
        model = "models/distac/glassis_welding glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Welding Glasses"
    },

    ["welding red glasses"] = {
        model = "models/distac/glassis_welding glasses.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 1,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Welding red Glasses"
    },

    ["big glasses"] = {
        model = "models/distac/big_ahhh_glassis.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        isdpoint = false,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Big Glasses"
    },

    ["griggs glasses"] = {
        model = "models/distac/big_ahhh_glassis.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 1,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        isdpoint = false,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Grigg's beloved glasses"
    },


    ["glasses with nose"] = {
        model = "models/distac/glasses_with_mustache.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "ОЧКИ С УСАМИ МЕМ"
    },

    ["glasses fmf"] = {
        model = "models/distac/street_kid_fmf.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        flex = true,
        bPointShop = true,
        price = 3000,
        vpos = Vector(0,0,69),
        name = "FMF Glasses"
    },

    ["warmcap"] = {
        model = "models/distac/warmcap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,-0.95,0),Angle(180,100,90),1},
        fempos = {Vector(0,0,0),Angle(0,0,0),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        flex = true,
        bPointShop = true,
        price = 2600,
        vpos = Vector(0,0,69),
        name = "Warmcap"
    },
    -- SCUGS!!!
    ["slugcat"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "0",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Survivor"
    },
    ["slugcat monk"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.6,5,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "1",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Monk"
    },
    ["slugcat gourmand"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "2",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Gourmand"
    },
    ["slugcat arti"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "3",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Artificer"
    },
    ["slugcat rivulet"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "4",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat WetMouse"
    },
    ["slugcat speermaster"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "5",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Spearmaster"
    },
    ["slugcat saint"] = {
        model = "models/salat_port/slugcat_figure.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "spine",
        bodygroups = "6",
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,0),
        name = "Slugcat Saint"
    },
    ["pinklizard"] = {
        model = "models/zcity/lizard.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(2,1,-6),Angle(100,0,0),1},
        fempos = {Vector(1,0,-5),Angle(70,180,180),1},
        skin = 0,
        placement = "spine",
        bPointShop = true,
        price = 1, -- for those who notices :3
        vpos = Vector(0,0,0),
        name = "Pink Lizard"
    },
    ["headband"] = {
        model = "models/distac/headband.mdl",
        femmodel = "models/distac/headband_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 3500,
        vpos = Vector(0,0,69),
        name = "Headband"
    },
    ["occluder"] = {
        model = "models/distac/occluder.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1200,
        vpos = Vector(0,0,69),
        name = "Occluder"
    },
    ["shapka ushanka"] = {
        model = "models/distac/shapka_ushanka.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        price = 2300,
        vpos = Vector(0,0,69),
        name = "Ushanka"
    },
    ["cap gop"] = {
        model = "models/distac/cap_gop.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "head",
        bPointShop = true,
        price = 2300,
        vpos = Vector(0,0,69),
        name = "Cap God"
    },
    ["glasses viktor"] = {
        model = "models/distac/viktor.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        isdpoint = false,
        price = 1350,
        vpos = Vector(0,0,69),
        name = "Viktor Glasses"
    },
    ["glasses folding"] = {
        model = "models/distac/folding.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        norender = true,
        bonemerge = true,
        placement = "face",
        bPointShop = true,
        price = 1350,
        vpos = Vector(0,0,69),
        name = "Folding Glasses"
    },
    ["headband kamikadze"] = {
        model = "models/distac/headband.mdl",
        femmodel = "models/distac/headband_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        isdpoint = false,
        price = 750,
        vpos = Vector(0,0,69),
        name = "Kamikaze Headband"
    },
    ["mfdoom mask"] = {
        model = "models/distac/mfdoom.mdl",
        femmodel = "models/distac/mfdoom.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "MF Doom Mask"
    },
    ["anon mask"] = {
        model = "models/rawjesus/wear/anon.mdl",
        femmodel = "models/rawjesus/wear/anon.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-1.2,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 6500,
        vpos = Vector(0,0,0),
        name = "Anonymous Mask"
    },
    ["hockey mask"] = {
        model = "models/rawjesus/wear/jason.mdl",
        femmodel = "models/rawjesus/wear/jason.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.5,-0.8,0),Angle(180,100,90),1},
        fempos = {Vector(-0.5,-0.8,0),Angle(180,100,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Hockey Mask"
    },

    ["Lucha renchdedsex's mask"] = {
        model = "models/lucha/lucha.mdl",
        femmodel = "models/lucha/lucha.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        skin = 1,
        placement = "face",
        pointshopPreview = {auto = true, flex = true},
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Lucha renchdedsex's mask"
    },
	
	["Lucha red mask"] = {
        model = "models/lucha/lucha.mdl",
        femmodel = "models/lucha/lucha.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        fempos = {Vector(-25.9,-5.5,0),Angle(180,100,90),0.95},
        pointshopPreview = {auto = true, flex = true},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Lucha red mask"
    },

	["Lucha blue mask"] = {
        model = "models/lucha/lucha.mdl",
        femmodel = "models/lucha/lucha.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        skin = 2,
        pointshopPreview = {auto = true, flex = true},
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Lucha blue mask"
    },

	["Lucha black mask"] = {
        model = "models/lucha/lucha.mdl",
        femmodel = "models/lucha/lucha.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        skin = 3,
        pointshopPreview = {auto = true, flex = true},
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Lucha black mask"
    },
	
	["Scary haloween mask"] = {
        model = "models/hallowen/hallowen.mdl",
        femmodel = "models/hallowen/hallowen.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
        skin = 0,
        pointshopPreview = {auto = true, flex = true},
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Scary haloween mask"
    },

    ["Hood mask"] = {
        model = "models/balaclava_hood/balaclava_hood.mdl",
        femmodel = "models/balaclava_hood/balaclava_hood.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.7,-5.5,0),Angle(180,100,90),1},
        fempos = {Vector(-26,-5.4,0),Angle(180,100,90),0.95},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = false,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Hood mask"
    },

    ["Hood white mask"] = {
        model = "models/balaclava_hood/balaclava_hood.mdl",
        femmodel = "models/balaclava_hood/balaclava_hood.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-26.7,-5.5,0),Angle(180,100,90),1},
        fempos = {Vector(-26,-5.4,0),Angle(180,100,90),0.95},
        skin = 2,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = false,
        price = 7500,
        vpos = Vector(0,0,0),
        name = "Hood white mask"
    },

    ["hood"] = {
        model = "models/distac/kapishon2.mdl",
        femmodel = "models/distac/kapishon2.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = function(ent) 
            local colthes = IsValid(ent) and ent.GetNWString and ent:GetNWString("Colthesmain","normal") or ""
            --print(colthes == "cold" and 0 or 1)
            return colthes == "cold" and 0 or 1
        end,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        bPointShop = true,
        price = 850,
        vpos = Vector(0,0,69),
        name = "Hood"
    },

    ["christmas hat"] = {
        model = "models/grinchfox/head_wear/christmas_hat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,0.5,0),Angle(180,90,90),1},
        fempos = {Vector(0.2,0,0),Angle(180,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        name = "Christmas Hat"
    },
    ["cap deeper"] = {
        model = "models/grinchfox/head_wear/caphat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 7,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 850,
        vpos = Vector(0,0,5),
        name = "Deeper Cap"
    },

    ["cap nurse"] = {
        model = "models/grinchfox/head_wear/caphat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 9,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 750,
        vpos = Vector(0,0,5),
        name = "Nurse Cap"
    },

	["cap payot"] = {
        model = "models/grinchfox/head_wear/jewhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,5),
        name = "Payot Cap"
    },

	["burger king crown"] = {
        model = "models/roblox_assets/burger_king_crown.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(7.8,-0.1,0),Angle(-90,-80,-90),0.7},
        fempos = {Vector(7.8,-0.1,0),Angle(-90,-80,-90),0.7},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 99999999, -- не должно быть видно в поинтшопе типо нельзя купить (пасхалка)
        vpos = Vector(0,0,5),
        name = "Burger King Crown"
    },

    ["deal glasses"] = {
        model = "models/grinchfox/head_wear/dealglasses_fix.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.5,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.5,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 7331,
        vpos = Vector(0,0,5),
        name = "DealGlasses™"
    },

    ["cool glasses"] = {
        model = "models/grinchfox/head_wear/fancyglasses2.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 4000,
        vpos = Vector(0,0,5),
        name = "Fancy Glasses"
    },

    ["retro glasses"] = {
        model = "models/grinchfox/head_wear/fancyglasses3.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
        fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,5),
        name = "Retro Glasses"
    },

    ["tophat white"] = {
        model = "models/grinchfox/head_wear/tophat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
        fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
        skin = 1,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 1700,
        vpos = Vector(0,0,5),
        name = "White Tophat"
    },

    ["bandana groove"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 3,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1400,
        vpos = Vector(0,0,63),
        name = "Groove Bandana"
    },

    ["bandana crips"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 1,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1400,
        vpos = Vector(0,0,63),
        name = "Crips Bandana"
    },

    ["bandana white"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        isdpoint = false,
        price = 1100,
        vpos = Vector(0,0,63),
        name = "White Bandana"
    },

    ["bandana ghost"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 10,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,63),
        name = "Ghost Bandana"
    },

    ["bandana hm"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 11,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 1100,
        vpos = Vector(0,0,63),
        name = "HM Bandana"
    },

    ["bandana evil"] = {
        model = "models/fix/grinchfox/gangwrap/gangwrap.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-63.5,-12,0),Angle(90,10,0),1},
        fempos = {Vector(-63.6,-12,0),Angle(90,10,0),1},
        skin = 5,
        placement = "face",
        norender = true,
        bonemerge = false,
        bSetColor = false,
        bPointShop = true,
        price = 1500,
        vpos = Vector(0,0,63),
        name = "Evil (evil) Bandana"
    },

    ["baseball hub"] = {
        model = "models/grinchfox/head_wear/baseballhat.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1,0.4,0),Angle(0,-95,-90),1.1},
        fempos = {Vector(0,0.1,0),Angle(0,-95,-90),1},
        skin = 6,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = false,
        bPointShop = true,
        price = 1750,
        vpos = Vector(0,0,5),
        name = "Baseball Hat"
    },

    ["leather bag"] = {
        model = "models/distac/bag.mdl",
        femmodel = "models/distac/bagf.mdl",
        bone = "ValveBiped.Bip01_Spine4",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 1,
        norender = false,
        placement = "torso",
        bonemerge = true,
        bPointShop = true,
        isdpoint = false,
        price = 1550,
        vpos = Vector(0,0,42),
        name = "Leather Bag"
    },

    ["starglassis"] = {
        model = "models/distac/starglassis.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(-64,-0.3,0),Angle(180,90,90),1},
        fempos = {Vector(-64,-0.3,0),Angle(180,90,90),1},
        skin = 0,
        placement = "face",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,69),
        name = "Star Glassis"
    },

    ["cap brain"] = {
        model = "models/distac/cap_brain.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,1.5,0),Angle(180,80,90),1},
        fempos = {Vector(0.5,1.5,0),Angle(180,80,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,0),
        name = "Brain Cap"
    },

    ["coolPro headphone"] = {
        model = "models/distac/headphone.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2500,
        vpos = Vector(0,0,69),
        name = "Headphones coolPro"
    },

    ["medieval hood"] = {
        model = "models/distac/kapishom_m.mdl",
        femmodel = "models/distac/kapishom_f.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(0.2,4.8,0),Angle(0,90,90),1},
        fempos = {Vector(-1.2,3.5,0),Angle(0,90,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bSetColor = true,
        bPointShop = true,
        price = 950,
        vpos = Vector(0,0,69),
        name = "Medieval hood"
    },

    ["cap cool"] = {
        model = "models/distac/cap_brain.mdl",
        bone = "ValveBiped.Bip01_Head1",
        malepos = {Vector(1.5,1.5,0),Angle(180,80,90),1},
        fempos = {Vector(0.5,1.5,0),Angle(180,80,90),1},
        skin = 0,
        placement = "head",
        norender = true,
        bonemerge = true,
        bPointShop = true,
        price = 2000,
        vpos = Vector(0,0,0),
        SubMat = "distac/41/cap_fire",
        name = "Cool Cap"
    },
    --[[
    ["fedora_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 0,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Fedora"
            },

    ["fedora_line_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 1,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Fedora (Line)"
            },

    ["fedora_black_line_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 2,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Black Fedora (Line)"
            },

    ["earmuffs_colorable"] = {
                model = "models/griggs/headphones_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
                fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
                skin = 0,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1200,
                name = "Colorable Earmuffs"
            },

    ["scarf_colorable"] = {
                model = "models/griggs/scarf01.mdl",
				bone = "ValveBiped.Bip01_Spine4",
				malepos = {Vector(-18,8,0),Angle(0,75,90),1},
				fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
                skin = 0,
                norender = true,
				placement = "torso",	
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Scarf"
            },

    ["tophat_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat"
            },

    ["tophat_white_line_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat White (Line)"
            },

    ["tophat_black_line_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat Black (Line)"
            },

    ["fancyglasses_colorable"] = {
                model = "models/griggs/fancyglasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
				fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cool Glasses"
            },

    ["fancyglasses_nt_colorable"] = {
                model = "models/griggs/fancyglasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
				fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cool Glasses (Not Transparent)"
            },

    ["hat03_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Beanie"
            },

    ["hat03_line_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Stripped Beanie"
            },

    ["hat03_double_line_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1}, 
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Double-Stripped Beanie"
            },

    ["hat01_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cap"
            },

    ["hat01_white_line_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable White Cap (Line)"
            },

    ["hat01_black_line_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Black Cap (Line)"
            },

    ["aviators_black_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators Black Colorable"
            },

    ["aviators_white_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators White Colorable"
            },

    ["aviators_whole_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 2,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators Fully Colorable"
            },

    ["bigglasses_black_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses Black Colorable"
            },

    ["bigglasses_white_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses White Colorable"
            },

    ["bigglasses_whole_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 2,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses Fully Colorable"
            },

    ["balaclava_hood_colorable"] = {
                model = "models/griggs/balaclava_hood_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.7,-5.5,0),Angle(180,100,90),1},
				fempos = {Vector(-26,-5.4,0),Angle(180,100,90),0.95},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "Balaclava with Hood Colorable"
            },

    ["ringmaster_default_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 0,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Default)"
            },

    ["ringmaster_reverse_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 1,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Reverse)"
            },

    ["ringmaster_whole_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 2,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Whole)"
            },

    ["el_mano_default_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 3,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Default)"
            },

    ["el_mano_reverse_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 4,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Reverse)"
            },

    ["el_mano_whole_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 5,
                norender = true,
                pointshopPreview = {auto = true, flex = true},
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Whole)"
            },
    --error
    --]]
--[[
    ["2011x_cap"] = {
                model = "models/griggs/2011x_cap.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(5,0,0),Angle(0,-75,-90), 1.12},
				fempos = {Vector(4,-0.1,0),Angle(0,-75,-90), 1.125},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 2011,
                name = "X's Runaway Cap"
            },

    ["fedora_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 0,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Fedora"
            },

    ["fedora_line_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 1,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Fedora (Line)"
            },

    ["fedora_black_line_colorable"] = {
                model = "models/griggs/fedora_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(5.5, -0.2, 0), Angle(90, -80, -90), 1},
                fempos = {Vector(4.5, -0.2, 0), Angle(90, -75, -90), 1},
                skin = 2,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Black Fedora (Line)"
            },

    ["scarf_colorable"] = {
                model = "models/griggs/scarf01.mdl",
				bone = "ValveBiped.Bip01_Spine4",
				malepos = {Vector(-18,8,0),Angle(0,75,90),1},
				fempos = {Vector(-18,5.5,0),Angle(0,80,90),.9},
                skin = 0,
                norender = true,
				placement = "torso",	
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Scarf"
            },

    ["tophat_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat"
            },

    ["tophat_white_line_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat White (Line)"
            },

    ["tophat_black_line_colorable"] = {
                model = "models/griggs/tophat_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(2,0.4,0),Angle(0,-95,-90),1},
				fempos = {Vector(1,0.1,0),Angle(0,-95,-90),1},
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Tophat Black (Line)"
            },

    ["fancyglasses_colorable"] = {
                model = "models/griggs/fancyglasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
				fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cool Glasses"
            },

    ["fancyglasses_nt_colorable"] = {
                model = "models/griggs/fancyglasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(0.6,0.2,0),Angle(0,-90,-90),1.1},
				fempos = {Vector(-0.5,.2,0),Angle(0,-90,-90),1.1},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cool Glasses (Not Transparent)"
            },

    ["hat03_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Beanie"
            },

    ["hat03_line_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Stripped Beanie"
            },

    ["hat03_double_line_colorable"] = {
                model = "models/griggs/hat03_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(4,0,0),Angle(180,105,90),1},
				fempos = {Vector(3.8,0.2,0),Angle(180,105,90),1}, 
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Double-Stripped Beanie"
            },

    ["hat01_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Cap"
            },

    ["hat01_white_line_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 1,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable White Cap (Line)"
            },

    ["hat01_black_line_colorable"] = {
                model = "models/griggs/hat01_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(3.8,0.2,0),Angle(180,105,90),1},
				fempos = {Vector(3,0.2,0),Angle(180,105,90),1},
                skin = 2,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Colorable Black Cap (Line)"
            },

    ["earmuffs_colorable"] = {
                model = "models/griggs/headphones_colorable.mdl",
                bone = "ValveBiped.Bip01_Head1",
                malepos = {Vector(2.8,-1,0),Angle(180,105,90),1},
                fempos = {Vector(1.8,-1,0),Angle(180,105,90),0.95},
                skin = 0,
                norender = true,
                placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 1200,
                name = "Colorable Earmuffs"
            },

    ["aviators_black_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators Black Colorable"
            },

    ["aviators_white_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators White Colorable"
            },

    ["aviators_whole_colorable"] = {
                model = "models/griggs/aviators_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.8,0),Angle(180,100,90),0.95},
				fempos = {Vector(-0.2,-1,0),Angle(180,100,90),.9},
                skin = 2,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Aviators Fully Colorable"
            },

    ["bigglasses_black_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses Black Colorable"
            },

    ["bigglasses_white_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses White Colorable"
            },

    ["bigglasses_whole_colorable"] = {
                model = "models/griggs/big_glasses_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(.5,-0.6,0),Angle(180,100,90),1},
				fempos = {Vector(-0.2,-0.5,0),Angle(180,100,90),.95},
                skin = 2,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 1500,
                name = "Big Glasses Fully Colorable"
            },

    ["balaclava_hood_colorable"] = {
                model = "models/griggs/balaclava_hood_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.7,-5.5,0),Angle(180,100,90),1},
				fempos = {Vector(-26,-5.4,0),Angle(180,100,90),0.95},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "Balaclava with Hood Colorable"
            },

    ["ringmaster_default_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 0,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Default)"
            },

    ["ringmaster_reverse_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 1,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Reverse)"
            },

    ["ringmaster_whole_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 2,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The RingMaster Mask (Whole)"
            },

    ["el_mano_default_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 3,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Default)"
            },

    ["el_mano_reverse_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 4,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Reverse)"
            },

    ["el_mano_whole_colorable"] = {
                model = "models/griggs/ringster_mask_colorable.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
				fempos = {Vector(-26.5,-6,0),Angle(180,100,90),1},
                skin = 5,
                norender = true,
				placement = "face",
                bSetColor = true,
                bPointShop = true,
                price = 3500,
                name = "The El Mano Mask (Whole)"
            },

    ["2011x_cap"] = {
                model = "models/griggs/2011x_cap.mdl",
				bone = "ValveBiped.Bip01_Head1",
				malepos = {Vector(5,0,0),Angle(0,-75,-90), 1.12},
				fempos = {Vector(4,-0.1,0),Angle(0,-75,-90), 1.125},
                skin = 0,
                norender = true,
				placement = "head",
                bSetColor = true,
                bPointShop = true,
                price = 2011,
                name = "X's Runaway Cap"
            },
            --]]
}

local pointshopGloves = {
    {"Gloves", 0, 300},
    {"Gloves fingerless", 1, 300},
    {"Skilet", 0, 399, {[0] = "distac/gloves/sceletgloves"}},
    {"Skilet fingerless", 1, 399, {[0] = "distac/gloves/sceletgloves"}},
    {"Bikers", 2, 300},
    {"Bikers fingerless", 3, 300},
    {"Bikers gloves", 5, 300},
    {"Bikers wool", 6, 399},
    {"Wool fingerless", 7, 300},
    {"Mitten wool", 8, 300}
}

local function RegisterPointshopGloves(pointshop)
    for _, glove in ipairs(pointshopGloves) do
        local name, bodygroup, price, submaterials = glove[1], glove[2], glove[3], glove[4]
        local uid = "Standard_BodyGroups_" .. name

        pointshop:CreateItem(
            uid,
            string.NiceName(name),
            "models/zcity/gloves/degloves.mdl",
            tostring(bodygroup),
            0,
            Vector(0, 0, 0),
            price,
            false,
            submaterials or {}
        )

        local item = pointshop.Items[uid]
        if item then item.CATEGORY = "GLOVES" end
    end
end

hook.Add("Think","RemoveME",function()
    hg.PointShop = hg.PointShop or {}

    local PLUGIN = hg.PointShop

    -- Do not clear the table here: bodygroup items (including gloves) are
    -- registered by ZPointshopLoaded and may already be present.
    PLUGIN.Items = PLUGIN.Items or {}

    for k, acces in pairs(hg.Accessories) do
        if not acces.bPointShop then continue end

        PLUGIN:CreateItem( k, string.NiceName( acces.name or k ), acces.model, acces.bodygroups, acces.skin, acces.vpos or Vector(0,0,0), acces.price, acces.isdpoint, {[0] = acces.SubMat} )
        local pointshopItem = PLUGIN.Items[k]
        if pointshopItem then
            pointshopItem.PREVIEW = acces.pointshopPreview
        end
    end

    RegisterPointshopGloves(PLUGIN)

    hook.Remove( "Think", "RemoveME" )
end)