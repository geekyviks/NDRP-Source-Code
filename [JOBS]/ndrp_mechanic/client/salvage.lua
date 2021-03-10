local spawnedItems = 0
local Salvage= {}
local isPickingUp = false

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
		if GetDistanceBetweenCoords(coords, Config.CircleZones.SalvageField.coords, true) < 40 then
			SpawnSalvage()
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #Salvage, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(Salvage[i]), false) < 1 then
				nearbyObject, nearbyID = Salvage[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUp then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to search")
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)
					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, false)
						exports['mythic_progbar']:Progress({
							name = "searching",
							duration = 10000,
							label = 'searching',
							useWhileDead = false,
							canCancel = faslse,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
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
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(Salvage, nearbyID)
						spawnedItems = spawnedItems - 1
						if math.random(1,4) == 4 then
							exports['mythic_notify']:SendAlert('inform', 'Nothing useful here!', 4500, { ['background-color'] = 'white', ['color'] = 'black' })
						else
							TriggerServerEvent('esx_mechanicjob:pickedUpSalvage')
						end
					else
						exports['mythic_notify']:SendAlert('inform', 'You can\'t carry anymore', 4500, { ['background-color'] = 'red', ['color'] = 'white' })
					end

					isPickingUp = false
				end, 'contrat')
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Salvage) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnSalvage()
	while spawnedItems < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_rub_litter_03c', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(Salvage, obj)
			spawnedItems = spawnedItems + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedItems > 0 then
		local validate = true

		for k, v in pairs(Salvage) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.SalvageField.coords, false) > 50 then
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

		weedCoordX = Config.CircleZones.SalvageField.coords.x + modX
		weedCoordY = Config.CircleZones.SalvageField.coords.y + modY

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