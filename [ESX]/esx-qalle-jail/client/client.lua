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

PlayerData = {}

local jailTime = 0
local canLeave = false
local jobCoords
local lastJobCoords
local taskBlip

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	LoadTeleporters()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData

	Citizen.Wait(25000)

	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then

			jailTime = newJailTime

			JailLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function(newJailTime)
	startJob()
	jailTime = newJailTime
	Cutscene()
end)

RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
	jailTime = 0

	UnJail()
end)

function JailLogin()
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)

	ESX.ShowNotification("Last time you went to sleep you were jailed, because of that you are now put back!")

	InJail()
end

function UnJail()
	if canLeave then
		InJail()

		ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])

		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)

		ESX.ShowNotification("You are released, stay calm outside! Good LucK!")
		RemoveBlip(taskBlip)
	else
		ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])
	end
end

function InJail()

	--Jail Timer--

	Citizen.CreateThread(function()

		while jailTime > 0 do
			canLeave = false
			jailTime = jailTime - 1

			ESX.ShowNotification("You have " .. jailTime .. " months left in jail!")

			TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)

			if jailTime == 0 then
				canLeave = true

				TriggerServerEvent("esx-qalle-jail:updateJailTime", 0)
			end

			Citizen.Wait(60000)
		end

	end)
	--Jail Timer--
end


function startJob()
	exports['mythic_notify']:SendAlert('inform', 'Work location has been set on GPS', 5000)
	RemoveBlip(taskBlip)
	lastJobCoords = jobCoords
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)
			jobCoords = Config.JobPos[math.random(1, #Config.JobPos)]
			while (jobCoords == lastJobCoords) do
				Citizen.Wait(5)
				jobCoords = Config.JobPos[math.random(1, #Config.JobPos)]
			end
			taskBlip = AddBlipForCoord(jobCoords.x, jobCoords.y, jobCoords.z)
			Citizen.Wait(1000)
			drawPointMarker(jobCoords)
			break
		end
	end)
end

function drawPointMarker(blip)
	print('drawing markers')
	Citizen.CreateThread(function()
		while blip ~= lastJobCoords do
			Citizen.Wait(5)
			local coords = GetEntityCoords(PlayerPedId())
			local loc = vector3(blip.x, blip.y, blip.z)
			local distance = GetDistanceBetweenCoords(coords, loc, true)

			if distance < 1.2 then

				exports['mythic_progbar']:Progress({		
					name = "Fixing",
					duration = 120000,
					label = "Fixing",
					useWhileDead = true,
					canCancel = true,
					controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
					},
					animation = {
							task = "WORLD_HUMAN_WELDING",
							animDict = nil,
							anim = nil,
							flags = 49,
					}
				})

				Citizen.SetTimeout(120000, function ()
					exports['mythic_notify']:SendAlert('inform', 'Your jail time has been reduced!', 5000)
					ClearPedTasksImmediately(PlayerPedId())
					ClearPedSecondaryTask(PlayerPedId())
					RemoveBlip(taskBlip)
					jailTime = jailTime - 1
					FreezeEntityPosition(PlayerPedId(), false)
					if (jailTime > 0) then
						startJob()
					end
				end)

				break

			end
		end
	end)
end

function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do
			
			local sleepThread = 500

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do

				if v.x == 1765.65 and not canLeave then

				else
					local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

					if DistanceCheck <= 7.5 then

						sleepThread = 5

						ESX.Game.Utils.DrawText3D(v, "[E] Open Door", 0.4)

						if DistanceCheck <= 1.0 then
							if IsControlJustPressed(0, 38) then
								TeleportPlayer(v)
							end
						end
					end
				end
			end

			Citizen.Wait(sleepThread)

		end
	end)
end

function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Prison Menu",
			align    = 'center',
			elements = {
				{ label = "Jail Closest Person", value = "jail_closest_player" },
				{ label = "Unjail Person", value = "unjail_player" }
			}
		}, 
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Jail Time (minutes)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("The time needs to be in minutes!")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("No players nearby!")
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Jail Reason"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								ESX.ShowNotification("You need to put something here!")
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("No players nearby!")
								else
								  	TriggerServerEvent("esx-qalle-jail:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					ESX.ShowNotification("Your jail is empty!")
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Prisoner: " .. playerArray[i].name .. " | Jail Time: " .. playerArray[i].jailTime .. " months", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Unjail Player",
						align = "center",
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function(data, menu)
		menu.close()
	end)	
end

