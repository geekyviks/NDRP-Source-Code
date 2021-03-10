ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local vehicle = false
local model = false
local street = false
local zone = false
local plate = false
local hotVehPlate = false
local playerPed = false
local gotitems = false
local pressed = false
local chopvehicle = false
local zCoords = false
local foundVehicle = false
local verified = false

RegisterNetEvent('ndrp_chop:spawnVehicle')
AddEventHandler('ndrp_chop:spawnVehicle', function(x,y,z, randomVeh,vplate)
	local plate = vplate
	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
	local zone = GetLabelText(GetNameOfZone(x,y,z))
	zCoords = vector3(x,y,z)
	model = randomVeh
	RequestModel(randomVeh)
	while not HasModelLoaded(randomVeh) do
        Citizen.Wait(20)
    end
    ClearAreaOfVehicles(x,y,z,10.0, false, false, false, false, false);
	ESX.Game.SpawnLocalVehicle(randomVeh, zCoords, 90, function(vehicle)
		chopvehicle = vehicle
		SetEntityAsMissionEntity(vehicle , true, true )
		Citizen.Wait(50)
		SetVehicleOnGroundProperly(vehicle)
		SetVehicleNumberPlateText(vehicle,plate)
		hotVehPlate = plate
	end)
end)

RegisterNetEvent('ndrp_chop:notifyOwner')
AddEventHandler('ndrp_chop:notifyOwner', function(x,y,z, randomVeh)
	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
	local zone = GetLabelText(GetNameOfZone(x,y,z))
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	randomVeh = randomVeh:gsub("^%l", string.upper)
	TriggerEvent('chat:addMessage', {
		templateId = 'outlaw',
		multiline = false,
		args = {"", "Hot vehicle " .. randomVeh .. " available at " .. zone .. " on " .. street .. " with plate number: " .. hotVehPlate}
	})
end)

RegisterNetEvent('ndrp_chop:informClientsChopped')
AddEventHandler('ndrp_chop:informClientsChopped', function(vehicle)
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    TriggerEvent('chat:addMessage', { 
		templateId = 'outlaw',
        multiline = false,
        args = {"", "A new hot vehicle has been requested. Use the radio to obtain the details."}
	})
end)

RegisterNetEvent('ndrp_chop:informClientsTimeOver')
AddEventHandler('ndrp_chop:informClientsTimeOver', function()
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	TriggerEvent('chat:addMessage', { 
		templateId = 'outlaw',
        multiline = false,
        args = {"", "The hot vehicle is no longer requested. Use the radio to get another hot vehicle's location."}
	})
end)

