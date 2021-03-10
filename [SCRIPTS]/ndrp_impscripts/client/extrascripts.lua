-- Disable Dispatch
Citizen.CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
end)

-- Disable Crosshair

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(14) 
	end
end)

-- Disable rewards

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DisablePlayerVehicleRewards(PlayerId())
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_SNIPERRIFLE'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_CARBINERIFLE'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PISTOL'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_ADVANCEDRIFLE'))
	end
end)

-- Stress System

local police = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		local currentWeaponHash = GetSelectedPedWeapon(playerPed)
		if IsPedShooting(ped) then
			if currentWeaponHash ~= GetHashKey("WEAPON_STUNGUN") and currentWeaponHash ~= GetHashKey("WEAPON_BALL") and currentWeaponHash ~= GetHashKey("WEAPON_PETROLCAN") then
				if police then
					TriggerEvent('esx_status:add', 'stress', 5000)
				else
					TriggerEvent('esx_status:add', 'stress', 20000)
				end
			end
		end
	end
end)

RegisterNetEvent("ndrp_scripts:isPolice")
AddEventHandler("ndrp_scripts:isPolice", function(policex)
	if policex then
		police = true
	else
		police = false
	end
end)

-- Discord Rich Presense

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
		local playerCount = #GetActivePlayers()
		Citizen.Wait(20*1000) -- checks every 5 seconds (to limit resource usage)
		SetDiscordAppId(788339158603137075) -- client id (int)
		SetRichPresence(string.format("%s Players", playerCount)) -- main text (string)
		SetDiscordRichPresenceAsset("ogrpx") -- large logo key (string)
		SetDiscordRichPresenceAssetText("ogrp.in") -- Large logo "hover" text (string)
		SetDiscordRichPresenceAssetSmall("ogrpy") -- small logo key (string)
		SetDiscordRichPresenceAssetSmallText("ogrp.in") -- small logo "hover" text (string)
	end
end)

-- AFK KICK

local afkTimeout = 1200 -- AFK kick time limit in seconds
local timer = 0
local currentPosition  = nil
local previousPosition = nil
local currentHeading   = nil
local previousHeading  = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		playerPed = PlayerPedId()
		if playerPed then
			currentPosition = GetEntityCoords(playerPed, true)
			currentHeading  = GetEntityHeading(playerPed)
			if currentPosition == previousPosition and currentHeading == previousHeading then
				if timer > 0 then
					if timer == math.ceil(afkTimeout / 4) then
						TriggerEvent('chat:addMessage', { templateId = 'outlaw', multiline = false, args = { "Warning : ", "You'll be kicked ".. timer .." seconds for being AFK" } })
					end
					timer = timer - 1
				else
					TriggerServerEvent('afkkick:kickplayer')
				end
			else
				timer = afkTimeout
			end
			previousPosition = currentPosition
			previousHeading  = currentHeading
		end
	end
end)

--- Disable drive by

local isInVehicle = false
Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	local vehicle = nil
	local class = nil
	while true do
		Citizen.Wait(1000)
		vehicle = GetVehiclePedIsIn(playerPed, false)
		class = GetVehicleClass(vehicle)
		if DoesEntityExist(vehicle) then
			if class == 7 then
				isInVehicle = true
			else
				isInVehicle = false
			end
		else
			isInVehicle = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if isInVehicle then
			SetPlayerCanDoDriveBy(PlayerId(), false)
		else
			SetPlayerCanDoDriveBy(PlayerId(), true)
			Citizen.Wait(2000)
		end
	end
end)

--- Hunger thirst sideeffects

local playerHungry = false
local playerThirsty = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                if hunger.getPercent() == 0.0 then
                    playerHungry = true
                else
                    playerHungry = false
                end
                if thirst.getPercent() == 0.0 then
                    playerThirsty = true
                else
                    playerThirsty = false
                end
            end)
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60*1000)
        local PlayerPed = GetPlayerPed(-1) 
        local chance = math.random(1,4)
        if playerHungry then
            if chance == 1 then
                exports['mythic_notify']:SendAlert('inform', 'You fainted', 5000)
                SetPedToRagdoll(GetPlayerPed(-1), 4000, 4000, 0, 0, 0, 0)
            elseif chance == 2 then
                exports['mythic_notify']:SendAlert('inform', 'You Suddenly Black Out', 5000)
                SetFlash(0, 0, 100, 7000, 100)
                DoScreenFadeOut(500)
                Wait(500)
                DoScreenFadeIn(500)
            elseif chance == 3 then 
                exports['mythic_notify']:SendAlert('inform', 'You are feeling hungry', 5000)
                SetEntityHealth(PlayerPed, GetEntityHealth(PlayerPed) - 5 )
            else
                exports['mythic_notify']:SendAlert('inform', 'Stressed Gained', 5000)
                TriggerEvent('esx_status:add', 'stress', 50000)
            end
        end 

        if playerThirsty then
            if chance == 1 then
                exports['mythic_notify']:SendAlert('inform', 'You Suddenly Black Out', 5000)
                SetFlash(0, 0, 100, 7000, 100)
                DoScreenFadeOut(500)
                Wait(500)
                DoScreenFadeIn(500)
            elseif chance == 2 then 
                exports['mythic_notify']:SendAlert('inform', 'You are feeling thirsty', 5000)
                SetEntityHealth(PlayerPed, GetEntityHealth(PlayerPed) - 5 )
            else
                exports['mythic_notify']:SendAlert('inform', 'Stressed Gained', 5000)
                TriggerEvent('esx_status:add', 'stress', 25000)
            end
        end 
    end
end)