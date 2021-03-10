local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


--- action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil


--- esx
local GUI = {}
ESX                           = nil
GUI.Time                      = 0
local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

----markers
AddEventHandler('esx_duty:hasEnteredMarker', function (zone)
  if zone ~= nil then
    CurrentAction     = 'onoff'
    CurrentActionMsg = _U('duty')
  end
end)

AddEventHandler('esx_duty:hasExitedMarker', function (zone)
  CurrentAction = nil
end)


--keycontrols
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1)

        local playerPed = GetPlayerPed(-1)
        
        local jobs = {
            'offambulance',
            'offpolice',
            'police',
            'ambulance'
        }

        if CurrentAction ~= nil then
            for k,v in pairs(jobs) do
                if PlayerData.job ~= nil and PlayerData.job.name == v then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString('Press ~INPUT_CONTEXT~ to join/leave duty')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                    if IsControlJustPressed(0, Keys['E']) then
                        TriggerServerEvent('duty:onoff')
						            Citizen.Wait(3000)
                    end
                end
            end

        end

    end       
end)

-- Display markers
Citizen.CreateThread(function ()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 150, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(0)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_duty:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_duty:hasExitedMarker', LastZone)
    end
  end
end)

RegisterCommand('impound', function(source, args, rawCommand)
  local playerPed = GetPlayerPed(-1)
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police"  or PlayerData.job.name == "ambulance" or PlayerData.job.name == "mechanic" then
      local pos = GetEntityCoords(playerPed, false)
      local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)
      if DoesEntityExist(vehicle) then 
        SetEntityAsMissionEntity(vehicle, true, true)

        ESX.Streaming.RequestAnimDict('random@arrests', function()
          TaskPlayAnim(PlayerPedId(), 'random@arrests', 'generic_radio_chatter', 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end) 

      -- TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        TriggerServerEvent('3dme:shareDisplay', 'Calls Tow Driver')
        Wait(3000)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
        exports['mythic_notify']:SendAlert('inform', 'Vehicle sent to LSPD Impound Lot')
        ClearPedTasks(playerPed)
      end 
    end
  end 
end)

RegisterCommand('fine', function(source, args, rawCommand)
  local playerPed = GetPlayerPed(-1)
  local victim = tonumber(args[1])
  local fineamount = tonumber(args[2])
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      if victim ~= nil and fineamount ~= nil then
        TriggerServerEvent('ndrp_customfine:sendFine', victim, fineamount, 'Custom Fine')
        exports['mythic_notify']:SendAlert('inform', 'The player has been fined', 2500, { })
      end
    end
  end
end)

RegisterNetEvent('ndrp_customfine:receiveFine')
AddEventHandler('ndrp_customfine:receiveFine', function(amount, message, sender)
  TriggerServerEvent('ndrp_customfine:payFine',amount)
  exports['mythic_notify']:SendAlert('inform', 'You have been fined ' .. amount .. ' by '..sender, 2500)
end)

RegisterCommand('comser', function(source, args, rawCommand)
  local victim = tonumber(args[1])
  local actions = tonumber(args[2])
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      if victim ~= nil and actions ~= nil then
        TriggerServerEvent('esx_communityservice:sendToCommunityService', victim , actions)
        exports['mythic_notify']:SendAlert('success', 'The player has been sent for community service')
      else
        exports['mythic_notify']:SendAlert('error', 'Invalid id or action')
      end
    end
  end
end)


RegisterCommand('endcomser', function(source, args, rawCommand)
  local victim = tonumber(args[1])
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      if victim ~= nil then
        TriggerServerEvent('esx_communityservice:endCommunityServiceCommand', victim)
        exports['mythic_notify']:SendAlert('success', 'The player has been released from community service')
      else
        exports['mythic_notify']:SendAlert('error', 'Invalid id')
      end
    end
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
		SetPedMinGroundTimeForStungun(GetPlayerPed(-1), 10000)
    end
    DisableControlAction(0, 140, true)
	end
end)

RegisterCommand('deloutfit', function(source, args, rawCommand)
  local outfit = args[1]
  print(outfit)
  if outfit ~= nil then
    TriggerServerEvent('esx_property:removeOutfit', outfit)
  end
end)

RegisterCommand('hardcuff', function(source, args, rawCommand)
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      TriggerEvent('esx_policejob:checkCuff', true)
    end
  end
end)

