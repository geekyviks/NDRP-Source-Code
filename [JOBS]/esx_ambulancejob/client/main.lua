Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local firstSpawn, PlayerLoaded = true, false
local i=0
local isDead = false
local hostilityOff = false
local playingDeath = false
local beingcarried= false

local relationshipTypes = {
	'GANG_1',
	'GANG_2',
	'GANG_9',
	'GANG_10',
	'AMBIENT_GANG_LOST',
	'AMBIENT_GANG_MEXICAN',
	'AMBIENT_GANG_FAMILY',
	'AMBIENT_GANG_BALLAS',
	'AMBIENT_GANG_MARABUNTE',
	'AMBIENT_GANG_CULT',
	'AMBIENT_GANG_SALVA',
	'AMBIENT_GANG_WEICHENG',
	'AMBIENT_GANG_HILLBILLY',
	'DEALER',
	'COP',
	'PRIVATE_SECURITY',
	'SECURITY_GUARD',
	'ARMY',
	'MEDIC',
	'FIREMAN',
	'HATES_PLAYER',
	'NO_RELATIONSHIP',
	'SPECIAL',
	'MISSION2',
	'MISSION3',
	'MISSION4',
	'MISSION5',
	'MISSION6',
	'MISSION7',
	'MISSION8'
}

function ClearHostility()
	hostilityOff = true;
	Citizen.CreateThread(function()
		while hostilityOff do
			for _, group in ipairs(relationshipTypes) do
				SetRelationshipBetweenGroups(1, GetHashKey('PLAYER'), GetHashKey(group)) -- could be removed
				SetRelationshipBetweenGroups(1, GetHashKey(group), GetHashKey('PLAYER'))
			end
			Citizen.Wait(3000)
		end
	end)
end

function NormalHostility()
	hostilityOff = false;
	for _, group in ipairs(relationshipTypes) do
		SetRelationshipBetweenGroups(255, GetHashKey('PLAYER'), GetHashKey(group)) -- could be removed
		SetRelationshipBetweenGroups(255, GetHashKey(group), GetHashKey('PLAYER'))
	end
end


isDead = false
ESX = nil
local isMenuOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('playerSpawned', function()
	isDead = false
	if firstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		firstSpawn = false
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
			if shouldDie and Config.AntiCombatLog then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end
				ESX.ShowNotification(_U('combatlog_message'))
				RemoveItemsAfterRPDeath()
			end
		end)
	else
		TriggerServerEvent('esx_ambulancejob:onPlayerSpawn')
	end
end)

-- Create blips

Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)
		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['U'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['ESC'], true)
			EnableControlAction(0, 54, true)
			EnableControlAction(0, 57, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	i=i+1
	if i == 1 then
		isDead = true
		ESX.UI.Menu.CloseAll()
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
		StartDeathTimer()
		GoUnconscious()
		Citizen.CreateThread(function()
			Citizen.Wait(10)
			while true do
				Citizen.Wait(100)
				local playerPed = PlayerPedId()
				if isDead or GetEntityHealth(playerPed) <= 0 then
					ClearPedBloodDamage(playerPed)
					ClearPedBloodDamageByZone(playerPed,10)
					ClearPedTasksImmediately(playerPed)
					SetEntityHealth(playerPed, 101)
					if not hostilityOff then
						ClearHostility()
					end
					SetEntityInvincible(playerPed, true)
					TriggerServerEvent('esx_ambulancejob:anim')
					TriggerEvent('ndrp_base:isDead', true)
					break
				end
			end
		end)
		Citizen.Wait(1000)
		TriggerEvent('mythic_hospital:client:RemoveBleed')
		TriggerEvent('mythic_hospital:client:ResetLimbs')
	end
end

RegisterNetEvent('esx_ambulancejob:animDeath')
AddEventHandler('esx_ambulancejob:animDeath', function()
	local firsttime = true
	RequestAnimDict('dead')
	while not HasAnimDictLoaded('dead') do
		Citizen.Wait(10)
	end
	while true do
		if not beingcarried then		
			if not isDead then
				ClearPedTasksImmediately(PlayerPedId())
				ClearPedSecondaryTask(PlayerPedId())
				break
			end
			if firstime then
				Wait(300)
				firstime = false
			else
				Wait(100)
			end
			if IsPedGettingUp(PlayerPedId()) then
				TaskPlayAnim(PlayerPedId(), 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
			elseif not IsEntityPlayingAnim(PlayerPedId(), 'dead', 'dead_a', 3) then
				TaskPlayAnim(PlayerPedId(), 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
			end
		else
			Wait(100)
		end
	end
end)

function GoUnconscious()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer
		local playerPed = PlayerPedId()
		local pressed = false
		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30
			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName('On foot? Press [~b~U~s~] to lie down!')
			EndTextCommandDisplayText(0.178, 0.840)

			if not pressed and IsDisabledControlJustReleased(0, 303) then
				pressed = true
				if not beingcarried then
				
				TriggerEvent('mythic_hospital:client:RemoveBleed')
				TriggerEvent('mythic_hospital:client:ResetLimbs')
				ClearPedBloodDamage(playerPed)
				ClearPedBloodDamageByZone(playerPed,10)
				ESX.Streaming.RequestAnimDict('dead', function()
					while not HasAnimDictLoaded('dead') do
						Citizen.Wait(0)
					end
					ClearPedTasksImmediately(playerPed)
					ClearPedSecondaryTask(playerPed)
					TaskPlayAnim(playerPed, 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
				end)
				end
				Citizen.Wait(5000)
				pressed = false
			end
		end
	end)
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()
	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
			local health = GetEntityHealth(playerPed)
			local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
			SetEntityHealth(playerPed, newHealth)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0
	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false
	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)
	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)
			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)
			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))
			DrawGenericTextThisFrame()
			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			
			Citizen.Wait(0)
			
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))
			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')
				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					NormalHostility()
					break
				end
			
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))
				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					NormalHostility()
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, Keys['E']) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()
			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
			
		end

		if bleedoutTimer < 1 and isDead then
			--	RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local playerpos = GetEntityCoords( GetPlayerPed(-1) )
			ESX.SetPlayerData('lastPosition', playerpos)
			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), playerpos, Config.RespawnPoint.heading)

			TriggerServerEvent('esx:updateLastPosition', playerpos)
			TriggerServerEvent('mythic_hospital:server:RequestBed')
			i=0
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	TriggerEvent('mythic_hospital:client:RemoveBleed')
	TriggerEvent('mythic_hospital:client:ResetLimbs')
	OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:carrycheck')
AddEventHandler('esx_ambulancejob:carrycheck', function(status)
	if status then	
		beingcarried = true
	else
		beingcarried = false
	end
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	ClearPedTasksImmediately(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		NormalHostility()
		DoScreenFadeIn(800)
		TriggerEvent('ndrp_base:isDead', false)
		ClearPedTasksImmediately(playerPed)
		TriggerEvent('esx_ambulancejob:heal', 'big', true)
		i=0
	end)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end