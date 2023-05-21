ESX.RegisterServerCallback("KraKss:craftBuilder:fetchPlayerInv", function(source, cb)
    local _src <const> = source
    local xPlayer <const> = ESX.GetPlayerFromId(_src)
    if (_src == 0) then return end
    if (not (xPlayer)) then return end
    cb(xPlayer.getInventory())
end)

RegisterNetEvent("KraKss:craftBuilder:craft", function(tableReceived, craft, amount)
    local _src <const> = source
    local xPlayer <const> = ESX.GetPlayerFromId(_src)
    local found, canBreak = false, false
    if (_src == 0) then return end
    if (not (xPlayer)) then return end
    for k in pairs(craftBuilder) do
        if (k == tableReceived) then
            found = true
            break
        end
    end
    if (not (found)) then craftBuilderServerFunction.kickPlayer(_src) return end
    
    local itemsToRemove = {}
    for i = 1, #craftBuilder[tableReceived].itemsCraft[craft].itemsRequired do
        local item = craftBuilder[tableReceived].itemsCraft[craft].itemsRequired[i]
        for k,v in pairs(xPlayer.getInventory()) do
            if (item.name == v.name) then                 
                if (v.count >= (item.quantityRequired * amount)) then
                    itemsToRemove[item.name] = {
                        name = item.name,
                        quantity = item.quantityRequired * amount
                    }
                else
                    canBreak = true                                       
                    return TriggerClientEvent("esx:showNotification", _src, ("[~r~ERROR~s~]\nVous n'avez pas assez de ~%s~%s~s~, il vous en manque %i"):format(craftBuilderColor, v.label, ((item.quantityRequired * amount) - v.count)))
                end
            end                        
        end
    end

    local itemsToCraft = {}
    for i = 1, #craftBuilder[tableReceived].itemsCraft[craft].itemsCrafted do
        local item = craftBuilder[tableReceived].itemsCraft[craft].itemsCrafted[i]
        for k,v in pairs(xPlayer.getInventory()) do
            if (item.name == v.name) then 
                itemsToCraft[item.name] = {
                    name = item.name,
                    quantity = item.quantityGiven,
                    label = item.label,
                    type = item.type
                }
            end                        
        end
    end

    if (canBreak) then return end

    local totalPlayerWeight = 0
    for k,v in pairs(itemsToRemove) do
        totalPlayerWeight = (totalPlayerWeight + (xPlayer.getInventoryItem(v.name).weight * v.quantity)) -- Sum total weight of items to remove
    end

    local itemsCraftedWeight = 0
    for k,v in pairs(itemsToCraft) do
        if (v.type == "item") then
            itemsCraftedWeight = (itemsCraftedWeight + (xPlayer.getInventoryItem(v.name).weight * v.quantity)) -- Sum total weight of all crafted items
        end
    end

    if (((xPlayer.getWeight() - totalPlayerWeight) + itemsCraftedWeight) <= (craftBuilderServerFunction.fetchMaxWeight())) then
        if (craftBuilder[tableReceived].itemsCraft[craft].craftCost ~= nil) then -- money != nil
            if (tonumber(xPlayer.getAccount(craftAccountMoney).money) < tonumber(craftBuilder[tableReceived].itemsCraft[craft].craftCost)) then -- check if has enough money
                return TriggerClientEvent("esx:showNotification", _src, "[~r~ERROR~s~]\nVous n'avez pas assez d'argent")
            end

            xPlayer.removeAccountMoney(craftAccountMoney, tonumber(craftBuilder[tableReceived].itemsCraft[craft].craftCost))
        end 

        for k,v in pairs(itemsToRemove) do
            xPlayer.removeInventoryItem(v.name, v.quantity)
        end

        for k,v in pairs(itemsToCraft) do
            if (v.type == "item") then
                xPlayer.addInventoryItem(v.name, (v.quantity * amount))
                craftBuilderServerFunction.craftNotif(_src, v.label, (v.quantity * amount))
                Wait(1000)
            elseif (v.type == "weapon") then
                xPlayer.addWeapon(v.name, (v.quantity * amount))
                craftBuilderServerFunction.craftWeaponNotif(_src, v.label, (v.quantity * amount))
                Wait(1000)
            else
                print(("[^4%s^7] %s type of item given wasn't specified in config file"):format(GetCurrentResourceName()))
            end
        end
    else
        return TriggerClientEvent("esx:showNotification", _src, "[~r~ERROR~s~]\nVous n'avez plus assez de place dans votre inventaire")
    end
end)

print(("\n[^6%s^0] resource started succesfully\nMade by ^4KraKss#8531^0 for ^1VIBE-DEV^0\n"):format(GetCurrentResourceName()))