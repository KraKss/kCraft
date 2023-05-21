craftBuilder = {
    ["Cockatoos"] = {
        label = "Cocktails", -- Label afficher après craftOpenMenuText
        jobRequired = {"vigneron", "vagos"}, -- nil ou {jobX, jobY, jobZ, ballas, police, ....}
        craftPos = vector3(-440.93041992188, -35.858558654785, 46.195613861084),
        itemsCraft = {
            [1] = {
                label = "Mojito", -- Label du craft dans le bouton du menu 
                craftCost = 9, -- Prix du craft // valeur ou nil pour désactiver
                itemsRequired = {
                    {name = "green_citrus", label = "Citron Vert", quantityRequired = 1},
                    {name = "alcohol_bottle", label = "Bouteille d'alcool", quantityRequired = 1},
                    {name = "mint_leaf", label = "Feuille de menthe", quantityRequired = 2},
                },
                itemsCrafted = {
                    {name = "mint_mojito", label = "Mojito à la menthe", quantityGiven = 1, type = "item"},
                    -- {name = "", label = "", quantityGiven = 1, type = "item"}, --  item ou weapon pour le type (item pour armes en item et weapon pour pas armes item)
                },
            },
            [2] = {
                label = "Pisco Punch",
                craftCost = nil,
                itemsRequired = {
                    {name = "alcohol_bottle", label = "Bouteille d'alcool", quantityRequired = 1},
                    {name = "water", label = "Bouteille d'eau", quantityRequired = 2},
                },
                itemsCrafted = {
                    {name = "bread", label = "Pain", quantityGiven = 1, type = "item"},
                },
            },
        },
        animHeading = 263.8668212890625, -- Heading que le joueur va prendre en faisant l'anim
        animDuration = 8, -- Temps en secondes pour l'anim
        animDict = "anim@gangops@facility@servers@bodysearch@", -- dictionnaire anim
        anim = "player_search", -- nom animation
    },
    -- ["Cockatoos"] = {
    --     label = "cocktails", -- Label afficher après craftOpenMenuText
    --     jobRequired = nil, -- nil ou {jobX, jobY, jobZ, ...}
    --     craftPos = vector3(0, 0, 0),
    --     itemsCraft = {
    --         [1] = {
    --             label = "Mojito",
    --             craftCost = 0, -- Prix du craft
    --             itemsRequired = {
    --                 {name = "green_citrus", label = "Citron Vert", quantityRequired = 1},
    --                 {name = "alcohol_bottle", label = "Bouteille d'alcool", quantityRequired = 1},
    --                 {name = "mint_leaf", label = "Feuille de menthe", quantityRequired = 2},
    --             },
    --             itemsCrafted = {
    --                 {name = "nom_db", label = "Mojito à la menthe", quantityGiven = 1, type = "item"}, --  item ou weapon pour le type (item pour armes en item et weapon pour pas armes item)
    --                 {name = "bread", label = "Pain", quantityGiven = 1, type = "item"},
    --             },
    --         },
    --         [2] = {
    --             label = "label",
    --             craftCost = 0,
    --             itemsRequired = {
    --                 {name = "alcohol_bottle", label = "Bouteille d'alcool", quantityRequired = 1},
    --                 {name = "water", label = "Bouteille d'eau", quantityRequired = 2},
    --             },
    --             itemsCrafted = {
    --                 {name = "bread", label = "Pain", quantityGiven = 1, type = "item"},
    --             },
    --         },
    --     },
    --     animHeading = 250, -- Heading que le joueur va prendre en faisant l'anim
    --     animDuration = 5, -- Temps en secondes pour l'anim
    --     animDict = "anim@amb@nightclub@dancers@solomun_entourage@",
    --     anim = "mi_dance_facedj_17_v1_female^1",
    -- },
}

craftBuilderESX = "esx:getSharedObject" 
craftBuilderColor = "b" -- couleur du texte du script r / g / b / ...
craftBuilderJob = "job"
craftBuilderJob2 = "job2" -- job2, Orga, ...
craftOpenMenuText = "Appuyez sur [~b~E~s~] pour accéder à la fabrication de" -- Texte afficher pour ouvrir le menu
craftIsInvincible = true -- Mettre le joueur invincible pendant qu'il est dans le menu
craftAccountMoney = "money" -- money, bank, dirtycash, cash, ... / Money utilisée pour payer le craft
craftMaxLimit = 2^32 -- Nombre de craft maximum possible en une fois (le + élevé possible est conseiller)  

-- ↓ Markers ↓
--DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate)

craftBuilderMarker = {
    isOnGround = true, --Met le marqueur au sol
    type = 23,
    dirX = 0.0,
    dirY = 0.0,
    dirZ = 0.0,
    rotX = 0.0,
    rotY = 180.0,
    rotZ = 0.0,
    scaleX = 0.7,
    scaleY = 0.7,
    scaleZ = 0.7,
    red = 255,
    green = 255,
    blue = 255,
    alpha = 200,
    bobUpAndDown = false,
    faceCamera = false,
    p19 = 2,
    rotate = nil,
}