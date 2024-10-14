local isInJail, unjail = false, false
local jailTime, fastTimer = 0, 0
ESX = exports["es_extended"]:getSharedObject()

local xPlayer = PlayerPedId(-1)
local ped = GetPlayerPed(PlayerPedId())

local mainMenu = RageUI.CreateMenu("~r~Jail", "~r~Has estado en la cárcel")
mainMenu.Closable = false
mainMenu.Closed = function()
    touche = false
end

RegisterNetEvent('esx_jail:jailPlayer')
AddEventHandler('esx_jail:jailPlayer', function(_jailTime, message, src)
    jailTime = _jailTime
    msg = message
    lol = src
    local playerPed = PlayerPedId()

    -- Cambiar el modelo del jugador a un ped específico definido en Config
    local jailModel = Config.JailPedModel  -- Asegúrate de definir esto en tu Config.lua
    RequestModel(jailModel)
    while not HasModelLoaded(jailModel) do
        Wait(500)
    end

    SetPlayerModel(PlayerId(), jailModel) -- Cambiar el modelo del jugador

    SetPedArmour(playerPed, 0)
    ESX.Game.Teleport(playerPed, Config.JailLocation)
    isInJail, unjail = true, false

    touche = true 
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
        while touche do 
            if jailTime > 0 and isInJail then
                if fastTimer < 0 then
                    fastTimer = jailTime 
                end

                fastTimer = fastTimer - 0.007666666 

                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Autor del jail :", nil, {RightLabel = lol}, true, {})
                    RageUI.Button("Tiempo", nil, {RightLabel = ESX.Math.Round(jailTime / 60).." Minutos"}, true, {})
                    RageUI.Line(0, 0, 0, 250)
                    RageUI.Button("Tiempo restante :", nil, {RightLabel = ESX.Math.Round(fastTimer).." Segundos"}, true, {})
                    if message == true then
                        RageUI.Separator("~r~Te has desconectado")
                    else
                        RageUI.Button("Razón de tu encarcelamiento :", nil, {RightLabel = msg }, true, {})
                    end
                end)
            end
            Wait(0)

            -- Deshabilitar controles
            DisableControlAction(2, 37, true) -- Select Weapon
            DisableControlAction(0, 25, true) -- Input Aim
            DisableControlAction(0, 24, true) -- Input Attack
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
        end
    end)

    while not unjail do
        playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            ClearPedTasksImmediately(playerPed)
        end

        Citizen.Wait(0)

        -- Verificar si el jugador intenta escapar
        if #(GetEntityCoords(playerPed) - Config.JailLocation) > 10 then
            ESX.Game.Teleport(playerPed, Config.JailLocation)
        end
    end

    ESX.Game.Teleport(playerPed, Config.UnJailLocation)
    isInJail = false

    RageUI.CloseAll()
    touche = false

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

RegisterNetEvent('esx_jail:unjailPlayer')
AddEventHandler('esx_jail:unjailPlayer', function()
    unjail, jailTime, fastTimer = true, 0, 0
end)

AddEventHandler('playerSpawned', function(spawn)
    if isInJail then
        ESX.Game.Teleport(PlayerPedId(), Config.JailLocation)
    end
end)