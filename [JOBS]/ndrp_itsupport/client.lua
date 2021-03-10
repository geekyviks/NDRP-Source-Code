local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["K"] = 311
}
local Zones = {
	'z1', 'z2', 'z3', 'z4', 'z5', 'z6', 'z7', 'z8', 'z9', 'z10', 'z11', 'z12', 'z13', 'z14', 'z15', 'z16', 'z17', 'z18', 'z19', 'z20', 'z21', 'z22', 'z23', 'z24', 'z25', 'z26', 'z27'
}

local PlayerData
ESX = nil
local hasAlreadyEnteredMarker = false
local isInMarker = false
local clockedIn = false
local ClubBlip = nil
local i = 0
local taskBlip
local jobCoords
local lastJobCoords
local ix=0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	if (PlayerData.job.name == 'itsupport') then
		print("is it")
		addJobStartBlip()
	else
		print("no it")
		RemoveBlip(ClubBlip)
		ClubBlip = nil
	end
end)

function addJobStartBlip()
	Citizen.CreateThread(function()
		ClubBlip = AddBlipForCoord(Config.Blip.BlipPos.x, Config.Blip.BlipPos.y, Config.Blip.BlipPos.z)
		SetBlipSprite(ClubBlip, Config.Blip.BlipSprite)
		SetBlipColour(ClubBlip, Config.Blip.BlipColor)
		SetBlipDisplay(ClubBlip, 4)
		SetBlipScale(ClubBlip, 0.8)
		SetBlipAsShortRange(ClubBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('IT Support - Cloakroom')
		EndTextCommandSetBlipName(ClubBlip)
		drawMarker()
	end)
end

function drawMarker()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			isInMarker = false

			for i=1, #Config.Marker, 1 do
				local distance = GetDistanceBetweenCoords(coords, Config.Marker[i], true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, Config.Marker[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end

				if distance < (Config.MarkerSize.x) then
					isInMarker = true
					if clockedIn then
						ESX.ShowHelpNotification(_U('clock_out'))
					else
						ESX.ShowHelpNotification(_U('clock_in'))
					end
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
			end
			if IsControlJustReleased(0, Keys['E']) and isInMarker then
				
				if not clockedIn then
					clockedIn = true
					exports['mythic_notify']:SendAlert('inform', _U('vehcile_job_start_alert'), 5000)
				else
					clockedIn = false
					endJob()
				end
			end
		end
	end)
end

function startJob()

	RemoveBlip(taskBlip)
	lastJobCoords = jobCoords
	i = i + 1
	Wait(100)
	if i == 1 then
		jobCoords = Config.Zones[Zones[ math.random(1, #Zones ) ]]
		while (jobCoords == lastJobCoords) do
			Wait(5)
			jobCoords = Config.Zones[Zones[ math.random(1, #Zones ) ]]
		end
		
		taskBlip = AddBlipForCoord(jobCoords.x, jobCoords.y, jobCoords.z)
		SetBlipRoute(taskBlip, 1)
		Wait(1000)
		drawPointMarker(jobCoords)
	else
		print("already drawn marker")
	end
end

function endJob()
	RemoveBlip(taskBlip)
	i=0
end

function jobCallback(success, timeremaining)
	i=0
	RemoveBlip(taskBlip)
	exports['mythic_notify']:SendAlert('inform', _U('vehcile_job_start_alert'), 5000)
	if success then
		TriggerServerEvent('ndrp_hack:setElectronics')
		TriggerEvent('mhacking:hide')
	else
		exports['mythic_notify']:SendAlert('error', 'Task failed')
		TriggerEvent('mhacking:hide')
	end
end

function drawPointMarker(blip)
	local displayHelp = true
	Citizen.CreateThread(function()
		while blip ~= lastJobCoords do
			Citizen.Wait(5)

			local coords = GetEntityCoords(PlayerPedId())
			isInMarker = false
			local loc = vector3(blip.x, blip.y, blip.z)
			local distance = GetDistanceBetweenCoords(coords, loc, true)

			if distance < (Config.MarkerSize.x * 1.5) then
				isInMarker = true
				if clockedIn and blip ~= lastJobCoords and displayHelp and ix == 0then
					displayHelp = false
					ESX.ShowHelpNotification(_U('start_hacking'))
				end
			else
				displayHelp = true
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
			end
			if ix == 0 then
				if IsControlJustReleased(0, Keys['E']) and isInMarker then
					ix = ix+1
					if blip ~= lastJobCoords then
						Citizen.Wait(100)
						if clockedIn then
							TriggerEvent("mhacking:show")
							TriggerEvent("mhacking:start", 4, 25, jobCallback)
						end
					end
				end
			end
			if not clockedIn then
				break
			end
		end
	end)
end


RegisterNetEvent('ndrp_hack:updateJobBlip')
AddEventHandler('ndrp_hack:updateJobBlip', function(job)
	if (job == 'itsupport') then
		RemoveBlip(ClubBlip)
		addJobStartBlip()
	else
		clockedIn = false
		RemoveBlip(taskBlip)
		RemoveBlip(ClubBlip)
	end
end)

RegisterCommand('startit', function(source, args, rawCommand)
	if clockedIn and i == 0 then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			startJob()
			ix = 0
		else
			exports['mythic_notify']:SendAlert('error', 'Sit in your vehicle to see the GPS location', 2500)
		end
	elseif clockedIn and i > 0 then
		ix = 1
		exports['mythic_notify']:SendAlert('error', 'Finish your current job before starting another!', 4500)
	else
		exports['mythic_notify']:SendAlert('error', 'You haven\'t started IT support job', 2500)
	end
end)

TriggerEvent('chat:addSuggestion', '/startit', 'Get a new job location for IT support')