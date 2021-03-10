ESX = nil
local BerryCoords  = vector3(180.71,-1638.29,28.30)
local CarSpawnCoords = vector3(173.47,-1648,28.62)
local CarSpawnHeading = 103.33
local BerryHash = GetHashKey('g_m_m_chicold_01')
local BerryCarHash = GetHashKey('specter2')
local carPlate = 0
local Berry = 0
local timerStarted = false
local chillZone = false
local delivered = false

local deliveryPoint = {
    vector3(-778.25,-184.95,35.30),
    vector3(374.48,796.98,186.29),
    vector3(1315.16,-583.61,74.05),
    vector3(-1077.21,466.07,76.70),
    vector3(-1295.15,-1617.44,3.10),
    vector3(-492.04,-2791.02,5.1),
    vector3(136.03,275.05,108.98),
    vector3(-1281.59,302.65,63.98),
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if not HasModelLoaded(BerryHash) then
        RequestModel(BerryHash)
        Citizen.Wait(200)
    end
    Berry = CreatePed( PED_TYPE_GANG_CHINESE_JAPANESE , BerryHash, BerryCoords, 150.6, false, true )
    FreezeEntityPosition(Berry, true)
    SetEntityInvincible(Berry, true)
    SetBlockingOfNonTemporaryEvents(Berry, true)
end)

Citizen.CreateThread(function()
    local wait = 100
    local pressed = false
    local edabaya = false
    while true do
        Citizen.Wait(wait)
        local PlayerPed = GetPlayerPed(-1)
        local PlayerCoords = GetEntityCoords(PlayerPed)
        local distance = GetDistanceBetweenCoords(BerryCoords, PlayerCoords)
        if distance < 10 then 
            wait = 5
            if distance < 2 then
                if not edabaya then
                    DrawText3Deheh(BerryCoords.x, BerryCoords.y, BerryCoords.z+1.0, '~g~[E]~w~ - to Talk')
                end
                if IsControlJustPressed(1,46) and not pressed then
                    edabaya, pressed = true , true
                    exports['mythic_progbar']:Progress({
                        name = "Talking to Berry",
                        duration = 15000,
                        label = "Talking to Berry",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "misscarsteal4@actor",
                            anim = "actor_berating_loop",
                            flags = 49,
                        }
                    }, function(status)
                        if not status then
                            edabaya, pressed = false , false
                            TriggerServerEvent('ndrp_hsbolo:startMissionServer')
                        end
                    end)
                    Citizen.Wait(15000)
                    edabaya, pressed = false , false
                end
            end
        else
            wait = 100
        end
    end
end)

-- Spawning Car

RegisterNetEvent('ndrp_hsbolo:startMission')
AddEventHandler('ndrp_hsbolo:startMission', function()
    exports['mythic_notify']:SendAlert('success', 'Berry Agreed')
    while not HasModelLoaded(BerryCarHash) do 
        RequestModel(BerryCarHash)
        Citizen.Wait(10)
    end
    local car = CreateVehicle(BerryCarHash, CarSpawnCoords, CarSpawnHeading, true, false)
    SetEntityAsMissionEntity(car, true, true)
    SetVehicleHasBeenOwnedByPlayer(car, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(car), true)
    SetVehicleNeedsToBeHotwired(car, false)
    SetModelAsNoLongerNeeded(BerryCarHash)

    if DoesEntityExist(car) then
        carPlate = GetVehicleNumberPlateText(car)
    else
        local car = CreateVehicle(BerryCarHash, CarSpawnCoords, CarSpawnHeading, true, false)
        SetEntityAsMissionEntity(car, true, true)
        SetVehicleHasBeenOwnedByPlayer(car, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(car), true)
        SetVehicleNeedsToBeHotwired(car, false)
        SetModelAsNoLongerNeeded(BerryCarHash)
        carPlate = GetVehicleNumberPlateText(car)
    end
    exports['mythic_notify']:SendAlert('inform', 'Get into the car')
    RandomDeliveryPoint()
    TriggerServerEvent('ndrp_hsbolo:alertcops', 'start')
end)

-- Sending Alerts to cops

