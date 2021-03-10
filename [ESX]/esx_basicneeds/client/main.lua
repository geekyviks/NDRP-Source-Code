ESX          = nil
local IsDead = false
local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
	TriggerEvent('esx_status:set', 'stress', 0)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'stress', 0)
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end
	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)
	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return false
	end, function(status)
		status.remove(1000)
	end)
  
	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return false
	end, function(status)
		status.remove(1000)
	end)
	
	TriggerEvent('esx_status:registerStatus', 'stress', 100000, '#cadfff', function(status)
		return false
	end, function(status)
		status.add(20)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local playerPed  = PlayerPedId()
		local stressVal  = 0
		TriggerEvent('esx_status:getStatus', 'stress', function(status)
			stressVal = status.val
		end)
		if stressVal >= 750000 then
			Citizen.Wait(5000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.16)
		elseif stressVal >= 700000 then
			Citizen.Wait(7000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.12)
		elseif stressVal >= 600000 then
			Citizen.Wait(8000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.07)
		elseif stressVal >= 350000 then
			Citizen.Wait(10000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.03)
		end
	end
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
				Citizen.Wait(5000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
			
		end)
	end
end)

RegisterNetEvent('esx_basicneeds:onEatSW')
AddEventHandler('esx_basicneeds:onEatSW', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_sandwich_01'
		IsAnimated = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
				Citizen.Wait(5000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)
	end
end)

RegisterNetEvent('esx_basicneeds:onEatPZ')
AddEventHandler('esx_basicneeds:onEatPZ', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_donut_01'
		IsAnimated = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
				Citizen.Wait(5000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
			
		end)
	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkGA')
AddEventHandler('esx_basicneeds:onDrinkGA', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_energy_drink'
		IsAnimated = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, -0.03, 0.03, -100.0, 0.0, -10.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				Citizen.Wait(4000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)
	end
end)


RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, -0.03, 0.03, -100.0, 0.0, -10.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)
	end
end)