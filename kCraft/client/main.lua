breakCraftingNotifsAndMarkers = false

local function drawMarkerOnGround(x, y, z)
    DrawMarker(craftBuilderMarker.type, x, y, z - 0.98, craftBuilderMarker.dirX, craftBuilderMarker.dirY, craftBuilderMarker.dirZ, craftBuilderMarker.rotX, craftBuilderMarker.rotY, craftBuilderMarker.rotZ, craftBuilderMarker.scaleX, craftBuilderMarker.scaleY, craftBuilderMarker.scaleZ, craftBuilderMarker.red, craftBuilderMarker.green, craftBuilderMarker.blue, craftBuilderMarker.alpha, craftBuilderMarker.bobUpAndDown, craftBuilderMarker.faceCamera, craftBuilderMarker.p19, craftBuilderMarker.rotate, nil, false)
end

local function drawMarkerOnCoords(x, y, z)
    DrawMarker(craftBuilderMarker.type, x, y, z, craftBuilderMarker.dirX, craftBuilderMarker.dirY, craftBuilderMarker.dirZ, craftBuilderMarker.rotX, craftBuilderMarker.rotY, craftBuilderMarker.rotZ, craftBuilderMarker.scaleX, craftBuilderMarker.scaleY, craftBuilderMarker.scaleZ, craftBuilderMarker.red, craftBuilderMarker.green, craftBuilderMarker.blue, craftBuilderMarker.alpha, craftBuilderMarker.bobUpAndDown, craftBuilderMarker.faceCamera, craftBuilderMarker.p19, craftBuilderMarker.rotate, nil, false)
end

local function openMenu(dst, k)
    if IsControlJustPressed(0, 38) then
        if (dst <= 0.8) then
            breakCraftingNotifsAndMarkers = true
            craftBuilderFunction.fetchCraftingPlayerInv()
            Wait(100)
            craftBuilderFunction.openCraftingMenu(k)
        end
    end
end

CreateThread(function()
    if (GetCurrentResourceName() ~= "kCraft") then
        return error(("[%s] Resource name must be 'kCraft'"):format(GetCurrentResourceName()))
    end

    while json.encode(ESX.GetPlayerData()) == "[]" do
        Wait(0)
    end
    craftBuilderData.job = craftBuilderFunction.getJob()
    craftBuilderData.job2 = craftBuilderFunction.getJob2()
    while true do
        local sleep = 1500
        for k,v in pairs(craftBuilder) do
            local coords = GetEntityCoords(PlayerPedId())
            local dst = #(v.craftPos - coords)
            if dst < 3.0 then
                sleep = 0                
                if (v.jobRequired == nil) then
                    openMenu(dst, k)
                    if (not breakCraftingNotifsAndMarkers) then
                        craftBuilderFunction.drawFloatNotif(v.label, v.craftPos)
                        if (craftBuilderMarker.isOnGround) then
                            drawMarkerOnGround(v.craftPos.x, v.craftPos.y, v.craftPos.z)
                        else
                            drawMarkerOnCoords(v.craftPos.x, v.craftPos.y, v.craftPos.z)
                        end
                    end
                else
                    for i = 1, #v.jobRequired do                                      
                        if (craftBuilderData.job == v.jobRequired[i]) or (craftBuilderData.job2 == v.jobRequired[i]) then
                            openMenu(dst, k)
                            if (not breakCraftingNotifsAndMarkers) then
                                craftBuilderFunction.drawFloatNotif(v.label, v.craftPos)
                                if (craftBuilderMarker.isOnGround) then
                                    drawMarkerOnGround(v.craftPos.x, v.craftPos.y, v.craftPos.z)
                                else
                                    drawMarkerOnCoords(v.craftPos.x, v.craftPos.y, v.craftPos.z)                             
                                end
                            end
                        end
                    end
                end            
            end    
        end
        Wait(sleep)
    end
end)