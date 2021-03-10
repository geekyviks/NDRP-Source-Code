local spawnedItems = 0
local salvage= {}
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.ScrapField.coords, true) < 50 then
			Spawnsalvage()
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #salvage, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(salvage[i]), false) < 1 then
				nearbyObject, nearbyID = salvage[i], i
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
		
						table.remove(salvage, nearbyID)
						spawnedItems = spawnedItems - 1
						local chance = math.random(1, 3)
						print(chance)
						if chance == 1 then
							TriggerServerEvent('esx_mechanicjob:pickedUpScrap')
						elseif chance == 2 then
							TriggerServerEvent('esx_mechanicjob:pickedUpGlass')
						else
							exports['mythic_notify']:SendAlert('inform', 'Nothing useful here', 4500, { ['background-color'] = 'red', ['color'] = 'white' })
						end
					else
						exports['mythic_notify']:SendAlert('inform', 'You can\'t carry anymore', 4500, { ['background-color'] = 'red', ['color'] = 'white' })
					end

					isPickingUp = false
				end, 'scrap')
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(salvage) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function Spawnsalvage()
	while spawnedItems < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_rub_litter_03c', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(salvage, obj)
			spawnedItems = spawnedItems + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedItems > 0 then
		local validate = true

		for k, v in pairs(salvage) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.ScrapField.coords, false) > 50 then
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

		weedCoordX = Config.CircleZones.ScrapField.coords.x + modX
		weedCoordY = Config.CircleZones.ScrapField.coords.y + modY

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