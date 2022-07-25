ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

local menugarage = {
    Base= { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Garage"},
    Data = { currentMenu = "Menu"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            if btn.name == "Dépanneuse" then
                carremorque()
                CloseMenu()
            elseif btn.name == "Plateau" then
                plateaucar()
                CloseMenu()
            end
        end,
},
    Menu = {
        ["Menu"] = {
            b = {
                {name = "Dépanneuse", ask = "", askX = true},
                {name = "Plateau", ask = "", askX = true},
            }
        }
    }
}

Citizen.CreateThread(function()

    while true do 

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Garage
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job.name == "mechanic" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~garage")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menugarage)
            end
        else 
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

function carremorque()

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local pi = "towtruck"
    local po = GetHashKey(pi)
    RequestModel(po) 
    while not HasModelLoaded(po) do Citizen.Wait(0) end
    local pipo = CreateVehicle(po, Config.Pos.SpawnVehicule, true, false)
    TaskWarpPedIntoVehicle(ped, pipo, -1)

    Citizen.CreateThread(function()
    
        while true do 

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local menu = Config.Pos.DeleteVehicle
            local dist = #(pos - menu)

            if dist <= 2 and ESX.PlayerData.job.name == "mechanic" then
            
                ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour rangé le ~b~véhicule")
                DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)
 
                if IsControlJustPressed(1, 51) then
                    DeleteVehicle(pipo)
                    return
                end

            end

            Citizen.Wait(0)
        end
    end)

end

function plateaucar()

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local pi = "flatbed"
    local po = GetHashKey(pi)
    RequestModel(po)
    while not HasModelLoaded(po) do Citizen.Wait(0) end
    local pipo = CreateVehicle(po, Config.Pos.SpawnVehicule, true, false)
    TaskWarpPedIntoVehicle(ped, pipo, -1)

    Citizen.CreateThread(function()
    
        while true do 

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local menu = Config.Pos.DeleteVehicle
            local dist = #(pos - menu)

            if dist <= 2 and ESX.PlayerData.job.name == "mechanic" then

                ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour rangé le ~b~véhicule")
                DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

                if IsControlJustPressed(1, 51) then
                    DeleteVehicle(pipo)
                    return
                end
            else 
                Citizen.Wait(1000)
            end
            Citizen.Wait(0)
        end
    end)

end