RegisterNetEvent('ndrp_chop:checkitems')
AddEventHandler('ndrp_chop:checkitems', function(itemcheck)
  gotitems = itemcheck
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local x,y,z = 471.91,-1874.16,26.44
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 4 then
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				local sitvehicle = GetVehiclePedIsIn(playerPed,false)
				local sitplate = GetVehicleNumberPlateText(sitvehicle)
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to chop the vehicle", true, true, 10000)
				if IsControlJustReleased(0,  46) then
					if sitplate == hotVehPlate then
						verified = false
						chopped = true
						TriggerServerEvent("ndrp_chop:Locked",hotVehPlate)
						exports['progressBars']:startUI(2000, "Let John confirm the vehicle")
						if verified then

							SetVehicleDoorsLocked(sitvehicle, 2)
							SetVehicleEngineOn(sitvehicle, false, false, true)
							SetVehicleUndriveable(sitvehicle, false)
							exports['progressBars']:startUI(3000, "Opening Front Left Door")
							
							SetVehicleDoorOpen(sitvehicle, 0, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing Front Left Door")
							
							SetVehicleDoorBroken(sitvehicle, 0, false)
							Citizen.Wait(1000)
							exports['progressBars']:startUI(3000, "Opening Front Right Door")
							
							SetVehicleDoorOpen(sitvehicle, 1, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing Front Right Door")
							
							SetVehicleDoorBroken(sitvehicle, 1, false)
							Citizen.Wait(1000)
							exports['progressBars']:startUI(3000, "Opening Rear left Door")
							
							SetVehicleDoorOpen(sitvehicle, 2, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing Rear left Door")
							
							SetVehicleDoorBroken(sitvehicle, 2, false)
							Citizen.Wait(1000)
							exports['progressBars']:startUI(3000, "Opening rear right Door")
							
							SetVehicleDoorOpen(sitvehicle, 3, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing rear right Door")
							
							SetVehicleDoorBroken(sitvehicle, 3, false)
							Citizen.Wait(1000)
							exports['progressBars']:startUI(3000, "Opening the hood door")
							
							SetVehicleDoorOpen(sitvehicle, 4, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing the hood door")
							
							SetVehicleDoorBroken(sitvehicle, 4, false)
							Citizen.Wait(1000)
							exports['progressBars']:startUI(3000, "Opening the trunk door")
							
							SetVehicleDoorOpen(sitvehicle, 5, false, true)
							Citizen.Wait(1000)
							TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
							exports['progressBars']:startUI(3000, "Removing the trunk door")
							
							SetVehicleDoorBroken(sitvehicle, 5, false)
							SetEntityAsMissionEntity(sitvehicle , true, true )
							DeleteEntity(sitvehicle)
							if (DoesEntityExist(sitvehicle)) then
								DeleteEntity(sitvehicle)
							end
							Citizen.Wait(1000)
							local chance = math.random(1,10)
						
							if chance == 5 then
								TriggerServerEvent('ndrp_chop:rareItem')
							end

							TriggerServerEvent('ndrp_chop:gotItem')
							exports['mythic_notify']:SendAlert('success', 'The hot vehicle has been chopped')
							TriggerServerEvent('ndrp_chop:vehicleChopped')
							foundVehicle = false
							hotVehPlate = false
							model = false
						else
							exports['mythic_notify']:SendAlert('error', 'This vehicle is already being chopped')
						end
					else
						exports['mythic_notify']:SendAlert('error', 'This is not the hot vehicle')
					end
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(playerPed)
		local x,y,z = 1001.93, -3194.95, -38.99
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 0.5 then
			ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to Hack radio", true, true, 10000)
			if IsControlJustReleased(0,  46) and not pressed then
				SetEntityHeading(playePed, 356.48)
				SetEntityCoords(playerPed, x, y, z-1)
				pressed = true
				TriggerServerEvent('ndrp_chop:checkitems')
				Citizen.Wait(100)
				if gotitems then
					exports['mythic_progbar']:Progress({
						name = "Hacking the Radio",
						duration = 13000,
						label = "Hacking the Radio",
						useWhileDead = false,
						canCancel = false,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "mp_prison_break",
							anim = "hack_loop",
							flags = 49,
						}	
					})
					Citizen.Wait(13000)
					TriggerServerEvent('ndrp_chop:getRadio')
					gotitems = false
					pressed = false
					exports['mythic_notify']:SendAlert('success', 'The Radio has been modified successfully')
				else
					pressed = false
					exports['mythic_notify']:SendAlert('error', 'You need a radio, a raspberry and 2 wires to hack the radio')
				end
			end
		end
	end
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local scale = 0.30
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1000)
		if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			local blavehicle = GetVehiclePedIsIn(GetPlayerPed(-1),true)
			local blaplate = GetVehicleNumberPlateText(blavehicle)
			if hotVehPlate then
				if not foundVehicle then
					if blaplate == hotVehPlate then
						foundVehicle = true
						ESX.Game.DeleteVehicle(blavehicle)
						chopvehicle = false
						TriggerServerEvent("ndrp_chop:LocalCars")
						Citizen.Wait(100)
						ESX.Game.SpawnVehicle(model, zCoords, 90, function(vehicle)
							SetEntityAsMissionEntity(vehicle , true, true )
							SetVehicleOnGroundProperly(vehicle)
							Citizen.Wait(50)
							SetVehicleNumberPlateText(vehicle,hotVehPlate)
							SetVehicleOnGroundProperly(vehicle)
						end)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("ndrp_chop:deleteLocalCars")
AddEventHandler("ndrp_chop:deleteLocalCars", function()
	if chopvehicle then
		ESX.Game.DeleteVehicle(chopvehicle)
		chopvehicle = false
		foundVehicle = true
	end
end)

RegisterNetEvent("ndrp_chop:verify")
AddEventHandler("ndrp_chop:verify", function()
	verified = true
end)