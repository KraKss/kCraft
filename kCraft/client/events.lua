craftBuilderFunction.getJob = function()
    return ESX.GetPlayerData()[craftBuilderJob].name
end

craftBuilderFunction.getJob2 = function()
    return ESX.GetPlayerData()[craftBuilderJob2].name
end

craftBuilderFunction.drawFloatNotif = function(label, pos)
    ESX.ShowFloatingHelpNotification(("%s ~%s~%s"):format(craftOpenMenuText, craftBuilderColor, label), pos)
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function()
    SetTimeout(150, function()        
        craftBuilderData.job = craftBuilderFunction.getJob()
    end)
end)

RegisterNetEvent("esx:setJob2")
AddEventHandler("esx:setJob2", function()
    SetTimeout(150, function()
        craftBuilderData.job2 = craftBuilderFunction.getJob2()
    end)
end)