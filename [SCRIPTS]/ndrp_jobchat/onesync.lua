local WaitTime = 100 -- How often do you want to update the status (In MS)
local onlinePlayers = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        onlinePlayers = #GetActivePlayers() 
    end
end)

DensityMultiplier = 1.0
playerMultiplier = 0
robbing = false

-- add more areas here 
OneSyncBadareas = {
    [1] = { ["x"] = 1822.8262939453, ["y"] = 2248.7468261719, ["z"] = 53.709140777588}, --Intersection splitting place near the jail.
    [2] = { ["x"] = 1704.5872802734, ["y"] = 3506.8410644531, ["z"] = 36.429180145264}, -- near jail
    [3] = { ["x"] = 1726.2159423828, ["y"] = 2536.3801269531, ["z"] = 45.564891815186}, -- near jail
    [4] = { ["x"] = 148.81317138672, ["y"] = 6529.986328125, ["z"] = 31.715270996094}, --peleto
    [5] = { ["x"] = -383.93887329102, ["y"] = 5997.466796875, ["z"] = 31.456497192383},
	[6] = { ["x"] = 2062.81640625, ["y"] = 3721.5895996094, ["z"] = 33.070247650146},
	[7] = { ["x"] = -216.88275146484, ["y"] = 6320.8959960938, ["z"] = 31.454381942749},
	[8] = { ["x"] = -3100.7924804688, ["y"] = 1186.4498291016, ["z"] = 20.33984375},
	[9] = { ["x"] = -2704.9948730469, ["y"] = 2305.4291992188, ["z"] = 18.006093978882},
	[10] =  { ['x'] = -551.43, ['y'] = 271.11, ['z'] = 82.97 },
	[11] =  { ['x'] = 534.99, ['y'] = -3105.27, ['z'] = 34.56 },
    [12] =  { ['x'] = 2396.26,['y'] = 3112.3,['z'] = 48.15 },
    [13] = { ['x'] = 189.742 ,['y'] = -930.015 ,['z'] = 30.687 }, --legion square
    [14] = { ['x'] = -94.372 ,['y'] = -722.368 ,['z'] = 43.894 }, -- overpass near legion
}


function checkBadAreas()
	local plyCoords = GetEntityCoords(GetPlayerPed(-1))
	local aids = 9999.0
	local returninfo = false
	for i = 1, #OneSyncBadareas do
		local distance = GetDistanceBetweenCoords(OneSyncBadareas[i]["x"],OneSyncBadareas[i]["y"],OneSyncBadareas[i]["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if distance < 350.0 and aids > distance then
			aids = distance
			returninfo = true
		end
	end
	return returninfo
end

Citizen.CreateThread( function()
	while true do
        Citizen.Wait(1000)

        WalkingMultiplier = string.format("%.2f", ((80 - (onlinePlayers - 0))/260)) -- Outside of aids areas
        DrivingMultiplier = string.format("%.2f", ((80 - (onlinePlayers - 0))/750)) -- Driving in aids areas.

        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local driving = false
        local playerPed = GetPlayerPed(-1)
		local currentVehicle = GetVehiclePedIsIn(playerPed, false)
		local inveh = IsPedInAnyVehicle(playerPed, true)

        if inveh then
			local driverPed = GetPedInVehicleSeat(currentVehicle, -1)

        	if GetPlayerPed(-1) == driverPed then
        		driving = true
            else
                driving = false
            end
        end

		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local aids = checkBadAreas()
        
		if plyCoords["z"] < -25 or aids then
            if driving then
                DensityMultiplier = DrivingMultiplier --If in car in bed area set multiplyer
            else
                DensityMultiplier = 0.0 -- If on foot in these areas disable this 
            end
        else
            DensityMultiplier = WalkingMultiplier
        end
    end

end)

-- Main loop to work with the above

isAllowedToSpawn = true
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        --print(DensityMultiplier) --You can print this if you want to change the math
		if GetDistanceBetweenCoords(958.76,-141.4, 74.51, GetEntityCoords(GetPlayerPed(-1))) > 200.0 and driving then
            SetPedDensityMultiplierThisFrame(0.0)
		else
			SetPedDensityMultiplierThisFrame(DensityMultiplier)
		end
		    SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
		    SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetParkedVehicleDensityMultiplierThisFrame(0.1)
            SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
	end
end)