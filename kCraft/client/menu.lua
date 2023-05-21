local pInv, qtyRequired, itemCount, isDisplayed, isPlaying, craftSelected = {}, 0, 0, false, false, nil
local SliderPanel = {
    Minimum = 0,
    Index = 0,
}

craftBuilderFunction.getMaximumQuantity = function(index) -- 3H pour cet algo de merde
    local maxCrafting = craftMaxLimit -- Quantité max de base

    for i = 1, #craftBuilder[index].itemsCraft[craftSelected].itemsRequired do
        local item = craftBuilder[index].itemsCraft[craftSelected].itemsRequired[i]       
        for k,v in pairs(pInv) do
            if (item.name == v.name) then
                if (maxCrafting > math.floor(math.min(v.count/item.quantityRequired))) then
                    maxCrafting = math.floor(math.min(v.count/item.quantityRequired))
                end
            end
        end
    end     

    return maxCrafting
end

craftBuilderFunction.isFree = function(table)
    if (tonumber(craftBuilder[table].itemsCraft[craftSelected].craftCost) == 0) then
        return ("Coût de fabrication : ~g~Gratuit")
    end
    return ("Coût de fabrication : ~g~%i$"):format(tonumber(craftBuilder[table].itemsCraft[craftSelected].craftCost))
end

craftBuilderFunction.PlayAnim = function(heading, duration, animDict, anim, table)
    if tonumber(heading) == nil or type(heading) ~= "number" then
        print(("[^4%s^1] heading cannot be nil and must be a number"):format(GetCurrentResourceName()))
        return
    end
    if tonumber(duration) == nil or type(duration) ~= "number" then
        print(("[^4%s^1] duration cannot be nil and must be a number"):format(GetCurrentResourceName()))
        return
    end
    if tostring(animDict) == nil or type(animDict) ~= "string" then
        print(("[^4%s^1] animDict cannot be nil and must be a string"):format(GetCurrentResourceName()))
        return
    end
    if tostring(anim) == nil or type(anim) ~= "string" then
        print(("[^4%s^1] anim cannot be nil and must be a string"):format(GetCurrentResourceName()))
        return
    end
    isPlaying = true
    local totalTime = 0
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityHeading(PlayerPedId(), heading)
    if (not IsEntityPlayingAnim(PlayerPedId(), animDict, anim, 3)) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), animDict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
        Wait(1000)
        while IsEntityPlayingAnim(PlayerPedId(), animDict, anim, 3) do                                
            totalTime = totalTime + 0.01   
            if (totalTime > duration) then
                FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasksImmediately(PlayerPedId())
                break
            end
            Wait(0)                       
        end
    end
    TriggerServerEvent("KraKss:craftBuilder:craft", table, craftSelected, SliderPanel.Index)
    breakCraftingNotifsAndMarkers = false
    SliderPanel.Index = 0
    isPlaying = false
end

craftBuilderFunction.fetchCraftingPlayerInv = function()
    ESX.TriggerServerCallback("KraKss:craftBuilder:fetchPlayerInv", function(inv)
        pInv = inv
    end)
end

