local ESX = exports["es_extended"]:getSharedObject()
local isWorking, hasDelivered, activeTruck, activeTrailer = false, false, nil, nil
local depotBlip, routeBlip, truckerNPC = nil, nil, nil
local Lang = Config.Translate[Config.Language]

function SendNotify(msg, type)
    SendNUIMessage({
        type = "notify",
        message = msg,
        ntype = type or "info"
    })
end

function ShowHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Citizen.CreateThread(function()
    while Config == nil or Config.DepotLocation == nil do Wait(100) end
    depotBlip = AddBlipForCoord(Config.DepotLocation)
    SetBlipSprite(depotBlip, 473)
    SetBlipScale(depotBlip, 0.8)
    SetBlipColour(depotBlip, 47)
    SetBlipAsShortRange(depotBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Trucking Depot")
    EndTextCommandSetBlipName(depotBlip)

    local model = `s_m_m_trucker_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        if #(pCoords - Config.DepotLocation) < 100.0 then
            if not DoesEntityExist(truckerNPC) then
                truckerNPC = CreatePed(4, model, Config.DepotLocation.x, Config.DepotLocation.y, Config.DepotLocation.z - 1.0, Config.NPCHeading, false, true)
                SetEntityInvincible(truckerNPC, true)
                FreezeEntityPosition(truckerNPC, true)
                SetBlockingOfNonTemporaryEvents(truckerNPC, true)
                TaskStartScenarioInPlace(truckerNPC, "WORLD_HUMAN_CLIPBOARD", 0, true)
            end
        end
        Wait(5000)
    end
end)

function UpdateRouteBlip(coords)
    if routeBlip then RemoveBlip(routeBlip) end
    routeBlip = AddBlipForCoord(coords)
    SetBlipSprite(routeBlip, 1)
    SetBlipColour(routeBlip, 5)
    SetBlipRoute(routeBlip, true)
end

function StartJob(index, spot)
    local job = Config.Jobs[index]
    DoScreenFadeOut(500) Wait(600)
    ESX.Game.SpawnVehicle(job.model, spot.coords, spot.heading, function(truck)
        activeTruck = truck
        SetVehicleNumberPlateText(truck, "TRUCK")
        TaskWarpPedIntoVehicle(PlayerPedId(), truck, -1)
        local trailerPos = GetOffsetFromEntityInWorldCoords(truck, 0.0, -10.0, 0.0)
        ESX.Game.SpawnVehicle(job.trailer, trailerPos, spot.heading, function(trailer)
            activeTrailer = trailer
            AttachVehicleToTrailer(truck, trailer, 1.1)
            isWorking, hasDelivered = true, false
            SendNotify(Lang.n_start, "info")
            local goal = Config.DeliveryPoints[math.random(#Config.DeliveryPoints)]
            UpdateRouteBlip(goal)
            DoScreenFadeIn(1000)
            
            Citizen.CreateThread(function()
                while isWorking do
                    local sleep = 1000
                    local pCoords = GetEntityCoords(PlayerPedId())
                    local target = hasDelivered and Config.ReturnLocation or goal
                    local dist = #(pCoords - target)
                    if dist < 50.0 then
                        sleep = 0
                        DrawMarker(1, target.x, target.y, target.z - 1.1, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 0, 122, 255, 100, false, true, 2)
                        if dist < 6.0 then
                            ShowHelp(Lang.help_open)
                            if IsControlJustReleased(0, 38) then
                                if not hasDelivered then
                                    local hasT, tH = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                                    if hasT and tH == activeTrailer then
                                        TriggerServerEvent('truckerJob:server:reward', index, (1000.0 - GetVehicleBodyHealth(activeTrailer)) / 10)
                                        DeleteVehicle(activeTrailer)
                                        hasDelivered = true
                                        UpdateRouteBlip(Config.ReturnLocation)
                                        SendNotify(Lang.n_delivered, "success")
                                    else
                                        SendNotify(Lang.n_error_trailer, "error")
                                    end
                                else
                                    DeleteVehicle(activeTruck)
                                    isWorking = false
                                    if routeBlip then RemoveBlip(routeBlip) end
                                    SendNotify(Lang.n_finished, "info")
                                    break
                                end
                            end
                        end
                    end
                    Wait(sleep)
                end
            end)
        end)
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if #(GetEntityCoords(PlayerPedId()) - Config.DepotLocation) < 2.5 then
            ShowHelp(Lang.help_open)
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('truckerJob:getPlayerData', function(stats)
                    SetNuiFocus(true, true)
                    SendNUIMessage({type = "openUI", stats = stats, jobs = Config.Jobs, playerName = GetPlayerName(PlayerId()), lang = Lang})
                end)
            end
        end
    end
end)

RegisterNUICallback('close', function() SetNuiFocus(false, false) end)
RegisterNUICallback('selectJob', function(data)
    SetNuiFocus(false, false)
    local spot = nil
    for _, s in ipairs(Config.SpawnPoints) do
        if not IsPositionOccupied(s.coords.x, s.coords.y, s.coords.z, 5.0, false, true, true, false, false, 0, false) then
            spot = s break
        end
    end
    if spot then StartJob(data.index + 1, spot) else SendNotify(Lang.n_error_parking, "error") end
end)

RegisterNetEvent('truckerJob:client:notify')
AddEventHandler('truckerJob:client:notify', function(msg, type) SendNotify(msg, type) end)