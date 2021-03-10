Key = 46 -- E

vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{175.09,  -1736.53,  29.29},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139},
	{1362.5385, 3592.1274, 33.9211},
	{-196.59, -1324.78, 31.13}
}


Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				DrawMarker(-1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 5 then
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to wash the car", true, true, 6000)
					if IsControlJustPressed(1, Key) then
						TriggerServerEvent('es_carwash:checkmoney')
					end
				end
			end
		end
	end
end)

RegisterNetEvent('es_carwash:success')
AddEventHandler('es_carwash:success', function (price)
	WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	exports['mythic_notify']:SendAlert('success', 'Your vehicle was cleaned')
end)

RegisterNetEvent('es_carwash:notenoughmoney')
AddEventHandler('es_carwash:notenoughmoney', function (moneyleft)
	exports['mythic_notify']:SendAlert('error', 'You don\'t have enough money!')
end)

RegisterNetEvent('es_carwash:free')
AddEventHandler('es_carwash:free', function ()
	WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	exports['mythic_notify']:SendAlert('success', 'Your vehicle was cleaned for free')
end)