craftBuilderFunction.openCraftingMenu = function(table)
    if GetCurrentResourceName() ~= "kCraft" then
        return error(("[%s] Resource name must be 'kCraft'"):format(GetCurrentResourceName()))
    end

    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        return
    end

    if (active) then
        return
    end

    if (isPlaying) then
        return
    end

    local mainMenu <const> = RageUI.CreateMenu("", ("%s"):format(craftBuilder[table].label)) 
    local subMenu <const> = RageUI.CreateSubMenu(mainMenu, "", ("%s"):format(craftBuilder[table].label))
    mainMenu.Closed = function() active = false end
    mainMenu:DisplayPageCounter(false)
    mainMenu.Display.Glare = false
    subMenu.EnableMouse = false

    active = true
    RageUI.Visible(mainMenu, true)

    CreateThread(function()
        while (active) do
            if (craftIsInvincible) then
                SetEntityInvincible(PlayerPedId(), true)
            end
            FreezeEntityPosition(PlayerPedId(), true)            
            RageUI.IsVisible(mainMenu, function()
                qtyRequired, itemCount, isDisplayed, craftSelected = 0, 0, false, nil
                for k,v in pairs(craftBuilder[table].itemsCraft) do
                    RageUI.Button(("%s"):format(v.label), nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                        onSelected = function()
                            craftBuilderFunction.fetchCraftingPlayerInv()
                            craftSelected = k
                        end
                    }, subMenu)
                end
            end)

            RageUI.IsVisible(subMenu, function()        
                if (craftSelected) then
                    if (isDisplayed) then
                        RageUI.CraftBouton(("Quantité requise : ~%s~%s"):format(craftBuilderColor, qtyRequired))                 
                        RageUI.CraftBouton(("En votre possession : ~%s~%i"):format(craftBuilderColor, itemCount))
                    end
                    if (not isDisplayed) then
                        RageUI.CraftBouton((#craftBuilder[table].itemsCraft[craftSelected].itemsCrafted > 1) and ("~h~• Produits fabriqués :") or ("~h~• Produit fabriqué :"))
                        for k,v in pairs(craftBuilder[table].itemsCraft[craftSelected].itemsCrafted) do                    
                            RageUI.CraftBouton(("%s"):format(v.label))
                            RageUI.CraftBouton(("%s : ~%s~%i"):format("Quantité produite", craftBuilderColor, (v.quantityGiven * SliderPanel.Index)))
                            if #craftBuilder[table].itemsCraft[craftSelected].itemsCrafted > 1 then
                                RageUI.CraftLigne()  
                            end
                        end
                        if (tonumber(craftBuilder[table].itemsCraft[craftSelected].craftCost) ~= nil) then
                            if #craftBuilder[table].itemsCraft[craftSelected].itemsCrafted > 1 then                           
                                RageUI.CraftBouton(("• %s"):format(craftBuilderFunction.isFree(table)))                                
                            else
                                RageUI.CraftLigne()
                                RageUI.CraftBouton(("• %s"):format(craftBuilderFunction.isFree(table)))                               
                            end
                        end
                    end

                    for i = 1, #craftBuilder[table].itemsCraft[craftSelected].itemsRequired do
                        local item = craftBuilder[table].itemsCraft[craftSelected].itemsRequired[i]
                        for k,v in pairs(pInv) do
                            if (v.name == item.name) then
                                RageUI.Button(("%s"):format(item.label), nil, {LeftBadge = RageUI.BadgeStyle.Star}, true, {                  
                                    onActive = function()
                                        isDisplayed = true
                                        qtyRequired = item.quantityRequired
                                        itemCount = v.count
                                        subMenu.EnableMouse = false
                                    end
                                })
                            end
                        end         
                    end      

                    RageUI.Line()

                    RageUI.Button("Fabrication", nil, {LeftBadge = RageUI.BadgeStyle.Star, RightBadge = RageUI.BadgeStyle.Tick}, (craftBuilderFunction.getMaximumQuantity(table) > 0), {                    
                        onActive = function()            
                            isDisplayed = false
                            subMenu.EnableMouse = true
                        end,
                        onSelected = function()
                            if (SliderPanel.Index > 0) then                                                                                            
                                active = false
                                craftBuilderFunction.PlayAnim(craftBuilder[table].animHeading, craftBuilder[table].animDuration, craftBuilder[table].animDict, craftBuilder[table].anim, table)                                
                            end                    
                        end
                    })
                    if (craftBuilderFunction.getMaximumQuantity(table) > 0) then
                        RageUI.SliderPanel(SliderPanel.Index, SliderPanel.Minimum, ("Quantité à fabriquer : ~%s~%i"):format(craftBuilderColor, SliderPanel.Index), craftBuilderFunction.getMaximumQuantity(table), {
                            onSliderChange = function(Index)
                                SliderPanel.Index = Index
                            end
                        }, #craftBuilder[table].itemsCraft[craftSelected].itemsRequired + 1)
                    end
                end
            end)

            if (not (active)) then
                breakCraftingNotifsAndMarkers = false
                FreezeEntityPosition(PlayerPedId(), false)
                if (craftIsInvincible) then
                    SetEntityInvincible(PlayerPedId(), false)
                end
            end
            Wait(0)
        end
    end)
end