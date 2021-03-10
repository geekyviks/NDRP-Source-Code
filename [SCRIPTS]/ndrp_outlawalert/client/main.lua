ESX = nil

local timing, isPlayerWhitelisted = math.ceil(Config.Timer * 60000), false
local streetName
local allowChecking = false
local blip, x, y
local playerGender = "Someone"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if NetworkIsSessionStarted() then
			DecorRegister('isOutlaw', 3)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
			return
		end
	end
end)

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end
	if not ESX.PlayerData.job then
		return false
	end
	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

RegisterNetEvent('ndrp_outlawalert:outlawNotify')
AddEventHandler('ndrp_outlawalert:outlawNotify', function(type, data)
	if isPlayerWhitelisted then
		SendNUIMessage({action = 'display', style = type, info = data})
		TriggerEvent('InteractSound_CL:PlayOnOne', 'done', 0.4)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if DecorGetInt(PlayerPedId(), 'isOutlaw') == 2 then
			Citizen.Wait(timing)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
		end
	end
end)

local bulletshot = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local currentWeaponHash = GetSelectedPedWeapon(playerPed)
		if IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and Config.GunshotAlert and (currentWeaponHash ~= GetHashKey("WEAPON_STUNGUN") and currentWeaponHash ~= GetHashKey("WEAPON_BALL")) then
			if bulletshot < 2 then
				bulletshot = bulletshot + 1
				local playerCoords = GetEntityCoords(playerPed)
				streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
				streetName = GetStreetNameFromHashKey(streetName)
				Citizen.Wait(2000)
				if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
					DecorSetInt(playerPed, 'isOutlaw', 2)
					TriggerServerEvent('ndrp_outlawalert:gunshotInProgress', {
						x = ESX.Math.Round(playerCoords.x, 1),
						y = ESX.Math.Round(playerCoords.y, 1),
						z = ESX.Math.Round(playerCoords.z, 1)
					}, streetName, playerGender)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if bulletshot >= 2 then
			bulletshot = 0
		end
	end
end)

RegisterNetEvent('ndrp_outlawalert:carJackx')
AddEventHandler('ndrp_outlawalert:carJackx', function(steal,vehiclex)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
	streetName = GetStreetNameFromHashKey(streetName)
	Citizen.Wait(2000)
	local vehicle 
	if steal == "steal" then
		vehicle = vehiclex
	else
		vehicle = GetVehiclePedIsIn(playerPed, true)
	end
	if vehicle and ((isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted) then

		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		vehicleLabel = GetLabelText(vehicleLabel)
		local plate = GetVehicleNumberPlateText(vehicle)
		DecorSetInt(playerPed, 'isOutlaw', 2)
		TriggerServerEvent('ndrp_outlawalert:carJackInProgress', {
			x = ESX.Math.Round(playerCoords.x, 1),
			y = ESX.Math.Round(playerCoords.y, 1),
			z = ESX.Math.Round(playerCoords.z, 1)
		}, streetName, vehicleLabel .. ' ' .. plate, playerGender, steal)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0,  249) and allowChecking then
			print('control pressed')
			SetNewWaypoint(x, y)
		end
	end
end)

RegisterNetEvent('ndrp_outlawalert:carJackInProgress')
AddEventHandler('ndrp_outlawalert:carJackInProgress', function(targetCoords)
	if isPlayerWhitelisted then
		if Config.CarJackingAlert then
			local alpha = 250
			x = targetCoords.x
			y = targetCoords.y
			local thiefBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipJackingRadius * 7)
			blip = thiefBlip
			SetBlipHighDetail(thiefBlip, true)
			SetBlipColour(thiefBlip, 1)
			SetBlipAlpha(thiefBlip, alpha)
			SetBlipAsShortRange(thiefBlip, true)
			SetBlipSprite(thiefBlip, 225)
			allowChecking = true
			while alpha ~= 0 do
				Citizen.Wait(Config.BlipJackingTime * 6)
				alpha = alpha - 1
				SetBlipAlpha(thiefBlip, alpha)
				if alpha == 0 then
					RemoveBlip(thiefBlip)
					allowChecking = false
					return
				end
			end
		end
	end
end)

RegisterNetEvent('ndrp_outlawalert:gunshotInProgress')
AddEventHandler('ndrp_outlawalert:gunshotInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 250
		x = targetCoords.x
		y = targetCoords.y
		local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipGunRadius * 7)
		blip = gunshotBlip
		SetBlipHighDetail(gunshotBlip, 1)
		SetBlipColour(gunshotBlip, 1)
		SetBlipAlpha(gunshotBlip, alpha)
		SetBlipAsShortRange(gunshotBlip, true)
		SetBlipSprite(gunshotBlip, 313)
		allowChecking = true
		while alpha ~= 0 do
			Citizen.Wait(Config.BlipGunTime * 6)
			alpha = alpha - 1
			SetBlipAlpha(gunshotBlip, alpha)

			if alpha == 0 then
				RemoveBlip(gunshotBlip)
				allowChecking = false
				return
			end
		end
	end
end)

RegisterNetEvent('ndrp_outlawalert:custom')
AddEventHandler('ndrp_outlawalert:custom', function(targetCoords,blipx)
	if isPlayerWhitelisted then
		local alpha = 250
		x = targetCoords.x
		y = targetCoords.y
		local customBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipCustomRadius*7)
		SetBlipHighDetail(customBlip, true)
		SetBlipColour(customBlip, 1)
		SetBlipAlpha(customBlip, alpha)
		SetBlipAsShortRange(customBlip, true)
		SetBlipSprite(customBlip, blipx)
		allowChecking = true
		blip = customBlip
		while alpha ~= 0 do
			Citizen.Wait(Config.BlipCustomTime * 6)
			alpha = alpha - 1
			SetBlipAlpha(customBlip, alpha)
			if alpha == 0 then
				RemoveBlip(customBlip)
				allowChecking = false
				return
			end
		end
	end
end)