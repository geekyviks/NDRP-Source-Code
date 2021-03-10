local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 50 then
			SpawnWeedPlants()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to Pack the Cannabis")
			end
			if IsControlJustReleased(0, 38) and not isProcessing then
				isProcessing = true
				exports['mythic_progbar']:Progress({
					name = "weed processing",
					duration = 10000,
					label = "Packing Cannabis into 3oz Bag",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
						anim = "machinic_loop_mechandplayer",
						flags = 49,
					},
				})
				Citizen.Wait(10000)
				
				TriggerServerEvent('esx_drugs:processCannabis')
				isProcessing = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUp then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to Harvest Cannabis")
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)
					if canPickUp then pickupweed = true else pickupweed = false end
				end, 'cannabis')
				if pickupweed then
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
					Citizen.Wait(1500)
					ESX.Game.DeleteObject(nearbyObject)
					table.remove(weedPlants, nearbyID)
					spawnedWeeds = spawnedWeeds - 1
					TriggerServerEvent('esx_drugs:pickedUpCannabis')
					isPickingUp = false
				else
					exports['mythic_notify']:SendAlert('error', 'It seems like you don\'t have enough space. Try Again!')
					Citizen.Wait(3000)
					isPickingUp = false
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()
		ESX.Game.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true
		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)
		local weedCoordX, weedCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)
		Citizen.Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)
		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY
		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)
		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return 43.0
end