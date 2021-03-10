--------------------
ESX = nil
local playerCoords = GetEntityCoords(GetPlayerPed(-1))
local objectCoords = nil
local WaitLol = 0
local pressed = false
local Keys = {["E"] = 38}
--------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local once = true
	while true do
        Citizen.Wait(WaitLol)
		local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(PlayerPedId())
		local objectId = GetClosestObjectOfType(pedCoords, 1.5, GetHashKey("prop_watercooler"), false)
        local objectCoords = GetEntityCoords(objectId)
        local dist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, objectCoords.x, objectCoords.y, objectCoords.z)
		
		if dist <= 1.5 then
			WaitLol = 0
			DrawText3Ds(objectCoords.x, objectCoords.y, objectCoords.z+1.0, '[~g~ E ~s~] to drink')
		else
			WaitLol = 500
		end
		
        if DoesEntityExist(objectId) and IsControlJustPressed(0, Keys['E']) and not pressed then
			pressed = true
				local pedCoords = GetEntityCoords(PlayerPedId())
				local dist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, objectCoords.x, objectCoords.y, objectCoords.z)
				if dist <= 1.5 then
				local pedCoords = GetEntityCoords(GetPlayerPed(-1))
				TriggerEvent('esx_status:add', 'thirst', 200000)	
				TriggerEvent('break_drinkwater:drink2', source)
				ClearPedSecondaryTask(playerPed)
				Citizen.Wait(4000)
				pressed = false
			end
        end
	end
end)

RegisterNetEvent('break_drinkwater:drink2')
AddEventHandler('break_drinkwater:drink2', function(prop_name)
	if not animation then
		prop_name = prop_name or 'apa_prop_cs_plastic_cup_01'
		animation = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.10, -0.07, 0.03, -100.0, 0.0, -10.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				Citizen.Wait(3000)
				animation = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)
	end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.80, 0.40)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 900
end