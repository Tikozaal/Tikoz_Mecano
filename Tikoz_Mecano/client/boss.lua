ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Tikozaal = {}
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

function RefreshMecanoMoney()
	ESX.TriggerServerCallback('Tikoz:getSocietyMoney', function(money)
		UpdateMecanoMoney(money)
	end)
end

function UpdateMecanoMoney(money)
    MecanoFermier = ESX.Math.GroupDigits(money)
end

function Keyboardput(TextEntry, ExampleText, MaxStringLength) 
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function depotargentmechanic()
    local amount = Keyboardput("Montant", "", 25)
    amount = tonumber(amount)
    if amount == nil then
        ESX.ShowAdvancedNotification('Banque societé', "~b~Benny's", "Vous avez pas assez ~r~d'argent", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerServerEvent("Tikoz:mecanodepotentreprise", amount)
    end
end

function retraitargentmechanic()
    local amount = Keyboardput("Montant", "", 25)
    amount = tonumber(amount)
    if amount == nil then
        ESX.ShowAdvancedNotification('Banque societé', "~b~Benny's", "Vous avez pas assez ~r~d'argent", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerServerEvent("Tikoz:mecanoRetraitEntreprise", amount)
    end
end

menuboss = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Benny's"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            ESX.TriggerServerCallback("Tikoz:mecanoArgentEntreprise", function(compteentreprise) 

                if btn.name == "Compte en banque" then
                    for i=1, #compteentreprise, 1 do 
                        menuboss.Menu["Compte en banque"].b = {}
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "Déposé de l'argent", ask = "", askX = true})
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "Retiré de l'argent", ask = "", askX = true})
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "~b~Compte bancaire ~s~:", ask = "~g~"..compteentreprise[i].money.."$", askX = true})
                    end
                    OpenMenu('Compte en banque')
                end

            end, args)

            if btn.name == "Déposé de l'argent" then
                depotargentmechanic()
                OpenMenu('Menu :')
            elseif btn.name == "Retiré de l'argent" then
                retraitargentmechanic()
                OpenMenu('Menu :')

            end
        
            ESX.TriggerServerCallback('Tikoz:mechanicSalaire', function(salairemechanic) 
               

                if btn.name == "Salaire employé" then
                    menuboss.Menu["Salaire"].b = {}
                    for i=1, #salairemechanic, 1 do
                        if salairemechanic[i].job_name == "mechanic" then
                            table.insert(menuboss.Menu["Salaire"].b, { name = salairemechanic[i].label, ask = "~g~"..salairemechanic[i].salary.."$", askX = true})
                        end
                    end
                    OpenMenu('Salaire')
                end

                for i=1, #salairemechanic, 1 do
                    if btn.name == salairemechanic[i].label then
                        if salairemechanic[i].job_name == "mechanic" then
                            local amount = Keyboardput("Quelle est le nouveau salaire ? ", "", 15)
                            local label = salairemechanic[i].label
                            local id = salairemechanic[i].id
                            TriggerServerEvent('Tikoz:mechanicNouveauSalaire', id, label, amount)
                            OpenMenu("Menu :")
                            return
                        end
                    end
                end

            end, args)

        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
                {name = "Compte en banque", ask = ">", askX = true},
                {name = "Salaire employé", ask = ">", askX = true},
            }
        },
        ["Compte en banque"] = {
            b = {
            }
        },
        ["Salaire"] = {
            b = {
            }
        },
        ["Liste des employés"] = {
            b = {
            }
        },
    }
}

Citizen.CreateThread(function()

    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Boss
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job.name == "mechanic" then

            ESX.ShowHelpNotification('Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~menu')
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menuboss)
            end

        else 
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)