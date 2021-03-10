-----------
-- 3D ME --
-----------

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me', 'Can show personal actions, face expressions & much more.')
    TriggerEvent('chat:addSuggestion', '/impound', 'Send vehicles to impound lot (Police and EMS authorized)')
end)

local nbrDisplaying = 1

RegisterCommand('me', function(source, args, raw)
    local text = string.sub(raw, 4)
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 1 + (nbrDisplaying*0.15)
    Display(GetPlayerFromServerId(source), text, offset)
end)
 

local disableShuffle = true
local nibba

function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        nibba = PlayerPedId()
		if IsPedInAnyVehicle(nibba, false) and disableShuffle then
			local vehicle = GetVehiclePedIsIn(nibba, false)
			if GetPedInVehicleSeat(vehicle, 0) == nibba then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(nibba, vehicle, 0)
				end
			end
		end
	end
end) 

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(nibba, false) then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end)



RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it


Citizen.CreateThread(function() 
    while true do  
		Citizen.Wait(0)	
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)

            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
                 
            local pedd = GetPedInVehicleSeat(veh, -1)

            if pedd then                   
                SetPedCanBeDraggedOut(pedd, false)
            end             
        end   
            							
    end
end)



function Display(mePlayer, text, offset)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(5000)
        displaying = false
    end)
	
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 500 then
                 DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset-1.250, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 150)
    end
end