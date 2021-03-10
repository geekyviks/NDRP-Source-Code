local spawn = false
local fpp = false

Citizen.CreateThread(function()
	while not spawn do
		Citizen.Wait(5)
		local playerPedx = PlayerPedId()
		local coords = GetEntityCoords(playerPedx)
		local vehicleName = "bmx"
		local x = -1034.1 
		local y = -2732.98
		local z = 20.17
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 20 then
			DrawMarker(38, x,y,z, 0, 0, 0, 0, 0, 0, 1.0,1.0,1.0, 255,255,255, 100, 0, 0, 0, 0)
			if distance < 1 then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to rent free bicycle", true, true, 10000)
				if IsControlJustReleased(0,  46) then
					RequestModel(vehicleName)
					while not HasModelLoaded(vehicleName) do
						Wait(500) -- often you'll also see Citizen.Wait
					end
					local vehicle = CreateVehicle(vehicleName, x, y, z, GetEntityHeading(playerPedx), true, false)
					SetPedIntoVehicle(playerPedx, vehicle, -1)
					SetEntityAsNoLongerNeeded(vehicle)
					SetModelAsNoLongerNeeded(vehicleName)
					spawn = true
				end
			end
		end
	end
end)

-- CODE --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisableControlAction(0,0)
		if IsDisabledControlPressed(0,0) then
			Citizen.Wait(500)
			if not fpp then
				SetFollowVehicleCamViewMode(4)
				SetFollowPedCamViewMode(4)
				fpp=true
			else
				SetFollowVehicleCamViewMode(0)
				SetFollowPedCamViewMode(0)
				fpp = false
			end
		end
	end
end)