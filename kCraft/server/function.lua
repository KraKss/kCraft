craftBuilderServerFunction.kickPlayer = function(player) -- Pas changer le nom de fonction
    local _src <const> = player
    DropPlayer(_src, ("[%s] Tentative de cheat ou désync avec le serveur"):format(GetCurrentResourceName())) --Si vous voulez mettre votre ban
end

craftBuilderServerFunction.fetchMaxWeight = function()
    return ESX.GetConfig().MaxWeight -- ESX.GetConfig().MaxWeight récupère tout seul le poids max ou le nombre que vous voulez 
end

craftBuilderServerFunction.craftNotif = function(source, label, quantity)
    local _src <const> = source 
    TriggerClientEvent("esx:showNotification", _src, ("[~g~INFO~s~]\nVous avez fabriqué ~y~%ix ~%s~%s"):format(quantity, craftBuilderColor, label))
end

craftBuilderServerFunction.craftWeaponNotif = function(source, label, quantity)
    local _src <const> = source 
    TriggerClientEvent("esx:showNotification", _src, ("[~g~INFO~s~]\nVous avez fabriqué ~%s~%s~s~ avec ~r~%i balles"):format(craftBuilderColor, label, quantity))
end