RegisterCommand('softcuff', function(source, args, rawCommand)
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      TriggerEvent('esx_policejob:checkCuff', false)
    end
  end
end)


RegisterCommand('panic', function(source, args, rawCommand)
  if PlayerData.job ~= nil then
    if PlayerData.job.name == "police" then
      local ped = PlayerPedId()
      local x,y,z = table.unpack(GetEntityCoords(ped, false))
      local streetName, crossing = GetStreetNameAtCoord(x, y, z)
      streetName = GetStreetNameFromHashKey(streetName)
      local message = ""
      if crossing ~= nil then
          crossing = GetStreetNameFromHashKey(crossing)
          message = "^0 An officer has called a 10-13 near " .. streetName .. " and " .. crossing .. " all units break and roll code 3."
      else
          message = "^0 An officer has called a 10-13 near " .. streetName .. " all units break and roll code 3."
      end
      TriggerServerEvent('sendChatMessage', message)
    end
  end
end)


RegisterCommand('treat', function(source, args, rawCommand)
	
	if args ~= nil then
		 if PlayerData.job ~= nil then
			if PlayerData.job.name == "ambulance" then
				local action = args[1]
				if action == 'sit' then
					TriggerEvent('ndrp_emotes:playthisemote', 'c')
					TriggerEvent('ndrp_emotes:playthisemote', 'medic2')
					TriggerServerEvent('3dme:shareDisplay', 'Checking the patient')
				elseif action == 'cw' then
					TriggerServerEvent('3dme:shareDisplay', 'Checking the wounds')
				elseif action == 'ccw' then
					TriggerEvent('ndrp_emotes:playthisemote', 'clean')
					TriggerServerEvent('3dme:shareDisplay', 'Cleaning the wounds with saline')
				elseif action == 'tw' then
					TriggerEvent('ndrp_emotes:playthisemote', 'mechanic')
					TriggerServerEvent('3dme:shareDisplay', 'Treating the wounds')
				elseif action == 'ci' then
					TriggerServerEvent('3dme:shareDisplay', 'Checking the injuries')
				elseif action == 'ti' then
					TriggerEvent('ndrp_emotes:playthisemote', 'mechanic4')
					TriggerServerEvent('3dme:shareDisplay', 'Treating the injuries')
				elseif action == 'cg' then
					TriggerEvent('ndrp_emotes:playthisemote', 'think2')
					TriggerServerEvent('3dme:shareDisplay', 'Checking the gunshots')
				elseif action == 'rb' then
					TriggerEvent('ndrp_emotes:playthisemote', 'mechanic4')
					TriggerServerEvent('3dme:shareDisplay', 'Removing the bullets')
				elseif action == 'ww' then
					TriggerEvent('ndrp_emotes:playthisemote', 'mechanic2')
					TriggerServerEvent('3dme:shareDisplay', 'Wrapping the wound using Gauze and Povidone')
				elseif action == 'ap' then
					TriggerEvent('ndrp_emotes:playthisemote', 'cpr')
					TriggerServerEvent('3dme:shareDisplay', 'Applying pressure on chest')
				end
			end
		end
	end
			
end)

TriggerEvent('chat:addSuggestion', '/treat', 'Custom shortcodes (For EMS)', {
  
  { name="shortcode", help="e.g. sit,cw,ccw,tw,ci,ti etc." },
  
})

TriggerEvent('chat:addSuggestion', '/steal', 'Steal a cuffed person')
TriggerEvent('chat:addSuggestion', '/escort', 'Toggle escort on a cuffed person')
TriggerEvent('chat:addSuggestion', '/hardcuff', 'Hardcuff or uncuff a player (For Police)')
TriggerEvent('chat:addSuggestion', '/softcuff', 'Softcuff or uncuff a player (For Police)')
TriggerEvent('chat:addSuggestion', '/comser', 'Send a player for community service (For Police)', {
  { name="id", help="Player ID" },
  { name="actions", help="Actions" }
})
TriggerEvent('chat:addSuggestion', '/endcomser', 'End community sentence of a player (For Police)', { { name="id", help="Play ID" },})
TriggerEvent('chat:addSuggestion', '/fine', 'Send a custom fine to player (For Police)', {
  { name="id", help="Player ID" },
  { name="amount", help="Amount" }
})

TriggerEvent('chat:addSuggestion', '/impound', 'Impound nearest vehicle (For Police and EMS)')
TriggerEvent('chat:addSuggestion', '/panic', 'Send a Panic message to all available units (For Police Only)')