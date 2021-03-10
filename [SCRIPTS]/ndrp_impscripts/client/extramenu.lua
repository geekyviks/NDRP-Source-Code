local extracoords = {
    [1] = vector3(-329.66,-137.29,38.02),
    [2] = vector3(-1158.8,-2012.37,12.19),
    [3] = vector3(733.96,-1081,21.06),
}

local insidextraMarker = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPedx = PlayerPedId()
		local coords = GetEntityCoords(PlayerPedId())
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
        for k,v in pairs(extracoords) do
            for i = 1, #extracoords, 1 do
				local distance = Vdist(coords, v)
                if (distance < 20.0) then
                    if insidextraMarker == false and pedInVeh then
                        DrawMarker(2, v+vector3(0.0,0.0,1.0), 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.5, 0.5, 0.3, 255,0,0,100, false, true, 2, true, false, false, false)
                    end
                end 
				if (distance < 2.5 ) and insidextraMarker == false and pedInVeh then
					DrawText3DZ(v.x,v.y,v.z+1.5, "~g~E~s~ - Extra Menu")
					if IsControlJustPressed(0, 46) then
						OpenExtraMainMenu()
						insidextraMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end
	end
end)

-- LS CustomsExtra Menu:

function OpenExtrasMenu()
	local elements = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local engineHealth = GetVehicleEngineHealth(vehicle)

	if engineHealth > 700.00 then
		for id=0, 12 do
			if DoesExtraExist(vehicle, id) then
				local state = IsVehicleExtraTurnedOn(vehicle, id) 

				if state then
					table.insert(elements, {
						label = "Extra: "..id.." | "..('<span style="color:green;">%s</span>'):format("On"),
						value = id,
						state = not state
    	            })
				else
					table.insert(elements, {
						label = "Extra: "..id.." | "..('<span style="color:red;">%s ($1000)</span>'):format("Off"),
						value = id,
						state = not state
					})
				end
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
			title    = 'Vehicle Extras',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			SetVehicleExtra(vehicle, data.current.value, not data.current.state)
			local newData = data.current
			if data.current.state then
				newData.label = "Extra: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("On")
				TriggerServerEvent("extramenu:Pay")
			else
				newData.label = "Extra: "..data.current.value.." | "..('<span style="color:red;">%s ($1000)</span>'):format("Off")
			end
			newData.state = not data.current.state
			menu.update({value = data.current.value}, newData)
			menu.refresh()
		end, function(data, menu)
			menu.close()
		end)
	else
		exports['mythic_notify']:SendAlert('error', 'You can\'t put extras on damaged vehicle')
	end
end

-- Police Livery Menu:

function OpenLiverysMenu()
	local elements = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	local liveryCount = GetVehicleLiveryCount(vehicle)
			
	for i = 1, liveryCount do
		local state = GetVehicleLivery(vehicle) 
		local text
		
		if state == i then
			text = "Livery: "..i.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			text = "Livery: "..i.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		
		table.insert(elements, {
			label = text,
			value = i,
			state = not state
		}) 
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
		title    = "Vehicle Liveries",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		SetVehicleLivery(vehicle, data.current.value, not data.current.state)
		local newData = data.current
		if data.current.state then
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		newData.state = not data.current.state
		menu.update({value = data.current.value}, newData)
		menu.refresh()
		menu.close()	
	end, function(data, menu)
		menu.close()		
	end)
end

-- LS Customs Extra Main Menu:

function OpenExtraMainMenu()
	local elements = {
		{label = 'Extras',value = 'extra'},
		{label = 'Liveries',value = 'livery'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'color_menu', {
		title    = "LS Customs Extras",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'extra' then
			OpenExtrasMenu()
		elseif data.current.value == 'livery' then
			OpenLiverysMenu()
		end
	end, function(data, menu)
		menu.close()
		insidextraMarker = false
	end)
end

function DrawText3DZ(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
end