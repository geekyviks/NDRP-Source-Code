local Keys = {
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

ESX = nil

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local OnJob = 0
local Collected = 0
local Blips = {}
local hasMoney = 0
local vehicles = nil
local timerx = 0
local jobTime = 0 -- max time (seconds) you want to set
local oncex = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()	
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


function timer()
    gametime = GetGameTimer()
	seconds = 600 -- max time (seconds) you want to set
    printtime = seconds
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if printtime > 0 and timerx == 1 then
                diftime = GetGameTimer() - gametime
                printtime = math.floor(seconds - (diftime/1000))
				drawTxt("Return Plane within ~y~" .. printtime .. "~s~ Seconds")			
            else
				jobTime = 0
                Citizen.Wait(1000)
            end
        end
    end)    
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
    DrawText(0.88,0.90)
end


-- AIRDROP PICKUP AREA

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(10)
		if OnJob ~= 0 then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			if GetDistanceBetweenCoords(coords, -3413.00, 2766.00, 0.0, true) < 40 then
				ESX.ShowHelpNotification(_U('pickup'))
				if IsControlJustReleased(1, Keys["E"]) then
					
					Collected = 1
					-- Removes Blip for Airdrop Location
					
					RemoveBlip(Blips['JobStart'])
					
					-- Add Blip for Reward Location
					Blips['JobDone'] = AddBlipForCoord(2136.76, 4775.32, 40.97)
					SetBlipSprite(Blips['JobDone'], 501)                           -- lips icon
					SetBlipColour(Blips['JobDone'], 4)
					SetBlipScale(Blips['JobDone'], 0.8)
					BeginTextCommandSetBlipName("STRING")              -- start set caption
					AddTextComponentSubstringPlayerName("Reward Location")      -- caption=Hooker
					EndTextCommandSetBlipName(Blips['JobDone'])
					
					-- Shows Airdrop collected
					
					exports['mythic_progbar']:Progress({
							name = "Collecting Airdrop",
							duration = 5000,
							label = "Collecting Airdrop",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
							}})					
					Citizen.Wait(5000)
					exports['mythic_notify']:SendAlert('inform', 'Return aircraft to claim reward')
					OnJob = 0
				end
			end
		end
	end
end)

function VehicleMenu()
	oncex = true
	local playerPed = PlayerPedId()
	ESX.TriggerServerCallback('ndrp_airdrops:hasMoney', function(hb)
		hasMoney = hb
		if hasMoney == 1 then 
			
			local playerPed = PlayerPedId()
			jobTime = 600
			Collected = 0
			ESX.Game.SpawnVehicle(Config.Vehicles.Truck.Hash, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end)

			OnJob = 1
			timerx = 1
			if timerx == 1 then
				timer()
			end
			TriggerServerEvent("ndrp_airdrop:collected")
			Blips['JobStart'] = AddBlipForCoord(-3413.00, 2766.00, 0.0)
			SetBlipSprite(Blips['JobStart'], 94)                           
			SetBlipColour(Blips['JobStart'], 4)
			SetBlipScale(Blips['JobStart'], 0.8)
			BeginTextCommandSetBlipName("STRING")              
			AddTextComponentSubstringPlayerName("Airdrop Location")      
			EndTextCommandSetBlipName(Blips['JobStart']) 
			TriggerServerEvent("ndrp_airdrop:rent")
			RequestModel("prop_drop_armscrate_01")
			
			while not HasModelLoaded("prop_drop_armscrate_01") do
				Wait(50)
			end
			local airdropmodel = CreateObject(GetHashKey("prop_drop_armscrate_01"), -3413.00, 2766.00, 0.0,  true,  true, true)
			Citizen.Wait(60000)
			local airdropmodel = DeleteObject()	
		else
			TriggerServerEvent("ndrp_airdrop:timing")
		end
	end)	
	Citizen.Wait(1000)
	vehicles = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	TriggerEvent('ndrp_carkeys:carkeys', vehicles)
end


AddEventHandler('ndrp_airdrop:hasEnteredMarker', function(zone)

	if zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom_menu'
		CurrentActionMsg  = Config.Zones.Cloakroom.hint
		CurrentActionData = {}
	
	elseif zone == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = Config.Zones.VehicleDeleter.hint
				CurrentActionData = {}
			end
		end
	end

end)

