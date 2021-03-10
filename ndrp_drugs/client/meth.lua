local Keys = {
    ["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["K"] = 311
}
local pressed = false
local havecard = false

local coords = {
    [1] = 	{ pos =	vector3(1413.78 , -2042.17 , 51.0), heading = 359.3 },
    [2] = { pos = vector3(120.93 , -2468.62 , 5.0), heading = 233.0 },
    [3] = { pos = vector3(-647.15 , -1148.54 , 8.52),  heading = 334.5 },
	[4] = { pos = vector3(38.48 , -71.51 , 64.73 ), heading = 253.51},
	[5] = { pos = vector3(-1317.89 , -939.2 , 8.73  ),  heading = 117.4 },
	[6] = { pos = vector3(1639.65 , 3731.49 , 36.07 ), heading =  137.48},
}

local blip
ESX = nil
local phoneCoords = vector3(49.94, -1453.68, 29.31)


cachedPeds = {}
Citizen.CreateThread(function()
    while true do
        cachedPeds = {}
        Citizen.Wait(300000)
    end
end)


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local inMarker = false
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords, phoneCoords, true)

        if distance < 2 then
            DrawMarker(20, phoneCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 255, 100, false, true, 2, false, false, false, false)
        end

        if distance < 1 then
            ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to interact with Leroy')
            inMarker = true
        else
            inMarker = false
        end

        if IsControlJustReleased(0, Keys['E']) and not pressed and inMarker then
			pressed = true
			
			ESX.TriggerServerCallback('ndrp_drugs:hasItem', function(hasItem)
					if hasItem then 
						TriggerServerEvent('esx_drugs:burnerphone')
					else 
						exports['mythic_notify']:SendAlert('info', 'Show us the card and tell us who you belong to!', 7000, { ['background-color'] = '#000', ['color'] = '#fff' })
					end
			end, 'card_famine')
			
			Citizen.Wait(2000)
			pressed = false
        end
    end
end)

local lastblip

RegisterNetEvent('esx_drugs:burnerUsed')
AddEventHandler('esx_drugs:burnerUsed', function()
	
	exports['mythic_notify']:SendAlert('inform', 'Connecting to WAP...', 2500, { ['background-color'] = '#56f7fc', ['color'] = '#000' })
	Citizen.Wait(2500)
	exports['mythic_notify']:SendAlert('inform', 'Fetching GPS coordinates...', 2500, { ['background-color'] = '#56f7fc', ['color'] = '#000' })
	Citizen.Wait(2500)
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	exports['mythic_notify']:SendAlert('inform', 'GPS coordinates have been set!', 2500, { ['background-color'] = '#56f7fc', ['color'] = '#000' })
	Citizen.Wait(2500)
	RemoveBlip(blip)
	local rand = math.random(1, #coords)
	local blipCoords = coords[rand].pos
	
	while true do
		Citizen.Wait(10)
		if blipCoords == lastblip then
			rand = math.random(1, #coords)
			blipCoords = coords[rand].pos
		else
			lastblip = blipCoords
		break
		end
	end
	
	local blip = AddBlipForCoord(blipCoords)
    SetBlipRoute(blip, 1)

	local delay = 100
	
	 while true do
	 
		Citizen.Wait(delay)
		local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), blipCoords, true)
		if dist < 1.5  then
			delay = 0
			ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to interact with dealer')
			inRange = true
			RemoveBlip(blip)
		else
			delay = 100
			inRange = false
		end
		if IsControlJustReleased(0, Keys['E']) and inRange and not pressed then
				pressed = true
				SetEntityCoords(PlayerPedId(), coords[rand].pos)
				Citizen.Wait(50)
				SetEntityHeading(PlayerPedId(), coords[rand].heading)
				TriggerEvent('ndrp_emotes:playthisemote', 'knock')
				Citizen.Wait(100)
				TriggerEvent('InteractSound_CL:PlayOnOne', 'doorknock', 0.4)
				Citizen.Wait(4000)
				TriggerEvent('ndrp_emotes:playthisemote', 'c')
				TriggerEvent('InteractSound_CL:PlayOnOne', 'biatch', 0.4)
				Citizen.Wait(2000)
				PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
				TriggerServerEvent('esx_drugs:dealdone')
				TriggerEvent('esx_status:add', 'stress', 100000)
				exports['mythic_notify']:SendAlert('inform', 'Stress gained!.', 2500, { })
				Citizen.Wait(1000)
				pressed = false
                return
		end
	end
end)

function PlayAnim(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, -8, -1, r and 49 or 0, 0, 0, 0, 0)
    end)
end