RegisterNetEvent('ndrp_hsbolo:alertcopsC')
AddEventHandler('ndrp_hsbolo:alertcopsC', function(type)
    if ESX.PlayerData and ESX.PlayerData.job.name == 'police' then
        if type == 'done' then
            PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
            TriggerEvent('chat:addMessage', { templateId = 'outlaw', args = {"Disptach : ", "The vehicle has escaped"}})
        else
            PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
            TriggerEvent('chat:addMessage', { templateId = 'outlaw', args = {"Disptach : ", "High Speed Bolo in Progress at Davis. Model: Specter"}})
            local CopBlip = AddBlipForCoord(BerryCoords)
            SetBlipSprite(CopBlip, 161)
	        SetBlipScale(CopBlip, 2.0)
            SetBlipColour(CopBlip, 3)
            PulseBlip(CopBlip)
            Citizen.Wait(30000)
            RemoveBlip(CopBlip)
        end
    end
end)

-- Generating Delivery Point

function RandomDeliveryPoint()
    delivered = false
    timer()
    Citizen.CreateThread(function()
        local random = math.random(1,#deliveryPoint)
        local deliverCoords = deliveryPoint[random]
        local DeliveryBlip = AddBlipForCoord(deliverCoords)
        SetBlipSprite(DeliveryBlip, 596)
        SetBlipScale(DeliveryBlip, 0.8)
        SetBlipColour(DeliveryBlip, 38)
        SetBlipRoute(DeliveryBlip, true)
        SetBlipRouteColour(DeliveryBlip, 38)
        local wait = 100
        while not delivered do
            Citizen.Wait(wait)
            local PlayerPed = GetPlayerPed(-1)
            local plyCoords = GetEntityCoords(PlayerPed)
            local distance = GetDistanceBetweenCoords(deliverCoords, plyCoords)
            if distance < 50 then
                wait = 5
                DrawMarker(2, deliverCoords.x, deliverCoords.y, deliverCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.20, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
                if distance < 5 then 
                    if IsPedInAnyVehicle(PlayerPed,false) then
                        DrawText3Deheh(deliverCoords.x, deliverCoords.y, deliverCoords.z+1.0, '~g~[E]~w~ - to Deliver')
                        if IsControlJustPressed(1,46) then
                            local vehicle = GetVehiclePedIsIn(PlayerPed,false)
                            local vehiclePlate = GetVehicleNumberPlateText(vehicle)
                            if vehiclePlate == carPlate then
                                timerStarted = false
                                ESX.Game.DeleteVehicle(vehicle)
                                if chillZone then
                                    TriggerServerEvent('ndrp_hsbolo:reward', 'done')
                                    TriggerServerEvent('ndrp_hsbolo:alertcops', 'done')
                                    exports['mythic_notify']:SendAlert('success', 'Well done! Here\'s your reward')
                                    carPlate = 0
                                    RemoveBlip(DeliveryBlip)
                                else
                                    TriggerServerEvent('ndrp_hsbolo:alertcops', 'done')
                                    exports['mythic_notify']:SendAlert('error', 'You are too late! Now fuck off')
                                    carPlate = 0
                                    RemoveBlip(DeliveryBlip)
                                end
                                delivered = true
                            end
                        end
                    end
                end
            else
                wait = 100
            end
        end
    end)
end

-- Creating a timer

function timer()
    timerStarted = true
    local gametime = GetGameTimer()
	local seconds = 130
    local printtime = seconds
    Citizen.CreateThread(function()
        while timerStarted do
            Citizen.Wait(0)
            if printtime > 0 then
                chillZone = true
                diftime = GetGameTimer() - gametime
                printtime = math.floor(seconds - (diftime/1000))
                drawTxt("Deliver the car within ~y~" .. printtime .. "~s~ Seconds")		
            else
				chillZone = false
                Citizen.Wait(1000)
                timerStarted = false
            end
        end
    end)    
end

-- Some Drawing functions

function DrawText3Deheh(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
end

function drawTxt(content)
    SetTextFont(4)
    SetTextScale(0.4, 0.4)
    SetTextColour(255,255,255, 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(0.47,0.97)
end