AddEventHandler('ndrp_airdrop:hasExitedMarker', function(zone)
	
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

end)



Citizen.CreateThread(function()
	while true do
		
		Citizen.Wait(0)

			local coords = GetEntityCoords(PlayerPedId())
			
			for k,v in pairs(Config.Zones) do
					if v ~= Config.Zones.Cloakroom then
						if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
							DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
						end
					end
			end

			

			local Cloakroom = Config.Zones.Cloakroom
			if(Cloakroom.Type ~= -1 and GetDistanceBetweenCoords(coords, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(Cloakroom.Type, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Cloakroom.Size.x, Cloakroom.Size.y, Cloakroom.Size.z, Cloakroom.Color.r, Cloakroom.Color.g, Cloakroom.Color.b, 100, false, true, 2, false, false, false, false)
			end
				
			Citizen.Wait(500)
		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if v ~= Config.Zones.Cloakroom then
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.Size.x) then
						isInMarker  = true
						currentZone = k
					end
				end
			end
			

			local Cloakroom = Config.Zones.Cloakroom
			if(GetDistanceBetweenCoords(coords, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, true) <= Cloakroom.Size.x) then
				isInMarker  = true
				currentZone = "Cloakroom"
				
			end
				
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('ndrp_airdrop:hasEnteredMarker', currentZone)
			end
			
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('ndrp_airdrop:hasExitedMarker', LastZone)
			end
	end
end)

-- Action on demand

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if (IsControlJustReleased(1, Keys["E"]) or IsControlJustReleased(2, Keys["RIGHT"])) then
				
				local playerPed = PlayerPedId()
				if CurrentAction == 'cloakroom_menu' then
					if IsPedInAnyVehicle(playerPed, false) then
						ESX.ShowNotification(_U('in_vehicle'))
					else
						if ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 10) then
							VehicleMenu()
						else
							exports['mythic_notify']:SendAlert('inform', 'There is a vehicle blocking the away')
						end
					end
				elseif CurrentAction == 'vehiclespawn_menu' then
						
					if IsPedInAnyVehicle(playerPed, false) then
						ESX.ShowNotification(_U('in_vehicle'))
					else
						VehicleMenu()
					end

				elseif CurrentAction == 'delete_vehicle' then
					
					local playerPed = PlayerPedId()
					local vehiclex = GetVehiclePedIsIn(playerPed, false)
					local hash = GetEntityModel(vehiclex)
					print(vehicles)
					print(vehiclex)
					if vehicles == vehiclex then
						DeleteVehicle(vehiclex)
						RemoveBlip(Blips['JobStart'])
						RemoveBlip(Blips['JobDone'])
						if jobTime > 1 then
							if oncex then
								TriggerServerEvent("ndrp_airdrop:paid")
								oncex = false
							end
							if Collected == 1 then
								Collected = 0
								timerx = 0
								OnJob = 0
								TriggerServerEvent("ndrp_airdrop:airdrop")
								vehiclex = nil
							else
								Collected = 0
								timerx = 0
								OnJob = 0
								vehiclex = nil
							end
							vehiclex = nil
						else
							exports['mythic_notify']:SendAlert('inform', 'Mission Canceled')
							timerx = 0
							OnJob = 0
							vehiclex = nil
						end
					else
						exports['mythic_notify']:SendAlert('error', 'This plane wasn\'t provided to you')
					end
				end
				CurrentAction = nil				
			end
		end
	end
end)


-- Cocaine Processing


Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		if GetDistanceBetweenCoords(coords, 2329.02, 2571.29, 46.68 , true) < 1 then
			
			ESX.ShowHelpNotification("Press ~y~[E]~s~ to Process Cocaine Brick")
				
				if IsControlJustReleased(0, 38) then
				
					exports['mythic_progbar']:Progress({
								
								name = "Cocaine Processing",
								duration = 15000,
								label = "Procssing Cocaine Brick",
								useWhileDead = false,
								canCancel = false,
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
								}
					})
					Citizen.Wait(15000)
					TriggerServerEvent('ndrp_airdrop:processCocaine')
					
				end
		end	
	
	end
				
end)
